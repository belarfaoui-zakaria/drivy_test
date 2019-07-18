class Car
    attr_reader :id, :price_per_day, :price_per_km

    def initialize id:, price_per_day:, price_per_km:
        @id = id
        @price_per_day = price_per_day
        @price_per_km = price_per_km
    end

    def self.from_hash hash 
        Car.new(
            id: hash.dig("id"), 
            price_per_day: hash.dig("price_per_day"), 
            price_per_km: hash.dig("price_per_km")
        )
    end

    def self.load_cars_hash 
        Hash.new().tap{|obj|
            $data.dig("cars")&.each{|car| 
                obj[car.dig("id")] = Car.from_hash(car)
            }
        } 
    end
end