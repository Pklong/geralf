require 'json'

class Session
  APP = '_geralf'.freeze
  def initialize(req)
    @store = (req.cookies[APP] ? JSON.parse(req.cookies[APP]) : {})
  end

  def [](key)
    @store[key]
  end

  def []=(key, val)
    @store[key] = val
  end

  def store_session(res)
    @store[:path] = '/'
    res.set_cookie(APP, @store.to_json)
  end
end
