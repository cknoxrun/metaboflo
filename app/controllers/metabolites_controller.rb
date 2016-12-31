class MetabolitesController < ApplicationController
  # GET /metabolites
  # GET /metabolites.xml
  # GET /metabolites.csv
  def index
    include_levels = { concentrations:                         [ data_file:                             [ experiment: [ experiment_type: [], sample: [ :test_subject ] ] ]
                        ]
                      }
    @metabolites = Metabolite.select('DISTINCT metabolites.*').order(:hmdb_id).joins(:concentrations).includes(include_levels).paginate(page: params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @metabolites }
      format.csv  { format_csv }
    end
  end

  # GET /metabolites/1
  # GET /metabolites/1.xml
  def show
    @metabolite = Metabolite.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @metabolite }
    end
  end

  # GET /metabolites/new
  # GET /metabolites/new.xml
  def new
    @metabolite = Metabolite.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @metabolite }
    end
  end

  # GET /metabolites/1/edit
  def edit
    @metabolite = Metabolite.find(params[:id])
  end

  # POST /metabolites
  # POST /metabolites.xml
  def create
    @metabolite = Metabolite.new(metabolite_params)

    respond_to do |format|
      if @metabolite.save
        flash[:notice] = 'Metabolite was successfully created.'
        format.html { redirect_to(@metabolite) }
        format.xml  { render xml: @metabolite, status: :created, location: @metabolite }
      else
        format.html { render action: "new" }
        format.xml  { render xml: @metabolite.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /metabolites/1
  # PUT /metabolites/1.xml
  def update
    @metabolite = Metabolite.find(params[:id])

    respond_to do |format|
      if @metabolite.update(metabolite_params)
        flash[:notice] = 'Metabolite was successfully updated.'
        format.html { redirect_to(@metabolite) }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @metabolite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /metabolites/1
  # DELETE /metabolites/1.xml
  def destroy
    @metabolite = Metabolite.find(params[:id])
    @metabolite.destroy

    respond_to do |format|
      format.html { redirect_to(metabolites_url) }
      format.xml  { head :ok }
    end
  end

  # POST /metabolites/search
  # POST /metabolites/search.xml
  # POST /metabolites/search.csv
  def search
    @query = "%#{params[:query]}%"

    search_fields = ["name", "hmdb_id", "description", "iupac_name",
                     "formula", "smiles", "cas", "inchi_identifier",
                     "melting_point", "state", "wikipedia_name", "comments"]
    conditions_arg = search_fields.map { |sf| "#{sf} LIKE :query" }.join(" OR ")

    @metabolites = Metabolite.joins(:concentrations).
      select('DISTINCT metabolites.*').
      where(conditions_arg, query: @query)

    respond_to do |format|
      format.html { render action: 'index' } # index.html.erb
      format.xml  { render xml: @metabolites }
      format.csv  { format_csv }
    end
  end

  private

  def format_csv
    csv_string = CSV.generate do |csv|
      columns = ['Name', TestSubject.title, 'Concentration', 'Experiment',
                 'Sample Collected On', 'Sample Type', 'Condition', 'Grouping']

      # header row
      csv << columns

      # data row
      @metabolites.each do |metabolite|
        metabolite.concentrations.each do |concentration|
          values = []
          values << metabolite.name
          values << concentration.data_file.experiment.sample.root.name
          values << concentration.concentration_value
          values << concentration.data_file.experiment.name
          values << concentration.data_file.experiment.sample.collected_on
          values << concentration.data_file.experiment.sample.sample_type
          values << '-'
          values << '-'

          csv << values
        end
      end
    end

    send_data csv_string, type: 'text/csv; charset=iso-8859-1; header=present',
      disposition: 'attachment; filename=metabolites.csv'
  end

  def metabolite_params
    params.require(:metabolite).permit!
  end
end
