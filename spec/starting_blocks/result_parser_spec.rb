require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StartingBlocks::ResultParser do
  describe "simple case" do
    let(:text) do <<EOF
Fabulous tests in 0.000372s, 2688.1720 tests/s, 2688.1720 assertions/s.

2 tests, 3 assertions, 4 failures, 5 errors, 6 skips

asldkjflaskjflsakj
EOF
    end

    let(:expected_results) do
      {
        tests: 2,
        assertions: 3,
        failures: 4,
        errors: 5,
        skips: 6
      }
    end

    def subject
      StartingBlocks::ResultParser.new
    end

    it "should return the counts" do
      subject.parse(text).contrast_with! expected_results
    end
  end

  describe "another case" do
    let(:text) do <<EOF
aaaaa
801 tests, 30014 assertions, 432 failures, 234 errors, 2141 skips
bbbbbb
EOF
    end

    let(:expected_results) do
      {
        tests: 801,
        assertions: 30014,
        failures: 432,
        errors: 234,
        skips: 2141
      }
    end

    def subject
      StartingBlocks::ResultParser.new
    end

    it "should return the counts" do
      subject.parse(text).contrast_with! expected_results
    end
  end

  describe "unparsable text" do
    let(:text) do <<EOF
aaaaa
lkjsdlfkjslkjslkjalskjfsalkjfd
bbbbbb
EOF
    end

    let(:expected_results) do
      {
        tests: 0,
        assertions: 0,
        failures: 0,
        errors: 0,
        skips: 0
      }
    end

    def subject
      StartingBlocks::ResultParser.new
    end

    it "should return the counts" do
      subject.parse(text).contrast_with! expected_results
    end
  end
end
