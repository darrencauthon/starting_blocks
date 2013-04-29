require 'listen'

module StartingBlocks
  module Watcher

    include Displayable

    class << self
      def start_watching(dir, options)
        location = dir.getwd
        all_files = Dir['**/*']
        puts "Listening to: #{location}"
        Listen.to(location) do |modified, added, removed|
          if modified.count > 0
            StartingBlocks::Watcher.run_it modified[0], all_files, options
          end
          if added.count > 0
            StartingBlocks::Watcher.add_it added[0], all_files, options
          end
          if removed.count > 0
            StartingBlocks::Watcher.delete_it removed[0], all_files, options
          end
        end
      end

      def add_it(file_that_changed, all_files, options)
        return if file_that_changed.index('.git') == 0
        display "Adding: #{file_that_changed}"
        all_files << file_that_changed
      end

      def run_it(file_that_changed, all_files, options)
        specs = get_the_specs_to_run file_that_changed, all_files
        display "Matches: #{specs.inspect}"
        StartingBlocks::Runner.new(options).run_files specs
      end

      def delete_it(file_that_changed, all_files, options)
        return if file_that_changed.index('.git') == 0
        display "Deleting: #{file_that_changed}"
        all_files.delete(file_that_changed)
      end

      private

      def get_the_specs_to_run(file_that_changed, all_files)
        filename = file_that_changed.downcase.split('/')[-1].gsub('_spec', '')
        matches = all_files.select { |x| x.gsub('_spec.rb', '.rb').include?(filename) && x != file_that_changed }
        matches << file_that_changed
        specs = matches.select { |x| x.include?('_spec') && File.file?(x) }.map { |x| File.expand_path x }
      end
    end
  end
end
