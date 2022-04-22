# frozen_string_literal: true

require 'nokogiri'

class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :destroy]
  before_action :handle_filter, only: :index

  def index
    @filter_path = root_path
    @invoices = Invoice.where(@filter).order(created_at: :desc)
                       .paginate(page: params[:page], per_page: @per_page)
  end

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
      ActiveRecord::Base.transaction do
        doc = Nokogiri::XML(xml.open)
        return StandardError if doc.errors.any?
        handle_xml(xml)
      end
    end

    redirect_to root_path, flash: { success: "Invoice created successfully." }
  rescue Exception => e
    logger.error e
    @invoice = Invoice.new
    flash[:error] = "We had an error, please try again."
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

  def handle_xml(xml)
    hash = Hash.from_xml(xml.open).with_indifferent_access
    xml_json = hash[:hash]
    xml_json[:user] = current_user
    xml_json[:emitter] = handle_person(xml_json[:emitter])
    xml_json[:receiver] = handle_person(xml_json[:receiver])
    Invoice.create(xml_json)
  end

  def handle_person(data)
    Person.find_or_create_by(data)
  end
end
