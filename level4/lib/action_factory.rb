class ActionFactory
  attr_accessor :actions
  def initialize
    @actions = []
  end

  def add who, type, amount
    @actions << {
      who: who,
      type: type,
      amount: amount
    } 
  end

end