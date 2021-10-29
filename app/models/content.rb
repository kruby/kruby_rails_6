class Content < ApplicationRecord
  
    belongs_to :resource, :polymorphic => true
    # resource ovenfor er bare et navn. Det kunne have været hvadsomhelst, men i tabellen contents hedder de 2 vigtigste feltnavne så: resource_id og resource_type

    acts_as_tree :order => "position"

    scope :active, -> { where(active: true)}
    scope :no_parent, -> { where(parent_id: nil)}
    scope :sort_position, -> { order(:position)}

    scope :category_admin, -> { where(category: 'admin')}
    scope :category_editor, -> { where(category: 'editor')}
    scope :category_user, -> { where(category: 'user')}
    scope :category_public, -> { where(category: 'public')}


  scope :public_pages, -> { self.no_parent.active.category_public.sort_position }
  scope :user_pages, -> { self.no_parent.active.category_user.sort_position }
  scope :editor_pages, -> { self.no_parent.active.category_editor.sort_position }
  scope :admin_pages, -> { self.no_parent.active.category_admin.sort_position }

  #scope :admin_pages, :conditions => ["parent_id IS NULL and active and category = 'admin'", true], :order => 'position'
  #scope :editor_pages, :conditions => ["parent_id IS NULL and active and category = 'editor'", true], :order => 'position'
  #scope :user_pages, :conditions => ["parent_id IS NULL and active and category = 'user'", true], :order => 'position'
  #scope :public_pages, :conditions => ["parent_id IS NULL and active and category = 'public' ", true], :order => 'position'

  scope :system_menu, -> { self.no_parent.active.category_admin.sort_position }
  scope :public_menu, -> { self.no_parent.active.category_public.sort_position }

    #scope :main_menu, :conditions => ["parent_id IS NULL and active and category = 'public' ", true], :order => 'position, created_at'

    scope :pages, -> { where(controller_name: 'pages')}
    #scope :pages, :conditions => {:controller_name => 'pages'}, :order => 'position'

    #scope :active, :conditions => {:active => true }, :order => 'position'

    #scope :content_menu_items, :conditions => ["resource_type = 'menu' OR resource_type = 'page'", true], :order => 'position'
    scope :menus, -> {where(resource_type: 'menu')}
    scope :pages, -> {where(resource_type: 'page')}
    scope :menus_and_pages, -> {where(resource_type: ['menu', 'page']).order(:position)}
    private

    def self.sort_position
      order('position')
    end

    def self.navlabel
      pluck('navlabel')
    end

    def navlabel_and_id
      "ID:#{id} - #{navlabel}"
    end
  
end

