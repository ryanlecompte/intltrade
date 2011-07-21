# International Trade, RMU Puzzle Solution
# Author: Ryan LeCompte

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module InternationalTrade
  describe Parser do
    describe "#parse_rates" do
      context "given an XML string" do
        it "should parse the rates into a Hash" do
          input = <<-RATES
              <rates>
                <rate>
                  <from>AUD</from>
                  <to>CAD</to>
                  <conversion>1.0079</conversion>
                </rate>
                <rate>
                  <from>AUD</from>
                  <to>EUR</to>
                  <conversion>0.7439</conversion>
                </rate>
              </rates>
          RATES
          result = InternationalTrade::Parser.parse_rates(input)
          result.keys.should include('AUD-CAD', 'AUD-EUR')
          result['AUD-CAD'].should == BigDecimal('1.0079')
          result['AUD-EUR'].should == BigDecimal('0.7439')
        end
      end
      
      context "given an XML file" do
        it "should parse the rates into a Hash" do
          inputfile = File.join(File.dirname(__FILE__), 'testdata', 'RATES.xml')
          result = InternationalTrade::Parser.parse_rates(File.open(inputfile))
          result.should_not be_empty
        end
      end
    end

    describe "#parse_transactions" do
      context "given transactions input" do
        it "should return an Array of Transaction objects" do
          input = <<-TRANSACTIONS
          store,sku,amount
          Yonkers,DM1210,70.00 USD
          Yonkers,DM1182,19.68 AUD
          Nashua,DM1182,58.58 AUD
          Scranton,DM1210,68.76 USD
          Camden,DM1182,54.64 USD
          TRANSACTIONS
          result = InternationalTrade::Parser.parse_transactions(input)
          result.should_not be_empty
          result.should include(Transaction.new('Nashua', 'DM1182', BigDecimal('58.58'), 'AUD'))
        end
      end

      context "given transactions input and rates input" do
        it "should be able to convert between currencies" do
          transactions_input = <<-TRANSACTIONS
          store,sku,amount
          Yonkers,DM1210,70.00 USD
          TRANSACTIONS
          rates_input = <<-RATES
              <rates>
                <rate>
                  <from>USD</from>
                  <to>XYZ</to>
                  <conversion>5.00</conversion>
                </rate>
              </rates>
          RATES

          result = InternationalTrade::Parser.parse_transactions(transactions_input, rates_input)
          result.should have(1).item
          transaction = result.first
          transaction.currency.should == 'USD'
          transaction.amount.should == BigDecimal('70.00')
          transaction.to_xyz.should == BigDecimal('350.00')
        end
      end
    end
  end
end
