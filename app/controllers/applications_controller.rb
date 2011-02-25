class ApplicationsController < ApplicationController
  before_filter :load_application
  
  def github    
    @application.parse_payload(params[:payload])
    
    render :nothing => true
  end
  
  private
  
  def load_application
    @application = Application.find_by_permalink(params[:id])    
  end
end