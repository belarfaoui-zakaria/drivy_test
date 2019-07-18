require 'json'

class JsonIo
    def self.read path
        begin
            JSON.parse(File.read(path))
        rescue => exception
            raise Exception, "File not found, please add input.json to data folder"
        end
    end

    def self.write hash
        begin
            file = File.open("./data/output.json", "w")  
            file.puts JSON.pretty_generate(hash)
        rescue => exception
            
        ensure
            file.close
        end
    end
end