class Workflows::ExperimentsController < ApplicationController
  before_action :find_experiment, except: [ :index, :new, :create ]

  # GET /workflows/experiments
  # GET /workflows/experiments.xml
  def index
  end

  # GET /workflows/experiments/1
  # GET /workflows/experiments/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @experiment }
    end
  end

  # GET /workflows/experiments/new
  # GET /workflows/experiments/new.xml
  def new
    @experiment = Experiment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @experiment }
    end
  end

  # # GET /workflows/experiments/1/edit
  # def edit
  # end

  # POST /workflows/experiments
  # POST /workflows/experiments.xml
  def create
    @experiment = Experiment.new(experiment_params)

    respond_to do |format|
      if @experiment.save
        flash[:notice] = 'Experiment was successfully created.'
        format.html { redirect_to([@experiment.sample, @experiment]) }
        format.xml  { render xml: @experiment, status: :created, location: @experiment }
      else
        format.html { render action: "new" }
        format.xml  { render xml: @experiment.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def find_experiment
    @experiment = Experiment.find(params[:id])
  end

  def experiment_params
    params.require(:experiment).permit!
  end
end
