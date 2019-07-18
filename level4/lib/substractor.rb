
module Substractor
  class SubBase
    attr_accessor :amount, :kind 

    def initialize kind
      @kind = kind
    end

    def get_kind_amount
      [@kind, @amount]
    end
  end

  class SubPercent < SubBase
    
    def initialize(amount, percentage, kind = :kind)
      @amount = (amount * percentage).to_i
      super(kind)
    end
  end

  class SubUnit < SubBase 
    def initialize(amount, units, kind = :kind)
      @amount = (amount * units).to_i
      super(kind)
    end
  end

  def self.decompose amount, operators = [], default_kind = :drivy_fee
    i = amount
    decompositions = []
    operators.each do |op|
      i -= op.amount
      decompositions << op.get_kind_amount
    end
    decompositions << [default_kind, i.to_i]
    return decompositions
  end
end