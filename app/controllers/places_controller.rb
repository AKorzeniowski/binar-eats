class PlacesController < ApplicationController
  def index
    @places = Place.all
    @place = Place.new
  end
  def create
    @place = Place.new(params[:id])
    @place.save
    redirect_to places_path, notice: 'New place was created'
  end

end
