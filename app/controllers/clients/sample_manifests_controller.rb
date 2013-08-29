class Clients::SampleManifestsController < Clients::BaseController  
  before_filter :unverified_manifest, :only => [:edit, :update, :confirm, :destroy]
  def index
    @sample_manifests = current_client.sample_manifests
    respond_to do |format|
      format.html
    end
  end
  
  def new
    @sample_manifest = SampleManifest.new()
    respond_to do |format|
      format.html
    end
  end
  
  def show
    @sample_manifest = SampleManifest.find(params[:id])
    respond_to do |format|
      format.html
    end
  end
  
  def print
    @sample_manifest = SampleManifest.find(params[:id])
    respond_to do |format|
      format.html { render :print, :layout => false}
    end
  end
  
  def edit
  end
  
  def create
    @sample_manifest = SampleManifest.new(params[:sample_manifest])
    @sample_manifest.client = current_client
    respond_to do |format|
      if @sample_manifest.save
        format.html { redirect_to([:clients,@sample_manifest], :notice => 'Sample Manifest was successfully created.') }
      else
        format.html { render :action => "edit"}
      end
    end
  end
  
  def update
    respond_to do |format|
      if @sample_manifest.update_attributes(params[:sample_manifest])
          format.html { redirect_to([:clients,@sample_manifest], :notice => 'Sample manifest was successfully updated.') }
      else
          format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    @sample_manifest.destroy
    respond_to do |format|
      format.html { redirect_to(clients_sample_manifests_url) }
    end
  end
  
  def confirm
    @sample_manifest = SampleManifest.find(params[:id])
    message = ""
    if @sample_manifest.confirmable_manifest?
      @sample_manifest.verified = true
      @sample_manifest.assign_barcodes
      @sample_manifest.generate_barcodes(params.dup)
      message = "Successfully confirmed the order."
    else
      message = "Please fill out all the required fields."
    end
    redirect_to([:clients,@sample_manifest], :notice => message)
  end
  
  def download_uploaded_manifest
     @sample_manifest = SampleManifest.find(params[:id])
     send_file @sample_manifest.sample_manifest_path, :type => 'application/vnd.ms-excel.sheet.macroEnabled.12'
  end
   
  def barcode_pdf
    @sample_manifest = SampleManifest.find(params[:id])
    if File.exists?(@sample_manifest.barcodes_path)
      send_file @sample_manifest.barcodes_path, :type => 'application/pdf', :disposition => 'inline'
    else
      redirect_to([:clients,@sample_manifest], :notice => 'No Barcodes Available.')
    end
  end
  
  private
  def unverified_manifest
   @sample_manifest = SampleManifest.find(params[:id])
   redirect_to([:clients,@sample_manifest], :notice => 'Already confirmed!') unless !@sample_manifest.verified?
  end
  
end
