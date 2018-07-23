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
    if @place.update_attributes(place_params)
        flash[:notice] = "Place updated."
        redirect_to places_path
    else
        render action: 'edit'
    end
  end
  def destroy
    @place = Place.find(params[:id])
    @place.destroy
    flash[:notice] = "Place deleted"
    redirect_to places_path
  end

   private
   def place_params
     params.require(:place).permit(:name, :menu_url)
   end
end
