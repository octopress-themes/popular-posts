require 'fileutils'

module OctopressThemes
  module PopularPost
    PLUGINS_DIR = File.expand_path(File.dirname(__FILE__) + '/../templates/plugins')
    ASIDES_DIR = File.expand_path(File.dirname(__FILE__) + '/../templates/asides')

    def self.install
      FileUtils.copy_file plugin_path, plugin_destination
      FileUtils.copy_file aside_path, aside_destination
    end

    def self.remove
      FileUtils.rm plugin_destination
      FileUtils.rm aside_destination
    end

    protected

    def self.plugin_path
      File.join(PLUGINS_DIR, 'popular_post.rb')
    end

    def self.plugin_destination
      File.join(Dir.pwd, 'plugins', 'popular_post.rb')
    end

    def self.aside_path
      File.join(ASIDES_DIR, 'popular_posts.html')
    end

    def self.aside_destination
      File.join(Dir.pwd, 'source', '_includes', 'custom', 'asides', 'popular_posts.html')
    end
  end
end

if ARGV.length == 1 && ARGV[0] == 'install'
  OctopressThemes::PopularPost.install
  puts 'Octopress popular posts plugin: installed'
  puts 'Please view the README on https://github.com/octopress-themes/popular-posts for post installation configurations.'
elsif ARGV.length == 1 && ARGV[0] == 'remove'
  OctopressThemes::PopularPost.remove
  puts 'Octopress popular posts plugin: removed'
  puts 'Please view the README on https://github.com/octopress-themes/popular-posts for post removal configurations.'
else
  puts 'Usage: octopress-popular-posts [install|remove]'
end
