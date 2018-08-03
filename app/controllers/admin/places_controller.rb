class Admin::PlacesController < Admin::BaseController
  def index
    @places = Place.all
    @place = Place.new
  end

  def create
    @place = Place.new(place_params)
    if @place.save
      redirect_to admin_places_path, notice: 'New place was created'
    else
      redirect_to admin_places_path, alert: 'New place was not created'
    end
  end

  def edit
    @place = Place.find(params[:id])
  end

  def update
    @place = Place.find(params[:id])
    if @place.update(place_params)
      redirect_to admin_places_path, notice: 'Place has been updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @place = Place.find(params[:id])
    @place.destroy
    redirect_to admin_places_path, notice: 'Place has been deleted.'
  end

  private

  def place_params
    params.require(:place).permit(:name, :menu_url, :show)
  end
end
