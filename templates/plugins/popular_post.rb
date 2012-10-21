require 'page_rankr'
require 'yaml'


# Public: Popular posts plugin for Octopress. This plugin
#         opens up the Jekyll Post and Site classes to allow
#         Jekyll to render the popular posts aside section
module Jekyll
  class Post
    PAGE_RANK_CACHE = '.page_ranks'
    DAY_IN_SECS = 86400

    # Public: Returns the page rank of the post. It also caches the page rank.
    #         If a cached page rank is found, it returns the cached version.
    #         Caches expire in a month.
    #
    # host - The String which is the host name of the web site.
    #        It is defined in _config.yml. It is needed to form the full url
    #        of the post.
    #
    # Examples
    #
    #   page_rank('http://foo.com')
    #   # => 3
    #
    # Returns the Integer page rank of the post
    def page_rank(host)
      post_name = self.url.split('/').last
      cache_dir_path = File.join(Dir.pwd, PAGE_RANK_CACHE)
      post_path = File.join(Dir.pwd, PAGE_RANK_CACHE, post_name)

      if !File.directory?(cache_dir_path)
        Dir.mkdir cache_dir_path
      end

      if File.exists?(post_path) && !page_rank_expired?(post_path)
        read_page_rank_cache(post_path)[:rank]
      else
        post_page_rank = query_page_rank(host)
        page_rank_content = { url: self.url, rank: post_page_rank }
        cache_page_rank(page_rank_content, post_path)
        post_page_rank
      end
    end

    # Public: Checks if the cached page rank has expired. It is set
    #         to expire in 1 month. It assumes the presence of a
    #         cached page rank.
    #
    # cache_path - The String which is the file path to the cached
    #              page rank.
    #
    # Examples
    #
    #   page_rank_expired?('/path/to/cached/page_rank')
    #   # => true
    #
    # Returns a Boolean.
    def page_rank_expired?(cache_path)
      file_modified_time = File.mtime(cache_path)
      time_past = Time.now - file_modified_time

      # if file has not been modified for over a month
      time_past > (30 * DAY_IN_SECS)
    end

    # Public: Caches the page rank of the post.
    #
    # page_rank_content - The Hash which is contains rank and
    #                     the full url of the post.
    # cache_path        - The String which is the file path
    #                     to the cache
    #
    # Examples
    #
    #   cache_page_rank({url: 'http://foo/blog/bar', rank: 2}, '/path/to/cache')
    #   # => nil
    #
    # Returns nothing.
    def cache_page_rank(page_rank_content, cache_path)
      File.open(cache_path, 'w') do |file|
        file.puts YAML.dump(page_rank_content)
      end
    end

    # Public: Reads the cached page rank
    #
    # cache_path - The String which is the file path to the cache
    #
    # Examples
    #
    #   read_page_rank('/path/to/cache')
    #   # => {url: 'http://foo', rank: 2}
    #
    # Returns a Hash
    def read_page_rank_cache(cache_path)
      YAML.load_file(cache_path)
    end

    # Public: Queries Google for the page rank of the post
    #
    # host - The String which is the host name of the web site.
    #        It is defined in _config.yml. It is needed to form the full url
    #        of the post.
    #
    # Examples
    #
    #   query_page_rank('http://foo.com')
    #   # => {:google => 3}
    #
    # Returns a Hash
    def query_page_rank(host)
      PageRankr.ranks("#{host}#{self.url}", :google)[:google] || 0
    end
  end

  class Site
    attr_accessor :popular_posts

    alias_method :old_read, :read

    # Public: Making use of the read method to define popular
    #         posts. Popular posts are sorted by page rank
    #
    # Examples
    #
    #   read
    #   # => nil
    #
    # Returns nothing
    def read
      old_read
      host = self.config['url']
      self.popular_posts = self.posts.sort do |post_x, post_y|
        if post_y.page_rank(host) > post_x.page_rank(host) then 1
        elsif post_y.page_rank(host) == post_x.page_rank(host) then 0
        else -1
        end
      end
    end

    alias_method :old_site_payload, :site_payload

    # Public: We need to add popular_posts to site_payload, so that
    #         it gets passed to Liquid to be rendered.
    #
    # Examples
    #
    #   site_payload
    #   # => nil
    #
    # Returns nothing
    def site_payload
      old_site_hash = old_site_payload
      old_site_hash["site"].merge!({"popular_posts" => self.popular_posts})
      old_site_hash
    end
  end # Site
end # Jekyll
