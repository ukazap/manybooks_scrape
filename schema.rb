require 'dm-core'
require 'dm-migrations'
require 'dm-timestamps'
require 'dm-validations'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/db.sqlite3")

class Book
  include DataMapper::Resource
  DataMapper::Property::String.length(255)
  validates_uniqueness_of :source_url
  
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
  property :view_count, Integer
  property :dl_count, Integer
  property :created_at, DateTime
end

DataMapper.finalize

DataMapper.auto_upgrade!