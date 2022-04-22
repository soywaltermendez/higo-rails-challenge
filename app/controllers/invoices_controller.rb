# frozen_string_literal: true

require 'nokogiri'

class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :destroy]

  # GET /invoices/1
  def show
    @invoice = Invoice.find(params[:id])
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
  end

  # POST /invoices
  def create
    params[:xmls].each do |xml|
      doc = Nokogiri::XML(xml.open)

      return StandardError if doc.errors.any?

      hash = Hash.from_xml(xml.open).with_indifferent_access
      xml_json = hash[:hash]
      xml_json[:user] = current_user

      emitter = Person.find_or_create_by(xml_json[:emitter])
      xml_json[:emitter] = emitter

      receiver = Person.find_or_create_by(xml_json[:receiver])
      xml_json[:receiver] = receiver

      Invoice.create(xml_json)
    end

    @invoices = Invoice.all.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
    render "pages/index"
  rescue Exception => exception
    raise exception
    @invoice = Invoice.new
    flash[:error] = exception
    render :new
  end

  # DELETE /invoices/1
  def destroy
    @invoice.destroy
    redirect_to root_path, flash: { success: "Invoice deleted successfully." }
  end

  private

  def set_invoice
    @invoice = Invoice.find(params[:id])
  end
end
