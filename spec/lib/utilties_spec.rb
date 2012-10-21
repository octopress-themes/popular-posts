require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../lib/popular_posts/utilities')

describe OctopressThemes::PopularPost::Utilities do
  let(:plugin_path) { File.join(Dir.pwd, 'plugins', 'popular_post.rb') }
  let(:plugin_dir) { File.dirname(plugin_path) }
  let(:aside_path) { File.join(Dir.pwd, 'source', '_includes', 'custom', 'asides', 'popular_posts.html') }
  let(:aside_dir) { File.dirname(aside_path) }

  context 'install' do
    subject { OctopressThemes::PopularPost::Utilities.install }

    before(:each) do
      Dir.mkdir plugin_dir
      FileUtils.mkdir_p aside_dir
    end

    after(:each) do
      FileUtils.rm_r plugin_dir
      FileUtils.rm_r File.join(Dir.pwd, 'source')
    end

    it 'should copy the plugin and aside to the destinations' do
      subject
      File.exists?(plugin_path).should be_true
      File.exists?(aside_path).should be_true
    end
  end

  context 'remove' do
    subject { OctopressThemes::PopularPost::Utilities.remove }

    before(:each) do
      Dir.mkdir plugin_dir
      FileUtils.mkdir_p aside_dir
      FileUtils.touch plugin_path
      FileUtils.touch aside_path
    end

    after(:each) do
      FileUtils.rm_r plugin_dir
      FileUtils.rm_r File.join(Dir.pwd, 'source')
    end

    it 'should remove the plugin and asides' do
      subject
      File.exists?(plugin_path).should be_false
      File.exists?(aside_path).should be_false
    end
  end
end
