class GroupingsController < ApplicationController
  before_action :find_type

  # GET /groupings
  def index
    @groupings = "#{@type}Grouping".constantize.all
  end

  # GET /groupings/1
  def show
    @grouping = Grouping.find(params[:id])
  end

  # GET /groupings/new
  def new
    @grouping = Grouping.new
  end

  # GET /groupings/1/edit
  def edit
    @grouping = Grouping.find(params[:id])
  end

  # POST /groupings
  def create
    @grouping = Grouping.factory(@type, grouping_params)

    if @grouping.save
      redirect_to action: 'show', type: @type, id: @grouping, notice: 'Group was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /groupings/1
  def update
    @grouping = Grouping.find(params[:id])

    if @grouping.update(grouping_params)
      redirect_to action: 'show', type: @type, id: @grouping, notice: 'Group was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /groupings/1
  def destroy
    @grouping = Grouping.find(params[:id])
    @grouping.destroy

    flash[:notice] = 'Group was successfully deleted.'
    redirect_to(action: 'index', type: @type)
  end

  private

  def find_type
    @type = params[:type]
  end

  def grouping_params
    params.require(:grouping).permit!
  end
end
