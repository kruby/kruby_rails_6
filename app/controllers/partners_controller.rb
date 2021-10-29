class PartnersController < ApplicationController
  before_action :set_partner, only: %i[:show, :edit, :update, :destroy]
  before_action :logged_in_as_user?
  before_action :current_controller #Findes i application_controller.rb
  before_action :logged_in_as_admin?, :except => ['timeliste', 'show_years_public', 'show_months_public', 'show_days_public'] #Findes i application_controller.rb

  # GET /partners
  # GET /partners.json
  # def index
  # 	@partners = Partner.all.order(name: :asc)
  # end
	
  def index
    @hours = Hour.all
    @q = Partner.search(params[:q])
    @partners = @q.result.order(active: :desc, name: :asc)
  end
	

  # GET /partners/1
  # GET /partners/1.json
  def show
  end

  # GET /partners/new
  def new
    @partner = Partner.new
  end

  # GET /partners/1/edit
  def edit
  end

  # POST /partners
  # POST /partners.json
  def create
    @partner = Partner.new(partner_params)

    respond_to do |format|
      if @partner.save
        if @partner.ics_email?
          send_ics_event
        end
        format.html { redirect_to action: 'index' }
        flash[:notice] = 'Partner blev oprettet'
        #format.html { redirect_to @partner, notice: 'Partner was successfully created.' }
        format.json { render action: 'show', status: :created, location: @partner }
      else
        format.html { render action: 'new' }
        format.json { render json: @partner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /partners/1
  # PATCH/PUT /partners/1.json
  def update
    respond_to do |format|
      if @partner.update(partner_params)
        if @partner.ics_email?
          send_ics_event
          @partner.ics_email = 0
          @partner.save
        end
        format.html { redirect_to action: 'edit' }
        flash[:notice] = 'Partner blev opdateret'
        #format.html { redirect_to @partner, notice: 'Partner was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @partner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /partners/1
  # DELETE /partners/1.json
  def destroy
    @partner.destroy
    respond_to do |format|
      format.html { redirect_to partners_url }
      format.json { head :no_content }
    end
  end
	
  def all_partner_hours
    #@partners = Partner.all
    #@partners = Partner.active.joins(:hours).uniq.order(name: :asc)
    @partners = Partner.active.order(name: :asc)
  end
  
  def active
    active_or_not(params[:id],'partner', 'active')
    redirect_to action: 'index'
  end
  
  def make_passive
    @partner = Partner.find(params[:partner_id])
    @partner.active = false
    @partner.save
    redirect_to all_partner_hours_path
  end
  
  def timeliste
    @partner = Partner.find(session[:partner_id])
    @q = @partner.hours.search(params[:q])
    @hours = @q.result.reorder('partner_id DESC, date DESC').all
    find_years(@partner)
    #@hours = Hour.timeliste(current_user.relation_id).order('date desc')
  end

  def show_years
    #@partners_with_hours = Partner.joins(:hours).uniq.order(company: :asc)
    # Finder en af hver partner der har timer koblet på
    @partner = Partner.find(params[:partner_id])
    @partners = [] << @partner
    # Finder den aktuelle partner
    find_years(@partner)
    # Finder den aktuelle partners timer og kun den første fra hvert år
    render(:action => 'all_partner_hours')
  end

  def find_years(partner)
    @partner_hours = partner.hours.order(date: :asc)
    @year_first = @partner_hours.first.date.year
    @year_last = @partner_hours.last.date.year
    #@this_year = Time.now.year
    @years = []
    @year = @year_last
    until @year < @year_first
      @years << @year
      @year -= 1
    end
    return @years
  end

  def show_months
    #@partners_with_hours = Partner.joins(:hours).uniq.order(company: :asc)
    @partner = Partner.find(params[:partner_id])
    @partners = [] << @partner
    find_years(@partner)
    find_months(@partner, params[:year])
    render(:action => 'all_partner_hours')
  end

  def show_months_public
    @partner = Partner.find(session[:partner_id])
    find_years(@partner)
    find_months(@partner, params[:year])
    render(:action => 'timeliste')
  end


  def find_months(partner, year)
    @hours = Hour.customer(partner.id).yearly_hours(year.to_i).order(date: :desc)
    @month_dates = []
    @month_dates << @hours.first.date
    @month_previous = @hours.first.date.month.to_s
    @hours.each do |hour|
      if hour.date.month.to_s != @month_previous
        @month_dates << hour.date
        @month_previous = hour.date.month.to_s
      end
    end
    return @month_dates
  end

  def show_days
    @partner = Partner.find(params[:partner_id])
    @partners = [] << @partner
    find_years(@partner)
    find_months(@partner, params[:year])
    @hours = Hour.customer(@partner.id).monthly_hours(Date.new(params[:year].to_i,params[:month].to_i)).order(date: :asc) 
    render(:action => 'all_partner_hours')
  end

  def show_days_public
    @partner = Partner.find(session[:partner_id])
    find_years(@partner)
    find_months(@partner, params[:year])
    @hours = Hour.customer(@partner.id).monthly_hours(Date.new(params[:year].to_i,params[:month].to_i)).order(date: :desc) 
    render(:action => 'timeliste')
  end
  
  def send_ics_event
    @ics_event = generate_ics_event
    UserMailer.deliver_ical_email(@ics_event, @partner)
  end
  
  private
  def generate_ics_event
    cal = Icalendar::Calendar.new
    cal.event do |e|
      #e.dtstart     = Icalendar::Values::Date.new('20050428')
      e.dtstart     = @partner.next_action
      #e.dtstart     = DateTime.civil(2014, 11, 27, 18, 00)
      #e.dtend       = Icalendar::Values::Date.new('20050429')
      #e.dtend       = DateTime.civil(2014,11, 27, 19, 00)
      e.dtend       = @partner.next_action + @partner.ics_duration.to_i.minutes
      e.summary     = "Møde med #{@partner.name}"
      e.description = @partner.full_address + "\n\n" + @partner.ics_notes + "\n\n" + @partner.log 
      e.ip_class    = "ARBEJDE"
      # do unless ics alarm empty/blank
      unless @partner.ics_alarm.blank?
        e.alarm do |a|
          a.action        = "AUDIO"
          a.trigger       = @partner.ics_alarm
          a.append_attach "Basso"
        end
      end
    end
    cal.publish
    cal.to_ical
    #render :text => cal, :layout => true
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_partner
    @partner = Partner.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def partner_params
    params.require(:partner).permit(:active, :name, :address, :postno, :city, :log, :category, :responsible, :info, :next_action, :lock_version, :user_id, :search_lock, :phone, :email, :homepage, :ics_email, :ics_duration, :ics_alarm, :ics_notes, :status)
  end
end
