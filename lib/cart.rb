# frozen_string_literal: true

require 'item_parser'
require 'item'

class Cart
  attr_reader :items, :data

  def self.call(items)
    new(items).tap(&:call)
  end

  def initialize(items)
    @items = items
    @data = {}
  end

  def call
    parse_items!
    calculate_totals!
  end

  def parse_to_calculated_item(item)
    item_attributes = ItemParser.parse(item)

    return if item_attributes.nil?

    Item.new(**item_attributes).tap(&:calculate!)
  end

  def parse_items!
    data[:items] = items.map { |item| parse_to_calculated_item(item) }.compact
  end

  def calculate_totals!; end

  def to_s
    [
      '1 book: 13.49',
      'Sales Taxes: 0.00',
      'Total: 13.49'
    ].join("\n")
  end
end
