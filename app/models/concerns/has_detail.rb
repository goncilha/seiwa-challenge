# frozen_string_literal: true

module HasDetail
  extend ActiveSupport::Concern

  def detail
    self.details.last
  end
end
