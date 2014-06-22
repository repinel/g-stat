module GStat
  module Helpers
    module Report

      extend self

      def print_entries(entries, indentation=0)
        entries = Array entries
        longest_label = entries.max {|a, b|
          a = Array(a).first
          b = Array(b).first
          (a ? a : '').length <=> (b ? b : '').length
        }
        max_width = longest_label ? longest_label.is_a?(Array) ? longest_label.first.length : longest_label.length : 0
        entries.each do |label, value|
          printf "#{"\t" * indentation}%-#{max_width}s %s\n", label, value
        end
      end

    end
  end
end