# frozen_string_literal: true

require 'spec_helper'
require 'cart'

RSpec.describe Cart do
  describe '#call' do
    it 'returns a Cart instance' do
      expect(Cart.call([])).to be_a Cart
    end

    it 'executes call instance' do
      expect_any_instance_of(Cart).to receive(:call)

      Cart.call([])
    end
  end

  describe '.parse_items' do
    context 'with invalid line' do
      it 'loads data with empty array' do
        cart = Cart.new([''])
        cart.parse_items!

        expect(cart.data).to eq(items: [])
      end
    end

    context 'with valid line' do
      it 'loads data with parsed items' do
        cart = Cart.new(['1 book at 13.49'])
        cart.parse_items!

        expect(cart.data[:items].length).to eq 1
        # eq(items: [quantity: 1, name: 'book', unit_price: 13.49])
      end

      it 'loads data with an instance of Item' do
        cart = Cart.new(['1 book at 13.49'])
        cart.parse_items!

        expect(cart.data[:items][0]).to be_a(Item)
      end
    end
  end
end
