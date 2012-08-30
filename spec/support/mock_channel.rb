shared_context "mock channel", :mock_channel => true do

  let(:channel) { StringIO.new }
  let(:error_channel) { StringIO.new }

  before do
    @old_channel = Twtail.channel
    Twtail.channel = channel
    @old_error_channel = Twtail.error_channel
    Twtail.error_channel = error_channel
  end

  after do
    Twtail.channel = @old_channel
    Twtail.error_channel = @old_error_channel
  end
  
  def output
    channel.rewind
    channel.read
  end

  def error_output
    error_channel.rewind
    error_channel.read
  end

end
