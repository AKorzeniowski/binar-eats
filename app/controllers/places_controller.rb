class PlacesController < ApplicationController
  def index
    @places = Place.all
    @place = Place.new
  end

  def create
    @place = Place.new(place_params)
    if @place.save
      redirect_to places_path, notice: 'New place was created'
    else
      redirect_to places_path, alert: 'New place was not created'
    end
  end

  def edit
    @place = Place.find(params[:id])
  end

  def update
    @place = Place.find(params[:id])
    if @place.update(place_params)
      flash[:notice] = 'Place has been updated.'
      redirect_to places_path
    else
      redirect_to edit_place_path(@place.id)
    end
  end

  def destroy
    @place = Place.find(params[:id])
    @place.destroy
    flash[:notice] = 'Place has been deleted.'
    redirect_to places_path
  end

  private

  def place_params
    params.require(:place).permit(:name, :menu_url)
  end
end
