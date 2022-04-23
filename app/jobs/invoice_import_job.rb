# frozen_string_literal: true

require 'nokogiri'

class InvoiceImportJob < ApplicationJob
  queue_as :default

  def perform(files, current_user)
    files.each do |xml|
      ActiveRecord::Base.transaction do
        validate_xml(xml)
        handle_xml(xml, current_user)
      end
    end

    InvoiceMailer.confirmation(current_user.email).deliver
  rescue StandardError => e
    InvoiceMailer.error(current_user.email).deliver
    logger.error e
    raise e
  end

  private

  def validate_xml(xml)
    if xml.has_key?(:hash)
      xml_json = xml[:hash]
      validate_invoice_info(:invoice_uuid, xml_json)
      validate_invoice_info(:amount_cents, xml_json)
      validate_invoice_info(:amount_currency, xml_json)
      validate_invoice_info(:emitted_at, xml_json)
      validate_invoice_info(:expires_at, xml_json)
      validate_person(:emitter, xml_json, xml_json[:emitter])
      validate_person(:receiver, xml_json, xml_json[:receiver])
    else
      raise StandardError, "Missing hash key"
    end
  end

  def validate_person(key, hash, person_hash)
    if hash.has_key?(key)
      if person_hash.has_key?(person_hash[:name]) || !person_hash[:name].present?
        raise StandardError, "Missing #{key} name"
      elsif person_hash.has_key?(person_hash[:rfc]) || !person_hash[:rfc].present?
        raise StandardError, "Missing #{key} rfc"
      end
    else
      raise StandardError, "Missing #{key}"
    end
  end

  def validate_invoice_info(key, hash)
    if !hash.has_key?(key) || !hash[key].present?
      raise StandardError, "Missing #{key}"
    end
  end

  def handle_xml(xml, current_user)
    xml_json = xml[:hash]
    xml_json[:user] = current_user
    xml_json[:emitter] = handle_person(xml_json[:emitter])
    xml_json[:receiver] = handle_person(xml_json[:receiver])
    Invoice.create!(xml_json) if Invoice.find_by(invoice_uuid: xml_json[:invoice_uuid], user: current_user).nil?
  end

  def handle_person(data)
    Person.find_or_create_by(data)
  end
end
