require 'page_rankr'
require 'yaml'

module Jekyll
  class Post
    PAGE_RANK_CACHE = '.page_ranks'
    DAY_IN_SECS = 86400

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

    def page_rank_expired?(post_path)
      file_modified_time = File.mtime(post_path)
      time_past = Time.now - file_modified_time

      # if file has not been modified for over a month
      time_past > (30 * DAY_IN_SECS)
    end

    def cache_page_rank(page_rank_content, cache_path)
      File.open(cache_path, 'w') do |file|
        file.puts YAML.dump(page_rank_content)
      end
    end

    def read_page_rank_cache(cache_path)
      YAML.load_file(cache_path)
    end

    def query_page_rank(host)
      PageRankr.ranks("#{host}#{self.url}", :google)[:google] || 0
    end
  end

  class Site
    attr_accessor :popular_posts

    alias_method :old_read, :read

    def read
      old_read
      host = self.config['url']
      self.popular_posts = self.posts.sort do |post_x, post_y|
        if post_y.page_rank(host) > post_x.page_rank(host)
          1
        elsif post_y.page_rank(host) == post_x.page_rank(host)
          0
        else
          -1
        end
      end
    end

    alias_method :old_site_payload, :site_payload

    def site_payload
      old_site_hash = old_site_payload
      old_site_hash["site"].merge!({"popular_posts" => self.popular_posts})
      old_site_hash
    end
  end # Site
end # Jekyll
