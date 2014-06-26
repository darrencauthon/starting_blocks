require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StartingBlocks::Watcher do

  describe "filter files according to the contract" do

    [
      [['.rb'],         ['apple.rb', 'orange.py'],              ['apple.rb']],
      [['.rb'],         ['apple.py', 'orange.rb'],              ['orange.rb']],
      [['.txt'],        ['/test/something.txt', 'another.txt'], ['/test/something.txt', 'another.txt']],
      [['.txt'],        ['/test/something.TXT', 'another.Txt'], ['/test/something.TXT', 'another.Txt']],
      [['.txt', '.rb'], ['a.txt', 'b.rb', 'c.cs'],              ['a.txt', 'b.rb']],
      [['txt', 'rb'],   ['a.txt', 'b.rb', 'c.cs'],              ['a.txt', 'b.rb']],
      [[''],            ['a.txt', 'Gemfile'],                   ['Gemfile']],
    ].map { |a| Struct.new(:extensions, :files, :expected_results).new(*a) }.each do |example|

      describe "multiple examples" do

        it "should filter the files" do

          contract = Struct.new(:extensions).new example.extensions
          results = StartingBlocks::Watcher.filter_files_according_to_the_contract example.files, contract

          results.must_equal example.expected_results

        end

      end

    end

  end

end
