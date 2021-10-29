Rails.application.routes.draw do
  
  # mount Ckeditor::Engine => '/ckeditor'

	resources :contacts

	resources :partners do
		resources :hours
      resources :vouchers
	end  
  get 'partners/active/:id' => 'partners#active', as: :partner_active

	get '/klip' => 'partners#all_partner_hours', as: :all_partner_hours
  get '/passive/:partner_id' => 'partners#make_passive', as: :make_passive

	get '/timeliste' => 'partners#timeliste', as: :timeliste
	get '/monthly' => 'hours#monthly', as: :monthly

	get 'partners/years_show/:partner_id' => 'partners#show_years', as: :show_years
	get 'partners/months_show/:partner_id/:year' => 'partners#show_months', as: :show_months
	get 'partners/months/days_show/:partner_id/:year/:month' => 'partners#show_days', as: :show_days
	# get 'partners/partners/:partner_id/edit/:id' => 'partners#edit', as: :edit_hour
	# get 'partners/years_hide/:partner_id' => 'partners#hide_years', as: :hide_years
	# get 'partners/months_hide/:partner_id' => 'partners#hide_months', as: :hide_months
	# get 'partners/months/days_hide/:partner_id' => 'partners#hide_days', as: :hide_days
  
	# PUBLIC
	get 'partners/months_show_public/:partner_id/:year' => 'partners#show_months_public', as: :show_months_public
	get 'partners/months/days_show_public/:partner_id/:year/:month' => 'partners#show_days_public', as: :show_days_public
	# get 'partners/months_hide_public/:partner_id' => 'partners#hide_months_public', as: :hide_months_public
	# get 'partners/months/days_hide_public/:partner_id' => 'partners#hide_days_public', as: :hide_days_public


  get '/ingen_adgang' => 'users#no_access_admin', :as => :access_denied_admin
	resources :preferences

	resources :vouchers

	resources :users
	get 'users/active/:id' => 'users#active', as: :user_active
	

	resources :relations
	
	# resources :relations do
	# 	resources :hours
	# end

	# resources :hours, except: :edit
	# get '/timeliste' => 'hours#timeliste', as: :timeliste
	# get '/monthly' => 'hours#monthly', as: :monthly
	
	resources :hours
	#resources :hours, except: :edit
	
	# resources :hours, except: :edit do
	# 	collection do
	# 		match 'search' => 'hours#search', via: [:get, :post], as: :search
	# 	end
	# end
 

	resources :attachments do
		collection do
			post :sort
			delete 'destroy_from_post'
		end
	end
	
	get '/attachments/destroy_from_post/:id/:post_id' => 'attachments#destroy_from_post', :as => :destroy_from_post

	resources :assets do
		collection do
			post 'edit_multiple'
			put 'update_multiple'
			get 'add_to_post'
		end
	end

	get '/assets/add_to_post/:id' => 'assets#add_to_post', :as => :add_to_post

	resources :menus
	get 'menus/active/:id' => 'menus#active', as: :menu_active

	resources :posts do
		collection do
			post :sort
		end
	end

	get '/bloggen' => 'posts#blog', :as => :bloggen
	get 'posts/active/:id' => 'posts#active', as: :post_active
	

	resources :contents  
	get 'contents/active/:id' => 'contents#active', as: :content_active
	get 'contents/admin/:id' => 'contents#admin', as: :content_admin
	get 'contents/redirect/:id' => 'contents#redirect', as: :content_redirect
	get 'contents/change_category/:id' => 'contents#change_category', as: :change_category

	resources :pages
	get 'pages/active/:id' => 'pages#active', as: :page_active
  
	resource :sessions
	#Single resources map to plural controllers (/session => sessions_controller.rb)
  
	resources :viewer
	get 'projekter' => 'viewer#show', :as => :projekter, name: 'projekter'
	get 'produkter' => 'viewer#show', :as => :produkter, name: 'produkter'
	get 'kontakt' => 'viewer#show', :as => :kontakt, name: 'kontakt'
	get 'klippekort' => 'viewer#show', :as => :klippekort, name: 'klippekort'
  get 'torc' => 'viewer#torc', :as => :torc, name: 'torc'
	get 'persondatapolitik' => 'viewer#show', :as => :persondatapolitik, name: 'persondatapolitik'

  
	get 'logoff' => 'sessions#destroy', as: 'logoff'
	get 'log_out' => 'sessions#destroy', as: 'log_out'
	get 'logout' => 'sessions#destroy', as: 'logout'
	get 'log_in' => 'sessions#new', as: 'log_in'
	get 'login' => 'sessions#new', as: 'login'
	get 'sign_up' => 'users#new', as: 'sign_up'

	get 'old_menus', to: 'menus#create_from_old'
  
	root 'viewer#forside'
  
  get 'film' => 'viewer#film', :as => :film, name: 'film'
  get ':path' => 'viewer#download_file', :as => :download_file, name: 'download_file'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
