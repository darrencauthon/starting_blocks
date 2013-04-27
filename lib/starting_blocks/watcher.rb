require 'fssm'

module StartingBlocks
  class Watcher
    def initialize location, options
      @location = location
      @options = options
    end

    def start_watching
      files = Dir['**/*']
      options = @options
      FSSM.monitor(@location, '**/*') do
        update {|base, relative| StartingBlocks::Watcher.run_it relative, files, options }
        delete {|base, relative| StartingBlocks::Watcher.delete_it relative, files, options }
        create {|base, relative| StartingBlocks::Watcher.add_it relative, files, options }
      end
    end

    def self.add_it(file, files, options)
      return if file.index('.git') == 0
      display "Adding: #{file}"
      files << file
    end

    def self.run_it(file, files, options)
      filename = file.downcase.split('/')[-1].gsub('_spec', '')
      display "File to run is: #{file}"
      display "Filename: #{filename}"
      matches = files.select { |x| x.gsub('_spec.rb', '.rb').include?(filename) && x != file }
      matches << file
      specs = matches.select { |x| x.include?('_spec') && File.file?(x) }.map { |x| File.expand_path x }
      display "Matches: #{specs.inspect}"
      StartingBlocks::Runner.new(options).run_files specs
    end

    def self.delete_it(file, files, options)
      return if file.index('.git') == 0
      display "Deleting: #{file}"
      files.delete(file)
    end

    private

    def display message
      puts message if @verbose
    end
  end
end