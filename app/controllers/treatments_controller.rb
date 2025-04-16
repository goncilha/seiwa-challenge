# frozen_string_literal: true

class TreatmentsController < ApplicationController
  before_action :authenticate
  def create
    Treatment.transaction do
      @treatment = Treatment.create! performed_at: treatment_params[:performed_at]
      TreatmentDetail.create! treatment_params[:detail].merge({ treatment_id: @treatment.id })
      render :create, status: :created
    end
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private
    def treatment_params
      params.require(:treatment).permit(:performed_at, detail: [:doctor_id, :patient_id, :medical_procedure_id])
    end

    def validate_params
      validate_treatment && validate_details && validate_entities
    end

    def validate_treatment
      treatment_params[:performed_at].present?
    end

    def validate_details
      [:doctor_id, :patient_id, :medical_procedure_id].all? { |element| treatment_params[:detail].has_key?(element) }
    end
end
