require 'rubygems'
require 'oauth'
require 'open-uri'
require 'mechanize'
require 'fileutils'
require "pstore"

class GoodOath
  class UserToken
    attr_accessor :user,:request_token,:access_token
  end

  def initialize
    #production
    self.key    = 'xw3bw5rFUFr8LSuBqOdC2w'
    self.secret = 'qOKAqYJPZiC3iOdifigKFSxEd2vLGAiEqmVMxFSQ'
    self.hostname = 'http://www.goodreads.com'
    #development
    #self.key= 'RdigIYnGLMUVpzGa1IZVYw'
    #self.secret= 'JkaSe9jC2zpBZbgXfWZOpW59eFQNLgPMavizi59w'
    #self.hostname = 'http://localhost:3000'
  end
  attr_accessor :key,:secret,:user_token,:hostname

  def register_user(user)
    if !stored_user?(user)
      consumer=OAuth::Consumer.new(key,secret,{:site=>self.hostname})
      user_token = UserToken.new 
      user_token.user = user
      user_token.request_token = consumer.get_request_token
      goat.transaction do
        goat[user] = user_token
      end
    end
    load_user(user)
  end
  def stored_user?(user)
    goat.transaction do
      goat.root?(user)
    end
  end
  def load_user(user)
    user_token = nil # block
    goat.transaction do
      user_token = goat[user]
    end
    @user_token = user_token
  end
  def authorize_url
    @authorize_url ||= request_token.authorize_url
  end
  #
  # only one access token will be granted from a request token
  #
  def access_token
    user_token = @user_token
    goat.transaction do
      if user_token.access_token.nil?
        user_token.access_token = request_token.get_access_token
        if !user_token.access_token.nil?
          goat[user_token.user] = user_token
        end
      end
    end
    @user_token = user_token
    @user_token.access_token
  end
  def authorized?(user)
    if @user_token && 
      @user_token.user == user &&
      @user_token.access_token
      return true
    elsif stored_user?(user)
      load_user(user)
      return @user_token && 
        @user_token.user == user &&
        @user_token.access_token
    else 
      return false
    end
  end
  private 
  def request_token
    @user_token.request_token 
  end
  def goat
    @goat ||= PStore.new('goat.pstore')
  end
end
