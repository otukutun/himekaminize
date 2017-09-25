require "active_support/core_ext/module"
module Himekaminize
  module Nodes
    class Task < BaseNode
      INCOMPLETE_PATTERN = /[-+*]\s\[\s\]\s/
      COMPLETE_PATTERN = /[-+*]\s\[[xX]\]\s/

      INCOMPLETE_MD = '- [ ]'.freeze
      COMPLETE_MD = '- [x]'.freeze
      attr_accessor :name, :status, :seq, :space, :depth, :parent_seq
      alias_attribute :sequence, :seq

      COMPLETE_STATUSE = :complete
      INCOMPLETE_STATUSE = :incomplete
      STATUSES = %I(#{COMPLETE_STATUSE} #{INCOMPLETE_STATUSE})

      def initialize(line, seq)
        @seq = seq
        @status, @name, @space = split_name_and_status(line)
        @depth, @parent_seq = 0, nil if @space.length == 0
      end

      def to_s
        status_str = @status == COMPLETE_STATUSE ? COMPLETE_MD : INCOMPLETE_MD
        sprintf("%s%s %s\n", @space, status_str, @name)
      end

      def update_status(status)
        return false unless STATUSES.include?(status)
        @status = status
      end

      private
      def split_name_and_status(line)
        /\A(\s*)(#{INCOMPLETE_PATTERN}|#{COMPLETE_PATTERN})(.*)/.match(line) do |m|
          if m[2] =~ /#{INCOMPLETE_PATTERN}/
            return [INCOMPLETE_STATUSE, m[3], m[1]]
          else
            return [COMPLETE_STATUSE, m[3], m[1]]
          end
        end
      end
    end
  end
end
