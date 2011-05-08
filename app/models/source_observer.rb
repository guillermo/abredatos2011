class SourceObserver < ActiveRecord::Observer

  def after_save(model)
    model.regenerate_screenshots! if model.changes.include?(:url)
  end

end
