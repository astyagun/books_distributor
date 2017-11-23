class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do
    render json: {status: 404, detail: 'Record not found'}, status: :not_found
  end
end
