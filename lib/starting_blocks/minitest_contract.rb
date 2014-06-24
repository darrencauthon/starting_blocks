module StartingBlocks

  class MinitestContract < Contract

    def filter_these_files files
      files.select { |x| @include_vendor || x.include?('/vendor/') == false }
    end

    def execute_these_files files
      requires = files.map { |x| "require '#{x}'" }.join("\n")
      if options[:use_bundler]
        `bundle exec ruby -e "#{requires}"`
      else
        `ruby -e "#{requires}"`
      end
    end

  end

end
