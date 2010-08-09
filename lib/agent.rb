class Agent
  def initialize(go)
    @go = go
  end
  def authorize_user(user,password)
    go.register_user(user)
    if !go.authorized?(user)
      agent = Mechanize.new do |agent|
      end
      agent.get(go.authorize_url) do |page|
        auth_page = page.form_with(:name => 'sign_in') do |form|
          form['user[email]'] = user
          form['user[password]'] = password
        end.click_button
        page = auth_page.form_with(:action => "#{go.hostname}/oauth/authorize") do |form|
          form['authorize'] = 1
        end.click_button
      end
    end
    self
  end
  def go
    @go
  end
end

