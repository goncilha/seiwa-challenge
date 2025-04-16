# frozen_string_literal: true

require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Treatments", type: :request do
  fixtures :all

  path "/treatments" do
    post "Creates an Treatment" do
      tags "Treatments"
      security [ jwt: [] ]
      consumes "application/json"
      produces "application/json"
      parameter name: :Authorization, in: :header, type: :string
      parameter name: "treatment", in: :body, schema: {
        type: :object,
        properties: {
          performed_at: { type: :string },
          detail: {
            type: :object,
            properties: {
              doctor_id: { type: :integer },
              patient_id: { type: :integer },
              medical_procedure_id: { type: :integer },
            },
            required: ["doctor_id", "patient_id", "medical_procedure_id"]
          }
        },
        required: ["performed_at"]
      }

      response "201", "Treatment created" do
        schema type: :object,
          properties: {
            data: {
              "$ref" => "#/components/schemas/treatment"
            }
          }
        let(:Authorization) { SeiwaAuth::Token.new.encode(users(:joao).id) }
        let(:treatment) {
          {
            treatment: {
              performed_at: "2025-04-15",
              detail: {
                doctor_id: doctors(:house).id,
                patient_id: patients(:maria).id,
                medical_procedure_id: medical_procedures(:exam).id
              }
            }
          }
        }
        run_test!
      end

      response "422", "Unprocessable Entity" do
        schema "$ref" => "#/components/schemas/default_error"

        let(:Authorization) { SeiwaAuth::Token.new.encode(users(:joao).id) }
        let(:treatment) {
          {
            treatment: {
              performed_at: "2025-04-15",
              detail: {
                doctor_id: nil,
                patient_id: patients(:maria).id,
                medical_procedure_id: medical_procedures(:exam).id
              }
            }
          }
        }
        run_test!
      end

      response "400", "Bad Request" do
        schema "$ref" => "#/components/schemas/default_error"

        let(:Authorization) { SeiwaAuth::Token.new.encode(users(:joao).id) }
        let(:treatment) {
          {
            treatment: {
              performed_at: "2025-04-15",
            }
          }
        }
        run_test!
      end
    end

    get "Retrieve Treatments" do
      tags "Treatments"
      security [ jwt: [] ]
      produces "application/json"
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :report_type, in: :path, type: :string
      parameter name: :doctor_id, in: :path, type: :integer
      parameter name: :from_date, in: :path, type: :string
      parameter name: :to_date, in: :path, type: :string

      response "200", "OK" do
        schema type: :object,
          properties: {
            summary: {
              type: :object,
              properties: {
                status: {
                  type: :object,
                  properties: {
                    count: { type: :integer },
                    total_amount: { type: :string }
                  }
                }
              }
            },
            "$ref" => "#/components/schemas/treatment_collection"
          }

        let(:Authorization) { SeiwaAuth::Token.new.encode(users(:joao).id) }
        let(:report_type) { "" }
        let(:doctor_id) { "" }
        let(:from_date) { "" }
        let(:to_date) { "" }
        run_test!
      end
    end
  end

  describe "Scenarios" do
    describe "POST /treatments" do
      it "that treatment is created correctly" do
        today = Date.today.strftime("%d/%m/%Y")

        expect {
          post treatments_path, params: {
            treatment: {
              performed_at: today,
              detail: {
                doctor_id: doctors(:house).id,
                patient_id: patients(:maria).id,
                medical_procedure_id: medical_procedures(:exam).id
              }
            }
          }, headers: headers
        }.to change(Treatment, :count).by(1)

        expect(response).to have_http_status(:created)

        result = JSON.parse(response.body)["data"]
        expect(result["performed_at"]).to eq(today)
        expect(result["detail"]["medical_procedure"]).to eq(medical_procedures(:exam).name)
        expect(result["detail"]["price"]).to eq("R$ 100,00")
        expect(result["detail"]["status"]).to eq("pending")
        expect(result["detail"]["doctor"]["name"]).to eq(doctors(:house).name)
        expect(result["detail"]["doctor"]["document_number"]).to eq(doctors(:house).document_number)
        expect(result["detail"]["doctor"]["crm"]).to eq(doctors(:house).crm)
        expect(result["detail"]["doctor"]["crm_location"]).to eq(doctors(:house).crm_location)
        expect(result["detail"]["doctor"]["status"]).to eq(doctors(:house).status)
        expect(result["detail"]["patient"]["name"]).to eq(patients(:maria).name)
        expect(result["detail"]["patient"]["document_number"]).to eq(patients(:maria).document_number)
        expect(result["detail"]["patient"]["status"]).to eq(patients(:maria).status)
      end
    end

    describe "GET /treatments" do
      it "that returns default list" do
        get treatments_path, headers: headers

        expect(response).to have_http_status(:ok)

        result = JSON.parse(response.body)["data"]
        expect(result.count).to eq(3)
      end

      it "that returns daily report by doctor" do
        get treatments_path, params: {
          report_type: "daily_by_doctor",
          doctor_id: doctors(:house).id
        }, headers: headers

        expect(response).to have_http_status(:ok)

        result = JSON.parse(response.body)["data"]
        expect(result.count).to eq(1)
      end

      it "that returns denied report by date" do
        treatments(:medication).detail.denied!
        treatments(:two_stitch).detail.denied!

        get treatments_path, params: {
          report_type: "denied_by_date",
          from_date: Date.yesterday,
          to_date: Date.tomorrow
        }, headers: headers

        expect(response).to have_http_status(:ok)

        result = JSON.parse(response.body)["data"]
        expect(result.count).to eq(2)
      end

      it "empty list" do
        treatment_details(&:all).each { |record| record.destroy! }
        treatments(&:all).each { |record| record.destroy! }

        get treatments_path, headers: headers

        expect(response).to have_http_status(:ok)

        result = JSON.parse(response.body)["data"]
        expect(result.count).to eq(0)
      end

      it "summary with status pending only" do
        get treatments_path, params: {
          report_type: "financial_by_doctor",
          doctor_id: doctors(:house).id
        }, headers: headers

        expect(response).to have_http_status(:ok)

        summary = JSON.parse(response.body)["summary"]
        result = JSON.parse(response.body)["data"]

        expect(summary[0]["pending"]["count"]).to eq(2)
        expect(summary[0]["pending"]["total_amount"]).to eq("R$ 150,00")

        expect(result.count).to eq(2)
      end

      it "summary with status pending and paid treatments" do
        treatments(:two_stitch).detail.paid!

        get treatments_path, params: {
          report_type: "financial_by_doctor",
          doctor_id: doctors(:house).id
        }, headers: headers

        expect(response).to have_http_status(:ok)

        summary = JSON.parse(response.body)["summary"]
        result = JSON.parse(response.body)["data"]

        expect(summary.count).to eq(2)
        expect(summary[0]["pending"]["count"]).to eq(1)
        expect(summary[0]["pending"]["total_amount"]).to eq("R$ 100,00")

        expect(summary[1]["paid"]["count"]).to eq(1)
        expect(summary[1]["paid"]["total_amount"]).to eq("R$ 50,00")

        expect(result.count).to eq(2)
      end

      it "summary with all status and different doctor" do
        treatments(:medication).detail.update! status: :pending, doctor: doctors(:ray)
        treatments(:two_stitch).detail.update! status: :denied, doctor: doctors(:ray)
        treatments(:surgery).detail.update! status: :paid, doctor: doctors(:ray)

        get treatments_path, params: {
          report_type: "financial_by_doctor",
          doctor_id: doctors(:ray).id
        }, headers: headers

        expect(response).to have_http_status(:ok)

        summary = JSON.parse(response.body)["summary"]
        result = JSON.parse(response.body)["data"]
        
        expect(summary.count).to eq(3)
        expect(summary[0]["pending"]["count"]).to eq(1)
        expect(summary[0]["pending"]["total_amount"]).to eq("R$ 100,00")
        #
        expect(summary[1]["paid"]["count"]).to eq(1)
        expect(summary[1]["paid"]["total_amount"]).to eq("R$ 500,00")

        expect(summary[2]["denied"]["count"]).to eq(1)
        expect(summary[2]["denied"]["total_amount"]).to eq("R$ 50,00")

        expect(result.count).to eq(3)
      end
    end

    private
      def headers
        token = SeiwaAuth::Token.new.encode(users(:joao).id)
        { "Authorization": token }
      end
  end
end
