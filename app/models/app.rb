class App < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  
  has_many :app_sources
  has_many :sources, :through => :app_sources
  
  has_many :comments, :as => :thing
  has_many :screenshots, :as => :about

  validate :valid_url
  validate :name, :uniqueness => true
  before_save :set_default_values
  delegate :title, :meta_description, :to => :metadata
  delegate :host, :to => :uri
  delegate :path, :small, :medium, :big, :to => :screenshot, :prefix => true, :allow_nil => true
  
  def self.random
    order('rand()').where(:screenshots => {:workflow_state => :ready}).joins(:screenshots).first
  end
  
  def screenshot
    screenshots.first
  end
  
  def links
    metadata.links.map do |link|
      puts link
      next if link =~ /javascript|\@|mailto/
      next unless (link_uri = URI.parse(link.gsub(" ","%20")) rescue nil)
      
      next unless [uri.host,nil].include?(link_uri.host)
      link_uri.host ||= uri.host
      link_uri.scheme ||= uri.scheme
      link_uri.port ||= uri.port unless uri.port == 80
      link_uri.path = "/#{link_uri.path}" unless link_uri.path =~ /^\//
      next if link_uri.host != uri.host
      link_uri.to_s
    end.compact.sort{|a,b| a.size <=> b.size }.uniq
  end
  
  def short_name
    return name if name.strip.present?
    uri.host
  end

  def metadata
    @metadata ||= MetaInspector.new(url)
  end
  
  def regenerate_screenshots!
    screenshots.find_each {|s| s.destroy}
    links[0..5].each { |link| screenshots.create(:url => link) }
  end
  handle_asynchronously :regenerate_screenshots!

  def uri
    URI.parse(url)
  end

  protected

  def set_default_values
    self.name = title if name.blank?
    self.description = meta_description if description.blank?
  end

  def valid_url(*attr_names)
    schemes = %w(http https)
    if !schemes.include?(uri.scheme) || [:scheme, :host].any? { |i| uri.send(i).blank? }
      raise(URI::InvalidURIError)
    end
  rescue URI::InvalidURIError => e
    errors.add(:url, :invalid)
  end


end
