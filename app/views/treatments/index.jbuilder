json.data @treatments do |treatment|
  json.partial! "treatments/treatment", treatment: treatment
end
