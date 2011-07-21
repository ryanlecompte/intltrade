# International Trade, RMU Puzzle
# Author: Ryan LeCompte

module InternationalTrade
  module Helpers
    def key(from, to)
      "#{from.upcase}-#{to.upcase}"
    end
  end
end
