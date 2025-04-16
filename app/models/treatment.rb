# frozen_string_literal: true

class Treatment < ApplicationRecord
  has_many :details, class_name: "TreatmentDetail"
  
  validates :performed_at, presence: true

  def detail
    details.last
  end
end
