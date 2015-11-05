class ErrorsController < ApplicationController

  def show
    respond_to do |format|
      format.html { render template: "errors/#{status_code}", status: status_code }
      format.all  { render nothing: true, status: status_code }
    end
    # render status_code.to_s, status: status_code

  end

  private
  def status_code
    params[:code] || 500

  end
end
