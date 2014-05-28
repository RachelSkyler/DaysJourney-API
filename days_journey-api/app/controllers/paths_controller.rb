class PathsController < ApplicationController

  # GET /users/:user_id/paths.json
  def index
    @paths = Path.all

    render json: @paths
  end

  # GET /paths/1.json
  def show
    @path = Path.find(params[:id])
    
    puts "created_at #{@path.created_at}"

    if @path.nil?
      render json: {
        result: 1,
        path_id: @path.id,
        created_at: @path.created_at
      }
    else
      render json: {
        result: 0,
        error: @path.errors
      }
    end
  end

  # GET /paths/todaypath/1.json
  def today_path
    
  end

  # POST /users/:user_id/paths.json
  def create
    @user = User.find(params[:user_id])
    result = Path.new_today_path(params[:user_id])
    @path = result[:path]

    @user.paths.push(@path) unless @path.nil?
    
    puts "created_at #{@path.created_at}"
    if @path.save
      render json: {
        result: 1,
        path_id: @path.id,
        created_at: @path.created_at
      }
    else
      render json: {
        result:0,
        error: @path.errors
      }
    end
  end
  
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
