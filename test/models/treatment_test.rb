# frozen_string_literal: true

require "test_helper"

class TreatmentTest < ActiveSupport::TestCase
  setup do
    @blank = Treatment.new
  end

  test "that validates mandatory attributes" do
    assert @blank.invalid?
    assert_equal ["can't be blank"], @blank.errors[:performed_at]
  end
end
