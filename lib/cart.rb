# frozen_string_literal: true

require 'item_parser'
require 'item'

class Cart
  attr_reader :items, :tax_total, :total

  def initialize(items)
    @items = parse_items(items)
    @tax_total = 0
    @total = 0

    calculate!
  end

  def parse_to_calculated_item(item)
    item_attributes = ItemParser.parse(item)

    return if item_attributes.nil?

    Item.new(**item_attributes)
  end

  def parse_items(original_items)
    @items = original_items.map { |item| parse_to_calculated_item(item) }.compact
  end

  def calculate!
    items.each do |item|
      @total += item.total
      @tax_total += item.tax_total
    end
  end

  def to_s
    result = items.map(&:to_s)
    result << format('Sales Taxes: %.2f', tax_total)
    result << format('Total: %.2f', total)
    result.join("\n")
  end
end
