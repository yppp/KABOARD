# -*- coding: utf-8 -*-

require 'compass'
require 'sinatra'
require './model/comment.rb'
require 'haml'
require 'sass'
require 'coffee-script'
require 'json'


configure do
  Compass.configuration do |config|
    config.project_path = File.dirname(__FILE__)
    config.sass_dir = 'views'
  end

  set :haml, { :format => :html5 }
  set :sass, Compass.sass_engine_options
end

configure :production do
end

helpers do
  def partial(renderer, template, options = {})
    options = options.merge({:layout => false})
    template = "_#{template.to_s}".to_sym
    m = method(renderer)
    m.call(template, options)
  end

  def partial_haml(template, options = {})
    partial(:haml, template, options = {})
  end

  def partial_erb(template, options)
    partial(:erb, template, options)
  end
  
  include Rack::Utils; alias_method :h, :escape_html
end

set :haml, :format => :html5

get '/style.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :style
end

get '/' do
  @comments = Comments.order_by(:posted_date.desc).paginate(1, 20)
  haml :index, locals: {post: nil}
end

get '/board' do
  content_type :json
  @comments = Comments.order_by(:id.desc).paginate(1, 20)
  @comments.to_json
end


get %r{/([\d]+)} do
  @page = params[:captures].first.to_i
  @comments = Comments.order_by(:id.desc).paginate(@page, 20)
  haml :posts
end

post '/comment' do
  content_type :json
  post = Comments::new (
                        {auther: h(request[:name]),
                          title: h(request[:title]),
                          body: h(request[:message]),
                          posted_date: h(Time.now)})
  begin
    post.save
    {}.to_json
  rescue Sequel::ValidationFailed
    post.errors.to_json
  end
end


get '/app.js' do
  coffee :scri
end
