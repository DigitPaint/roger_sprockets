# RogerSprockets

Add sprockets to your roger project.

> Sprockets is a Ruby library for compiling and serving web assets. It 
> features declarative dependency management for JavaScript and CSS assets, as 
> well as a powerful preprocessor pipeline that allows you to write assets in 
> languages like CoffeeScript, Sass and SCSS.

## Installation

Add this line to your application's Gemfile:

    gem "roger_sprockets"

And then execute:

    $ bundle

## Usage

Add the following lines to your Mockupfile

For serving with sprockets

```
mockup.serve do |s|
    s.use(RogerSprockets::Middleware)
end
```

For making a release
```
mockup.release do |r|    
    r.use(RogerSprockets::Processor)
end
```

### Registering additional engines

```
require 'sprockets'
require 'mustache/js'
require 'tilt/mustache_js_template'

sprockets = Sprockets::Environment.new()
sprockets.register_engine '.mustache', Tilt::MustacheJsTemplate

mockup.serve do |s|
    s.use(RogerSprockets::Middleware, :sprockets_environment => sprockets)
end
```

## Options

__[:sprockets_environment]__, 
Pass a custom sprockets environment, in which you can register an additional enginge or tweak sprockets more to your need. See [registering-additional-engines].

__[:load_paths]__, 
Add additional loading paths. 
_Defaults:_ ``` ["html/javascripts"] ```


### Processor
__[:build_files]__, 
Define which files `roger_sprockets` should build.
_Defaults:_ ``` ["html/javascripts/site.js"] ```

__[:clean]__, 
`roger_sprockets` can clean your dependencies after you made a build. 
Pass `true` to let it remove all dependencies.


## TODO

* Add test coverage (especially on some edge cases)
* Add asset fingerprinting

## Contributing

1. Fork it ( https://github.com/[my-github-username]/roger_sprockets/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
