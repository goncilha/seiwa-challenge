# frozen_string_literal: true

require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @blank = User.new
  end

  test "that database defaults are set" do
    assert_equal "enabled", @blank.status
  end

  test "that validates mandatory attributes" do
    assert @blank.invalid?
    assert_equal 4, @blank.errors.count
    assert_equal ["can't be blank"], @blank.errors[:name]
    assert_equal ["can't be blank"], @blank.errors[:email]
    assert_equal ["can't be blank", "can't be blank"], @blank.errors[:password]
  end

  test "that validates email is unique" do
    user = User.new name: "João", email: "joao@seiwa.com.br"
    assert user.invalid?
    assert_equal ["has already been taken"], user.errors[:email]
  end
end
