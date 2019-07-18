require 'date'
require './price_with_reduction'

class Rental
    attr_reader :id, :car_id, :start_date, :end_date, :distance

    def initialize id:, car_id:, start_date:, end_date:, distance:
        @id = id
        @car_id = car_id
        @start_date = start_date
        @end_date = end_date
        @distance = distance
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
end