# frozen_string_literal: true

class InvalidInputError < StandardError; end

BASE_SALES_TAX_RATE = 10
BASE_IMPORT_DUTY_RATE = 5
FREE_ITEMS_FOR_SALES_TAX = %w[book chocolate pill].freeze

def float_to_cents(value)
  (value * 100).to_i
end

def parse_to_hash(input)
  parser_regex = /\A^(\d+) ?(imported)? (.*) at ([0-9,.]+)$\z/
  matched = parser_regex.match(input)

  raise InvalidInputError unless matched

  _, qtt, imported, item, price = matched.to_a

  {
    qtt: qtt.to_i,
    imported: !imported.nil?,
    item: [imported, item].compact.join(' '),
    unit_price_in_cents: float_to_cents(price.to_f)
  }
end

def sales_tax_rate_for_item(item)
  return 0 if item.match(FREE_ITEMS_FOR_SALES_TAX.join('|'))

  BASE_SALES_TAX_RATE
end

def import_duty_rate_for_item(item)
  return 0 unless item.include?('imported')

  BASE_IMPORT_DUTY_RATE
end

def ceil_nearest_to(value, step)
  (value + ((step - value) % step)).to_i
end

def calculate_rate(value, rate)
  rate /= 100.00
  ceil_nearest_to(value * rate, 5)
end

def calculate_item(item)
  qtt = item[:qtt]
  sales_tax_in_cents = calculate_rate(item[:unit_price_in_cents], sales_tax_rate_for_item(item[:item])) * qtt
  import_duty_in_cents = calculate_rate(item[:unit_price_in_cents], import_duty_rate_for_item(item[:item])) * qtt
  total_in_cents = ((qtt * item[:unit_price_in_cents]) + sales_tax_in_cents + import_duty_in_cents)

  item.merge(sales_tax_in_cents:, import_duty_in_cents:, total_in_cents:)
end

def process_cart(cart)
  total_in_cents = 0
  total_taxes_in_cents = 0

  cart[:items].each do |item|
    total_taxes_in_cents += item[:sales_tax_in_cents] + item[:import_duty_in_cents]
    total_in_cents += item[:total_in_cents]
  end

  cart.merge(total_taxes_in_cents:, total_in_cents:)
end

def format_cents(value)
  format('%.2f', value / 100.00)
end

def cart_to_print(cart)
  result = []
  cart[:items].each do |item|
    total_formatted = format_cents(item[:total_in_cents])
    result << format('%<qtt>d %<item>s: %<total_formatted>s', item.merge(total_formatted:))
  end
  result << format('Sales Taxes: %s', format_cents(cart[:total_taxes_in_cents]))
  result << format('Total: %s', format_cents(cart[:total_in_cents]))

  result.join("\n")
end

if $PROGRAM_NAME == __FILE__
  if ARGV.empty?
    cart_lines = $stdin.readlines.map(&:chomp)
  else
    file = File.open(ARGV[0])
    cart_lines = file.readlines.map(&:chomp)
  end
  cart_lines = cart_lines.map { |line| calculate_item(parse_to_hash(line)) }

  cart = process_cart(items: cart_lines)

  puts '-' * 50
  puts cart_to_print(cart)
  puts '-' * 50
end
