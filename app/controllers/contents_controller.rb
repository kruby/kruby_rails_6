class ContentsController < ApplicationController
  before_action :set_content, only: %i[:show, :edit, :update, :destroy]

  before_action :current_controller #Findes i application_controller.rb
  before_action :logged_in_as_admin?
  
  # GET /contents
  # GET /contents.xml
  def index
    @contents = Content.all.order("resource_type, resource_id")
    @types = Content.all.select("distinct resource_type")
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @contents }
    end
  end

  # GET /contents/1
  # GET /contents/1.xml
  def show
    @content = Content.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @content }
    end
  end

  # GET /contents/new
  # GET /contents/new.xml
  def new
    @content = Content.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @content }
    end
  end

  # GET /contents/1/edit
  def edit
    @content = Content.find(params[:id])
  end

  # POST /contents
  # POST /contents.json
  def create
    @content = Content.new(content_params)
	
    respond_to do |format|
      if @content.save
        format.html { redirect_to @content, notice: 'Content was successfully created.' }
        format.json { render action: 'show', status: :created, location: @content }
      else
        format.html { render action: 'new' }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contents/1
  # PATCH/PUT /contents/1.json
  def update
    respond_to do |format|
      if @content.update(content_params)
        format.html { redirect_to :action => 'edit'}
        flash[:notice] = 'Indholdet blev opdateret.' 
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end
	

  # DELETE /contents/1
  # DELETE /contents/1.json
  def destroy
    @content.destroy
    respond_to do |format|
      format.html { redirect_to contents_url }
      format.json { head :no_content }
    end
  end
  
  def change_category
       @content = Content.find(params[:id])
       if @content.category == 'Admin'
         @content.category = 'Public'
       elsif @content.category == 'Public'
         @content.category = 'Editor'   
       elsif @content.category == 'Editor'
         @content.category = 'User'
       elsif @content.category == 'User'
         @content.category = 'Admin'
       elsif @content.category == nil
          @content.category = 'Admin'
       end
       @content.save
      redirect_to(:action => 'index')   
  end
  
  
  def active
    active_or_not(params[:id],'content', 'active')
    @content = Content.find(params[:id])
    if @content.resource_type == 'Menu'
      active_or_not(@content.resource_id, 'menu', 'active')
    elsif @content.resource_type == 'Page'
      active_or_not(@content.resource_id, 'page', 'active')
    end
    redirect_to action: 'index'
  end
  
  def admin
    active_or_not(params[:id],'content', 'admin')
    redirect_to action: 'index'
  end

  def redirect
    active_or_not(params[:id],'content', 'redirect')
    redirect_to action: 'index'
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_content
    @content = Content.find(params[:id])
  end
	
  # Never trust parameters from the scary internet, only allow the white list through.
  def content_params
    params.require(:content).permit(:name, :resource_id, :resource_type, :parent_id, :navlabel, :active, :admin, :redirect, :controller_redirect, :action_redirect, :position, :controller_name, :category)
  end
end



  # class ContentsController < ApplicationController
  #   before_action :set_content, only: [:show, :edit, :update, :destroy]
  #   
  #   # GET /contents
  #   # GET /contents.json
  #   def index
  #     @contents = Content.all
  #   end
  #   
  #   # GET /contents/1
  #   # GET /contents/1.json
  #   def show
  #   end
  #   
  #   # GET /contents/new
  #   def new
  #     @content = Content.new
  #   end
  #   
  #   # GET /contents/1/edit
  #   def edit
  #   end
  #   
  #   # POST /contents
  #   # POST /contents.json
  #   def create
  #     @content = Content.new(content_params)
  #   
  #     respond_to do |format|
  #       if @content.save
  #         format.html { redirect_to @content, notice: 'Content was successfully created.' }
  #         format.json { render action: 'show', status: :created, location: @content }
  #       else
  #         format.html { render action: 'new' }
  #         format.json { render json: @content.errors, status: :unprocessable_entity }
  #       end
  #     end
  #   end
  #   
  #   # PATCH/PUT /contents/1
  #   # PATCH/PUT /contents/1.json
  #   def update
  #     respond_to do |format|
  #       if @content.update(content_params)
  #         format.html { redirect_to @content, notice: 'Content was successfully updated.' }
  #         format.json { head :no_content }
  #       else
  #         format.html { render action: 'edit' }
  #         format.json { render json: @content.errors, status: :unprocessable_entity }
  #       end
  #     end
  #   end
  #   
  #   # DELETE /contents/1
  #   # DELETE /contents/1.json
  #   def destroy
  #     @content.destroy
  #     respond_to do |format|
  #       format.html { redirect_to contents_url }
  #       format.json { head :no_content }
  #     end
  #   end
  #   
  #   private
  #   # Use callbacks to share common setup or constraints between actions.
  #   def set_content
  #     @content = Content.find(params[:id])
  #   end
  #   
  #   # Never trust parameters from the scary internet, only allow the white list through.
  #   def content_params
  #     params.require(:content).permit(:name, :resource_id, :resource_type, :parent_id, :navlabel, :active, :admin, :position, :controller_name, :category)
  #   end
  # end
