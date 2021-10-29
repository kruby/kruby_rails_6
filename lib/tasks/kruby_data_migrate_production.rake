# Denne rake task flytter alle de gamle data fra en gammel database til en ny database for et nyt projekt.
# Har bl.a. brugt den i forbindelse med overførsel af data da kruby.dk blev opdateret fra at være et rails 3 og ruby 1.8.7 site til at blive et rails 4 og ruby 2.1 site.
# Skal placeres i dit rails projekt under stien lib/tasks
# Kan manuelt startes med kommandoen $ rake migrate_old_data direkte i terminal programmet
# Hvis den skal startes når der deployes til serveren, skal der skrives noget lignende i deploy.rb filen:
# namespace :deploy do
#  namespace :rake_tasks do
#    task :singleton, :roles => :db, :only => {:primary => true} do
#      run rake_task("db:create")
#      run rake_task("migrate_old_data_production")
#      #HUSK at denne rake task ligger i lib/tasks og filen hedder kruby_data_migrate_production.rake
#      #Den tilsvarende til development skal omdøbes til .xrake for ikke at ligge i vejen når du deploy'er
#    end
#  end
# end

#BRUGES FØRSTE GANG (HUSK AT UDKOMMENTERE VALIDERING AF PASSWORD I USER.RB) :old_assets er udeladt med vilje
#task :migrate_old_data_production => [ :delete_all_in_new, :old_pages, :old_menus, :old_content, :old_posts, :old_attachments, :old_hours, :old_relations, :old_vouchers, :old_users, :old_relations_to_partners ]

#HEREFTER BRUGES DENNE PGA. USER.RB'S VALIDERING AF PASSWORD (DET VIRKER IKKE MED :old_assets AKTIVERET)
#task :migrate_old_data_production => [ :delete_all_in_new_1, :old_pages, :old_menus, :old_content, :old_posts, :old_attachments, :old_hours, :old_relations, :old_vouchers, :old_relations_to_partners ]

#DENNE BRUGES FORDI MENU, PAGE, CONTENT og ASSET DATA IKKE SKAL MED HVER GANG (DET VIRKER IKKE MED :old_assets AKTIVERET)
task :migrate_old_data_production => [ :delete_all_in_new_2, :old_posts, :old_hours, :old_relations, :old_vouchers, :old_relations_to_partners ]

task :migrate_old_data_development => [ :delete_all_in_new_1, :old_assets, :old_attachments, :old_contents, :old_partners, :old_users, :old_hours, :old_menus, :old_pages, :old_posts, :old_preferences, :old_vouchers ]

#DENNE BLIVER BRUGT TIL KUN AT OVERFØRER TIMERNE
#task :migrate_old_data_production => [ :delete_all_in_hours, :old_hours ]

# task :delete_all_in_hours => :environment do
#   ActiveRecord::Base.establish_connection :development
#   del = Hour.all.count
#   Hour.destroy_all
#   puts "Ialt slettet i Hour #{del}"
# end

# FOR AT ALT SKAL VIRKE, SKAL ALT KODE UDKOMMENTERES I ALLE MODELLER - 241021
# Alle data i den nye database bliver slettet her
task :delete_all_in_new_1 => :environment do
  ActiveRecord::Base.establish_connection :development
  del = Asset.all.count
  Asset.destroy_all
  puts "Ialt slettet i Asset #{del}"
  del = Attachment.all.count
  Attachment.destroy_all
  puts "Ialt slettet i Attachment #{del}"
  del = Content.all.count
  Content.destroy_all
  puts "Ialt slettet i Content #{del}"
  del = Hour.all.count
  Hour.destroy_all
  puts "Ialt slettet i Hour #{del}"
  del = Menu.all.count
  Menu.destroy_all
  puts "Ialt slettet i Menu #{del}"
  del = Page.all.count
  Page.destroy_all
  puts "Ialt slettet i Page #{del}"
  del = Partner.all.count
  Partner.destroy_all
  puts "Ialt slettet i Partner #{del}"
  del = Post.all.count
  Post.destroy_all
  puts "Ialt slettet i Post #{del}"
  del = Preference.all.count
  Preference.destroy_all
  puts "Ialt slettet i Preference #{del}"
  del = User.all.count
  User.destroy_all
  puts "Ialt slettet i User #{del}"
  del = Voucher.all.count
  Voucher.destroy_all
  puts "Ialt slettet i Voucher #{del}"
end

task :old_assets => :environment do
  desc "Overfører de gamle poster fra asset til den ny database"
  Asset.establish_connection :old_development
  @old_assets = Asset.all
  @old_assets.each do |asset|
    puts "Navnet på 'asset' er: #{asset.description}"
  end
  puts "----------------------------------"
  new_asset(@old_assets)
end

def new_asset(old_assets)
  Asset.establish_connection :development
  old_assets.each do |asset_old|
    asset_new = Asset.new
    asset_new.attributes = {
      :description => asset_old.description,
      :caption => asset_old.caption,
      :user_id => asset_old.user_id,
      :photo_file_name => asset_old.photo_file_name,
      :photo_content_type => asset_old.photo_content_type,
      :photo_file_size => asset_old.photo_file_size,
      :photo_updated_at => asset_old.photo_updated_at
    }
    asset_new.id = asset_old.id
    asset_new.created_at = asset_old.created_at
    asset_new.updated_at = asset_old.updated_at
    asset_new.save!
  end
end

task :old_attachments => :environment do
  desc "Overfører de gamle poster fra attachment til den ny database"
  Attachment.establish_connection :old_development
  @old_attachments = Attachment.all
  @old_attachments.each do |attachment|
    puts "Navnet på 'attachment' er: #{attachment.description}"
  end
  puts "----------------------------------"
  new_attachment(@old_attachments)
end

def new_attachment(old_attachments)
  Attachment.establish_connection :development
  old_attachments.each do |attachment_old|
    attachment_new = Attachment.new
    attachment_new.attributes = {
      :attachable_type => attachment_old.attachable_type,
      :attachable_id => attachment_old.attachable_id,
      :description => attachment_old.description,
      :image_size => attachment_old.image_size,
      :position => attachment_old.position,
      :asset_id => attachment_old.asset_id
    }
    attachment_new.id = attachment_old.id
    attachment_new.created_at = attachment_old.created_at
    attachment_new.updated_at = attachment_old.updated_at
    attachment_new.save!
  end
end

task :old_contents => :environment do
  desc "Overfører de gamle poster fra content til den ny database"
  Content.establish_connection :old_development
  @old_content = Content.all
  @old_content.each do |content|
    puts "Navnet på 'content' er: #{content.navlabel}"
  end
  puts "----------------------------------"
  new_content(@old_content)
end

def new_content(old_content)
  Content.establish_connection :development
  old_content.each do |content_old|
    content_new = Content.new
    content_new.attributes = {
      :resource_id => content_old.resource_id,
      :resource_type => content_old.resource_type,
      :parent_id => content_old.parent_id,
      :navlabel => content_old.navlabel,
      :active => content_old.active,
      :redirect => content_old.redirect,
      :controller_redirect => content_old.controller_redirect,
      :action_redirect => content_old.action_redirect,
      :position => content_old.position,
      :controller_name => content_old.controller_name,
      :category => content_old.category
    }
    content_new.id = content_old.id
    content_new.created_at = content_old.created_at
    content_new.updated_at = content_old.updated_at
    content_new.save!
  end
end

task :old_hours => :environment do
  desc "Overfører de gamle poster fra hour til den ny database"
  Hour.establish_connection :old_development
  @old_hours = Hour.all
  @old_hours.each do |hour|
    puts "Navnet på 'hour' er: #{hour.description}"
  end
  puts "----------------------------------"
  new_hour(@old_hours)
end

def new_hour(old_hours)
  Hour.establish_connection :development
  old_hours.each do |hour_old|
    hour_new = Hour.new
    hour_new.attributes = {
      :description => hour_old.description,
      :number => hour_old.number,
      :date => hour_old.date,
      :user_id => hour_old.user_id,
      :partner_id => hour_old.partner_id
    }
    hour_new.id = hour_old.id
    hour_new.created_at = hour_old.created_at
    hour_new.updated_at = hour_old.updated_at
    hour_new.save!
  end
end

task :old_menus => :environment do
  desc "Overfører de gamle poster fra menus til den ny database"
  Menu.establish_connection :old_development
  @old_menus = Menu.all
  @old_menus.each do |menu|
    puts "Navnet på 'menu' er: #{menu.name}"
  end
  puts "----------------------------------"
  new_menus(@old_menus)
end

def new_menus(old_menus)
  Menu.establish_connection :development
  old_menus.each do |menu_old|
    menu_new = Menu.new
    menu_new.attributes = {
      :name => menu_old.name,
      :title => menu_old.title,
      :body => menu_old.body,
      :active => menu_old.active
    }
    menu_new.id = menu_old.id
    menu_new.created_at = menu_old.created_at
    menu_new.updated_at = menu_old.updated_at
    menu_new.save!
  end
end

task :old_pages => :environment do
  desc "Overfører de gamle poster fra pages til den ny database"
  Page.establish_connection :old_development
  @old_pages = Page.all
  @old_pages.each do |page|
    puts "Navnet på 'page' er: #{page.name}"
  end
  puts "----------------------------------"
  new_pages(@old_pages)
end

def new_pages(old_pages)
  Page.establish_connection :development
  old_pages.each do |page_old|
    page_new = Page.new
    page_new.attributes = {
      :name => page_old.name,
      :title => page_old.title,
      :headline => page_old.headline,
      :body => page_old.body,
      :active => page_old.active
    }
    page_new.id = page_old.id
    page_new.created_at = page_old.created_at
    page_new.updated_at = page_old.updated_at
    page_new.save!
  end
end

task :old_partners => :environment do
  desc "Overfører de gamle poster fra partner til den ny database"
  Partner.establish_connection :old_development
  @old_partners = Partner.all
  @old_partners.each do |partner|
    puts "Navnet på 'partner' er: #{partner.name}"
  end
  puts "----------------------------------"
  new_partner(@old_partners)
end

def new_partner(old_partners)
  Partner.establish_connection :development
  old_partners.each do |partner_old|
    partner_new = Partner.new
    partner_new.attributes = {
      :name => partner_old.name,
      :address => partner_old.address,
      :postno => partner_old.postno,
      :city => partner_old.city,
      :log => partner_old.log,
      :category => partner_old.category,
      :responsible => partner_old.responsible,
      :info => partner_old.info,
      :next_action => partner_old.next_action,
      :lock_version => partner_old.lock_version,
      :user_id => partner_old.user_id,
      :search_lock => partner_old.search_lock,
      :phone => partner_old.phone,
      :email => partner_old.email,
      :homepage => partner_old.homepage,
      :status => partner_old.status,
      :active => partner_old.active
    }
    partner_new.id = partner_old.id
    partner_new.created_at = partner_old.created_at
    partner_new.updated_at = partner_old.updated_at
    partner_new.save!
  end
end

task :old_posts => :environment do
  desc "Overfører de gamle poster fra post til den ny database"
  Post.establish_connection :old_development
  @old_posts = Post.all.order('created_at desc')
  @old_posts.each do |post|
    puts "Navnet på 'post' er: #{post.title}"
  end
  puts "----------------------------------"
  new_post(@old_posts)
end

def new_post(old_posts)
  Post.establish_connection :development
  old_posts.each do |post_old|
    post_new = Post.new
    post_new.attributes = {
      :title => post_old.title,
      :body => post_old.body,
      :position => post_old.position,
      :parent_id => post_old.parent_id,
      :user_id => post_old.user_id,
      :active => post_old.active
    }
    post_new.id = post_old.id
    post_new.created_at = post_old.created_at
    post_new.updated_at = post_old.updated_at
    post_new.save!
  end
end

task :old_preferences => :environment do
  desc "Overfører de gamle preferenceer fra preference til den ny database"
  Preference.establish_connection :old_development
  @old_preferences = Preference.all.order('created_at desc')
  @old_preferences.each do |preference|
    puts "Navnet på 'preference' er: #{preference.title}"
  end
  puts "----------------------------------"
  new_preference(@old_preferences)
end

def new_preference(old_preferences)
  Preference.establish_connection :development
  old_preferences.each do |preference_old|
    preference_new = preference.new
    preference_new.attributes = {
      :name => preference_old.name,
      :value => preference_old.value,
      :user_id => preference_old.user_id
    }
    preference_new.id = preference_old.id
    preference_new.created_at = preference_old.created_at
    preference_new.updated_at = preference_old.updated_at
    preference_new.save!
  end
end

# SKAL IKKE KALDES NÅR DATA ER FLYTTET OVER FØRSTE GANG
task :old_users => :environment do
  desc "Overfører de gamle poster fra user til den ny database"
  User.establish_connection :old_development
  @old_users = User.all
  @old_users.each do |user|
    puts "Navnet på 'user' er: #{user.name}"
  end
  puts "----------------------------------"
  new_user(@old_users)
end

def new_user(old_users)
  User.establish_connection :development
  old_users.each do |user_old|
    user_new = User.new
    user_new.attributes = {
      :name => user_old.name,
      :email => user_old.email,
      :remember_token => user_old.remember_token,
      :remember_token_expires_at => user_old.remember_token_expires_at,
      :active => user_old.active,
      :category => user_old.active,
      :blogname => user_old.blogname
    }
    user_new.id = user_old.id
    user_new.password_hash = user_old.password_hash
    user_new.password_salt = user_old.password_salt
    user_new.created_at = user_old.created_at
    user_new.updated_at = user_old.updated_at
    user_new.save!
  end
end

task :old_vouchers => :environment do
  desc "Overfører de gamle poster fra voucher til den ny database"
  Voucher.establish_connection :old_development
  @old_vouchers = Voucher.all
  @old_vouchers.each do |voucher|
    puts "Navnet på 'voucher' er: #{voucher.description}"
  end
  puts "----------------------------------"
  new_voucher(@old_vouchers)
end

def new_voucher(old_vouchers)
  Voucher.establish_connection :development
  old_vouchers.each do |voucher_old|
    voucher_new = Voucher.new
    voucher_new.attributes = {
      :description => voucher_old.description,
      :number => voucher_old.number,
      :partner_id => voucher_old.partner_id,
      :date => voucher_old.date,
      :user_id => voucher_old.user_id,
      :hourly_rate => voucher_old.hourly_rate
    }
    voucher_new.id = voucher_old.id
    voucher_new.created_at = voucher_old.created_at
    voucher_new.updated_at = voucher_old.updated_at
    voucher_new.save!
  end
end




# # Alle data i den nye database bliver slettet her
# task :delete_all_in_new_2 => :environment do
#   ActiveRecord::Base.establish_connection :development
#   del = Post.all.count
#   Post.destroy_all
#   puts "Ialt slettet i Post #{del}"
#   del = Hour.all.count
#   Hour.destroy_all
#   puts "Ialt slettet i Hour #{del}"
#   del = Relation.all.count
#   Relation.destroy_all
#   puts "Ialt slettet i Relation #{del}"
#   if User.all.count > 0
#     del = 'INGEN'
#   else
#     del = User.all.count
#     User.destroy_all
#   end
#   puts "Ialt slettet i User #{del}"
#   del = Voucher.all.count
#   Voucher.destroy_all
#   puts "Ialt slettet i Voucher #{del}"
# end