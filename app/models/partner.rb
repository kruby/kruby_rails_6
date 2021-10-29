class Partner < ApplicationRecord
	
    has_many :contacts
    has_many :hours
    has_many :vouchers

        def full_address
          "#{postno} #{city} \n#{address} \n#{phone} \n#{homepage}"
        end

        scope :active, -> { where(active: true)}
  
	
  end

