# frozen_string_literal: true

require 'spec_helper'
require 'item'

RSpec.describe Item do
  it 'returns an instance of Item' do
    expect(Item.new(quantity: 1, name: 'book', unit_price: 16.49)).to be_a Item
  end

  describe '.calculate!' do
    let(:attributes) { { quantity: 1, unit_price: 14.99 } }

    context 'with common item' do
      subject(:music_cd) { Item.new(**attributes.merge(name: 'music CD')) }

      it { is_expected.not_to be_imported }
      it { is_expected.not_to be_exempt_item }

      [
        ['quantity', 1],
        ['name', 'music CD'],
        ['unit_price', 14.99],
        ['sales_tax', 1.50],
        ['import_duty', 0.00],
        ['subtotal', 14.99],
        ['tax_total', 1.50],
        ['total', 16.49]
      ].each do |attribute, expected_value|
        it("must #{attribute} equals to #{expected_value}") do
          expect(music_cd.instance_eval(attribute)).to eq expected_value
        end
      end

      it { expect(music_cd.to_s).to eq '1 music CD: 16.49' }
    end

    context 'with imported common item' do
      subject(:perfume) { Item.new(quantity: 1, name: 'imported bottle of perfume', unit_price: 27.99) }

      it { is_expected.to be_imported }
      it { is_expected.not_to be_exempt_item }

      [
        ['quantity', 1],
        ['name', 'imported bottle of perfume'],
        ['unit_price', 27.99],
        ['sales_tax', 2.80],
        ['import_duty', 1.40],
        ['subtotal', 27.99],
        ['tax_total', 4.20],
        ['total', 32.19]
      ].each do |attribute, expected_value|
        it("must #{attribute} equals to #{expected_value}") do
          expect(perfume.instance_eval(attribute)).to eq expected_value
        end
      end

      it { expect(perfume.to_s).to eq '1 imported bottle of perfume: 32.19' }
    end

    context 'with exempt item' do
      subject(:book) { Item.new(quantity: 2, name: 'books', unit_price: 12.49) }

      it { is_expected.not_to be_imported }
      it { is_expected.to be_exempt_item }

      [
        ['quantity', 2],
        %w[name books],
        ['unit_price', 12.49],
        ['sales_tax', 0.00],
        ['import_duty', 0.00],
        ['subtotal', 24.98],
        ['tax_total', 0.00],
        ['total', 24.98]
      ].each do |attribute, expected_value|
        it("must #{attribute} equals to #{expected_value}") do
          expect(book.instance_eval(attribute)).to eq expected_value
        end
      end

      it { expect(book.to_s).to eq '2 books: 24.98' }
    end

    context 'with imported exempt item' do
      subject(:box_of_chocolates) { Item.new(quantity: 3, name: 'imported boxes of chocolates', unit_price: 11.25) }

      it { is_expected.to be_imported }
      it { is_expected.to be_exempt_item }

      [
        ['quantity', 3],
        ['name', 'imported boxes of chocolates'],
        ['unit_price', 11.25],
        ['sales_tax', 0.00],
        ['import_duty', 1.80],
        ['subtotal', 33.75],
        ['tax_total', 1.80],
        ['total', 35.55]
      ].each do |attribute, expected_value|
        it("must #{attribute} equals to #{expected_value}") do
          expect(box_of_chocolates.instance_eval(attribute)).to eq expected_value
        end
      end

      it { expect(box_of_chocolates.to_s).to eq '3 imported boxes of chocolates: 35.55' }
    end
  end
end
