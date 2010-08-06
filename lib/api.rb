class Api
  def initialize(go)
    @go = go
  end
  def set_user_status(opts)
    body = opts[:body] 
    page = (opts[:page] ||= 0).to_s
    response = Nokogiri(go.access_token.post("/user_status.xml?user_status[body]=#{CGI.escape(body)}&user_status[page]=#{CGI.escape(page)}").body).search('user-status body').first.text
    body == response
  end
  def search_reviews(query)
    Nokogiri(go.access_token.get("/review/list?format=xml&v=2&search[query]=#{CGI.escape(query)}").body).search('book')
  end
  def user_id
    Nokogiri(go.access_token.get('/api/auth_user').body).search('user').attr('id').value
  end
  private
  def go
    @go
  end
end

