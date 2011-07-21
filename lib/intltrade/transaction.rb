# International Trade, RMU Puzzle
# Author: Ryan LeCompte

require 'bigdecimal'

module InternationalTrade
  # Transaction encapsulates information related to a particular sale.
  class Transaction
    include Helpers

    attr_reader :store
    attr_reader :sku
    attr_reader :amount
    attr_reader :currency

    def initialize(store, sku, amount, currency, rates={})
      @store = store
      @sku = sku
      @amount = amount
      @currency = currency
      @rates = rates
    end

    def ==(other)
      other.is_a?(Transaction) &&
          @store == other.store &&
          @sku == other.sku &&
          @amount == other.amount &&
          @currency == other.currency
    end

    def method_missing(m, *args, &block)
      # Resort to standard implementation if we don't know about this currency.
      return super unless m =~ /to_(.+)/
      # Return amount if already in desired currency.
      return @amount if @currency == $1.upcase
      # Convert this transaction's currency to the specified one.
      (find_conversion_rate(@currency, $1.upcase) * @amount).round(2, BigDecimal::ROUND_HALF_EVEN)
    end

    def find_conversion_rate(from, to)
      # Return immediately if a direct mapping exists.
      return @rates[key(from, to)] if @rates.include?(key(from, to))
      # Otherwise, iterate each existing mapping and try to find an indirect match.
      @rates.keys.select { |k| k.start_with?("#{from}-") }.each do |k|
        _, key_to = k.split('-')
        if converted = @rates[k] * find_conversion_rate(key_to, to)
          return converted
        end
      end
    end
  end
end
