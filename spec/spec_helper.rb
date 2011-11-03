require 'singleton'
require 'rack/test'
require 'fabrication'

class SinatraSpecHelper
  include Singleton
  attr_accessor :last_app
end

module Sinatra
  class Base
    def call(env)
      _dup = dup
      SinatraSpecHelper.instance.last_app = _dup
      _dup.call!(env)
     end
    
    def assigns(sym)
      instance_variables.include?(sym)
    end
  end
end

module MyTestMethods
  def app
    Sinatra::Application
  end
  
  def last_app
    SinatraSpecHelper.instance.last_app
  end
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include MyTestMethods
  config.before(:all)    { Fabrication.reset(:before_all)  }
  config.before(:each)   { Fabrication.reset(:before_each) }
end
