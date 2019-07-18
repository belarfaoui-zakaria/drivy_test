require 'json'
require 'date' 

data = JSON.parse(File.read('./data/input.json'))

def readCars data
  return Hash.new().tap{|obj|
    data.dig("cars")&.each{|car| 
      obj[car.dig("id")] = car
    }
  }
end

def getDays(starts, ends)
    (Date.parse(ends) - Date.parse(starts)).to_i + 1
end

cars = readCars(data)

json = {
  rentals: data.dig("rentals").map{|rental|
    # - A time component: the number of rental days multiplied by the car's price per day
    # - A distance component: the number of km multiplied by the car's price per km
    car = cars[rental.dig("car_id")]
    days = getDays(rental.dig('start_date'), rental.dig('end_date'))
    price = car.dig('price_per_day') * days + rental.dig('distance') * car.dig('price_per_km')
    
    {
        id: rental['id'],
        price: price
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

