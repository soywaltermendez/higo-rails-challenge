# frozen_string_literal: true

require './app/jobs/invoice_import_job/'

class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :destroy]
  before_action :handle_filter, only: :index

  def index
    @filter_path = root_path
    @invoices = Invoice.where(@filter).order(created_at: :desc)
                       .paginate(page: params[:page], per_page: @per_page)
  end

  def show
    @invoice = Invoice.find(params[:id])
  end

  def new
    @invoice = Invoice.new
  end

  def create
    files = Array.new
    params[:xmls].each do |xml|
        doc = Nokogiri::XML(xml.open)
        return StandardError if doc.errors.any?
        files << Hash.from_xml(xml.open).with_indifferent_access
    end

    InvoiceImportJob.perform_later(files, current_user)
    redirect_to root_path, flash: { success: "Invoice process created." }
  rescue Exception => e
    logger.error e
    @invoice = Invoice.new
    flash[:error] = "We had an error, please try again."
    render :new
  end

  def destroy
    @invoice.destroy
    redirect_to root_path, flash: { success: "Invoice deleted successfully." }
  end

  private

  def set_invoice
    @invoice = Invoice.find(params[:id])
  end
end
