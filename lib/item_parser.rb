# frozen_string_literal: true

# class ItemParser
class ItemParser
  ITEM_REGEXP = /\A^(?<quantity>\d+) (?<name>.+) at (?<price>[0-9,.]+)$\z/

  def self.parse(line)
    matched = line.match(ITEM_REGEXP)

    return unless matched

    quantity = matched[:quantity].to_i
    name = matched[:name]
    unit_price = matched[:price].tr(',', '').to_f

    { quantity:, name:, unit_price: }
  end
end
