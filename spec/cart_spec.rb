# frozen_string_literal: true

require 'spec_helper'
require 'cart'

RSpec.describe Cart do
  context 'with invalid line' do
    it 'loads data with empty array' do
      cart = Cart.new([''])
      # cart.parse_items!

      expect(cart.items).to eq([])
    end
  end

  context 'with valid line' do
    subject(:cart) { Cart.new(['1 imported perfume at 13.49']) }

    it 'loads data with parsed items' do
      expect(cart.items.length).to eq 1
    end

    it 'loads data with an instance of Item' do
      expect(cart.items[0]).to be_a(Item)
    end

    it 'loads total' do
      expect(cart.total).to eq 15.54
    end

    it 'loads tax total' do
      expect(cart.tax_total).to eq 2.05
    end

    it 'returns cart printable format' do
      result = [
        '1 imported perfume: 15.54',
        'Sales Taxes: 2.05',
        'Total: 15.54'
      ].join("\n")

      expect(cart.to_s).to eq result
    end
  end

  context 'with many items' do
    subject(:cart) do
      Cart.new([
                 '2 book at 12.49',
                 '1 music CD at 14.99',
                 '1 chocolate bar at 0.85'
               ])
    end

    it 'returns cart printable format' do
      result = [
        '2 book: 24.98',
        '1 music CD: 16.49',
        '1 chocolate bar: 0.85',
        'Sales Taxes: 1.50',
        'Total: 42.32'
      ].join("\n")

      expect(cart.to_s).to eq result
    end
  end
end
