class ScreenshotsController < ApplicationController
  # GET /apps
  # GET /apps.xml
  def index
    @screenshots = Screenshot.where(:workflow_state => "ready")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @apps }
    end
  end

end
