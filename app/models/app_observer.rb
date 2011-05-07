class AppObserver < ActiveRecord::Observer

  def after_save(model)
    model.generate_screenshots if model.changes.include?(:url)
  end

end
