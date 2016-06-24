=begin	
	This is a test file script for en email line.  The IBC standard manifest line is specified in
	http://www.pactrak.com/manifest-to-pactrak.html.  We will test a sub-standard that 
	will support a HTTP rest driven approach, to submit and create the IBC standard format.
=end

#       requirements
require 'csv'

#       variables
$debug = false

#       Regular expressions for email line Short one = \A[0-9a-z][0-9a-z.]+\w+@[0-9a-z][0-9a-z.]+\w+$
#       http://www.ex-parrot.com/~pdw/Mail-RFC822-Address.html
#       http://www.sw-engineering-candies.com/blog-1/howtofindvalidemailaddresswitharegularexpressionregexinjava
#$email_regex = %r{(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])}

$email_regex = %r{\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+}xi

=begin  Notes on the regex above
        For some reason the regex above crashes when tested with Jruby
        $ jruby email-line.rb 
        SyntaxError: email-line.rb:16: syntax error, unexpected null

        I removed the x0e-\ from the last section \x0e-\x7f])+)\])}  but it still fails
        but not with ruby 2
        therefore we will for the time being continue to use the short regex.
=end
#       print message array
def print_array arr
        arr.each_with_index do |issue, index|
                puts "#{ index+1 }: #{ issue }"
        end
end

#       Simple function to test the email address
def valid_email? email_address
        puts "Test address: #{email_address}" if $debug
        return ( email_address.strip =~ $email_regex ) == 0
end

#       main function to call passing the email line
def test_email_line input_line
        err = []
        begin
                csv_array = CSV.parse( input_line )

                puts "Size is #{csv_array[0].size}" if $debug
                if csv_array[0].size == 2
                        err.push "Record type definition should be either a 6 or 7" unless (6..7).member?( Integer( csv_array[0][0]) )     
                        err.push "The email address defined appears to be invalid." unless valid_email? csv_array[0][1]
                else
                        err.push "Email definition line does not have the correct format [record_type,email]  Example: 6,email@address or 7,email@address"
                end     
                raise "Errors found" unless err.empty?
                @passed = true
        rescue Exception => e
                puts "Email Line: #{ e.message }"                
                print_array err
                puts "The input tested is: #{ csv_array }"
                @passed = false
        end
end

#       unit test for test_email_line
=begin
##      Main

puts "Begin Program"

line1 = "6,ochoa@ibcinc.com,,,,,,,"
line2 = "7,Aochoa@ibcinc.com"
line3 = "7,mia.prealert@tnt.com"
line4 = "7,john.smith@breuck.com"
line5 = "7,john.smith@breuck.co.ve"
line6 = "9,john.smith@breuck.co.ve"

val = test_email_line line1
puts "Result for line: #{line1} is: #{val}"
puts "------------------------------------"
val = test_email_line line2
puts "Result for line: #{line2} is: #{val}"
puts "------------------------------------"
val = test_email_line line3
puts "Result for line: #{line3} is: #{val}"
puts "------------------------------------"
val = test_email_line line4
puts "Result for line: #{line4} is: #{val}"
puts "------------------------------------"
val = test_email_line line5
puts "Result for line: #{line5} is: #{val}"
puts "------------------------------------"
val = test_email_line line6
puts "Result for line: #{line6} is: #{val}"
puts "------------------------------------"

puts "End Program"

=end
