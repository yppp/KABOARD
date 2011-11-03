# -*- coding: utf-8 -*-
require 'fabrication'
require 'faker'

Fabricator(:comments) do
  title { sequence(:title){Faker::Lorem.words(5).join(' ') }}
  auther { Faker::Internet.user_name }
  body { sequence(:body){Faker::Lorem.paragraphs(3).join("\n\n")}}
  posted_date { Time::now }
end
