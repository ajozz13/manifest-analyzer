=begin	
	This is a test file script for a Manifest line.  The IBC standard manifest line is specified in
	http://www.pactrak.com/manifest-to-pactrak.html.  We will test a sub-standard that 
	will support a HTTP rest driven approach, to submit and create the IBC standard format.
=end
#	requirements
require 'date'
require 'csv'

#	Global variables
$manifest_line_headers = [ "record_type", "man_code", "man_date", "man_origin", "man_dest", "flight_info", "man_info" ]
$airline_regex = %r{\A[A-Z]{2}\d{3,4}\z}
$ibc_date_format = "%Y%m%d"
$debug = false

#	Functions
def print_array arr
        arr.each_with_index do |issue, index|
                puts "#{ index+1 }: #{ issue }"
        end
end

##      Print the fields with the entries that where read into the input array
def print_manifest_line input_array
        $manifest_line_headers.each_with_index do |header, index|
                puts "#{ header } = #{ input_array[0][ index ] }"
        end
        puts
end

##      Test the max length of a String and fail if it's empty
def test_max_length input_str, name, max_size
	raise "The value for #{name} is empty." if input_str.nil?
	input_str.length <= max_size
end

##      Perform date tests
def test_date input_str
	begin
		d = Date.strptime input_str, $ibc_date_format
		@date_test = true
	rescue
		@date_test = false
	end
end

##      Perform MAWB Tests
def test_mawb input_str
	if ( input_str.length != 11 )  
		puts "MAWB must have 11 digits (#{ input_str.length })" if $debug
		return false
	end
	
	#@cd = Integer( input_str[input_str.length-1] )
	@cd = input_str[input_str.length-1].to_i
	#@noncd = Integer( input_str[3..input_str.length - 2] )  
	@noncd = input_str[3..input_str.length-2].to_i 
	@compare = ( @noncd - (@noncd / 7 * 7) ) == @cd
	return @compare
end

##      Perform test of the Airline code
def valid_airline_code? input_code
        return ( input_code =~ $airline_regex ) == 0
end

=begin
        Test manifest line
        Unit Test with main program below
        See documentation page to see all the rules
=end
def test_manifest_line input_line
        errors_found = []
        begin
                csv_array = CSV.parse( input_line )

                if csv_array[0].size == $manifest_line_headers.size

                unless csv_array[0][0].eql? "1"
                        errors_found.push "Record type definition should start with 1"
                end

                ##Simple tests for length
                unless test_max_length csv_array[0][1], "manifest code", 15  #maxlength for man_code is 15 
                        errors_found.push "Manifest code: #{csv_array[0][1]} exceeds the maximum limit"
                end

                #test date given of manifest
                unless test_date csv_array[0][2]
                        errors_found.push "Date given: #{csv_array[0][2]} may be invalid or not in format expected: YYYYmmDD"
                end

                unless test_max_length csv_array[0][3], "origin code", 3  #maxlength for origin_code is 3 
                        errors_found.push "Origin code: #{csv_array[0][3]} exceeds the maximum limit"
                end

                unless test_max_length csv_array[0][4], "destination code", 3  #maxlength for destination_code is 3 
                        errors_found.push "Destination code: #{csv_array[0][4]} exceeds the maximum limit"
                end

                #test format of airline input
                unless valid_airline_code? csv_array[0][5]
                        errors_found.push "Airline info given: #{csv_array[0][5]} does not match expected format, IE: AA####"
                end

                unless test_mawb csv_array[0][6]
                        errors_found.push "MAWB test failed. Please confirm the number used is valid."
                end
    
        else
                errors_found.push "Manifest line does not contain the required fields."
        end
        raise "Errors found" unless errors_found.empty?
        @completed = true
  rescue Exception => e
        puts "Manifest Line: #{ e.message }"
        print_array errors_found
        print_manifest_line csv_array 
        puts "Backtrace: #{ e.backtrace }" if $debug
        @completed = false 
  end

end

##      Run Test for test_manifest_line function
=begin

#       Requirements  csv library

puts "Begin Test Program"

input_lines = []
input_lines.push "1,abc12345,20140701,YYZ,MIA,AA2012,18062148741"
input_lines.push "1,abc12345,,YYZX,MIA,AASS2012,AB221111"


input_lines.each_with_index do |l, index|
        ans = test_manifest_line( l )
        puts "Line ##{ index+1 } completed with answer = #{ ans }"
        puts "-------------------------------------"
end


puts "End Test Program"  
=end
