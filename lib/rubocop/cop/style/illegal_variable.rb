# frozen_string_literal: true

module RuboCop
  module Cop
    module Style
      class IllegalVariable < Base
        include RangeHelp

        MSG_DETECTED = "Not recommend using 'p' as a variable because it can be confused with the standard output function 'p'."

        def on_new_investigation
          start_p_lines = processed_source.tokens.filter_map.with_index do |token, i|
            if token.type == :tIDENTIFIER && token.text == 'p'
              next_token = processed_source.tokens[i + 1]
              next_token.type == :tEQL && next_token.text == '=' && token.line
            end
          end

          return if start_p_lines.size.zero?

          missing_offense(processed_source, start_p_lines)
        end

        private

        def missing_offense(processed_source, start_p_lines)
          start_p_lines.each do |line|
            range = source_range(processed_source.buffer, line, line)
            add_offense(range, message: MSG_DETECTED)
          end
        end
      end
    end
  end
end
