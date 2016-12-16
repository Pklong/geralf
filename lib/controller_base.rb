require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params = req.params.merge(route_params)
  end

  def already_built_response?
    !@already_built_response.nil?
  end

  def redirect_to(url)
    raise if already_built_response?
    @already_built_response = true

    res['location'] = url
    res.status = 302
    session.store_session(res)

    res.finish
  end

  def render_content(content, content_type)
    raise if already_built_response?
    @already_built_response = true

    res['Content-Type'] = content_type
    res.write(content)
    session.store_session(res)
    res.finish
  end

  def render(template_name)
    raw_template = File.read(
      'views/' + self.class.to_s.underscore +
      "/#{template_name}.html.erb"
    )
    template = ERB.new(raw_template).result(binding)

    render_content(template, 'text/html')
  end

  def session
    @session ||= Session.new(req)
  end

  def invoke_action(name)
    send(name)
    render(name) unless @already_built_response
  end
end
