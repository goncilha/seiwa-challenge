class AddMedicalProcedureDetailIdToTreatmentDetail < ActiveRecord::Migration[8.0]
  def change
    add_reference :treatment_details, :medical_procedure_detail, null: false, foreign_key: true
  end
end
