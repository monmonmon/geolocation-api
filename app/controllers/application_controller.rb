class ApplicationController < ActionController::API
  rescue_from Exception, with: :error500

  protected

  def error500(e)
    if Rails.env.development?
      Rails.logger.debug{e.inspect}
      Rails.logger.debug{e.backtrace.join("\n")}
    end
    message, status =
      case e
      when ActionController::BadRequest
        [
          e.message || "Bad Request",
          :bad_request,
        ]
      when ActiveRecord::RecordNotFound
        [
          "Not found",
          :not_found,
        ]
      else
        [
          e.message || "Bad Request",
          :bad_request,
        ]
      end
    render json: {
      error: message
    }, status: status
  end
end
