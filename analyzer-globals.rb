##      Utility functions

##      Simply print the array
def print_array input_array
        puts "The Input Line is: #{ input_array }"
end

##      Print the corresponding header array with the csv input array.
def print_shipment_line header_array, input_array
        header_array.each_with_index do |item,index|
                puts "#{ index + 1 }: #{ item } = #{ input_array[ 0 ][ index ]}"
        end
end

##      Simple test to confirm the expected line size
def confirm_line_size input_array, length
        input_array.size == length
end
