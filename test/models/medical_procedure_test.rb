# frozen_string_literal: true

require "test_helper"

class MedicalProcedureTest < ActiveSupport::TestCase
  setup do
    @blank = MedicalProcedure.new
  end

  test "that validates mandatory attributes" do
    assert @blank.invalid?
    assert_equal 1, @blank.errors.count
    assert_equal ["can't be blank"], @blank.errors[:name]
  end
end
