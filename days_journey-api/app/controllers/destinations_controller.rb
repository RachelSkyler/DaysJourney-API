class DestinationsController < ApplicationController

  # GET /paths/:path_id/destinations.json
  def index
    @destinations = Destination.all

    render json: @destinations
  end

  # GET /destinations/1.json
  def show
    @destination = Destination.find(params[:id])

    unless @destination.nil?
      render json: {
        result: 1,
        destination: @destination 
      }
    else
      render json: {
        result: 0,
        error: @destination.errors
      }
    end
  end

  def home
    sign_in_user = User.find(params[:user_id])
    today_path = sign_in_user.paths.first
    destinations = today_path.destinations
    home_index = destinations.index {|destination| destination.is_home == "true" }

    @home = destinations[home_index]
    puts "Home ID = #{@home.id} Home description = #{@home.description}"
    unless @home.nil? 
      render json: {
        result: 1,
        path_id: today_path.id,
        destination_id: @home.id,
        description: @home.description,
        reference: @home.reference,
        latitude: @home.latitude,
        longitude: @home.longitude
      }
    else
      render json: {
        result: 0,
        error: 'You did not configure home address.'
      }
    end
  end

  # POST /paths/:path_id/destinations.json
  def create
    params = create_destination_params
    @path = Path.find(params[:path_id])
    @destination =  Destination.new(params)
    @path.destinations << @destination

    if @destination.save
      render json: {
        result: 1,
        destination_id: @destination.id
      }
    else
      render json: {
        result: 0,
        error: @destination.errors
      }
    end
  end

  # PATCH/PUT /destinations/1.json
  def update
    @destination = Destination.find(params[:id])

    if @destination.update(update_destination_params)
      render json: {
        result: 1,
        destination_id: @destination.id
      }
    else
      render json: {
        result: 0,
        error: @description.errors
      }
    end
  end

  # DELETE /destinations/1.json
  def destroy
    @destination = Destination.find(params[:id])
    @destination.destroy

    head :no_content
  end

  private

  def create_destination_params
    params.permit(:is_home, :path_id, :location_name, :description, :latitude, :longitude, :reference)
  end

  def update_destination_params
    params.permit(:is_home, :location_name, :description, :latitude, :longitude, :reference)
  end
end
