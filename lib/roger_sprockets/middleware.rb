module RogerSprockets
  class Middleware
    def initialize(app, options = {})
      @app = app
      defaults = {
        sprockets_environment: ::Sprockets::Environment.new,
        load_paths: ["html/javascripts"]
      }

      # Use the resolver to translate urls
      # to file paths
      @resolver = Roger::Resolver.new(app.project.html_path)

      @options = defaults.update(options)
      @sprockets = @options[:sprockets_environment]

      # Add load_paths to sprocket env
      @options[:load_paths].each do |load_path|
        @sprockets.append_path(app.project.path + load_path)
      end
    end

    def call(env)
      url = ::Rack::Utils.unescape(env["PATH_INFO"].to_s).sub(/^\//, "")

      # Convert the url to an absolute path,
      # which is used to retrieve the asset from sprockets
      asset_path = resolve_url(url)

      if url.length > 1 && file = @sprockets.find_asset(asset_path)
        respond(file)
      else
        @app.call(env)
      end
    end

    private

    def resolve_url(url)
      @resolver.url_to_path url, exact_match: true
    end

    def respond(file)
      resp = ::Rack::Response.new do |res|
        res.status = 200
        res.headers["Content-Type"] = file.content_type
        res.write file.to_s
      end
      resp.finish
    end
  end
end
