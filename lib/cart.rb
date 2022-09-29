# frozen_string_literal: true

class Cart
  def self.call(items)
    new(items).tap(&:call)
  end

  def call
    parse_items!
  end

  def to_s
    [
      '1 book: 13.49',
      'Sales Taxes: 0.00',
      'Total: 13.49'
    ].join("\n")
  end

  private

  def initialize(items)
    @items = items
  end
end
