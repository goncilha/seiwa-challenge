# frozen_string_literal: true

class Treatment < ApplicationRecord
  include HasDetail

  has_many :details, class_name: "TreatmentDetail"
  
  validates :performed_at, presence: true

  default_scope { includes(details: [:doctor, :patient, :medical_procedure, :medical_procedure_detail]) }

  scope :daily, -> { where(performed_at: Date.today) }
  scope :by_doctor, ->(doctor_id) { where(details: { doctor: doctor_id }) }
  scope :denied_by_date_range, ->(from_date, to_date) { where(performed_at: from_date..to_date, details: { status: :denied }) }
end
