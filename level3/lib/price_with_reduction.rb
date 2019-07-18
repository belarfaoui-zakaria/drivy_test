class PriceWithReduction
    def self.compute amount, days
        proportions = [1,0.9,0.7,0.5]
        decomposition = decompose(days) 
        decomposition.each_with_index.map{|value, index| amount * value * proportions[index]}.reduce(&:+).to_i
    end

    def self.decompose days
        i = days
        composition = [10, 4, 1]
        decomposed = [] 
        for number in composition 
            if i - number > 0
               decomposed << i - number
               i -= i - number
            else  
               decomposed << 0
            end
        end
        decomposed << 1
        decomposed.reverse
    end
end