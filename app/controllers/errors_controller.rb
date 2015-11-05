class ErrorsController < ApplicationController

  def page_not_found
      respond_to do |format|
        format.html { render template: 'errors/404', layout: 'layouts/application', status: 404 }
        format.all  { render nothing: true, status: 404 }
      end
    end

    def server_error
      respond_to do |format|
        format.html { render template: 'errors/500', layout: 'layouts/error', status: 500 }
        format.all  { render nothing: true, status: 500}
      end
    end

end
