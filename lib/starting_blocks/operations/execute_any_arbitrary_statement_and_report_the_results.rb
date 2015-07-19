module StartingBlocks

  class ExcuteAnyArbitraryStatementAndReportTheResults < Operation

    def self.id
      :execute
    end

    def run
      StartingBlocks::Publisher.result_builder = StartingBlocks::PassThroughResultBuilder.new

      statement_to_execute = ARGV[ARGV.index('execute') + 1]
      StartingBlocks::Publisher.publish_files_to_run [statement_to_execute]
      result = StartingBlocks::Bash.run(statement_to_execute)
      StartingBlocks::Publisher.publish_results( { color:      (result[:success] ? :green : :red),
                                                   tests:      1,
                                                   assertions: 1,
                                                   failures:   (result[:success] ? 0 : 1),
                                                   errors:     0,
                                                   skips:      0 } )
      puts result[:text]
    end

  end

end
