module Fixtures

  def fixture(name)
    filename = File.expand_path("../../fixtures/#{name}.xml", __FILE__)
    File.read filename
  end
  
end
