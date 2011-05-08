class Source < Commentable


  def short_title
    return title if title.strip.present?
    uri.host
  end

  def regenerate_screenshots!
    screenshots.find_each {|s| s.destroy}
    screenshots.create(:url => self.url)
  end

end
