if @report_type == "financial_by_doctor"
  json.summary @summary do |summary|
    status = TreatmentDetail.statuses.key(summary[0])
    json.set! status do
      json.count summary[1]
      json.total_amount number_to_currency(summary[2], unit: "R$ ", separator: ",", delimiter: ".")
    end
  end
end

json.data @treatments do |treatment|
  json.partial! "treatments/treatment", treatment: treatment
end
