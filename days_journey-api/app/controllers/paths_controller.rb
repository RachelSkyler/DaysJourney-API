class PathsController < ApplicationController
  # GET /paths
  # GET /paths.json
  def index
    @paths = Path.all

    render json: @paths
  end

  # GET /paths/1
  # GET /paths/1.json
  def show
    @path = Path.find(params[:id])

    render json: @path
  end

  # POST /paths
  # POST /paths.json
  def create
    @path = Path.new(params[:path])

    if @path.save
      render json: @path, status: :created, location: @path
    else
      render json: @path.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /paths/1
  # PATCH/PUT /paths/1.json
  def update
    @path = Path.find(params[:id])

    if @path.update(params[:path])
      head :no_content
    else
      render json: @path.errors, status: :unprocessable_entity
    end
  end

  # DELETE /paths/1
  # DELETE /paths/1.json
  def destroy
    @path = Path.find(params[:id])
    @path.destroy

    head :no_content
  end
end
