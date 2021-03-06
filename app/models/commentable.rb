class Commentable < ActiveRecord::Base
  self.abstract_class = true
  
  validate :valid_url

  belongs_to :category
  delegate :name, :to => :category, :prefix => true, :allow_nil => true
  belongs_to :user
  
  has_many :comments, :as => :thing, :dependent => :destroy
  has_many :screenshots, :as => :about, :dependent => :destroy

  delegate :path, :small, :medium, :big, :to => :screenshot, :prefix => true, :allow_nil => true


  def host
    uri.host
  rescue
    return url
  end

  def self.random
    order('rand()').where(:screenshots => {:workflow_state => :ready}).joins(:screenshots).first
  end
  
  def screenshot
    screenshots.ready.first || screenshots.first
  end

  def url
    return self["url"] if uri.nil?
    u = uri.dup
    u.path = '/' if u.path == "" || u.path.empty?
    u.to_s
  end
  
  def links
    all_links = [url] + metadata.links.map do |link|
      next if link =~ /javascript|\@|mailto/
      next unless (link_uri = URI.parse(link.gsub(" ","%20")) rescue nil)
      
      next unless [uri.host,nil].include?(link_uri.host)
      link_uri.host ||= uri.host
      link_uri.scheme ||= uri.scheme
      link_uri.port ||= uri.port unless uri.port == 80
      link_uri.path = "/#{link_uri.path}" unless link_uri.path =~ /^\//
      next if link_uri.host != uri.host
      link_uri.to_s
    end
    all_links.compact.sort{|a,b| a.size <=> b.size }.uniq
  end
  

  def metadata
    return nil unless self["url"].present?
    MetaInspector.new(self["url"]) 
  end
  

  def has_screenshots?
    screenshots.ready.any?
  end
  
  def uri
    return nil unless self["url"].present?
    URI.parse(self["url"]) 
  rescue
    nil
  end

  protected


  def valid_url(*attr_names)
    return false unless uri
    schemes = %w(http https)
    if !schemes.include?(uri.scheme) || [:scheme, :host].any? { |i| uri.send(i).blank? }
      raise(URI::InvalidURIError)
    end
  rescue URI::InvalidURIError => e
    errors.add(:url, :invalid)
  end

  
end