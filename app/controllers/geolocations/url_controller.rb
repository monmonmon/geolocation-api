class Geolocations::UrlController < ApplicationController
  before_action :set_geolocation, only: %i[show destroy]

  def show
    render
  end

  def create
    @geolocation = Geolocation.build_by_url(params[:url]) rescue nil
    if @geolocation&.save!
      render :show, status: :created
    else
      render json: {"error": "Failed"}, status: :bad_request
    end
  end

  def destroy
    @geolocation.destroy!
  end

  private
    def set_geolocation
      raise ActionController::BadRequest.new("invalid URL: #{params[:url]}") unless URI.regexp.match params[:url]
      @geolocation = Geolocation.find_by_url!(params[:url])
    end
end
