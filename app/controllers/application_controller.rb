# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def handle_filter
    @filter = String.new
    min_amount_filter = "amount_cents >= #{params[:min_amount]}"
    max_amount_filter = "amount_cents <= #{params[:max_amount]}"

    if params[:min_amount].present? && params[:max_amount].present?
      @filter += min_amount_filter
      @filter += " AND "
      @filter += max_amount_filter
      @filter += " AND "
    elsif params[:min_amount].present?
      @filter += min_amount_filter
      @filter += " AND "
    elsif params[:max_amount].present?
      @filter += max_amount_filter
      @filter += " AND "
    end

    @filter += "user_id = #{current_user.id}"
  end
end
