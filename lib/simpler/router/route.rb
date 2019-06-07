module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end

      def match?(env)
        method = env['REQUEST_METHOD'].downcase.to_sym
        request_path = env['PATH_INFO'].split('/')
        @method == method && path_comparison(request_path)
      end

      def params
        @params
      end

      private

      def path_comparison(request_path)
        @params = {}
        route_path = @path.split('/')

        request_path.zip(route_path).each do |elem_request_path, elem_route_path|
          return false if elem_route_path.nil?

          if elem_route_path.include?(':')
            key = elem_route_path.delete(':').to_sym
            @params[key] = element_request_path
          else
            elem_route_path == elem_request_path ? true : (return false)
          end
        end
      end
    end
  end
end
