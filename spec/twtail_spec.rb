require File.dirname(__FILE__) + '/spec_helper.rb'

describe Twtail, 'execute', :mock_channel => true do

  context "without parameters" do
    before do
      Twtail.execute(nil)
    end
    it "should return the application usage" do
      error_output.should == "Usage: twtail [xbox+live | from:caffo | '#barcamp']\n"
    end
  end

  context "with a parameter" do
    before do
      Twtail.execute("xbox")
    end
    it "should display some results" do  
      output.should =~ /xbox/
    end
  end

end
