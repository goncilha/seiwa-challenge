# frozen_string_literal: true

require "test_helper"

class TreatmentDetailTest < ActiveSupport::TestCase
  setup do
    @blank = TreatmentDetail.new
  end

  test "that database defaults are set" do
    assert @blank.pending?
  end

  test "that ensure associations exist" do
    assert @blank.invalid?
    assert @blank.errors.count, 4
    assert_equal ["must exist"], @blank.errors[:doctor]
    assert_equal ["must exist"], @blank.errors[:patient]
    assert_equal ["must exist"], @blank.errors[:treatment]
    assert_equal ["must exist"], @blank.errors[:medical_procedure]
  end
end
