#!/usr/bin/env ruby

=begin	
	This is a unit test script for the email line tester
	http://en.wikibooks.org/wiki/Ruby_Programming/Unit_testing
=end

#	Library requirements
require 'test/unit'
require '../email-line.rb'
require 'tester-globals.rb'

class EmailLineTester < Test::Unit::TestCase
	
	def test_email_list_should_not_be_valid
		bad_emails = [ 'me/sap.com', 'bad-emailaddress.com', 'myfakemail.net', 'aaere3223sd' ]
		bad_emails.each do |input|
			print_this input, "is an invalid email address"
			assert_equal false, valid_email?( input )
		end
		puts
	end
	
	def test_email_list_should_be_valid
		bad_emails = [ 'aochoa@ibcinc.com', 'frank.martinez@venevicion.net', 'mikemartinez@arruga.net', 'joinme@join.me.ve', 'me124@me.com', 'long-email-address.express@pactrak.com']  ##mike-martinez  and me@me.com should ve invalid with the small regex but ok with the large regex.
		bad_emails.each do |input|
			print_this input, "is a valid email address"
			assert_equal true, valid_email?( input )
		end
		puts
	end
end	
