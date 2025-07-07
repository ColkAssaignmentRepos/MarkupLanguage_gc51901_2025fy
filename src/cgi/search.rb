#!/usr/bin/env ruby
require 'cgi'
require 'digest'

cgi = CGI.new
author_name = cgi['author']

# デバッグ出力
STDERR.puts "--- search.rb debug ---"
STDERR.puts "author_name: #{author_name.inspect}"

if author_name && !author_name.empty?
  hash = Digest::SHA256.hexdigest(author_name)
  file_path = "/var/www/html/authors/#{hash}.html"

  # デバッグ出力
  STDERR.puts "hash: #{hash}"
  STDERR.puts "file_path: #{file_path}"
  STDERR.puts "File.exist?: #{File.exist?(file_path)}"

  if File.exist?(file_path)
    puts "Content-Type: text/html; charset=UTF-8"
    puts ""
    puts File.read(file_path)
  else
    puts "Status: 404 Not Found"
    puts "Content-Type: text/plain"
    puts ""
    puts "Not Found in CGI"
  end
else
  puts "Status: 400 Bad Request"
  puts "Content-Type: text/plain"
  puts ""
  puts "Author parameter is missing."
end
STDERR.puts "-----------------------"
