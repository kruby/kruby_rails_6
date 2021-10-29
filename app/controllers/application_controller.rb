# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
	
	#before_action :set_search

  # def set_search
  #   @q = Hour.search(params[:q])
  # end
  
  helper_method :active
  helper_method :route_exists
  helper_method :current_user
  
  helper :all # include all helpers, all the time
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  

  before_action :get_content_for_menu
  before_action :set_user_language
  
  # before_action :set_locale
  #  
  # def set_locale
  #   # I18n.locale = params[:locale] || I18n.default_locale
  #   I18n.locale = 
  # end
  
  def get_content_for_menu
    @system_menu ||= Content.active.no_parent.category_admin.sort_position
    @public_menu ||= Content.active.no_parent.category_public.sort_position
    if session[:user_id]
      @user_category = User.find(session[:user_id]).category
      if @user_category == 'Admin'
        @tabs ||= Content.admin_pages + Content.editor_pages + Content.user_pages
      elsif @user_category == 'Editor'
        @tabs ||= Content.editor_pages + Content.user_pages
      elsif @user_category == 'User'
        @tabs ||= Content.user_pages
      end
    end
  end
  
  def active_admin
   active_controller = params[:controller].classify.constantize
   @active_controller = active_controller.find(params[:id])
   if @active_controller.admin
     @active_controller.admin = 0
     #flash[:notice] = 'Jobbet blev til nul'
   else
     @active_controller.admin = 1
   #flash[:notice] = 'Jobbet blev til 1'
   end
   
   @active_controller.update_attributes(params[:active_controller])
   
   redirect_to(:action => 'index')
  end
  
  def active_redirect
   active_controller = params[:controller].classify.constantize
   @active_controller = active_controller.find(params[:id])
   if @active_controller.redirect
     @active_controller.redirect = 0
     #flash[:notice] = 'Jobbet blev til nul'
   else
     @active_controller.redirect = 1
   #flash[:notice] = 'Jobbet blev til 1'
   end
   
   @active_controller.update_attributes(params[:active_controller])
   
   redirect_to(:action => 'index')
  end

  def admin
    
     admin_controller = params[:controller].classify.constantize
     @active_controller = admin_controller.find(params[:id])
     if @active_controller.admin
       if User.admin.count < 2 #Her sørges der for, at der altid er mindst 1 admin blandt Users
         #redirect_to(:controller => 'users', :action => 'index')
         flash[:notice] = 'Kan ikke ændres. Altid mindst én admin tilgængelig'
       else
         @active_controller.admin = 0
       end
       #flash[:notice] = 'Jobbet blev til nul'
     else
       @active_controller.admin = 1
     #flash[:notice] = 'Jobbet blev til 1'
     end
   
     @active_controller.update_attributes(params[:admin_controller])
   
     redirect_to(:action => 'index')
  end
  
  
  def category
    
     category_controller = params[:controller].classify.constantize
     @category_controller = category_controller.find(params[:id])
         if @category_controller.category == 'Admin'
            if User.admin.count < 2 #Her sørges der for, at der altid er mindst 1 admin blandt Users
              #redirect_to(:controller => 'users', :action => 'index')
              flash[:notice] = 'Kan ikke ændres. Altid mindst én admin tilgængelig'
            else
              @category_controller.category = 'Editor'
            end
         elsif @category_controller.category == 'Editor'
           @category_controller.category = 'User'
         elsif @category_controller.category == 'User'
           @category_controller.category = 'Public'
         elsif @category_controller.category == 'Public'
            @category_controller.category = 'Admin'
         end

     @category_controller.update_attributes(params[:category_controller])
   
     redirect_to(:action => 'index')
  end
  
  #NY AUTHENTICATION FOR RAILS3
  
  private

  def active_or_not id, contrl, attr
    active_or_not = contrl.classify.constantize.find(id)
    active_or_not[attr] == true ? active_or_not[attr] = false : active_or_not[attr] = true
    active_or_not.save
  end

  def set_user_language  
    I18n.locale = 'da'  
  end
  
  private
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  protected
  
    def current_controller
      session[:current_controller] = params[:controller]
    end

    def logged_in_as_user?
      unless session[:user_id]
        flash[:notice] = "Du skal først logge ind."
        redirect_to log_in_path
        return false
      else
        @tabs ||= Content.user_pages
        return true
      end
    end  
    
    def logged_in_as_admin?
      unless session[:user_id]
        flash[:notice] = "Du skal først logge ind."
        redirect_to log_in_path
        return false
      else
        if current_user.category == 'Admin'
          return true
        else
          if current_user.category == 'Editor' || current_user.category == 'User'
            redirect_to access_denied_admin_path
          end
          return false
        end
        return true
      end
    end
    
    def logged_in_as_editor?
      unless session[:user_id]
        flash[:notice] = "Du skal først logge ind."
        redirect_to log_in_path
        return false
      else
        if current_user.category == 'Editor' || current_user.category == 'Admin'
          @tabs ||= Content.editor_pages + Content.user_pages
          return true
        else
          if current_user.category == 'User'
            redirect_to access_denied_admin_path
          end
          return false
        end
        return true
      end
    end

  
end