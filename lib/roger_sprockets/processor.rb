require "roger/release"
require "fileutils"
require "pathname"

module RogerSprockets
  class Processor < ::Roger::Release::Processors::Base
    def initialize(options = {})
      @options = {
        sprockets_environment: ::Sprockets::Environment.new,
        build_files: ["html/javascripts/site.js"],
        load_paths: ["html/javascripts"],
        clean: true
      }.update(options)
    end

    # @option options [Hash]
    #   :build_files
    def call(release, options = {})
      @release = release

      @options.update(options)
      @sprockets = @options[:sprockets_environment]

      # Add load_paths to sprocket env
      @options[:load_paths].each do |load_path|
        @sprockets.append_path(release.project.path + load_path)
      end

      # Build output based on files passed by options[:build_files]
      @options[:build_files].each do |filename|
        build_file(filename)
      end

      # Remove included dependencies
      @options[:build_files].each do |filename|
        clean_files(filename)
      end
    end

    private

    def build_file(filename)
      asset = get_sprockets_file(filename)

      build_file = source_file_in_build_path(filename)

      # Write file to FS
      @release.log self, "Building #{build_file}"
      File.open(build_file, "w+") { |f| f.write(asset.to_s) }
    end

    def clean_files(filename)
      asset = get_sprockets_file(filename)
      asset.dependencies.each do |dep|
        dep_build_path = source_file_in_build_path(dep.filename)

        # Check if file is contained in build_path
        if dep_build_path.to_s.match(@release.config[:build_path].to_s)
          @release.debug self, "Cleaning #{dep_build_path}"
          FileUtils.rm_rf dep_build_path
        else
          @release.debug self, "Not cleaning: #{dep_build_path}"
        end
      end
    end

    def source_file_in_build_path(filepath)
      build_path = @release.config[:build_path]
      source_path = @release.source_path
      project_path = @release.project.path

      # Create a absolute_path to the given file, in a string
      # to gsub, the source_path with the build_path
      absolute_filepath = (project_path.realpath + filepath)

      # Does nothing when its outside
      absolute_filepath.sub(source_path.to_s, build_path.to_s)
    end

    def get_sprockets_file(filename)
      asset_file = Pathname.new(filename).realpath
      @sprockets.find_asset(asset_file)
    end
  end
end

::Roger::Release::Processors.register(:sprockets, RogerSprockets::Processor)
