=begin	
	This is a test file script for a Shipment line.  The IBC standard shipment line is specified in
	http://www.pactrak.com/manifest-to-pactrak.html.  We will test a sub-standard that 
	will support a HTTP rest driven approach, to submit and create the IBC standard format.
=end
##      requirements
require 'csv'

##	save the last line tested
$last_line_tested

##      Global Variables
$shipment_line_headers = ["record_type", "profile_key", "hawb", "ship_ref_num", "second_ship_ref", 
  "vend_ref_num", "origin", "final_dest", "outlying", "dls_station", "dls_final_dest", "num_pieces",
  "weight", "weight_unit", "contents", "value", "insurance_amount", "description",
  "fda_prior_notice", "terms", "packaging", "service_type", "collect_amount", "cust_key",
  "ship_acct_num", "dls_acct_num", "ext_cust_acct", "shipper_name", "shipper_address1",
  "shipper_address2", "shipper_city", "shipper_state", "shipper_zip", "shipper_country", "shipper_phone",
  "con_person", "con_company", "con_street_1", "con_street_2", "con_city", "con_state", "con_postal_code",
  "con_country", "con_phone", "comments"]

$shipment_line_9_header = "harmonized_code"
$shipment_line_10_header = "service_provider"

#       Record the number of expected items in the end array.
$line_type = { "8"=> 45, "9"=> 46, "10" => 47 }
$debug = false

#       print an array with index
def print_array arr
        arr.each_with_index do |issue, index|
                puts "#{ index+1 }: #{ issue }"
        end
end

##      Print the fields with the entries that where read into the input array
def print_shipment_line input_array, headers_array
        @counter = 0
        #for i in 0..$shipment_line_headers.length - 1    
	begin
		for i in 0..headers_array.length - 1               
			puts "#{ @counter+1 }) #{ headers_array[ i ] } = #{ input_array[0][ @counter ]}"
			@counter += 1 
		end  
	rescue Exception => e
		puts "Line tested: #{ $last_line_tested }"
		puts "Backtrace: #{ e.backtrace }"
	end	
        puts
end

##      Tests that apply to the shipment lines  ##All unit tested in tests directory
##      test max length of string it is OK if input is null
def test_max_length input_str, name, max_size
        unless input_str.nil?    
                raise "The input of #{name}: '#{input_str}', exceeds the maximum length: #{max_size}." if input_str.strip.length > max_size
        end
end

##      Test max length but fail if input is null
def test_nil_and_length input_str, name, max_size
        raise "Input of #{name} can not be blank." if input_str.nil? || input_str.strip.empty?
        test_max_length input_str, name, max_size
end

#       Generic error messager
def err_msg item, header, should_be , msg
        "Input for #{ header }: '#{ item }' should be #{ should_be }. #{ msg }"
end

##      The input of array at position should be blank
def should_be_blank input_arr, position, hpos
        raise err_msg input_arr[0][position], hpos, "null", 
                "Null fields are represented by two adjacent commas (,,)." unless input_arr[0][position].to_s.strip.empty?
end

##      The input array at position should not be blank
def should_not_be_blank input_arr, position, hpos, reason=""
	raise err_msg input_arr[0][position], hpos, "filled out",
		"The input for this field should not be empty. #{reason}" if input_arr[0][position].nil? || input_arr[0][position].strip.empty?
end

##      The input array at position should only contains characters
def should_be_char input_arr, position, hpos
        should_not_be_blank input_arr, position, hpos
        expr = %r{^\D*$}
        raise err_msg input_arr[0][position], hpos, "non-numeric", "Only chars are accepted." unless (input_arr[0][position] =~ expr) == 0
end

#       Test if the input string in the array at position matches the regular expression for a numeric digit
#       This will also fail if the input is nil
def should_be_numeric input_arr, position, hpos
        should_not_be_blank input_arr, position, hpos
        expr = %r{\A[0-9]+(\.[0-9][0-9]?)?\z}
        input = input_arr[0][position].strip
        raise err_msg input, hpos, "numeric", "Only 0 to 9 values are accepted." unless (input =~ expr) == 0
end

#       Test if the input in the array at position matches the regular expression for a decimal(dig,dec)
#       this will also fail if the input is nil
def should_be_decimal input_arr, position, hpos, dig, dec
        should_not_be_blank input_arr, position, hpos
        expr = %r{^\d{0,#{dig}}(?:\.\d{0,#{dec}})?$}
        input = input_arr[0][position].strip
        raise err_msg input, hpos, "a valid decimal", "The input should be decimal(#{dig}, #{dec})." unless (input =~ expr) == 0
end

##      Test if input is char, has the required length and in the given list
def should_be_in_list input_arr, position, header, max_length, accepted_list  
        unless (should_be_char input_arr, position, header or 
                        test_max_length input_arr[0][position], header, max_length)
                arr = accepted_list.split(",")
                raise "Input of: #{input_arr[0][position]} is not a valid option for #{header}" unless arr.include? input_arr[0][position].strip
        end
end

##      This function is not unit tested //simple enough
def confirm_line_size input_array
        @p = input_array.size == $line_type[ input_array[0] ]
end

##      function template to capture and return the exception message
##      called perform_and_capture{ function to call with params }
def perform_and_capture
        begin
                yield
        rescue Exception => e
		#puts "ST: #{ e.backtrace }"
                return e.message
        end
end

##      Main function to call when tests are made
##      Unit tested with Test program below
def test_shipment_line input_line
	$last_line_tested = input_line
        errs = []
	headers = $shipment_line_headers.dup
        begin
                csv_array = CSV.parse( input_line )
                print_array csv_array if $debug
		
		lt = Integer( csv_array[0][0] )
		
		if lt >= 9
			headers.insert 18, $shipment_line_9_header
			headers.insert 9, $shipment_line_10_header if lt >= 10
		end 
		puts "headers #{ $shipment_line_headers.length  } : #{ headers.length }" if $debug
		#print_shipment_line csv_array, headers

                puts "Size is #{csv_array[0].size}" if $debug
                if lt.between?(8,10)  #(8..9).member?(Integer( csv_array[0][0] ))
                        unless confirm_line_size csv_array[0]
                                raise "Size of input line (#{csv_array[0].size}) does not match expected size " \
                                      "for a type #{csv_array[0][0]} line (#{$line_type[ csv_array[0][0] ]}). "
                        end
			# headers.length == 45 is 8,  headers.length == 46 is 9  headers.length == 47 is 10
                        @line_eight = lt.eql? 8 

                        ##BEGIN LINE TEST
                        ##profile_key
                        errs.push perform_and_capture{ should_be_blank csv_array, 1, headers[1]  }

                        ##hawb  numeric and maxlength of 11
                        errs.push perform_and_capture{ should_be_numeric csv_array, 2, headers[2] or test_nil_and_length csv_array[0][2], headers[2], 11 }
                     
                        #ship_ref_num max_length 11
                        errs.push perform_and_capture{ test_max_length csv_array[0][3], headers[3], 11 }
 
                        #second_ship_ref
                        errs.push perform_and_capture{ test_max_length csv_array[0][4], headers[4], 22 }
  
                        #vend_ref_num
                        errs.push perform_and_capture{ test_max_length csv_array[0][5], headers[5], 22 }
  
                        #origin 3 letter char
                        errs.push perform_and_capture{ should_be_char csv_array, 6, headers[6] or test_max_length csv_array[0][6], headers[6], 3 }

                        #final_dest 3 letter char
                        errs.push perform_and_capture{ should_be_char  csv_array, 7, headers[7] or test_max_length csv_array[0][7], headers[7], 3 }
                        
                        #outlying X or nil
                        errs.push perform_and_capture{ test_max_length csv_array[0][8], headers[8], 1 }

			@position = 9
			@header_pos = 9
			if lt.eql? 10  #headers.length == 47
				#service_provider 3 letter char
                        	errs.push perform_and_capture{ should_be_char csv_array, @position, headers[@header_pos] or test_max_length csv_array[0][@position], headers[@header_pos], 3 } unless csv_array[0][@position].nil?
                        @position += 1
                        @header_pos += 1
			end

			
                        #dls_station 
                        errs.push perform_and_capture{ should_be_blank csv_array, @position, headers[@header_pos] }
                        @position += 1
                        @header_pos += 1
                        
                        #dls_final_dest                        
                        errs.push perform_and_capture{ should_be_blank csv_array, @position, headers[@header_pos] }
                        @position += 1
                        @header_pos += 1

                        ##num_pieces decimal(3,0)
                        errs.push perform_and_capture{ should_be_decimal csv_array, @position, headers[@header_pos], 3, 0 }
                        errs.push "num_pieces should be at least 1" if ( csv_array[0][@position].to_f < 1 )
                        @position += 1
                        @header_pos += 1
                        ##weight decimal 
                        errs.push perform_and_capture{ should_be_decimal csv_array, @position, headers[@header_pos], 7, 2 }
                        errs.push "weight should be greater than 0" unless ( csv_array[0][@position].to_f > 0 )
                        @position += 1
                        @header_pos += 1

                        ##weight_unit
                        errs.push perform_and_capture{ should_be_in_list csv_array, @position, headers[@header_pos], 1, "P,K,G" }
                        @position += 1
                        @header_pos += 1

                        ##contents  DOC or APX
                        errs.push perform_and_capture{ should_be_in_list csv_array, @position, headers[@header_pos], 3, "DOC,APX" }
                        @position += 1
                        @header_pos += 1

                        ##value should be null or 0 if DOC
                        if csv_array[0][@position - 1].eql? "DOC"
                                errs.push "Value should be 0 or blank for DOC entries. value: #{csv_array[0][@position]}" if ( (csv_array[0][@position]).to_i > 0) unless csv_array[0][@position].nil?
                        else
                                ##value decimal(7,0)
                                errs.push "Value should not be less than 1 or blank for APX" if csv_array[0][@position].nil? or (csv_array[0][@position].to_f < 1)
                                errs.push perform_and_capture{ should_be_decimal csv_array, @position, headers[@header_pos], 7, 0 }
                        end
                        @position += 1
                        @header_pos += 1

                        ##insurance_amount decimal(9,2)
                        errs.push perform_and_capture{ should_be_decimal csv_array, @position, headers[@header_pos], 9, 2 } unless csv_array[0][@position].nil?
                        @position += 1
                        @header_pos += 1
                        
                        #description char20
                        errs.push perform_and_capture{ test_max_length csv_array[0][@position], headers[@header_pos], 20 }
                        if csv_array[0][14].eql? "APX"  ##description should not be blank.
                                errs.push perform_and_capture{ should_not_be_blank csv_array, @position, headers[@header_pos], "APX Document type detected." }
                        end
                        @position += 1
                        @header_pos += 1

			unless @line_eight
                        	#harmonized_code char10 Only on line 9 lines
                        	errs.push perform_and_capture{ test_max_length csv_array[0][@position], headers[@header_pos], 10 } 
        	                @position += 1
	                        @header_pos += 1
			end
                        ##adjust position depending on the line type
                        # @position = @line_eight ? 19:20
                        # @header_pos = @line_eight ? @position + 1:@position

                        #fda_prior_notice char12
                        errs.push perform_and_capture{ test_max_length csv_array[0][@position], headers[@header_pos], 12 }
                        @position += 1
                        @header_pos += 1

                        #terms
                        errs.push perform_and_capture{ should_be_in_list csv_array, @position, @header_pos, 1, "P,C,S,F" }
                        @position += 1 
                        @header_pos += 1

                        #packaging
                        errs.push perform_and_capture{ should_be_in_list csv_array, @position, @header_pos,1, "L,P,B,T,C,M,O" }
                        @position += 1
                        @header_pos += 1

                        #service_type
                        errs.push perform_and_capture{ test_max_length csv_array[0][@position], headers[@header_pos], 2 }
                        @position += 1 
                        @header_pos += 1

                        #collect_amount should only appear if terms (@position - 3) is C 
                        if csv_array[0][@position - 3].eql? "C"
                                if csv_array[0][@position].nil?
                                        errs.push "The terms are Collect, and the value data supplied collect_amount is empty."
                                else
                                        errs.push "Collect value should be numeric and greater than 0. collect value: #{csv_array[0][@position]}" unless (csv_array[0][@position].to_f > 0)
                                        errs.push perform_and_capture{ should_be_decimal csv_array, @position, @header_pos, 7, 2 }
                                end
                        else
                                #collect_amount when terms are not C
                                errs.push perform_and_capture{ should_be_blank csv_array, @position, @header_pos }
                        end
                        @position += 1 
                        @header_pos += 1      

                        #cust_key should be blank
                        errs.push perform_and_capture{ should_be_blank csv_array, @position, @header_pos }
                        @position += 1
                        @header_pos += 1	 

                        #ship_acct_num char4 Position 25 (if line 9)
                        errs.push perform_and_capture{ test_max_length csv_array[0][@position], headers[@header_pos], 4 }
                        @position += 1 
                        @header_pos += 1

                        #dls_acct_num blank
                        errs.push perform_and_capture{ should_be_blank csv_array, @position, @header_pos }
                        @position += 1
                        @header_pos += 1

                        #ext_cust_acct blank
                        errs.push perform_and_capture{ should_be_blank csv_array, @position, @header_pos }
                        @position += 1
                        @header_pos += 1

                        ##SHIPPER INFO

                        #shipper_name char30
                        errs.push perform_and_capture{ test_nil_and_length csv_array[0][@position], headers[@header_pos], 30 }
                        @position += 1
                        @header_pos += 1

                        #shipper_address1 char25
                        errs.push perform_and_capture{ test_nil_and_length csv_array[0][@position], headers[@header_pos], 25 }
                        @position += 1
                        @header_pos += 1

                        #shipper_address2 char25
                        errs.push perform_and_capture{ test_max_length csv_array[0][@position], headers[@header_pos], 25 }
                        @position += 1
                        @header_pos += 1

                        #shipper_city char25
                        errs.push perform_and_capture{ test_nil_and_length csv_array[0][@position], headers[@header_pos], 25 }
                        @position += 1
                        @header_pos += 1

                        #shipper_state char2
                        errs.push perform_and_capture{ test_max_length csv_array[0][@position], headers[@header_pos], 2 }
                        @position += 1
                        @header_pos += 1

                        #shipper_zip char10
                        errs.push perform_and_capture{ test_max_length csv_array[0][@position], headers[@header_pos], 10 }
                        @position += 1 
                        @header_pos += 1

                        #shipper_country char2 FOR AAMS
                        errs.push perform_and_capture{ test_nil_and_length csv_array[0][@position], headers[@header_pos], 2 }
                        @position += 1 
                        @header_pos += 1      

                        #shipper_phone char15
                        errs.push perform_and_capture{ test_max_length csv_array[0][@position], headers[@header_pos], 15 }
                        @position += 1 
                        @header_pos += 1

                        ##CONSIGNEE INFO

                        #con_person char35
                        errs.push perform_and_capture{ test_max_length csv_array[0][@position], headers[@header_pos], 35 }
                        con_name = csv_array[0][@position].to_s.strip
                        @position += 1
                        @header_pos += 1

                        #con_company char35
                        errs.push perform_and_capture{ test_max_length csv_array[0][@position], headers[@header_pos], 35 }
                        con_comp = csv_array[0][@position].to_s.strip
                        errs.push "You must supply either a name( con_name ) or a company( con_company ) for the Consignee." if con_name.empty? and con_comp.empty?
                        @position += 1
                        @header_pos += 1

                        #con_street_1 char35
                        errs.push perform_and_capture{ test_max_length csv_array[0][@position], headers[@header_pos], 35 }
                        @position += 1
                        @header_pos += 1

                        #con_street_2 char35
                        errs.push perform_and_capture{ test_max_length csv_array[0][@position], headers[@header_pos], 35 }
                        @position += 1
                        @header_pos += 1

                        #con_city char35
                        errs.push perform_and_capture{ test_nil_and_length csv_array[0][@position], headers[@header_pos], 35 }
                        @position += 1
                        @header_pos += 1

                        #con_state char20
                        errs.push perform_and_capture{ test_max_length csv_array[0][@position], headers[@header_pos], 20 }
                        @position += 1 
                        @header_pos += 1

                        #con_postal_code char20
                        errs.push perform_and_capture{ test_max_length csv_array[0][@position], headers[@header_pos], 20 }
                        @position += 1 
                        @header_pos += 1

                        #con_country char2 FOR AAMS
                        errs.push perform_and_capture{ test_nil_and_length csv_array[0][@position], headers[@header_pos], 2 }
                        @position += 1 
                        @header_pos += 1

                        #con_phone char20
                        errs.push perform_and_capture{ test_max_length csv_array[0][@position], headers[@header_pos], 20 }
                        @position += 1 
                        @header_pos += 1

                        #comments char512
                        errs.push perform_and_capture{ test_max_length csv_array[0][@position], headers[@header_pos], 512 }
                else
                        raise "Line Format does not match the format definition.  Only 8 or 9 lines are accepted."
                end

                raise "Errors found" unless errs.compact.empty?
                @completed = true

        rescue Exception => e
                puts "Shipment Line: #{ e.message }"
                print_array errs.compact
		puts "---------------------------------"
                print_shipment_line csv_array, headers
                puts "Backtrace: #{ e.backtrace }" if $debug
                @completed = false 
        end
end

##      Run Test for test_shipment_line function
=begin
#requirements csv

##Main
puts "Begin Program"

line1 = "8,,123456771,,,,LHR,USA,,,,1,0.44,P,APX,10,,ADHESIVE CHEMICALS,,P,P,ST,,,,,," \
"SOME COMPANY A,123 MAIN STREET,,LONDON,,LE4 6BW,GB,+442087594076,"\
"HUGO JORGE,COMPANY 1,211 BOSTON STREET,MIDDLETON,MASSACHUSETTS,MA,01949,US,5085551212,THIS IS A COMMENT"

line2 = "9,,123456782,,,,LHR,USA,,,,1,0.44,P,DOC,10,,ADHESIVE CHEMICALS AND LONG MASKS,,,P,P,ST,,,,,," \
"SOME COMPANY A,123 MAIN STREET,,LONDON,,LE4 6BW,GB,+442087594076,"\
"HUGO JORGE,COMPANY 1,211 BOSTON STREET,MIDDLETON,MASSACHUSETTS,MA,01949,US,5085551212,THIS IS A COMMENT"

line3 = "9,,12345679,,,,LHR,USA,,,,1,0.44,P,APX,100,,ADHESIVE CHEMICALS,,,P,P,ST,,,8040,,," \
"SOME COMPANY A,123 MAIN STREET,,LONDON,,LE4 6BW,GB,+44208759407,"\
"HUGO JORGE,,211 BOSTON STREET,MIDDLETON,MASSACHUSETTS,MA,01949,US,5085551212565656655,THIS IS A COMMENT"

val = test_shipment_line line1
puts "Result for line 1 is: #{val}"
puts "-------------------------"

val = test_shipment_line line2
puts "Result for line 2 is: #{val}"
puts "-------------------------"

val = test_shipment_line line3
puts "Result for line 3 is: #{val}"
puts "-------------------------"

puts "End Program"
##End Test Program
=end       
