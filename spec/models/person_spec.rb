# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Person, type: :model do
  it 'is valid with valid attributes' do
    expect(described_class.new).to be_valid
  end
end
