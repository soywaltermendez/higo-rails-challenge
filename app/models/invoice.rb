# frozen_string_literal: true

class Invoice < ApplicationRecord
  belongs_to :user
  belongs_to :emitter, class_name: "Person", foreign_key: "emitter_id"
  belongs_to :receiver, class_name: "Person", foreign_key: "receiver_id"
end
