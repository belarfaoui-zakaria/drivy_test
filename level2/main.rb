require 'json'
require 'date' 
require './car'
require './rental'

data = JSON.parse(File.read('./data/input.json'))

def readCars data
  return Hash.new().tap{|obj|
    data.dig("cars")&.each{|car| 
      obj[car.dig("id")] = Car.from_hash(car)
    }
  }
end

 
cars = readCars(data) 
json = {
  rentals: data.dig("rentals").map{|rental|
    rental = Rental.from_hash(rental)
    rental.set_car(cars[rental.car_id])

    {
        id: rental.id,
        price: rental.price
    }
  }
}


begin
    file = File.open("./data/output.json", "w")  
    file.puts JSON.pretty_generate(json)
rescue => exception
    
ensure
    file.close
end
