#!/usr/bin/env ruby

=begin	
	This is a unit test script for the manifest line script.
	http://en.wikibooks.org/wiki/Ruby_Programming/Unit_testing
=end

#	Library requirements
require 'test/unit'
require '../manifest-line.rb'
require 'tester-globals.rb'

#	Global variables
$test_array = [ 'William Buckley', 'Short', nil ]

class ManifestLineTester < Test::Unit::TestCase	
	##Test function text_max_length  - text_max_length input_string, Name_of_column, maximum_length_allowed
	def test_max_length_should_be_false
		max_length = 2
		print_this $test_array[ 0 ], "should not exceed #{ max_length }"
		assert_equal false, test_max_length( $test_array[ 0 ], "TestString", max_length ) 
		puts
	end
	
	def test_max_length_should_be_true
		max_length = 7
		print_this $test_array[ 1 ], "should not exceed #{ max_length }"
		assert_equal true, test_max_length( $test_array[ 1 ], "TestString", max_length )
		puts 
	end
	
	def test_max_length_throws_exception
		max_length = 10
		print_this "'#{ $test_array[ 2 ] }'", "should not exceed #{ max_length } but is nil."
		ex = assert_raises(RuntimeError) {
			test_max_length( $test_array[ 2 ], "TestString", max_length )
		}
		print_this "The message: '#{ ex.message }'", "is returned from the exception."
		assert_equal( "The value for TestString is empty.", ex.message )
		puts
	end
	###########################################################
	
	#Test test_date -	test_date string_with_date  (should match ibc_date_format %Y%m%d)
	def test_date_should_be_false
		input_dates = [ '2014-07-31', '2014/07/31', '201401']
		input_dates.each do |input|
			print_this input, "does not match format YYYYMMDD"
			assert_equal false, test_date( input )
		end
		puts
	end
	
	def test_date_should_be_true
		input =  '20140731'
		print_this input, "matches format YYYYMMDD"
		assert_equal true, test_date( input )
		puts
	end
	###########################################################
	
	#Test test_mawb -	test_mawb input_str (mod digit check testing )
	def test_mawb_failures
		input_mawb = [ '1020304050', '1234769756445564464652', ' 180-62148741', 'abc', ' ']
		input_mawb.each do |input|
			print_this input, "is an invalid mawb"
			assert_equal false, test_mawb( input )
		end
		puts
	end
	
	def test_mawb_success
		input =  '18062148741'
		print_this input, "is a valid mawb"
		assert_equal true, test_mawb( input )
		puts
	end

	###########################################################
	
	#Test airline codes -	valid_airline_code? input_code  Should be like 'AA233' or 'LS2345'
	def test_airline_codes_should_be_invalid
		input_codes = [ 'A332', 'LS 3222', 'NO21']
		input_codes.each do |input|
			print_this input, "is an invalid airline code"
			assert_equal false, valid_airline_code?( input )
		end
		puts
	end

	#Test airline codes -	valid_airline_code? input_code  Should be like 'AA233' or 'LS2345'
	def test_airline_codes_should_be_valid
		input_codes = [ 'AA332', 'LS3222', 'NO0221']
		input_codes.each do |input|
			print_this input, "is a valid airline code"
			assert_equal true, valid_airline_code?( input )
		end
		puts
	end
end
