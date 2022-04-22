# frozen_string_literal: true

require 'nokogiri'

class InvoiceImportJob < ApplicationJob
  queue_as :default

  def perform(files, current_user)
    files.each do |xml|
      ActiveRecord::Base.transaction do
        handle_xml(xml, current_user)
      end
    end

    InvoiceMailer.confirmation(current_user.email).deliver
  rescue StandardError => e
    logger.error e
    raise "We had an error, please try again."
  end

  private

  def handle_xml(xml, current_user)
    xml_json = xml[:hash]
    xml_json[:user] = current_user
    xml_json[:emitter] = handle_person(xml_json[:emitter])
    xml_json[:receiver] = handle_person(xml_json[:receiver])
    Invoice.create(xml_json)
  end

  def handle_person(data)
    Person.find_or_create_by(data)
  end
end
