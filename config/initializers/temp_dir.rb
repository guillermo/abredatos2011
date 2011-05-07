require 'fileutils'
TEMP_DIR = Dir.mktmpdir('abredatos')
directory = File.join(RAILS_ROOT,'public','system','thumbnails')
FileUtils.mkdir_p directory unless File.directory?(directory)