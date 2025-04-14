# frozen_string_literal: true

class MedicalProceduresController < ApplicationController
  before_action :authenticate
  def index
    render json: { data: "" }
  end
end
