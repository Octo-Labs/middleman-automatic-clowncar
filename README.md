# Middleman::Automatic::Clowncar

Automatically generated responsive images for Middleman.

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
