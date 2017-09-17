require "active_support/core_ext/object"
module Himekaminize
  class Outline
    include ::Himekaminize::Filterable
    class << self
       # @return [Array<Himekaminize::Filters::BaseFilter>]
       def filter_classes
         @filter_classes ||= [
           ::Himekaminize::Filters::HeaderFilter
         ]
       end
    end
  end
end
