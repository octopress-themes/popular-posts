require 'fileutils'
require File.join(File.dirname(__FILE__) + '/popular_posts/utilities')

# Handles the command line options
if ARGV.length == 1 && ARGV[0] == 'install'
  OctopressThemes::PopularPost::Utilities.install
  puts 'Octopress popular posts plugin: installed'
  puts 'Please view the README on https://github.com/octopress-themes/popular-posts for post installation configurations.'
elsif ARGV.length == 1 && ARGV[0] == 'remove'
  OctopressThemes::PopularPost::Utilities.remove
  puts 'Octopress popular posts plugin: removed'
  puts 'Please view the README on https://github.com/octopress-themes/popular-posts for post removal configurations.'
else
  puts 'Usage: octopress-popular-posts [install|remove]'
end
