require 'jekyll'
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../templates/plugins/popular_post')

class MockPost
  include OctopressThemes::PopularPost::Post
end

class MockSite
  def read ; end
  def site_payload
    { 'site' => {} }
  end

  include OctopressThemes::PopularPost::Site
end


describe 'PopularPost' do

  describe 'Post' do
    subject { post.page_rank(host) }

    let(:page_rank) { 3 }
    let(:file_name) { 'foo-foo' }
    let(:post_name) { "/blog/#{file_name}" }
    let(:host) { 'http://foo.com' }
    let(:cache_dir_path) { File.join(Dir.pwd, OctopressThemes::PopularPost::Post::PublicInstanceMethods::PAGE_RANK_CACHE) }
    let(:cache_path) { File.join(Dir.pwd, OctopressThemes::PopularPost::Post::PublicInstanceMethods::PAGE_RANK_CACHE, file_name) }
    let(:post) { MockPost.new }
    let(:page_rank_content) { {rank: page_rank, url: post_name} }

    context 'with no cached page rank' do

      before(:each) do
        post.stub(:url) { post_name }
        PageRankr.stub(:ranks) { {google: 3} }
      end

      after(:each) do
        if File.directory?(cache_dir_path)
          FileUtils.rm_r cache_dir_path
        end
      end

      it 'should return the page rank and cache it' do
        should == page_rank
        File.exists?(cache_path).should be_true
      end
    end

    context 'with cached page rank' do
      context 'that has not expired' do
        before(:each) do
          Dir.mkdir cache_dir_path
          File.open(cache_path, 'w') do |file|
            file.puts YAML.dump(page_rank_content)
          end
          post.stub(:url) { post_name }
          PageRankr.should_not_receive(:ranks)
        end

        after(:each) do
          if File.directory?(cache_dir_path)
            FileUtils.rm_r cache_dir_path
          end
        end

        it 'should read from the cache' do
          should == page_rank
        end
      end

      context 'that has expired' do
        let(:updated_page_rank) { 6 }

        before(:each) do
          Dir.mkdir cache_dir_path
          File.open(cache_path, 'w') do |file|
            file.puts YAML.dump(page_rank_content)
          end
          post.stub(:url) { post_name }
          File.stub(:mtime) { Time.now - (40 * OctopressThemes::PopularPost::Post::ProtectedInstanceMethods::DAY_IN_SECS)}
          PageRankr.should_receive(:ranks).and_return({google: updated_page_rank})
        end

        after(:each) do
          if File.directory?(cache_dir_path)
            FileUtils.rm_r cache_dir_path
          end
        end

        it 'should make a query and update the cache' do
          should == updated_page_rank
        end
      end
    end
  end

  describe 'Site' do
    let(:site) { MockSite.new }
    let(:post) { double }

    context 'read' do
      before(:each) do
        post.stub(:page_rank) { 1 }
        site.stub(:posts) { [post] }
        site.stub(:config) { 'http://foo.com' }
      end

      it 'should set popular posts' do
        site.read
        site.popular_posts.nil?.should be_false
      end
    end

    context 'site_payload' do
      before(:each) do
        site.stub(:popular_posts) { ['foo'] }
      end

      it 'should add popular posts to site payload' do
        site.site_payload['site']['popular_posts'].nil?.should be_false
      end
    end
  end
end
