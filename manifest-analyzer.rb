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
        f.each_line do |line|
                puts "Test #{ line }" if $debug
                case line[ 0 ]

                        when "1"
                                run_test{ test_manifest_line line }
                        when "6","7"                
                                run_test{ test_email_line line }
                        when "8","9"
                                run_test{ test_shipment_line line }
                        else
                                raise "There is a line that does not belong"
                end
                puts "Stop? #{ stop_processing } Pause Testing? #{ $errors_count > 0 }" if $debug
                raise "Stop Processing. Total errors #{ $errors_count }" if stop_processing  && $errors_count > 0
        end
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
