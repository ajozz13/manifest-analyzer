#!/bin/bash

##run tests ruby -I. name_of_test_script
## Pass as arguments String with a test name and the name of the script file to run 

PROG=ruby

ruby_tester(){
        echo -----------------------------------------------------
        echo Run Tests for "$1"
        $PROG -I. $2
        wait
        read -p "The set has been completed.  Press Enter to continue." 
}

##Start Script
if [ "$1" == "-j" ]; then
	PROG=jruby
fi

$PROG -v

#ruby_tester "Email Line Tester" email-line-tester.rb
#ruby_tester "Manifest Line Tester" manifest-line-tester.rb
ruby_tester "Shipment Line Tester" shipment-line-tester.rb
