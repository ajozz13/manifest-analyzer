=begin	
	This is a test file script for a Manifest line.  The IBC standard manifest line is specified in
	http://www.pactrak.com/manifest-to-pactrak.html.  We will test a sub-standard that 
	will support a HTTP rest driven approach, to submit and create the IBC standard format.
=end

#	Library requirements
require 'date'

#	Global variables

$manifest_line_headers = [ "record_type", "man_code", "man_date", "man_origin", "man_dest", "flight_info", "man_info" ]
$airline_regex = %r{\A[A-Z]{2}\d{3,4}\z}
$ibc_date_format = "%Y%m%d"
$debug = false

#	Functions

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
		puts "MAWB must have 11 digits (#{ input_str.length })" 
		return false
	end
	
	#@cd = Integer( input_str[input_str.length-1] )
	@cd = input_str[input_str.length-1].to_i
	#@noncd = Integer( input_str[3..input_str.length - 2] )  
	@noncd = input_str[3..input_str.length-2].to_i 
	@compare = ( @noncd - (@noncd / 7 * 7) ) == @cd
	puts "MAWB Check digit is incorrect: #{ @cd }" unless @compare
	return @compare
end

##      Perform test of the Airline code
def valid_airline_code? input_code
        return ( input_code =~ $airline_regex ) == 0
end



