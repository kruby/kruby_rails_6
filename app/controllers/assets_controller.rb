class AssetsController < ApplicationController
  before_action :set_asset, only: %i[:show, :edit, :update, :destroy]

  before_action :current_controller #Findes i application_controller.rb
  before_action :logged_in_as_admin?

  # GET /assets
  # GET /assets.json
  def index
    #@assets = Asset.all
    @q = Asset.search(params[:q])
    @assets = @q.result.order(photo_updated_at: :desc)
  end

  # GET /assets/1
  # GET /assets/1.json
  def show
  end

  # GET /assets/new
  def new
    @asset = Asset.new
  end

  # GET /assets/1/edit
  def edit
  end

  # POST /assets
  # POST /assets.json
  def create
    @asset = Asset.new(asset_params)

    respond_to do |format|
      if @asset.save
        # format.html { redirect_to @asset, notice: 'Asset was successfully created.' }
        format.html { redirect_to assets_url, notice: 'Foto blev oprettet!' }
        flash[:notice] = 'Foto blev oprettet!'
        format.json { render action: 'show', status: :created, location: @asset }
      else
        format.html { render action: 'new' }
        format.json { render json: @asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assets/1
  # PATCH/PUT /assets/1.json
  def update
    respond_to do |format|
      if @asset.update(asset_params)
        #format.html { redirect_to @asset, notice: 'Asset was successfully updated.' }
        format.html { redirect_to action: 'edit' }
        flash[:notice] = 'Foto blev opdateret'
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assets/1
  # DELETE /assets/1.json
  def destroy
    @asset.destroy
    respond_to do |format|
      format.html { redirect_to assets_url }
      format.json { head :no_content }
    end
  end
	
  def add_to_post
    @assets = Asset.all.order('photo_updated_at DESC')
    @attachable = Post.find(params[:id])
    @array_of_ids = find_attachment_ids(@attachable)
      

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assets }
    end
  end
	
	
  def edit_multiple
    @asset_ids = params[:asset_ids]
    @post = Post.find(params[:post_id])
    
    if @asset_ids
      @assets = Asset.find(@asset_ids)
      @assets.each do |asset|
        @post.attachments.build(attachable_id: @post.id, asset_id: asset.id, attachable_type: 'Post')
      end
      @post.save!
      redirect_to edit_post_path(@post)
    else
      redirect_to add_to_post_path(@post)
      flash[:notice] = 'Du skal tilføje fotos eller gå tilbage!'
    end  
  end

  def update_multiple
    @assets = Product.find(params[:product_ids])
    @products.each do |product|
      product.update_attributes!(params[:product].reject { |k,v| v.blank? })
    end
    flash[:notice] = "Flere fotos opdateret!"
    redirect_to products_path
  end
  
  def find_attachment_ids(attachable)
		@attachment_ids = Attachment.where(attachable_id: attachable.id).select(:asset_id)
    @array_of_ids = []
    @c = 0
    @attachment_ids.each do
      @array_of_ids << @attachment_ids[@c][:asset_id]
      @c += 1
    end
    return @array_of_ids
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_asset
    @asset = Asset.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def asset_params
    params.require(:asset).permit(:description, :user_id, :photo, :caption)
  end
end
