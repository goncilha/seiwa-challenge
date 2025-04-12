# frozen_string_literal: true

require "test_helper"

class DoctorTest < ActiveSupport::TestCase
  setup do
    @blank = Doctor.new
  end

  test "that database defaults are set" do
    assert_equal "enabled", @blank.status
  end

  test "that validates mandatory attributes" do
    assert @blank.invalid?
    assert_equal 3, @blank.errors.count
    assert_equal ["can't be blank"], @blank.errors[:name]
    assert_equal ["can't be blank"], @blank.errors[:crm_location]
  end

  test "that validates CRM" do
    @blank.crm = "xxx"
    assert @blank.invalid?
    assert_equal ["is not a number"], @blank.errors[:crm]

    @blank.crm = 1234567
    assert @blank.invalid?
    assert_equal ["is too long (maximum is 6 characters)"], @blank.errors[:crm]
  end

  test "that validates CRM location" do
    @blank.crm_location = "ABC"
    assert @blank.invalid?
    assert_equal ["is too long (maximum is 2 characters)"], @blank.errors[:crm_location]
  end
end
