class Api
  def initialize(go)
    @go = go
  end
  def search_reviews(query)
    Nokogiri(go.access_token.get("/review/list?format=xml&v=2&search[query]=#{query}").body).search('book')
  end
  def user_id
    Nokogiri(go.access_token.get('/api/auth_user').body).search('user').attr('id').value
  end
  private
  def go
    @go
  end
end

