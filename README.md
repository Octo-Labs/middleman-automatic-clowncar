# Middleman::Automatic::Clowncar

Automatically generated responsive images for Middleman.

[![Gem Version](https://badge.fury.io/rb/middleman-automatic-clowncar.png)](http://badge.fury.io/rb/middleman-automatic-clowncar)
[![Build Status](https://travis-ci.org/Octo-Labs/middleman-automatic-clowncar.png?branch=master)](https://travis-ci.org/Octo-Labs/middleman-automatic-clowncar)
[![Code Climate](https://codeclimate.com/github/Octo-Labs/middleman-automatic-clowncar.png)](https://codeclimate.com/github/Octo-Labs/middleman-automatic-clowncar)
[![Coverage Status](https://coveralls.io/repos/Octo-Labs/middleman-automatic-clowncar/badge.png?branch=master)](https://coveralls.io/r/Octo-Labs/middleman-automatic-clowncar?branch=master)


## Installation

Add this line to your application's Gemfile:

    gem 'middleman-automatic-clowncar'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install middleman-automatic-clowncar

## Usage

Activate the module in `config.rb` and pass in config options.

```ruby
activate :automatic_clowncar,
  :sizes => {
    :small => 200,
    :medium => 400,
    :large => 600
  },
  :namespace_directory => %w(photos)
```

At build time the extension will look in `source/photos` and will create
thumbnails for each image it finds there.

For example, let's say you have an image at
`source/photos/my-photo.jpg`. With the configuration above the extension
will generate the following files:

```
build/photos/my-photos.svg
build/photos/my-photo/my-photo-small.jpg
build/photos/my-photo/my-photo-medium.jpg
build/photos/my-photo/my-photo-large.jpg
build/photos/my-photo/timestamp.txt
```

The timestamp file is used to allow the extension to skip regenerating
the thumbnails if the modified timestamp of the source image has not changed.

Then in a template you can use the `automatic_clowncar_tag` to display a
responsive image.

```erb
<%= automatic_clowncar_tag 'photos/my-photo.jpg' %>
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/middleman-automatic-clowncar/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
