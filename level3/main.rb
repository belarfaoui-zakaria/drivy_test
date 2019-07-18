# load required classes
Dir.glob(File.join(File.dirname(__FILE__), 'lib', '**', '*.rb'), &method(:require))


commission = Rental.load_rentals do |rental|
    {
        id: rental.id,
        price: rental.price,
        commission: rental.commission
    }
end

JsonIo.write(rentals: commission)