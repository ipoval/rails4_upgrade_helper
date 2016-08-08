# Rails 4 upgrade helpers.
#
# Bring compatability between rails 3 and rails 4 versions of code base.
# Help to reduce the size of the code changes and allow to do code review.

# General helper
def Rails.four?
  Rails::VERSION::MAJOR.equal?(4)
end

# Routing helper
module ActionDispatch
  module Routing
    class Mapper
      class Mapping
        private

        alias_method :'rails original normalize_conditions!', :normalize_conditions!

        def normalize_conditions!
          __send__(:'rails original normalize_conditions!')
        rescue StandardError => e
          raise e unless e.message.start_with?('You should not use the `match`')
        end
      end
    end
  end
end

# Test helper
if ENV['RAILS_ENV'].eql?('test')
  module Minitest
    class ProgressReporter < Reporter
      def record result # :nodoc:
        io.print "%s#%s = %.2f s = " % [result.class, result.name, result.time.to_f] if options[:verbose]
        io.print result.result_code
        io.puts if options[:verbose]
      end
    end
  end
end
