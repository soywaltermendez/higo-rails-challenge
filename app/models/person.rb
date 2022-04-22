# frozen_string_literal: true

class Person < ApplicationRecord
  has_many :invoices

  accepts_nested_attributes_for :invoices
end
