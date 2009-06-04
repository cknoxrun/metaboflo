class TestSubjectsController < ApplicationController
  before_filter :find_test_subject, :only => [ :show, :edit, :update, :destroy ]

  # GET /test_subjects
  # GET /test_subjects.xml
  def index
    @test_subjects = current_user.rank == 'Superuser' || current_user.rank == 'Administrator' ?
    TestSubject.find(:all) :
    TestSubject.find(:all, :conditions => [ 'site_id=?', current_user.site ])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @test_subjects }
    end
  end

  # GET /test_subjects/1
  # GET /test_subjects/1.xml
  def show

    # @tree = test_subject_tree(@test_subject)

    @meals = @test_subject.meals

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @test_subject }
    end
  end

  # GET /test_subjects/new
  # GET /test_subjects/new.xml
  def new
    @test_subject = TestSubject.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @test_subject }
    end
  end

  # GET /test_subjects/1/edit
  def edit
  end

  # POST /test_subjects
  # POST /test_subjects.xml
  def create
    @test_subject = TestSubject.new(params[:test_subject])

    respond_to do |format|
      if @test_subject.save
        flash[:notice] = 'Test Subject was successfully created.'
        format.html { redirect_to(@test_subject) }
        format.xml  { render :xml => @test_subject, :status => :created, :location => @test_subject }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @test_subject.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /test_subjects/1
  # PUT /test_subjects/1.xml
  def update
    respond_to do |format|
      if @test_subject.update_attributes(params[:test_subject])
        flash[:notice] = 'Test Subject was successfully updated.'
        format.html { redirect_to(@test_subject) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @test_subject.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /test_subjects/1
  # DELETE /test_subjects/1.xml
  def destroy
    @test_subject.destroy

    respond_to do |format|
      format.html { redirect_to(test_subjects_url) }
      format.xml  { head :ok }
    end
  end

  protected
  def find_test_subject(param_name = :id)
    super
  end
end