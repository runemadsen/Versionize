class Link < Item
  
  attr_accessor :url, :notes
  validates_presence_of :url
  
  def file_extension
     File.extname(url)
  end
  
  def vimeo?
    url[0..15] == "http://vimeo.com" || url[0..19] == "http://www.vimeo.com"
  end
  
  def vimeo_video_id
    url.split("/").last.split("?")[0]
  end
  
  def youtube?
    url[0..21] == "http://www.youtube.com" || url[0..14] == "http://youtu.be" || url[0..17] == "http://youtube.com"
  end
  
  def youtube_video_id
    
    url_split = url.split("?")
    
    if(url_split.count == 2)
      CGI::parse(url_split[1])["v"]
    else
      url.split("/").last
    end
  end
  
end