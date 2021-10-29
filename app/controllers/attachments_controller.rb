class AttachmentsController < ApplicationController
	before_action :set_attachment, only: %i[:show, :edit, :update, :destroy]
  
	before_action :current_controller #Findes i application_controller.rb
	before_action :logged_in_as_admin?

	# GET /attachments
	# GET /attachments.json
	def index
		@attachments = Attachment.all
	end

	def sort
	  params[:attachment].each_with_index do |id, index|
      Attachment.where(id: id).update_all(position: index+1)
	    #Attachment.update_all({position: index+1}, {id: id})
	  end
	  render nothing: true
	end

	# GET /attachments/1
	# GET /attachments/1.json
	def show
	end

	# GET /attachments/new
	def new
		@attachment = Attachment.new
	end

	# GET /attachments/1/edit
	def edit
	end

	# POST /attachments
	# POST /attachments.json
	def create
		@attachment = Attachment.new(attachment_params)

		respond_to do |format|
			if @attachment.save
				format.html { redirect_to @attachment, notice: 'Attachment was successfully created.' }
				format.json { render action: 'show', status: :created, location: @attachment }
			else
				format.html { render action: 'new' }
				format.json { render json: @attachment.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /attachments/1
	# PATCH/PUT /attachments/1.json
	def update
		respond_to do |format|
			if @attachment.update(attachment_params)
				format.html { redirect_to @attachment, notice: 'Attachment was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: 'edit' }
				format.json { render json: @attachment.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /attachments/1
	# DELETE /attachments/1.json
	def destroy
		@attachment.destroy
		respond_to do |format|
			format.html { redirect_to attachments_url }
			format.json { head :no_content }
		end
	end
	
	def destroy_from_post
		@attachment = Attachment.find(params[:id])
		@attachment.destroy

		#redirect_to (:controller => 'post', :id => params[:post_id], :action => 'edit' )
		redirect_to edit_post_path(params[:post_id])
	end
  
  
	private

	def find_attachment
		params.each do |name, value|
			if name =~ /(.+)_id$/
				return $1.classify.constantize.find(value)
			end
		end
		nil
	end
	
	

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_attachment
		@attachment = Attachment.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def attachment_params
		params.require(:attachment).permit(:attachable_type, :attachable_id, :description, :image_size, :position, :asset_id)
	end
end
