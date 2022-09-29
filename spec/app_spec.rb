# frozen_string_literal: true

require 'spec_helper'
require_relative '../app'

RSpec.describe 'App' do
  describe '.call' do
    it 'delegates to instance call' do
      expect_any_instance_of(App).to receive(:call)

      App.call([])
    end
  end

  describe 'blackbox test' do
    it 'prints cart calculated via STDIN' do
      expected_result = [
        '1 book: 13.49',
        'Sales Taxes: 0.00',
        'Total: 13.49',
        ''
      ].join("\n")

      expect(`echo '1 book at 13.49' | ruby app.rb`).to eq expected_result
    end

    it 'prints cart calculated from file' do
      expected_result = [
        '1 book: 13.49',
        'Sales Taxes: 0.00',
        'Total: 13.49',
        ''
      ].join("\n")

      expect(`ruby app.rb spec/cart.txt`).to eq expected_result
    end
  end
end
