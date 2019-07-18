# load required classes from lib folder
Dir.glob(File.join(File.dirname(__FILE__), 'lib', '**', '*.rb'), &method(:require))

actions = Rental.load_rentals do |rental|
    {
        id: rental.id,
        options: rental.options.map(&:to_s),
        actions: rental.actions        
    }
end

JsonIo.write(rentals: actions)