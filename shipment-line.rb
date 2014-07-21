=begin	
	This is a test file script for a shipment line.  The IBC standard shipment line is specified in
	http://www.pactrak.com/manifest-to-pactrak.html.  We will test a sub-standard that 
	will support a HTTP rest driven approach, to submit and create the IBC standard format.
=end
##      Library requirements

##      Global Variables
$shipment_line_headers = ["record_type", "profile_key", "hawb", "ship_ref_num", "second_ship_ref", 
  "vend_ref_num", "origin", "final_dest", "outlying", "dls_station", "dls_final_dest", "num_pieces",
  "weight", "weight_unit", "contents", "value", "insurance_amount", "description", "harmonized_code",
  "fda_prior_notice", "terms", "packaging", "service_type", "collect_amount", "cust_key",
  "ship_acct_num", "dls_acct_num", "ext_cust_acct", "shipper_name", "shipper_address1",
  "shipper_address2", "shipper_city", "shipper_state", "shipper_zip", "shipper_country", "shipper_phone",
  "con_person", "con_company", "con_street_1", "con_street_2", "con_city", "con_state", "con_postal_code",
  "con_country", "con_phone", "comments"]

##      Notes we will only test for 9 lines, which contain a total of 46 columns.
$debug = false

##      Tests that apply to the shipment lines
##      test max length of string it is OK if input is null
def test_max_length input_str, name, max_size
        unless input_str.nil?    
                raise "The input of #{name}: '#{input_str}', exceeds the maximum length: #{max_size}." if input_str.strip.length > max_size
        end
end

##      Test max length but fail if input is null
def test_nil_and_length input_str, name, max_size
        raise "Input of #{name} can not be blank." if input_str.nil?
        test_max_length input_str, name, max_size
end

#       Generic error messager
def err_msg item, position, should_be , msg
  "Input for #{ $shipment_line_headers[ position ] }: '#{ item }' should be #{ should_be }. #{ msg }"
end

##      The input of array at position should be blank
def should_be_blank input_arr, position, hpos
        raise err_msg input_arr[0][position], hpos, "null", 
                "Null fields are represented by two adjacent commas (,,)." unless input_arr[0][position].nil?
end

##      The input array at position should not be blank
def should_not_be_blank input_arr, position, hpos
	raise err_msg input_arr[0][position], hpos, "filled out",
		"The input for this field should not be empty." if input_arr[0][position].nil? || input_arr[0][position].strip.empty?
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
