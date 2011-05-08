class App < Commentable

  validate :name, :uniqueness => true
  before_save :set_default_values

  has_many :app_sources
  has_many :sources, :through => :app_sources
  delegate :title, :meta_description, :to => :metadata
  
  validates :name, :presence => true
  scope :highlight, limit(10).order("RAND()")
  
  def regenerate_screenshots!
    screenshots.find_each {|s| s.destroy}
    links[0..5].each { |link| screenshots.create(:url => link) }
  end
  handle_asynchronously :regenerate_screenshots!
  
  
  def short_name
    return name if name.strip.present?
    uri.host
  end
  

  protected

  def set_default_values
    self.name = title if name.blank?
    self.description = meta_description if description.blank?
  end


end
