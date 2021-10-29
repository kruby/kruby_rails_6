class Asset < ApplicationRecord
  
  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/jpg', 'image/png']

  # has_attached_file   :photo, :styles => { :original => "500x500>", :small => "100x100>", :medium => "200x200>", :large => "300x300>", :thumb => "20x20>" },
  #                      :default_url => "/uploads/assets/:id/:style/:basename.:extension",
  #                      :path => ":rails_root/public/uploads/assets/:id/:style/:basename.:extension"

  scope :forside_fotos, -> {where('description LIKE ?', "%(Forside)%")}


  belongs_to :attachment, :polymorphic => true

end
