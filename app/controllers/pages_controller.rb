# frozen_string_literal: true

class PagesController < ApplicationController
  def index
    @invoices = Invoice.all.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
  end

  def show
    render view
  end

  private

  def view
    request.path.gsub('/', '')
  end
end
