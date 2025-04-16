json.performed_at treatment.performed_at.strftime("%d/%m/%Y")
json.detail do
  json.medical_procedure treatment.detail.medical_procedure.name
  json.status treatment.detail.status

  json.doctor do
    json.name treatment.detail.doctor.name
    json.document_number treatment.detail.doctor.document_number
    json.crm treatment.detail.doctor.crm
    json.crm_location treatment.detail.doctor.crm_location
    json.status treatment.detail.doctor.status
  end

  json.patient do
    json.name treatment.detail.patient.name
    json.document_number treatment.detail.patient.document_number
    json.status treatment.detail.patient.status
  end
end