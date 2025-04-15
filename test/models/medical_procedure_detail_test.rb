# frozen_string_literal: true

require "test_helper"

class MedicalProcedureDetailTest < ActiveSupport::TestCase
  setup do
    @blank = MedicalProcedureDetail.new medical_procedure: medical_procedures(:exam)
  end

  test "that validates mandatory attributes" do
    assert @blank.invalid?
    assert_equal ["can't be blank", "is not a number"], @blank.errors[:price]
  end
end