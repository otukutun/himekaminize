module Himekaminize
  module Filters
    class BaseFilter
      # @param array [Array]
      # @return [Array]
      def call(array)
        raise ::NotImplementedError
      end
    end
  end
end
