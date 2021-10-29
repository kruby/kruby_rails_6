class Page < ApplicationRecord
  
    has_one :content, :as => :resource, :dependent => :destroy

    after_create :make_content
    after_update :update_content

    def make_content
      c = Content.new
      c.resource = self #fordi jeg bruger after_create kan jeg bruge self til at få id fra den aktuelle post
      c.navlabel = self.name.capitalize #opretter navlabel første gang men opdatere ikke fra titel igen
      c.active = self.active
      c.controller_name = 'pages'
      c.save
    end

    def update_content
      if
        c = Content.find_by_resource_id_and_resource_type(self.id, 'Page')
        c.navlabel = self.name
        c.active = self.active
        c.save
      else
        c = Content.new
        c.resource = self #fordi jeg bruger after_create kan jeg bruge self til at få id fra den aktuelle post
        c.navlabel = self.name.capitalize #opretter navlabel første gang men opdatere ikke fra titel igen
        c.active = self.active
        c.controller_name = 'pages'
        c.save
      end
    end
  
  end
