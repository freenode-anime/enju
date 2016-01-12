require 'cinch/cooldown'

module Cinch
  module Plugins
    # Cinch plugin to allow complex math calculations to be done.
    class Calculate
      include Cinch::Plugin

      self.help = 'Use .math <problem> to do math computations.' \
                  '(e.g. 5 feet / inches, .math sin(2) + 4)'

      enforce_cooldown

      match(/math\s(.+)/)

      def initialize(*args)
        super
        @units_path = config[:units_path] || '/usr/bin/units'
      end

      def execute(m, problem)
        m.reply math(problem), true
      end

      private

      def math(problem_string)
        return 'Sorry, I can\'t do that' unless units_binary_exists?
        return IO.popen([@units_path, '-t', problem_string]).readline.chomp
      rescue EOFError
        debug 'Make sure you have GNU Units installed ' \
              'and not the BSD Units that ships with OSX.'
      end

      def units_binary_exists?
        return true if File.exist? @units_path
        debug 'Cinch can\'t find the unit conversion binary.'
        false
      end
    end
  end
end
