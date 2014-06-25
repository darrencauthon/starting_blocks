module StartingBlocks
  class Runner

    def initialize options
      @contract = StartingBlocks::Contract.for options
    end

    def run_files files
      StartingBlocks.display "Received these files to consider: #{files.inspect}"
      extensions = @contract.extensions.map { |x| x.gsub('.', '') }
      files = files.select { |x| extensions.include? x.split('/')[-1].split('.')[-1] }
      files = @contract.filter_these_files files 
      StartingBlocks.display "Files to run: #{files.inspect}"
      return if files.count == 0
      StartingBlocks::Publisher.publish_files_to_run files
      results = execute_these_files files
      StartingBlocks::Publisher.publish_results results
      puts results
      results
    end

    private

    def execute_these_files files
      @contract.execute_these_files files
    end

  end

end
