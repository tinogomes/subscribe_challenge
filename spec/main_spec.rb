# frozen_string_literal: true

load 'main.rb'

describe 'float_to_cents' do
  [
    [0.010000000001, 1],
    [0.050000000001, 5],
    [1.050000000001, 105],
    [1.5, 150]
  ].each do |(value, in_cents)|
    it 'has some behaviour' do
      expect(float_to_cents(value)).to eq in_cents
    end
  end
end

def create_line(qtt, item, unit_price_in_cents)
  imported = item.include?('imported')

  { qtt:, imported:, item:, unit_price_in_cents: }
end

describe 'parse_to_hash' do
  [
    ['1 chocolate bar at 0.85', create_line(1, 'chocolate bar', 85)],
    ['2 chocolate bar at 0.85', create_line(2, 'chocolate bar', 85)],
    ['1 imported chocolate bar at 0.85', create_line(1, 'imported chocolate bar', 85)]
  ].each do |(input, result)|
    it "should parse #{input.inspect} to #{result.inspect}" do
      expect(parse_to_hash(input)).to eq(result)
    end
  end

  context 'with invalid input' do
    it 'raises an exception' do
      expect do
        parse_to_hash('invalid input')
      end.to raise_error InvalidInputError
    end
  end
end

describe 'sales_tax_rate_for_item' do
  [
    ['book', 0],
    ['imported box of chocolate', 0],
    ['imported boxes of chocolates', 0],
    ['chocolate bar', 0],
    ['music CD', 10],
    ['bottle of perfume', 10],
    ['packed of headache pills', 0]
  ].each do |(item, sales_tax)|
    it "should sales_tax_rate_for_item(#{item.inspect}) returns #{sales_tax}" do
      expect(sales_tax_rate_for_item(item)).to eq sales_tax
    end
  end
end

describe 'import_duty_rate_for_item' do
  [
    ['book', 0],
    ['imported box of chocolate', 5],
    ['imported boxes of chocolates', 5],
    ['chocolate bar', 0],
    ['music CD', 0],
    ['bottle of perfume', 0],
    ['imported bottle of perfume', 5],
    ['packed of headache pills', 0]
  ].each do |(item, sales_tax)|
    it "should import_duty_rate_for_item(#{item.inspect}) returns #{sales_tax}" do
      expect(import_duty_rate_for_item(item)).to eq sales_tax
    end
  end
end

describe 'ceil_nearest_to' do
  [
    [11, 5, 15],
    [12, 5, 15],
    [15, 5, 15],
    [16, 5, 20],
    [10, 5, 10],
    [3, 2, 4],
    [4, 3, 6]
  ].each do |(value, step, expected)|
    it "should #{value} with step #{step} to #{expected}" do
      expect(ceil_nearest_to(value, step)).to eq expected
    end
  end
end

describe 'calculate_rate' do
  [
    [100, 10, 10],
    [124, 10, 15]
  ].each do |(value, rate, expected)|
    it "#{rate}% over #{value} equals to #{expected}" do
      expect(calculate_rate(value, rate)).to eq expected
    end
  end
end

describe 'calculate_item' do
  [
    [create_line(2, 'book', 1249), { sales_tax_in_cents: 0, import_duty_in_cents: 0, total_in_cents: 2498 }],
    [create_line(1, 'music CD', 1499), { sales_tax_in_cents: 150, import_duty_in_cents: 0, total_in_cents: 1649 }],
    [create_line(1, 'imported bottle of perfume', 2799),
     { sales_tax_in_cents: 280, import_duty_in_cents: 140, total_in_cents: 3219 }],
    [create_line(3,	'imported boxes of chocolates',	1125),
     { sales_tax_in_cents: 0, import_duty_in_cents: 180, total_in_cents: 3555 }]
  ].each do |input, to_merge|
    sformat = 'item: %<qtt>d %<item>s %<unit_price_in_cents>d sales_tax: %<sales_tax_in_cents>d '\
              'import_duty: %<import_duty_in_cents>d total: %<total_in_cents>d'
    input_string = format(sformat, input.merge(to_merge))
    it input_string do
      result = input.merge(to_merge)

      expect(calculate_item(input)).to eq(result)
    end
  end
end

def create_cart(*items)
  { items: }
end

describe 'process_cart' do
  context 'without taxes' do
    it 'should calculate all items and aggredate totals' do
      cart = create_cart calculate_item(create_line(2, 'book', 1249))

      expected_cart = cart.merge({ total_taxes_in_cents: 0, total_in_cents: 2498 })

      expect(process_cart(cart)).to eq expected_cart
    end
  end

  context 'with sale taxes' do
    it 'should calculate all items and aggredate totals' do
      cart = create_cart calculate_item(create_line(1, 'music CD', 1499))
      expected_cart = cart.merge({ total_taxes_in_cents: 150, total_in_cents: 1649 })

      expect(process_cart(cart)).to eq expected_cart
    end
  end

  context 'with import duty taxes' do
    it 'should calculate all items and aggredate totals' do
      cart = create_cart calculate_item(create_line(1, 'imported box of chocolate', 1000))

      expected_cart = cart.merge({ total_taxes_in_cents: 50, total_in_cents: 1050 })

      expect(process_cart(cart)).to eq expected_cart
    end
  end
end

describe 'format_cents' do
  [
    [1, '0.01'],
    [10, '0.10'],
    [100, '1.00'],
    [111, '1.11']
  ].each do |(cents, expected)|
    it "should convert #{cents} to #{expected.inspect}" do
      expect(format_cents(cents)).to eq expected
    end
  end
end

describe 'cart_to_print' do
  it 'should print' do
    cart = create_cart calculate_item(create_line(1, 'music CD', 1499))
    cart_calculated = process_cart(cart)

    result = [
      '1 music CD: 16.49',
      'Sales Taxes: 1.50',
      'Total: 16.49'
    ].join("\n")

    expect(cart_to_print(cart_calculated)).to eq result
  end
end
