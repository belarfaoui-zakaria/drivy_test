# this module helps to devide the amount to differents actors defined by the kind
module Substractor
  class SubBase
    attr_accessor :amount, :kind 

    def initialize kind, plus = 0
      @kind = kind
      @plus = plus
    end

    def get_kind_amount
      [@kind, @amount + @plus]
    end
  end

  class SubUnit < SubBase 
    def initialize(amount, units, kind = :kind, plus=0)
      @amount = (amount * units).to_i
      super(kind, plus)
    end
  end

  # devide an amount between different actors
  def self.decompose amount, kinds = [], default_kind = :drivy_fee, plus=0
    i = amount
    decompositions = []
    kinds.each do |op|
      i -= op.amount
      decompositions << op.get_kind_amount
    end
    decompositions << [default_kind, (i+plus).to_i]
  end
end