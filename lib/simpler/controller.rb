require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      @request.env['simpler.params'].merge!(@request.params)

      send(action)
      write_response
      set_default_headers

      @response.finish
    end

    private

    def status(status)
      @response.status = status
    end

    def headers
      @response.headers
    end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      return @response['Content-Type'] = 'text/plain' if @request.env['simpler.template'].is_a?(Hash)
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.env['simpler.params']
    end

    def render(template)
      @request.env['simpler.template'] = template
    end

  end
end
