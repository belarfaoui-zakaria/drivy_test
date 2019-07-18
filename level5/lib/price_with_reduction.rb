# class or helper to do reductions according to the days number 
class PriceWithReduction
    # represent the reduction of 0% 10% 30% 50%
    PROPORTIONS = [0.5, 0.7, 0.9, 1].freeze
    # Determine how we decompose a number of days
    COMPOSITIONS = [10, 4, 1].freeze

    # compute reduction per day and returns sum
    def self.compute amount, days 
        decomposition = decompose(days)
        decomposition.each_with_index.map{|value, index| amount * value * PROPORTIONS[index]}.reduce(&:+).to_i
    end

    # distribute days into array 
    # example if decompose(12) => [2, 6, 3, 1], it plays hands by hands with proportions array
    # 2 days reuced to 50%, 6 days reuced to 30%, 3 days reduced to 10%, 1 day without reduction
    def self.decompose days
        i = days
        decomposed = [] 
        for number in COMPOSITIONS 
            substract = i - number
            if substract > 0
               decomposed << substract
               i -= substract
            else  
               decomposed << 0
            end
        end
        decomposed << 1 
    end
end