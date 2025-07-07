#!/usr/bin/env ruby
# 入力 : 著者名（1 行ごと、タブや末尾改行なし）
# 出力 : SHA256ハッシュ <TAB> スペースを+に置換した著者名
require "digest"

STDIN.each_line(chomp: true) do |name|
  hash = Digest::SHA256.hexdigest(name)
  slug = name.gsub(" ", "+")
  puts "#{hash}	#{slug}"
end
