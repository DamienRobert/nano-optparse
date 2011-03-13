require "micro-optparse"

describe Parser do
  describe "example program" do
    it "should show help message when called with --help or -h" do
      results = [`ruby spec/programs/example.rb -h`, `ruby spec/programs/example.rb --help`]
      results.each do |result|
        result.should include("--help")
        result.should include("Show this message")
      end
    end

    it "should include the banner info in the help message" do
      result = `ruby spec/programs/example.rb --help`
      result.should include("This is a banner")
    end
    
    it "should display the version when called with --version or -V" do
      # here -V is used for version, as -v is already taken for the verbose switch
      results = [`ruby spec/programs/example.rb -V`, `ruby spec/programs/example.rb --version`]
      results.each do |result|
        result.strip.should == "OptParseWrapper 0.8 (c) Florian Pilz 2011"
      end
    end
    
    it "should display the default values if called without arguments" do
      result = `ruby spec/programs/example.rb`
      result.should include(":severity => 4")
      result.should include(":verbose => false")
      result.should include(":mutation => MightyMutation")
      result.should include(":plus_selection => true")
      result.should include(":selection => BestSelection")
      result.should include(":chance => 0.8")
    end
    
    it "should display overwritten values accordingly when long option names were used" do
      args = "--severity 5 --verbose --mutation DumbMutation \
              --no-plus-selection --selection WorstSelection --chance 0.1"
      result = `ruby spec/programs/example.rb #{args}`
      result.should include(":severity => 5")
      result.should include(":verbose => true")
      result.should include(":mutation => DumbMutation")
      result.should include(":plus_selection => false")
      result.should include(":selection => WorstSelection")
      result.should include(":chance => 0.1")
    end
    
    it "should display overwritten values accordingly when short option names were used" do
      # there is no short form to set switches to false
      args = "-s 5 -v -m DumbMutation --no-plus-selection -l WorstSelection -c 0.1"
      result = `ruby spec/programs/example.rb #{args}`
      result.should include(":severity => 5")
      result.should include(":verbose => true")
      result.should include(":mutation => DumbMutation")
      result.should include(":plus_selection => false")
      result.should include(":selection => WorstSelection")
      result.should include(":chance => 0.1")
    end
    
    it "should display a warning if an argument was invalid" do
      result = `ruby spec/programs/example.rb --free-beer`
      result.strip.should == "invalid option: --free-beer"
    end
    
    it "should display a warning if another argument is needed" do
      result = `ruby spec/programs/example.rb --mutation`
      result.strip.should == "missing argument: --mutation"
    end
    
    it "should display a warning if an argument of the wrong type was given" do
      result = `ruby spec/programs/example.rb --severity OMFG!!!`
      result.strip.should == "invalid argument: --severity OMFG!!!"
    end
    
    it "should display a warning if autocompletion of an argument was ambiguous" do
      result = `ruby spec/programs/example.rb --se 5`
      result.strip.should == "ambiguous option: --se"
    end
    
    it "should display a warning if validation value_in_set failed" do
      result = `ruby spec/programs/example.rb --severity 1`
      result.strip.should == "Parameter for severity must be in [4,5,6,7,8]"
    end
    
    it "should display a warning if validation value_matches failed" do
      result = `ruby spec/programs/example.rb --mutation Bazinga`
      result.strip.should == "Parameter must match /Mutation/"
    end
    
    it "should display a warning if validation value_satisfies failed" do
      result = `ruby spec/programs/example.rb --chance 300.21`
      result.strip.should == "Parameter must satisfy given conditions (see description)"
    end
  end
end