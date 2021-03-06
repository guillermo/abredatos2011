class Source < Commentable

  scope :highlight, limit(10).order("RAND()")

  validates :title, :url, :description, :category, :presence => true, :on => :create

  def short_title
    return title if title.strip.present?
    uri.host
  end

  def regenerate_screenshots!
    screenshots.find_each {|s| s.destroy}
    screenshots.create(:url => self.url)
  end

end
