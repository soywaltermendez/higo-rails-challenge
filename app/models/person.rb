# frozen_string_literal: true

class Person < ApplicationRecord
  has_many :invoices_emitted, foreign_key: "emitter_id", class_name: "Invoice"
  has_many :invoices_received, foreign_key: "receiver_id", class_name: "Invoice"
end
