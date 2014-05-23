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
    destinations = sign_in_user.paths.first.destinations
    home_index = destinations.index {|destination| destination.is_home == "true" }

    @home = destinations[home_index]

    unless @home.nil? 
      render json: {
        result: 1,
        destination_id: @home.id,
        description: @home.description,
        reference: @home.refenence,
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
    puts "is_home value of the destination : #{@destination.is_home} & #{params[:is_home]}"
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

    if @destination.update(params[:destination])
      head :no_content
    else
      render json: @destination.errors, status: :unprocessable_entity
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
    params.permit(:is_home, :path_id, :location_name, :description, :latitude, :longitude, :refenence)
  end
end
