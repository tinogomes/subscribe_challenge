# frozen_string_literal: true

$LOAD_PATH.unshift("#{Dir.pwd}/lib")

require 'cart'

class App
  attr_reader :filename_list

  def self.call(filename_list)
    app = App.new(filename_list)
    app.call
  end

  def initialize(filename_list)
    @filename_list = filename_list
  end

  def call
    if filename_list.empty?
      run_from_stdin!
    else
      run_from_files!
    end
  end

  def run_from_files!
    filename_list.each do |filename|
      next unless File.exist?(filename)

      file = File.open(filename)

      process(file.readlines)
    end
  end

  def run_from_stdin!
    process($stdin.readlines)
  end

  def process(cart_items)
    cart_items = cart_items.map(&:chomp).filter { |obj| !obj.empty? }

    cart = Cart.new(cart_items)

    puts cart
  end
end

App.call(ARGV) if $PROGRAM_NAME == __FILE__
