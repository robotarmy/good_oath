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

  def search_params(opts)
    query_param = ''
    shelf_param = ''
    query = opts[:query]
    query_param = "&search[query]=#{CGI.escape(query)}" unless query.to_s.empty?
    shelf = opts[:shelf]
    shelf_param = "&shelf=#{CGI.escape(shelf)}" unless shelf.to_s.empty?

    p i = "#{query_param}#{shelf_param}"
    i
  end

  def search_reviews(opts)
    params = search_params(opts)
    Nokogiri(go.access_token.get("/review/list.xml?v=2#{params.to_s}").body).search('book')
  end

  def user_id
    Nokogiri(go.access_token.get('/api/auth_user').body).search('user').attr('id').value
  end
  private
  def go
    @go
  end
end

