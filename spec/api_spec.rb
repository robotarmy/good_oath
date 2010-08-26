require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
describe 'API' do
  # authorize once
  before(:all) do
    @goat = GoodOath.new
    agent = Agent.new(@goat).authorize_user('bob.fake.4@robotarmyma.de','oauth')
  end
  
  it "can load a user id" do
    @goat = GoodOath.new
    @goat.load_user('bob.fake.4@robotarmyma.de')
    api = Api.new(@goat)
    api.user_id.should == '4113025'
  end

  it "can get a list of books for my shelf when i have a private profile" do
    # bob has a private profile
    @goat = GoodOath.new
    @goat.load_user('bob.fake.4@robotarmyma.de')
    api = Api.new(@goat)
    result = api.search_reviews(:query =>'dune').search('description')
    result.size.should == 1
  end

  it "tells me about my friend updates" do
    @goat = GoodOath.new
    @goat.load_user('bob.fake.4@robotarmyma.de')
    api = Api.new(@goat)

    updates = api.get_friend_updates
    updates.size.should >= 1
    update = updates.search('//update//name[text()="Friend Bob Fake"]').first.parent.parent

    body = update.search('body').text
    action_text = update.search('action_text').text
    action_text.should_not include(body)

  end
  it "can create a user status" do
    @goat = GoodOath.new
    @goat.load_user('bob.fake.4@robotarmyma.de')
    api = Api.new(@goat)

    api.set_user_status(:body => 'i like books').should be_true
  end

end
