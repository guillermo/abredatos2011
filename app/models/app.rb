class App < Commentable

  validate :name, :uniqueness => true

  has_many :app_sources
  has_many :sources, :through => :app_sources
  delegate :title, :meta_description, :to => :metadata
  
  before_validation :set_default_values
  
  validates :name, :description, :url, :presence => true
  scope :highlight, joins("LEFT JOIN `comments` ON `comments`.`thing_id` = `apps`.`id` AND `comments`.`thing_type` = 'App'").group(:id).select("count('id') as comments_count, `apps`.*").order("comments_count DESC, RAND()").limit(10)
  
  
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
    return unless url.present?
    self.name = title if name.blank?
    self.description = meta_description if description.blank?
  end


end
