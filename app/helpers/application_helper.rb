module ApplicationHelper
	#KIG EFTER DATOER I DA.YML ISTEDET
	
	def nice_date datoen
		return datoen.strftime('%d.%m.%Y')
	end

	def mini_date datoen
		return datoen.strftime('%d%m%y')
	end
  
	def route_exists path
		@r = Rails.application.routes.recognize_path(path)
		@r == nil ? true : false
	end
  
	def delimiter number
		number_with_precision(number.to_d, locale: :da, precision: 2)
	end
  
	def nice_timestamp(timestamp)
		h timestamp.strftime("%d.%m.%y - %H:%M")
	end

	def nice_time(tiden)
		return tiden.strftime(' - %H:%M')
	end

	def flowtype_1
		return("<script>$('body').flowtype({  
		minimum:450, 
		maximum:850, 
		minFont:12, 
		maxFont:28, 
		fontRatio:40 
		});</script>")
	end
  
  # def google_font_link_tag(family)
  #   tag('link', {:rel => :stylesheet, :type => Mime::CSS, :href => "https://fonts.googleapis.com/css?family=#{family}"}, false, false)
  # end
  
end
