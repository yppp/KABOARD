# -*- coding: utf-8 -*-

require 'sinatra'
require './model/comment.rb'
require 'haml'
require 'sass'

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

get %r{/([\d]+)} do
  @page = params[:captures].first.to_i
  @comments = Comments.order_by(:id.desc).paginate(@page, 20)
  haml :index, locals: {post: nil}
end

post '/comment' do
  post = Comments::new (
                        {auther: request[:name],
                          title: request[:title],
                          body: request[:message],
                          posted_date: Time.now})
  begin
    post.save
    redirect '/'
  rescue Sequel::ValidationFailed
    @comments = Comments.order_by(:id.desc).paginate(1, 20)
    haml :index, locals: {post: post}
  end


end
