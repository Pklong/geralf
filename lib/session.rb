require 'json'


class Session
  APP = '_rails_lite_app'
  # deserialize the cookie into a hash
  def initialize(req)
    @store = (req.cookies[APP] ? JSON.parse(req.cookies[APP]) : {})
  end

  def [](key)
    @store[key]
  end

  def []=(key, val)
    @store[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)

    @store[:path] = "/"

    res.set_cookie(APP, @store.to_json)
  end

end
