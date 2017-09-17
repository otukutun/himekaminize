module Himekaminize
  module Nodes
    class BaseNode
      def to_s
        raise ::NotImplementedError
      end
    end
  end
end
