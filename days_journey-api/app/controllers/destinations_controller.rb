class DestinationsController < ApplicationController

  # GET /paths/:path_id/destinations.json
  def index
    @destinations = Destination.all

    render json: @destinations
  end

  # GET /destinations/1.json
  def show
    @destination = Destination.find(params[:id])

    render json: @destination
  end

  # POST /paths/:path_id/destinations.json
  def create
    params = create_destination_params
    @path = Path.find(params[:path_id])
    @destination =  Destination.new(create_destination_params)
    puts "Destination : #{@destination}"
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
    params.permit(:path_id, :location_name, :description, :latitude, :longitude, :refenence, :is_home)
  end
end
