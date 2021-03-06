# -*- coding: utf-8 -*-
require 'sequel'

Sequel.extension :pagination

Sequel::Model.plugin :schema
Sequel::Model.plugin :validation_class_methods
Sequel::Model.plugin :json_serializer

Sequel.connect(ENV['DATABASE_URL'] || "sqlite://co.db")

class Comments < Sequel::Model
  unless table_exists?
    set_schema do
      primary_key :id
      String :auther
      String :title
      text :body
      timestamp :posted_date
    end
    create_table
  end

  def validate
    errors.add(:body, "本文を入れてください") if body.nil? || body.empty?
    errors.add(:auther, "名前を入れてください") if auther.nil? || auther.empty?
  end

  def date
    self.posted_date.strftime("%Y-%m-%d %H:%M:%S")
  end

  def formatted_message
    Rack::Utils.escape_html(self.body).gsub(/\n/, "<br>")
  end
end
