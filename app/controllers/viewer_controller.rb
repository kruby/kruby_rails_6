class ViewerController < ApplicationController
  
  
  def show
    if params[:name]
      @page = Page.find_by_name(params[:name]) || Page.find_by_name('Forside')
    else
      @page = Page.find(params[:id]) || Page.find_by_name('Forside')
    end
    
    @content = @page.body rescue 'Indhold følger snarest'
    @posts = Post.by_position.activated.limit(16)
    @assets = Asset.forside_fotos
    @facebook = Page.find_by_name('Facebook').body rescue "Her kommer noget fra FaceBook"
    render 'forside'
  end

  def forside
    @page = Page.find_by_name('Forside')
    @posts = Post.by_position.activated.limit(16)
    @assets = Asset.forside_fotos
    @forside_titel = Preference.find_by_name('Forside titel').value rescue "Bloggen"
    @content = @page.body rescue 'Indhold følger snarest'
    @facebook = Page.find_by_name('Facebook').body rescue "Her kommer noget fra FaceBook"
  end

  def torc
    #@page = Page.find_by_name('Forside')
    #@posts = Post.by_position.activated.limit(16)
    @assets = Asset.forside_fotos
    @forside_titel = 'The Original Racing Collection'
    #@content = @page.body rescue 'Indhold følger snarest'
  end

  def index
    @pagetitle = 'Overskrifter fra Viewercontroller!'
  end


  def product
    @pagetitle="Her viser vi alle kort i databasen"
    @fruit = Fruit.find_by_name(params[:name])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @fruit }
    end
  end
  
  def download_file
    path = params[:path]
    require 'open-uri'
    open do |file|
      file << open(path.to_s).read
    end
  end
  
  
  private

  def test_web_browser
    catch(:match) do
      ["Apple", "Firefox/3", "Firefox/2", "MSIE 6", "MSIE 7", "Opera"].each do |ua|
        throw(:match, ua.gsub(/[^a-z0-9]/i, "")) if request.user_agent =~ Regexp.new(ua)
      end
      nil
    end
  end

end
