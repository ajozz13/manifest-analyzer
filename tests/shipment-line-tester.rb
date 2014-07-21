#!/usr/bin/env ruby

=begin	
	This is a unit test script for the shipment line tester
	http://en.wikibooks.org/wiki/Ruby_Programming/Unit_testing
=end

#	Library requirements
require 'test/unit'
require '../shipment-line.rb'
require 'tester-globals.rb'

class ShipmentLineTester < Test::Unit::TestCase

        $test_array = ['322123', 'Non-numeric', 'Mixed 13343-2343', nil, '', 'Milton Friedman.', '342342.33', '22.111', '999.0000', '2,323.91', '30.33', '2321.22', '99'] 
	
        ##      Tests for test_max_length       test_max_length input_str, name, max_size       
        ##      Raises an exception if length is exceeded
	def test_string_with_invalid_length_throws_exception
		input = 'Donald Rumsfeld'
		max_length = 10
		print_this "'#{ input }'", "should not exceed #{ max_length }."
		ex = assert_raises(RuntimeError) {
			test_max_length( input, "TestColumn", max_length )
		}
		print_this "The message: '#{ ex.message }'", "is returned from the exception."
		assert_equal( "The input of TestColumn: 'Donald Rumsfeld', exceeds the maximum length: 10.", ex.message )
		puts
	end
	
        ##      Test for test_max_legnth        It is valid if nil's are passed, nil is returned if it is ok..
	def test_strings_with_valid_lengths
		input = [ 'Input string', 'bad@emailaddress.com', 'Donald Rumsfeld', 'aaere3223sd', nil ]
		input.each do |i|
			print_this "#{ i }", "should be valid max is 50"
			assert_nil test_max_length( i, "TestColumn", 50 )
		end
		puts
	end

        ##      Test for test_nil_and_length    test_nil_and_length input_str, name, max_size
        ##      The only applicable test here is to make sure the exception is raised, it then calls the functions above
        def test_nil_and_length_throws_exception
                print_this "'nil'", "should raise an exception."
		ex = assert_raises(RuntimeError) {
			test_nil_and_length( nil, "TestColumn", 10 )
		}
		print_this "The message: '#{ ex.message }'", "is returned from the exception."
		assert_equal( "Input of TestColumn can not be blank.", ex.message )
		puts
        end

        ##      Test for the err_msg function.  err_msg item, position, should_be , msg
        def test_err_msg_returns_specific_message
                print_this "err_msg function", "should return a specific message" 
                assert_equal( "Input for hawb: 'test_item' should be a house bill. Keep trying.", 
                                err_msg( "test_item", 2, "a house bill", "Keep trying." ) ) 
        end

        ##      Test should_be_blank input_arr, position, hpos
        def test_should_be_blank_throws_exception
		input = $test_array[ 2 ]
		print_this "'#{ input }'", "should raise exception since we are expecting a field to be blank."
		ex = assert_raises(RuntimeError) {
			should_be_blank( $test_array, 2, 8 ) ## hpos is the position of the header item
		}
		print_this "The message: '#{ ex.message }'", "is returned from the exception."
		assert_equal( "Input for outlying: '2' should be null. Null fields are represented by two adjacent commas (,,).", 
                        ex.message )
		puts
	end

        ##      Test should_not_be_blank input_arr, position, hpos
        def test_should_not_be_blank_throws_exception
                dimm_arr = [ $test_array ]                
                (3..4).each do |num|
                        input = dimm_arr[0][ num ]
		        print_this "'#{ input }'", "should raise exception since we are expecting a field not to be blank."
		        ex = assert_raises(RuntimeError) {
			        should_not_be_blank( dimm_arr, num, 8 ) ## hpos is the position of the header item
		        }
		        print_this "The message: '#{ ex.message }'", "is returned from the exception."
                end
                puts
        end

        ##      Test should_be_char input_arr, position, hpos
        def test_should_be_char_throws_exception        ##If it detects that the input contains numbers
                dimm_arr = [ $test_array ]                
                [0, 2, 3, 4].each do |num|
                        input = dimm_arr[0][ num ]
		        print_this "'#{ input }'", "should raise exception since we are expecting a field to only contain chars."
		        ex = assert_raises(RuntimeError) {
			        should_be_char( dimm_arr, num, 8 ) ## hpos is the position of the header item
		        }
		        print_this "The message: '#{ ex.message }'", "is returned from the exception."
                end
		puts
        end

        ##      Test should_be_char input_arr, position, hpos
        def test_should_be_char_works        ##If it detects that the input contains only characters
                dimm_arr = [ $test_array ]                
                [1, 5].each do |num|
                        input = dimm_arr[0][ num ]
		        print_this "'#{ input }'", "should pass validation."
		        assert_nothing_raised(RuntimeError) {
			        should_be_char( dimm_arr, num, 8 ) ## hpos is the position of the header item
		        }
                end
		puts
        end


        ##      Test should_be_numeric input_arr, position, hpos
        def test_should_be_numeric_throws_exception     ## if input is not numeric only
                dimm_arr = [ $test_array ]                
                (2..4).each do |num|
                        input = dimm_arr[0][ num ]
		        print_this "'#{ input }'", "should raise exception since we are expecting only numbers."
		        ex = assert_raises(RuntimeError) {
			        should_be_numeric( dimm_arr, num, 8 ) ## hpos is the position of the header item
		        }
		        print_this "The message: '#{ ex.message }'", "is returned from the exception."
                end
		puts
        end

        ##      Test should_be_numeric input_arr, position, hpos
        def test_should_be_numeric_works     ## if input is numeric only
                dimm_arr = [ $test_array ]                
                [0, 6].each do |num|
                        input = dimm_arr[0][ num ]
		        print_this "'#{ input }'", "should pass validation."
		        assert_nothing_raised(RuntimeError) {
			        should_be_numeric( dimm_arr, num, 8 ) ## hpos is the position of the header item
		        }
                end
		puts
        end

        ##      Test should_be_decimal input_arr, position, hpos, dig, dec
        def test_should_be_decimal_throws_exception
                dimm_arr = [ $test_array ]                
                (6..9).each do |num|
                        input = dimm_arr[0][ num ]
		        print_this "'#{ input }'", "should raise exception since we are expecting only decimal(4,2)."
		        ex = assert_raises(RuntimeError) {
			        should_be_decimal( dimm_arr, num, 8, 4, 2 ) ## hpos is the position of the header item
		        }
		        print_this "The message: '#{ ex.message }'", "is returned from the exception."
                end
		puts
        end
        
        def test_should_be_decimal_works
                dimm_arr = [ $test_array ]                
                (10..12).each do |num|
                        input = dimm_arr[0][ num ]
		        print_this "'#{ input }'", "be ok, accepting only decimal(4,2)."
		        assert_nothing_raised(RuntimeError){
			        should_be_decimal( dimm_arr, num, 8, 4, 2 ) ## hpos is the position of the header item
		        }
                end
		puts
        end

        ##      Test should_be_in_list input_arr, position, header_position, max_length, accepted_list 
        def test_should_be_in_list_throws_exception
                accepted_list = "P,D,X"
                input_list = [ ['A', 'B', 'C'] ]               
                (0..2).each do |num|
                        input = input_list[0][ num ]
		        print_this "'#{ input }'", "should raise exception since it is not in the list: '#{ accepted_list }'."
		        assert_raises(RuntimeError) {
			        should_be_in_list( input_list, num, 8, 1, accepted_list ) ## hpos is the position of the header item
		        }
                end
		puts
        end

        def test_should_be_in_list_works
                accepted_list = "DOC,POB,APX"
                input_list = [ ['POB', 'APX', 'DOC'] ]               
                (0..2).each do |num|
                        input = input_list[0][ num ]
		        print_this "'#{ input }'", "should be ok because it's in the list: '#{ accepted_list }'."
		        assert_nothing_raised(RuntimeError) {
			        should_be_in_list( input_list, num, 8, 3, accepted_list ) ## hpos is the position of the header item
		        }
                end
		puts
        end
end	



