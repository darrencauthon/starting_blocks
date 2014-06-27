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

  describe "filtering files according to file clues" do

    [
      [
        ['one_test.txt'], ['_test'], ['one_test.txt']
      ],
      [
        ['one_spec.txt'], ['_test'], [],
      ],
      [
        ['two_spec.txt', 'three_test.txt'], ['_spec', '_test'], ['two_spec.txt', 'three_test.txt'],
      ],
      [
        ['another', 'two_spec.txt', 'three_test.txt'], ['_spec', '_test'], ['two_spec.txt', 'three_test.txt'],
      ],
      [
        ['another', 'two_spec_something_else.txt', 'three_test.txt'], ['_spec', '_test'], ['three_test.txt'],
      ],
      [
        ['ttest_two_spec_something_else.txt', 'test_three.txt'], ['_spec', 'test_'], ['test_three.txt'],
      ],
    ].map { |x| Struct.new(:files, :clues, :expected).new(*x) }.each do |example|

      describe "multiple examples" do
        it "should return the expected results" do
          results = StartingBlocks::Watcher.filter_files_by_file_clues example.files, example.clues
          results.must_equal example.expected
        end
      end

    end

  end

end
