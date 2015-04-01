require "sprockets"
require "sprockets/es6"
require "roger_sprockets/version"

module RogerSprockets; end

# Load modules
require File.dirname(__FILE__) + "/roger_sprockets/middleware"
require File.dirname(__FILE__) + "/roger_sprockets/processor"
