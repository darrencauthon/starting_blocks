require 'listen'

module StartingBlocks
  module Watcher

    TEST_FILE_CLUES = ["_test", "test_", "_spec"]

    @last_failed_run = nil

    include Displayable

    class << self
      def start_watching(dir, options)
        set_up_the_runner options

        location = dir.getwd
        @all_files = Dir['**/*']

        puts "Listening to: #{location}"
        Listen.to!(location) do |modified, added, removed|
          StartingBlocks::Watcher.add_it(added[0], @all_files)      if added.count > 0
          StartingBlocks::Watcher.delete_it(removed[0], @all_files) if removed.count > 0
          return if @running
          StartingBlocks::Watcher.run_it(modified[0], @all_files)   if modified.count > 0
        end
      end

      def add_it(file_that_changed, all_files)
        return if file_that_changed.index('.git') == 0
        display "Adding: #{file_that_changed}"
        @all_files << file_that_changed
      end

      def run_it(file_that_changed, all_files)
        @running = true
        specs = get_the_specs_to_run file_that_changed, @all_files
        display "Matches: #{specs.inspect}"
        results = @runner.run_files specs
        store_the_specs_if_they_failed results, specs
        @running = false
      end

      def delete_it(file_that_changed, all_files)
        return if file_that_changed.index('.git') == 0
        display "Deleting: #{file_that_changed}"
        @all_files.delete(file_that_changed)
      end

      private

      def set_up_the_runner options
        @runner = StartingBlocks::Runner.new(options)
      end

      def store_the_specs_if_they_failed results, specs
        parsed_results = StartingBlocks::Publisher.result_parser.parse(results)
        if parsed_results[:failures] > 0 || parsed_results[:skips] > 0 || parsed_results[:errors] > 0
          @last_failed_run = specs
        else
          @last_failed_run = nil
        end
      rescue
      end

      def get_the_specs_to_run(file_that_changed, all_files)
        filename = flush_file_name file_that_changed
        matches = @all_files.select { |x| flush_file_name(x).include?(filename) && x != file_that_changed }
        matches << file_that_changed

        specs = matches.select { |x| is_a_test_file?(x) && File.file?(x) }.map { |x| File.expand_path x }
        specs = (@last_failed_run + specs).flatten if @last_failed_run

        specs
      end

      def is_a_test_file?(file)
        matches = TEST_FILE_CLUES.select { |clue| file.to_s.include?(clue) }
        matches.count > 0
      end

      def flush_file_name(file)
        the_file = file.downcase.split('/')[-1]
        TEST_FILE_CLUES.reduce(the_file) { |t, i| t.gsub(i, '') }
      end
    end
  end
end
