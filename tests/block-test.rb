=begin
        Test for block and yield.
=end

##      Simple function to raise a message
def raise_function index, msg
        raise msg if index % 2 == 0
end

##      function template to capture an exception
def perform_function
        begin
                yield
        rescue Exception => e
                puts "#{ e.message }"
                return e.message
        end
end

##      Main program
arr = []
(1..5).each_with_index do | item, index |
        arr.push perform_function{ raise_function index, "I'm running function #{ index }" }
end

puts 
puts "I got these messages"
##      call to compact will remove any nil's pushed in
puts "Answer: #{ arr.compact }"
