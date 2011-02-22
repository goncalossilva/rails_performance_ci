class ApplicationsController < ApplicationController
  protect_from_forgery
  
  def github
    @application.parse_push(params[:payload])
  end
  
  private
  
  def load_application
    @application = Application.find_by_permalink(params[:id])
  end
end