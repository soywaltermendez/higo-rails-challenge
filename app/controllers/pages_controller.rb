class PagesController < ApplicationController
  def index
  end

  def show
    render view
  end

  private

  def view
    request.path.gsub('/', '')
  end
end
