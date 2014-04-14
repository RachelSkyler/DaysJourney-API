class DestinationsController < ApplicationController
  # GET /destinations
  # GET /destinations.json
  def index
    @destinations = Destination.all

    render json: @destinations
  end

  # GET /destinations/1
  # GET /destinations/1.json
  def show
    @destination = Destination.find(params[:id])

    render json: @destination
  end

  # POST /destinations
  # POST /destinations.json
  def create
    @destination = Destination.new(params[:destination])

    if @destination.save
      render json: @destination, status: :created, location: @destination
    else
      render json: @destination.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /destinations/1
  # PATCH/PUT /destinations/1.json
  def update
    @destination = Destination.find(params[:id])

    if @destination.update(params[:destination])
      head :no_content
    else
      render json: @destination.errors, status: :unprocessable_entity
    end
  end

  # DELETE /destinations/1
  # DELETE /destinations/1.json
  def destroy
    @destination = Destination.find(params[:id])
    @destination.destroy

    head :no_content
  end
end
