json.data do
  json.(@treatment, :performed_at, :created_at, :updated_at)
  json.detail do
    json.(@treatment.detail, :doctor_id, :patient_id, :medical_procedure_id)
  end
end