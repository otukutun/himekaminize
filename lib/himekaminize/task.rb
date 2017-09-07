module Himekaminize
  class Task
    INCOMPLETE_PATTERN = /[-+*]\s\[\s\]\s/
    COMPLETE_PATTERN = /[-+*]\s\[[xX]\]\s/

    INCOMPLETE_MD = '- [ ]'.freeze
    COMPLETE_MD = '- [x]'.freeze
    attr_accessor :name, :status, :sequence

    COMPLETE_STATUSE = :complete
    INCOMPLETE_STATUSE = :incomplete
    STATUSES = %I(#{COMPLETE_STATUSE} #{INCOMPLETE_STATUSE})

    def initialize(line, sequence)
      @sequence = sequence
      @status, @name, @space = split_name_and_status(line)
    end

    def to_s
      status_str = @status == COMPLETE_STATUSE ? COMPLETE_MD : INCOMPLETE_MD
      sprintf("%s%s %s", @space, status_str, @name)
    end

    private
    def split_name_and_status(line)
      /\A(\s)*(#{INCOMPLETE_PATTERN}|#{COMPLETE_PATTERN})(.*)/.match(line) do |m|
        if m[2] =~ /#{INCOMPLETE_PATTERN}/
          return [INCOMPLETE_STATUSE, m[3], m[1]]
        else
          return [COMPLETE_STATUSE, m[3], m[1]]
        end
      end
    end

  end
end
