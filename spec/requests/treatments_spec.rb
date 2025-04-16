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
        schema "$ref" => "#/components/schemas/treatment"
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
    end
  end
end
