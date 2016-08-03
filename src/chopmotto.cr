require "http/server"
require "./chopmotto/*"

module Chopmotto
  class FriedFile
    def initialize(@path : String)
      @loaded = false
      @values = [] of String
    end
    def lines : Array(String)
      if !@loaded
        @values = File.read_lines(@path).map do |value|
          value.strip
        end
        @loaded = true
      end
      return @values
    end
  end
  class Harbringer
    def initialize(@top_patterns : Array(String), @bottom_patterns : Array(String))
      @random = Random.new
    end
    def phrase : String
      return phrase(@random.rand(@top_patterns.size+1)-1)
    end
    def phrase(i : Int32) : String
      return phrase(i, @random.rand(@bottom_patterns.size+1)-1)
    end
    def phrase(i : Int32, j : Int32) : String
      return "#{@top_patterns[i]} #{@bottom_patterns[j]}"
    end
  end
  class Server
    def initialize(@harbringer : Chopmotto::Harbringer)
    end
    def harbringer : Chopmotto::Harbringer
      return @harbringer
    end
  end
end

$Motto = Chopmotto::Server.new(Chopmotto::Harbringer.new(Chopmotto::FriedFile.new("top.txt").lines, Chopmotto::FriedFile.new("bottom.txt").lines))
puts $Motto.harbringer.phrase
