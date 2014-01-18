require 'middleman-core'

module Middleman
  module AutomaticClowncar
    class Extension < Middleman::Extension
      option :sizes, {}, "The sizes of thumbnails to generate"
      option :namespace_directory, %w(), "The directories inside of images that should be clowncared."
      def initialize(app, options_hash={}, &block)
        super
      end

    end
  end
end

