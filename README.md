# Octopress Popular Posts Plugin

Popular posts plugin adds a popular posts asides section to your [Octopress](http://octopress.org) blog. Popularity of the post is calculated by the [Google page rank](http://en.wikipedia.org/wiki/PageRank).

## How it works

The popular posts template is generated with the blog. It makes queries to check the page rank for each post. Once generated, the popular posts asides section is a static page. Which means popularity is updated only when the site is generated.

Popular posts plugin caches the page rank results of each post. The results are stored in the __.page_ranks__ directory of your blog. When there is a cache, the plugin will read from it. When there is no cache, it will generate one. Caches expires in 1 month. This shortens the time needed to generate your blog.

Google page rank is updated every 3 months. A static page is sufficient as page rank don't change every hour.

## Installation

The plugin is distributed by Ruby gems.

Add this line to your __Gemfile__

```
gem 'octopress-popular-posts'
```

Install it using Bundler

```
bundle install
```

We have to run installation commands to copy the plugin to your source

```
bundle exec octopress-popular-posts install
```

## Usage

Once installed, the popular posts asides section will be generated whenever you run

```
rake generate
```

No additional steps are necesary.

## Post install configurations

In your blog's __config.yml__, add this line.

```
popular_posts_count: 5      # Posts in the sidebar Popular Posts section
```

This sets the number of popular posts to show.

Next, we need to add the popular post aside section.

```
default_asides: [custom/asides/about.html, custom/asides/subscribe.html, custom/asides/popular_posts.html, asides/recent_posts.html, asides/github.html, asides/twitter.html, asides/delicious.html, asides/pinboard.html, asides/googleplus.html]
```

Note the __custom/asides/popular_posts.html__ that is added on the third entry of the array.

Once done, you need to generate the blog.

```
rake generate
```

The first run will take some time as the cache for popular plugins is created. You should see the popular posts aside section on your blog.

I also suggest that you ignore the cached page rank files by adding this line to your __.gitignore__

```
.page_ranks
```

## Updating the plugin

Upon new updates, run the following command

```
bundle exec octopress-popular-posts install
```

## Post remove configurations

To remove the plugin, run the following command

```
bundle exec octopress-popular-posts remove
```

You will also need to remove the following configurations

1. The octopress-popular-posts gem from your __Gemfile__
2. The __popular_posts_count__ variable from your __config.yml__
3. The popular posts asides under __defaults_asides__ from your __config.yml__

## Other themes and plugins

Shameless plug: more themes and plugins are available on [Octopress themes](http://octopressthemes.com). Feel free to take a look.

## Copyright

Copyright &copy 2012 [Wong Liang Zan](http://liangzan.net). MIT License
