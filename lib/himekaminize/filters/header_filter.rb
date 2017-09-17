require "himekaminize/filters/base_filter"
module Himekaminize
  module Filters
    class HeaderFilter < BaseFilter
      def call(context:, output:)
        @context = context
        output = output.map do |line|
          if line.is_a?(String) && line =~ /\A\s*(#{Himekaminize::Header::PATTERN})/
            Himekaminize::Header.new(line)
          else
            line
          end
        end

        {
          context: context,
          output: output,
        }
      end
    end
  end
end
