# frozen_string_literal: true

require 'spec_helper'
require 'item_parser'

RSpec.describe ItemParser do
  describe '.parse' do
    it 'returns nil for invalid data' do
      expect(ItemParser.parse('invalid')).to be_nil
    end

    it 'returns a hash' do
      result = {
        quantity: 1,
        name: 'MacBook Pro 13-inch',
        unit_price: 1299.00
      }

      expect(ItemParser.parse('1 MacBook Pro 13-inch at 1,299.00')).to eq result
    end
  end
end
