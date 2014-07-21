#!/bin/bash

##run tests ruby -I. name_of_test_script
## Pass as arguments String with a test name and the name of the script file to run 
ruby_tester(){
        echo -----------------------------------------------------
        echo Run Tests for "$1"
        ruby -I. $2
        wait
        read -p "The set has been completed.  Press Enter to continue." 
}

#ruby_tester "Email Line Tester" email-line-tester.rb
#ruby_tester "Manifest Line Tester" manifest-line-tester.rb
ruby_tester "Shipment Line Tester" shipment-line-tester.rb
