# frozen_string_literal: true

class TreatmentsController < ApplicationController
  before_action :authenticate
  def index
    @report_type = treatment_filter_params[:report_type]
    @summary = nil

    if treatment_filter_params[:report_type] == "daily_by_doctor"
      @treatments = Treatment.daily.by_doctor(treatment_filter_params[:doctor_id])
    elsif treatment_filter_params[:report_type] == "denied_by_date"
      @treatments = Treatment.denied_by_date_range(treatment_filter_params[:from_date], treatment_filter_params[:to_date])
    elsif treatment_filter_params[:report_type] == "financial_by_doctor"
      @summary = Treatment.by_doctor(treatment_filter_params[:doctor_id])
                  .group("details.status")
                  .pluck("details.status, count(treatments.id), sum(medical_procedure_details.price)")
      @treatments = Treatment.by_doctor(treatment_filter_params[:doctor_id])
    else
      @treatments = Treatment.all
    end
  end
  def create
    return render json: { error: "Missing attributes" }, status: :bad_request unless validate_params
    begin
      Treatment.transaction do
        @treatment = Treatment.create! performed_at: treatment_params[:performed_at]
        TreatmentDetail.create! treatment_params[:detail].merge({
          treatment_id: @treatment.id,
          medical_procedure_detail_id: MedicalProcedure.find(treatment_params[:detail][:medical_procedure_id]).detail.id
        })
        render :create, status: :created
      end
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  private
    def treatment_params
      params.require(:treatment).permit(:performed_at, detail: [:doctor_id, :patient_id, :medical_procedure_id])
    end

    def treatment_filter_params
      params.permit(:report_type, :doctor_id, :from_date, :to_date)
    end

    def validate_params
      validate_treatment && validate_details
    end

    def validate_treatment
      treatment_params[:performed_at].present?
    end

    def validate_details
      treatment_params[:detail].present? && [:doctor_id, :patient_id, :medical_procedure_id].all? { |element| treatment_params[:detail].has_key?(element) }
    end
end
