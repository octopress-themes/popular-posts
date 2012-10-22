Gem::Specification.new do |s|
  s.name         = 'octopress-popular-posts'
  s.version      = '0.1.0'
  s.platform     = Gem::Platform::RUBY
  s.authors      = ['Wong Liang Zan']
  s.email        = ['zan@liangzan.net']
  s.homepage     = 'https://github.com/octopress-themes/popular-posts'
  s.summary      = 'Adds a popular posts asides section to your Octopress blog.'
  s.description  = 'Octopress popular posts adds a popular posts asides section to your Octopress blog. It makes use of Google page rank to determine the popularity of the posts.'

  s.add_dependency 'PageRankr', '~> 3.2.1'
  s.add_development_dependency 'rspec', '~> 2.11.0'
  s.add_development_dependency 'jekyll', '~> 0.11.2'

  s.files = Dir.glob('lib/**/*')
  s.files += Dir.glob('bin/*')
  s.files += Dir.glob('templates/**/*')
  s.files += %w(LICENSE README.md)
  s.require_path = 'lib'
  s.executables = ['octopress-popular-posts']
  s.license = 'MIT'
end
