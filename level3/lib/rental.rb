require 'date'

class Rental
    attr_reader :id, :car_id, :start_date, :end_date, :distance

    def initialize id:, car_id:, start_date:, end_date:, distance:
        @id = id
        @car_id = car_id
        @start_date = start_date
        @end_date = end_date
        @distance = distance
    end

    def self.load_rentals &block
        cars = Car.load_cars_hash
        $data.dig("rentals").map{|rental|
            rental = Rental.from_hash(rental)
            rental.set_car(cars[rental.car_id])
            if(block.nil?)
                rental
            else 
                block.call(rental)
            end
        }
    end

    def self.from_hash hash 
        Rental.new(
            id: hash.dig("id"),
            car_id: hash.dig("car_id"),
            start_date: hash.dig("start_date"),
            end_date: hash.dig("end_date"),
            distance: hash.dig("distance")
        )
    end

    def set_car car 
        @car = car
    end

    def rental_days
        (Date.parse(@end_date) - Date.parse(@start_date)).to_i + 1
    end

    def price 
        PriceWithReduction.compute(@car.price_per_day , rental_days) + @distance * @car.price_per_km
    end

    def commission
        amount = price * 0.3
        sp = Substractor::SubPercent.new(amount, 0.5, :insurance_fee)
        su = Substractor::SubUnit.new(100, rental_days, :assistance_fee)
        Hash[Substractor.decompose(amount, [sp, su], :drivy_fee)]
    end
end