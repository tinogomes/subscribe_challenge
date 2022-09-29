# frozen_string_literal: true

class Item
  EXEMPT_ITEMS = %w[book chocolate pill].freeze
  IMPORT_DUTY = 0.05
  SALES_TAX = 0.1

  attr_reader :quantity, :name, :unit_price, :import_duty, :sales_tax

  def initialize(quantity:, name:, unit_price:)
    @quantity = quantity
    @name = name
    @unit_price = unit_price
    @sales_tax = 0
    @import_duty = 0

    calculate!
  end

  def exempt_item?
    EXEMPT_ITEMS.any? { |exempt_term| name.include?(exempt_term) }
  end

  def imported?
    name.include?('imported')
  end

  def subtotal
    (unit_price * quantity).round(2)
  end

  def tax_total
    (sales_tax + import_duty).round(2)
  end

  def total
    (subtotal + tax_total).round(2)
  end

  def to_s
    format('%<quantity>d %<name>s: %<total>.2f', { quantity:, name:, total: })
  end

  private

  def calculate!
    calculate_sales_tax!
    calculate_import_duty!
  end

  def calculate_sales_tax!
    return if exempt_item?

    @sales_tax = ceil_value(unit_price * SALES_TAX) * quantity
  end

  def calculate_import_duty!
    return unless imported?

    @import_duty = ceil_value(ceil_value(unit_price * IMPORT_DUTY) * quantity)
  end

  def ceil_value(value, step = 0.05)
    ((value / step).ceil * step).round(2)
  end
end
