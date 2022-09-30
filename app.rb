# frozen_string_literal: true

$LOAD_PATH.unshift("#{Dir.pwd}/lib")

require 'cart'

class App
  attr_reader :data

  def self.call(data)
    app = App.new(data)
    app.call
  end

  def initialize(data)
    @data = data
  end

  def call
    process(data)
  end

  def process(cart_items)
    cart_items = cart_items.map(&:chomp).filter { |obj| !obj.empty? }

    cart = Cart.new(cart_items)

    puts cart
  end
end

if $PROGRAM_NAME == __FILE__
  data = ARGF.readlines.map(&:chomp)

  App.call(data)
end
