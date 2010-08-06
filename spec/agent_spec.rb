require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Agent" do
  before(:each) do
    @a = Agent.new(GoodOath.new)
  end

  it "has authorize this app as user" do
    username = 'bob.fake.4@robotarmyma.de'
    password = 'oauth'
    @a.authorize_user(username,password)
    @a.go.stored_user?(username).should be_true
  end
end
