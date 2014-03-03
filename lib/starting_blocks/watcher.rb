require 'listen'

module StartingBlocks
  module Watcher

    TEST_FILE_CLUES = ["_test", "test_", "_spec"]

    @last_failed_run = nil

    class << self
      def start_watching(dir, options)
        StartingBlocks.display("Start watching #{dir.getwd} with #{options.inspect}")
        set_up_the_runner options

        location = dir.getwd
        @all_files = Dir['**/*']

        puts "Listening to: #{location}"

        callback = Proc.new do |modified, added, removed|
                     StartingBlocks.display("File counts: #{[modified.count, added.count, removed.count].inspect}")
                     StartingBlocks::Watcher.add_it(added[0])      if added.count > 0
                     StartingBlocks::Watcher.delete_it(removed[0]) if removed.count > 0
                     next if @running
                     StartingBlocks::Watcher.run_it(modified[0])   if modified.count > 0
                   end

        ::Listen.to location, &callback
      end

      def add_it(file_that_changed)
        return if not_concerned_about? file_that_changed
        StartingBlocks.display "Adding: #{file_that_changed}"
        @all_files << file_that_changed
      end

      def run_it(file_that_changed)
        @running = true
        specs = get_the_specs_to_run file_that_changed
        StartingBlocks.display "Matches: #{specs.inspect}"
        results = @runner.run_files specs
        store_the_specs_if_they_failed results, specs
        @running = false
      end

      def delete_it(file_that_changed)
        return if not_concerned_about? file_that_changed
        StartingBlocks.display "Deleting: #{file_that_changed}"
        @all_files.delete(file_that_changed)
      end

      private

      def not_concerned_about? file
        file.index('.git') == 0
      end

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

      def get_the_specs_to_run(file_that_changed)
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
