# International Trade, RMU Puzzle
# Author: Ryan LeCompte

require 'csv'
require 'nokogiri'
require 'bigdecimal'

module InternationalTrade
  # Parser can parse rates XML files as well as CSV transaction files.
  class Parser
    extend Helpers

    def self.parse_rates(input)
      rates = {}
      doc   = Nokogiri::XML(input)
      doc.xpath('//rate').each do |rate|
        from                 = rate.at_xpath('from').content
        to                   = rate.at_xpath('to').content
        conversion           = BigDecimal(rate.at_xpath('conversion').content)
        rates[key(from, to)] = conversion
      end
      rates
    end

    def self.parse_transactions(transactions_input, rates_input=nil)
      result = []
      rates  = rates_input ? parse_rates(rates_input) : {}
      CSV.parse(transactions_input.strip, :headers => true) do |row|
        amount, currency = row['amount'].split
        result << Transaction.new(row['store'].lstrip,
                                  row['sku'],
                                  BigDecimal(amount),
                                  currency,
                                  rates)
      end
      result
    end
  end
end