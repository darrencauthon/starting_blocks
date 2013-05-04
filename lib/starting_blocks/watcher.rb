require 'listen'

module StartingBlocks
  module Watcher

    include Displayable

    class << self
      def start_watching(dir, options)
        location = dir.getwd
        all_files = Dir['**/*']
        puts "Listening to: #{location}"
        Listen.to!(location, latency: 0.1) do |modified, added, removed|
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
        filename = flush_file_name file_that_changed
        matches = all_files.select { |x| flush_file_name(x).include?(filename) && x != file_that_changed }
        matches << file_that_changed
        specs = matches.select { |x| is_a_test_file?(x) && File.file?(x) }.map { |x| File.expand_path x }
      end

      def is_a_test_file?(file)
        file.to_s.include?('_spec') || file.to_s.include?('_test') || file.to_s.include?('test_')
      end

      def flush_file_name(file)
        file.downcase.split('/')[-1].gsub('_spec', '').gsub('test_', '').gsub('_test', '')
      end
    end
  end
end
