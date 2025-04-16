# frozen_string_literal: true

class MedicalProcedure < ApplicationRecord
  include HasDetail

  has_many :details, class_name: "MedicalProcedureDetail"

  validates :name, presence: true
end
