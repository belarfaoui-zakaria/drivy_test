class Option
    attr_reader :id, :rental_id, :type

    PRICES = {
        gps: 500,
        baby_seat: 200,
        additional_insurance: 1000
    }.freeze

    GOESTO = {
        gps: :owner,
        baby_seat: :owner,
        additional_insurance: :drivy
    }.freeze

    def initialize id:, rental_id:, type:
        @id = id
        @rental_id = rental_id
        @type = type
    end

    def to_s
        @type
    end
    
    def price
        PRICES[@type.to_sym]
    end

    def self.from_hash hash 
        Option.new(
            id: hash.dig("id"), 
            rental_id: hash.dig("rental_id"), 
            type: hash.dig("type")
        )
    end

    def goes_to
        GOESTO[@type.to_sym]
    end

    def self.load_option_hash
        Hash.new([]).tap{|obj|
            $data.dig("options")&.each{|option| 
                obj[option.dig("rental_id")] += [Option.from_hash(option)]
            }
        } 
    end
end