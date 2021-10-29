class UsersController < ApplicationController
  
  #before_action :logged_in_as_user?
  before_action :current_controller #Findes i application_controller.rb
  before_action :logged_in_as_admin?, :except => ['no_access_admin']

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to :action => 'index'
      flash[:notice] = "Brugeren " + @user.name + " blev oprettet!"
    else
      render "new"
    end
  end

  def no_access_admin
    #Der er her blot for at kunne lede hen til det rigtige layout
  end

  def index
    @q = User.search(params[:q])
    @users = @q.result.order(category: :asc)
    #@users = User.find(:all)
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    if @user.category == 'Admin'
      if User.admin.count < 2
        flash[:notice] = 'Kan ikke slettes. Altid mindst én admin tilgængelig'
        redirect_to(:action => 'index')
      else
        @user.destroy
        flash[:notice] = 'Brugeren ' + @user.name + ' blev slettet!'
        redirect_to(users_url)
      end
    else
      @user.destroy
      flash[:notice] = 'Brugeren ' + @user.name + ' blev slettet!'
      redirect_to(users_url) 
    end

  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.category == 'Admin' and params[:user][:category] != 'Admin' 
      if User.admin.count < 2
        flash[:notice] = 'Kan ikke ændres. Altid mindst én admin tilgængelig'
        redirect_to(:action => 'index')
      else
        update_now
      end
    
    else
      update_now 
    end
  end

  def update_now
    respond_to do |format|
      if @user.update(user_params)
        flash[:notice] = 'Brugeren blev opdateret!'
        #format.html { redirect_to(user_path(@user)) }
        format.html { redirect_to(:action => 'index') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def active
    active_or_not(params[:id],'user', 'active')
    redirect_to action: 'index'
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :blogname, :name, :category, :active, :partner_id, :avatar)
  end
end
