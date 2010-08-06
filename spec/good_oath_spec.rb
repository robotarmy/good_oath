require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "GoodOath" do
  it "has as key and secret" do
    @goat = GoodOath.new
    @goat.key.should_not be_nil
    @goat.secret.should_not be_nil
  end
  it "has an authorized? " do
    @goat = GoodOath.new
    @goat.user_token = GoodOath::UserToken.new
    @goat.user_token.user = 1213
    @goat.user_token.access_token = 1213
    @goat.user_token.request_token = 1213
    @goat.authorized?(1213).should be_true

  end
end

