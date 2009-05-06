class AnimalsController < ApplicationController
  before_filter :find_animal, :only => [ :show, :edit, :update, :destroy ]

  # GET /animals
  # GET /animals.xml
  def index
    @animals = current_user.rank == 'Superuser' || current_user.rank == 'Administrator' ?
    Animal.find(:all) :
    Animal.find(:all, :conditions => [ 'site_id=?', current_user.site ])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @animals }
    end
  end

  # GET /animals/1
  # GET /animals/1.xml
  def show

    # @tree = animal_tree(@animal)


    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @animal }
    end
  end

  # GET /animals/new
  # GET /animals/new.xml
  def new
    @animal = Animal.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @animal }
    end
  end

  # GET /animals/1/edit
  def edit
  end

  # POST /animals
  # POST /animals.xml
  def create
    @animal = Animal.new(params[:animal])

    respond_to do |format|
      if @animal.save
        flash[:notice] = 'Animal was successfully created.'
        format.html { redirect_to(@animal) }
        format.xml  { render :xml => @animal, :status => :created, :location => @animal }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @animal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /animals/1
  # PUT /animals/1.xml
  def update
    respond_to do |format|
      if @animal.update_attributes(params[:animal])
        flash[:notice] = 'Animal was successfully updated.'
        format.html { redirect_to(@animal) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @animal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /animals/1
  # DELETE /animals/1.xml
  def destroy
    @animal.destroy

    respond_to do |format|
      format.html { redirect_to(animals_url) }
      format.xml  { head :ok }
    end
  end

  protected
  def find_animal(param_name = :id)
    super
  end
end