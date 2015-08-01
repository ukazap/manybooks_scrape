require 'dm-core'
require 'dm-migrations'
require 'dm-timestamps'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/db.sqlite3")

class Book
  DataMapper::Property::String.length(255)
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :subtitle, Text
  property :author, String
  property :published_in, String
  property :genres, String
  property :language, String
  property :word_count, String
  property :description, Text
  property :excerpt, Text
  property :source_url, String, key: true, unique_index: true
  property :dl_url, String
  property :cover_url, String
  property :created_at, DateTime
end

DataMapper.finalize

DataMapper.auto_upgrade!