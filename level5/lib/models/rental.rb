require 'date'

class Rental
    attr_reader :id, :car_id, :start_date, :end_date, :distance, :options

    def initialize id:, car_id:, start_date:, end_date:, distance:
        @id = id
        @car_id = car_id
        @start_date = start_date
        @end_date = end_date
        @distance = distance
    end

    def self.load_rentals &block
        cars = Car.load_cars_hash
        options = Option.load_option_hash
        if($data.dig("rentals").nil?)
            raise Exception, "Rentals are essential for this module, please provide valid input"
        end
        $data.dig("rentals")&.map{|rental|
            rental = Rental.from_hash(rental)
            if(cars[rental.car_id].nil?)
                raise Exception, "Car with id #{rental.car_id} not found, please provide valid input"
            end
            rental.set_car(cars[rental.car_id])
            rental.set_options(options[rental.id])
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

    def set_options options
        @options = options
    end

    def rental_days
        (Date.parse(@end_date) - Date.parse(@start_date)).to_i + 1
    end

    def options_amount 
        @options.reduce(0){|a,b|  
            a + b.price * rental_days
        }
    end

    def owner_options_amount
        @options.select{|option| option.goes_to == :owner}.reduce(0){|a,b|  
            a + b.price * rental_days
        }
    end

    def drivy_options_amount
        @options.select{|option| option.goes_to == :drivy}.reduce(0){|a,b|  
            a + b.price * rental_days
        }
    end

    def price 
        [
            PriceWithReduction.compute(@car.price_per_day , rental_days),
            @distance * @car.price_per_km,
            options_amount
        ].reduce(&:+)

    end

    def commission
        amount = (price - options_amount) * 0.3
        insurance_sub = Substractor::SubUnit.new(amount, 0.5, :insurance_fee)
        assistance_sub = Substractor::SubUnit.new(100, rental_days, :assistance_fee)
        Hash[Substractor.decompose(amount, [insurance_sub, assistance_sub], :drivy_fee)]
    end

    def actions 
        amount = price - options_amount
        owner_sub = Substractor::SubUnit.new(amount, 0.7, :owner, owner_options_amount)
        insurance_sub = Substractor::SubUnit.new(amount, 0.3*0.5, :insurance)
        assistance_sub = Substractor::SubUnit.new(100, rental_days, :assistance)
        factory = ActionFactory.new
        factory.add :driver, :debit, price
         
        Hash[Substractor.decompose(amount, [owner_sub, insurance_sub, assistance_sub], :drivy, drivy_options_amount)].each do |kind, pamount|
            factory.add kind, :credit, pamount
        end

        factory.actions
    end
end