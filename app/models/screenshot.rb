class Screenshot < ActiveRecord::Base
  include Workflow 
  
  THUMB_SIZES = %w(800x600 400x300 150x150)
  FORMAT      = "jpg"
  QUALITY     = 75
  
  belongs_to :about, :polymorphic => true
  
  validates_presence_of :url
  
  named_scope :ready_for_process, where(:workflow_state => 'new')
  
  workflow do
    state :new do
      event :fetch_image, :transitions_to => :fetched_image
      event :fail, :transitions_to => :fetch_image_failed
    end
    state :fetched_image do
      event :generate_thumbnails, :transition_to => :ready
      event :fail, :transitions_to => :generate_thumbnails_failed
    end
    state :fetch_image_failed
    state :generate_thumbnails_failed
    state :ready
  end
  
  def self.regenerate_all!
    update_all(:workflow_state => "new")
    find_each do |screenshot|
      process_screenshot(screenshot)
    end
  end
  
  def self.process_pending
    ready_for_process.find_each do |screenshot|
      process_pending(screenshot)
    end
  end
  
  def self.process_screenshot(screenshot)
    screenshot.process!
  rescue => e
    Rails.logger.error("Error regenereting thumbnail for #{screenshot.inspect}\n#{e.inspect}\n#{screenshot.build_log}")
  rescue Workflow::NoTransitionAllowed => e
    Rails.logger.error("Error regenereting thumbnail for #{screenshot.inspect}\n#{e.inspect}\n#{screenshot.build_log}")
  end
  
  
  def process!
    return false unless ["new",nil].include?(workflow_state)
    update_attribute(:build_log, '')
    [:fetch_image!, :generate_thumbnails!].each do |state|
      send(state)
      fail! and break if halted?
    end
  end
  
  handle_asynchronously :process!
  
  def path(size = nil)
    size ||= THUMB_SIZES.first
    "/system/thumbnails/#{id}-#{size}.#{FORMAT}"
  end
  
  def big
    path(THUMB_SIZES[0])
  end
  
  def medium
    path(THUMB_SIZES[1])
  end
  
  def small
    path(THUMB_SIZES[2])
  end
  

protected

  def fetch_image
    self.execute "wkhtmltoimage  #{url} #{tempfile_path}" or halt
  end

  def generate_thumbnails
    THUMB_SIZES.each do |size|
      generate_thumbnail_for_size(size) or halt
    end
  end
  
  def generate_thumbnail_for_size(size)
    self.execute("convert -strip -resize '#{size}^' -gravity north -extent #{size} -quality #{QUALITY} #{tempfile_path} #{local_thumbnail_path_for_size(size)}")
  end


  def on_ready_entry(*args)
    puts "Removing temp file"
    File.unlink(tempfile_path)
  end
  
  def tempfile_path
    save if new_record?
    format = Rails.env.production? ? "png" : "jpg"
    File.join(TEMP_DIR,"#{id}.#{format}")
  end
  
  
  def local_thumbnail_path_for_size(size)
    File.join(RAILS_ROOT,'public','system','thumbnails',"#{id}-#{size}.#{FORMAT}")
  end
  

  def execute(cmd)
    Timeout::timeout(10) do
      log =  "#{self.build_log}\n\nExecuting #{cmd}\n"
      log << "="*(10+cmd.size)
      log << `#{cmd} 2>&1`
      update_attribute(:build_log,log)
      return $?.success?
    end
  rescue Timeout::Error => e
    return false
  ensure
    save
  end


end
