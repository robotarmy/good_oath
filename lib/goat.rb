class Goat
  STORE = './goat'
  def store_for(key)
    STORE+key
  end

  def stored?(key)
    File.exist?(store_for(key))
  end

  def load_user_token(key)
    user_token = nil
    if stored_user?(user) 
      user_token = Marshal.load(Base64.decode64(IO.read(store_for_user(user))))
    else
      raise RuntimeError('user not found in goat')
    end
    user_token
  end
   def store(user_token)
    if !stored_user?(user_token.user)
      write_user_token(user_token)
    end
  end
  def write_user_token(user_token)
    FileUtils.mkdir_p STORE
    File.open(store_for_user(user_token.user),File::CREAT|File::RDWR|File::TRUNC) do |f|
      f.write(Base64.encode64(Marshal.dump(user_token)))
    end
  end


end
