class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :thing, :polymorphic => true
  attr_accessible :title, :body
  
  delegate :name, :to => :user, :prefix => true, :allow_nil => true
  
  def author
    user_name || "Anónimo"
  end
end
