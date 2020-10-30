# frozen_string_literal: true

# Abstract Controller every other controller inherits from
class ApplicationController < ActionController::API
  include Knock::Authenticable

  rescue_from ActionController::ParameterMissing, with: :head_bad_request
  rescue_from ActiveRecord::RecordNotFound, with: :head_not_found

  def head_bad_request
    head :bad_request and return
  end

  def head_not_found
    head :not_found and return
  end
end
