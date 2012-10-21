# Public: Module for handling the installation and removal of the Octopress popular post
#         plugin
module OctopressThemes
  module PopularPost
    module Utilities
      PLUGINS_DIR = File.expand_path(File.dirname(__FILE__) + '/../../templates/plugins')
      ASIDES_DIR = File.expand_path(File.dirname(__FILE__) + '/../../templates/asides')

      # Public: Installs the templates to the designated locations
      #
      # Examples
      #
      #   OctopressThemes::PopularPost.install
      #   # => nil
      #
      # Returns nothing
      def self.install
        FileUtils.copy_file plugin_path, plugin_destination
        FileUtils.copy_file aside_path, aside_destination
      end

      # Public: Removes plugin files
      #
      # Examples
      #
      #   OctopressThemes::PopularPost.remove
      #   # => nil
      #
      # Returns nothing
      def self.remove
        FileUtils.rm plugin_destination
        FileUtils.rm aside_destination
      end

      protected

      # Private: Returns the file path to the plugin template
      #
      # Examples
      #
      #   plugin_path
      #   # => /path/to/plugin.rb
      #
      # Returns a String
      def self.plugin_path
        File.join(PLUGINS_DIR, 'popular_post.rb')
      end

      # Private: Returns the file path to the plugin destination
      #
      # Examples
      #
      #   plugin_destination
      #   # => /path/to/destination/plugin.rb
      #
      # Returns a String
      def self.plugin_destination
        File.join(Dir.pwd, 'plugins', 'popular_post.rb')
      end

      # Private: Returns the file path to the aside template
      #
      # Examples
      #
      #   aside_path
      #   # => /path/to/aside.html
      #
      # Returns a String
      def self.aside_path
        File.join(ASIDES_DIR, 'popular_posts.html')
      end

      # Private: Returns the file path to the aside destination
      #
      # Examples
      #
      #   aside_destination
      #   # => /path/to/destination/aside.html
      #
      # Returns a String
      def self.aside_destination
        File.join(Dir.pwd, 'source', '_includes', 'custom', 'asides', 'popular_posts.html')
      end
    end
  end
end
