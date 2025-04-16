# frozen_string_literal: true

class TreatmentDetail < ApplicationRecord
  enum :status, %i[pending paid denied]

  belongs_to :doctor
  belongs_to :patient
  belongs_to :treatment
  belongs_to :medical_procedure
end
