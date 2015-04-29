=begin
        This program manages the IBC Air AMS analysis.
        Usage: manifest-analyzer.rb -f path_to_input_file [-d][-s]
=end

##      requirements
require_relative 'email-line'
require_relative 'manifest-line'
require_relative 'shipment-line'

##      variables
$debug = false
$errors_count = 0

##      functions
def run_test
        result = yield
        puts "Last Test result? #{ result }" if $debug
        $errors_count = $errors_count + 1 unless result
end


##MAIN
begin
        $debug = ARGV.include? "-d"
        
        f_index = (ARGV.index "-f") + 1 if ARGV.include? "-f"
        raise "Usage: #{ $0 } -f path_to_file" if f_index.nil?
        stop_processing = ARGV.include? "-s" #On first error line error
        f = File.open( ARGV[ f_index ], "r" )
        puts "Start Analysis for: #{ f.inspect }"
        ##Counters and flags
        man_line_detected = false
        man_line_counter = 0
        ship_line_counter = 0
        f.each_line do |line|
                puts "Test #{ line } : #{ line[ 0..1 ] }" if $debug
                case line[ 0..1 ]

                        when "1,"
                                run_test{ test_manifest_line line }
                                man_line_detected = true
                                man_line_counter += 1
                        when "6,","7,"                
                                run_test{ test_email_line line }
                        when "8,","9,","10"
                                run_test{ test_shipment_line line }
                                man_line_detected = false if man_line_detected
                                ship_line_counter += 1
                        else
                                raise "There is an issue processing this line\n[#{ line }]"
                end
                puts "Stop? #{ stop_processing } Pause Testing? #{ $errors_count > 0 }" if $debug
                raise "Stop Processing. Total errors #{ $errors_count }" if stop_processing  && $errors_count > 0
                
        end
        puts "Total manifest reported: #{ man_line_counter }. Total shipments reported: #{ ship_line_counter }."
        raise "A new manifest line was detected but no subsequent shipment lines." if man_line_detected
        raise "We did not find any manifest lines to report." if man_line_counter < 1
        raise "Errors reported. Total lines with errors #{ $errors_count }" if $errors_count > 0   
rescue Exception => e
        puts "Exception: #{e}"
        puts "#{ e.backtrace }"
        exit 2
ensure
        puts "Close file: #{ f.inspect }" if $debug
        f.close
end
puts "Congratulations: All tests passed."
exit 0

##END MAIN
