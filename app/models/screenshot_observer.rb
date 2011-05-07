class ScreenshotObserver < ActiveRecord::Observer
  
  def after_create(model)
    model.process!
  end
  
end
