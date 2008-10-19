require File.dirname(__FILE__) + '/spec_helper.rb'

describe "A call without parameters" do
    it "should return the application usage" do
      Twtail.execute(nil).should == "Usage: twtail [xbox+live | from:caffo | '#barcamp']"
    end
end

describe "A call with a parameter" do
  it "should display some results" do  
    DEBUG=true  
    Twtail.execute("xbox").should ==~ /xbox/
  end
end