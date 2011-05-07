class App < ActiveRecord::Base
  belongs_to :category
  belongs_to :user

  has_many :screenshots, :as => :about

  validate :valid_url

  before_save :set_default_values

  delegate :title, :meta_description, :to => :metadata

  def links
    host = uri.host
    metadata.links.map do |link|
      begin
        next if link =~ /javascript/
        unless link =~ /\Ahttp(s?)\:\/\//
          port = uri.port != 80 ? ":#{uri.port}" : ""
          link = "/#{link}" unless link[0] == 47
          "#{uri.scheme}://#{uri.host}#{port}#{link}" 
        else
          link
        end
      rescue => e
        nil
      end
      
    end.compact.select do |url|
      debugger
      URI.parse(url.gsub(" ","%20")).host == uri.host
    end[0..10]
  end

  def generate_screenshots
    links.each do |link|
      screenshots.create(:url => link)
    end
  end

  def metadata
    @metadata ||= MetaInspector.new(url)
  end

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
