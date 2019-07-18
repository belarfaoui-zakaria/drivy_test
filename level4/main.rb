# load required classes
Dir.glob(File.join(File.dirname(__FILE__), 'lib', '**', '*.rb'), &method(:require))


actions = Rental.load_rentals do |rental|
    {
        id: rental.id,
        actions: rental.actions
    }
end

JsonIo.write(rentals: actions)