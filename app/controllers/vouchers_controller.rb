class VouchersController < ApplicationController
  before_action :set_voucher, only: %i[:show, :edit, :update, :destroy]

  # GET /vouchers
  # GET /vouchers.json
  def index
		if params[:partner_id]
      @q = Voucher.search(params[:q])
			@vouchers = Partner.find(params[:partner_id]).vouchers.order(date: :desc)
    else
      @q = Voucher.search(params[:q])
      @vouchers = @q.result.order(date: :desc)
    end
  end

  # GET /vouchers/1
  # GET /vouchers/1.json
  def show
  end

  # GET /vouchers/new
  def new
    @voucher = Voucher.new
  end

  # GET /vouchers/1/edit
  def edit
  end

  # POST /vouchers
  # POST /vouchers.json
  def create
    @voucher = Voucher.new(voucher_params)
    respond_to do |format|
      if voucher_params[:number].present?
        @voucher.number = voucher_params[:number].to_s.gsub!(',', '.').to_f
      end      
      if @voucher.save
        if params[:voucher][:partner_id].present?
          @partner_id = params[:voucher][:partner_id].to_i
          format.html { redirect_to show_years_path(@partner_id), notice: 'Klippekortet blev oprettet.' }
        else
          format.html { redirect_to vouchers_path, notice: 'Klippekortet blev oprettet.' }
          format.json { render action: 'show', status: :created, location: @voucher }
        end
      else
        format.html { render action: 'new' }
        format.json { render json: @voucher.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vouchers/1
  # PATCH/PUT /vouchers/1.json
  def update
    respond_to do |format|
      if voucher_params[:number].present?
        voucher_params[:number].to_s.gsub!(',', '.').to_f
      end
      if @voucher.update(voucher_params)
        format.html { redirect_to vouchers_path, notice: 'Klippekortet blev opdateret.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @voucher.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vouchers/1
  # DELETE /vouchers/1.json
  def destroy
    @voucher.destroy
    respond_to do |format|
      format.html { redirect_to show_years_path(@voucher.partner_id) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_voucher
      @voucher = Voucher.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def voucher_params
      params.require(:voucher).permit(:description, :number, :partner_id, :date, :user_id, :hourly_rate)
    end
end
