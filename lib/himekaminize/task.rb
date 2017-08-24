module Himekaminize
  class Task
    INCOMPLETE_PATTERN = /[-+*]\s\[\s\]\s/
    COMPLETE_PATTERN = /[-+*]\s\[[xX]\]\s/

    attr_accessor :name, :status, :sequence

    COMPLETE_STATUSE = :complete
    INCOMPLETE_STATUSE = :incomplete

    def initialize(line, sequence)
      @sequence = sequence
      @status, @name = split_name_and_status(line)
    end

    private
    def split_name_and_status(line)
      /\A\s*(#{INCOMPLETE_PATTERN}|#{COMPLETE_PATTERN})(.*)/.match(line) do |m|
        if m[1] =~ /#{INCOMPLETE_PATTERN}/
          return [INCOMPLETE_STATUSE, m[2]]
        else
          return [COMPLETE_STATUSE, m[2]]
        end
      end
    end

  end
end
