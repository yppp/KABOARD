# -*- coding: utf-8 -*-
require './app'
require './spec/spec_helper'
require './spec/fabricators'
require 'fabrication'
require 'nokogiri'

describe 'GET /', "した時" do
  before :all do
    get '/'
  end
  
  it "statusコードは200" do
    last_response.ok?.should be_true
  end
  
  it "responseがあること" do
    last_response.body.should be_true
  end

  it "@commentsをもつ" do
    last_app.assigns(:@comments).should be_true
  end

  it "viewはindex.hamlをつかう" do
    last_response.body.should == last_app.haml(:index, locals: {post: nil})
  end

  it "タイトルはKABOARD" do
    Nokogiri::HTML(last_response.body).xpath('/html/head/title').children.to_s.should == 'KABOARD'
  end
end

describe Comments, "にレコードを追加したら" do
  before do
    @re =  Fabricate.build(:comments)
  end
  
  it "記事があること" do
    @re.should be_true
  end
end

describe Comments do
  describe "validations" do
    it "should require a body" do
      Comments.new().should_not be_valid
      Comments.new(:body => '').should_not be_valid
      Comments.new(:body => "Maggie", :auther => "foo").should be_valid
    end
  end
end
