class Attachment < ApplicationRecord
  
  acts_as_list #SÅSNART EN POST BLIVER OPRETTET VED SÅ FÅR POSITION EN VÆRDI.
  belongs_to :attachable, :polymorphic => true
  
end
