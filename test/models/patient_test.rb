# frozen_string_literal: true

require "test_helper"

class PatientTest < ActiveSupport::TestCase
  setup do
    @blank = Patient.new
  end

  test "that database defaults are set" do
    assert_equal "enabled", @blank.status
  end

  test "that validates mandatory attributes" do
    assert @blank.invalid?
    assert_equal 2, @blank.errors.count
    assert_equal ["can't be blank"], @blank.errors[:name]
    assert_equal ["can't be blank"], @blank.errors[:document_number]
  end

  test "that validates document_number is unique" do
    patient = Patient.new name: "João", document_number: "123.456.789-10"
    assert patient.invalid?
    assert_equal ["has already been taken"], patient.errors[:document_number]
  end
end
