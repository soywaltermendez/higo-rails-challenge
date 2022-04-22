# frozen_string_literal: true

class PagesController < ApplicationController


  def index
    filter = ""
    min_amount_filter = "amount_cents >= #{params[:min_amount]}"
    max_amount_filter = "amount_cents <= #{params[:max_amount]}"

    if params[:min_amount].present? && params[:max_amount].present?
      filter += min_amount_filter
      filter += " AND "
      filter += max_amount_filter
    elsif params[:min_amount].present?
      filter += min_amount_filter
    elsif params[:max_amount].present?
      filter += max_amount_filter
    end

    @invoices = Invoice.where(filter).where(user: current_user)
                       .order(created_at: :desc)
                       .paginate(page: params[:page], per_page: 10)
  end

  def show
    render view
  end

  private

  def view
    request.path.gsub('/', '')
  end
end
