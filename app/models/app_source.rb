class AppSource < ActiveRecord::Base
  belongs_to :app
  belongs_to :source
end
