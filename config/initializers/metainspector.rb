
require 'meta_inspector/scraper'

module MetaInspector
  extend self

  # Sugar method to be able to create a scraper in a shorter way
  def new(url)
    Scraper.new(url)
  end
end
