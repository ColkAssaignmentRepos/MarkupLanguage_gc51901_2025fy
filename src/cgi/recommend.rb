#!/usr/bin/env ruby
# frozen_string_literal: true

require 'rexml/document'

# --- 設定 ---
# スクリプトと同じディレクトリにあるデータファイルを読み込む
XML_FILE_PATH = File.expand_path('data0421.xml', File.dirname(__FILE__))
RECOMMEND_COUNT = 5

# BASE_URLはmakeから渡される環境変数を参照、なければデフォルト値
BASE_URL = ENV['BASE_URL'] || 'https://www.u.tsukuba.ac.jp/~s2513929/'

# --- データ処理 ---
def get_random_books(file_path, count)
  begin
    doc = REXML::Document.new(File.open(file_path))
    items = doc.elements.to_a('//item')
    items.sample(count)
  rescue
    # ファイルが読めないなどのエラー時は空の配列を返す
    []
  end
end

# --- HTML生成 ---
# Rubyの標準機能だけでHTMLを組み立てる
def generate_html(books)
  # HTTPヘッダーを最初に出力
  puts "Content-Type: text/html; charset=utf-8"
  puts ""

  # HTMLの骨格（ヘッダー部分）
  puts <<-HTML
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>おすすめの本</title>
  <link rel="stylesheet" href="#{BASE_URL}css/common.css">
  <link rel="stylesheet" href="#{BASE_URL}css/recommend.css">
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>🌟 おすすめの本</h1>
      <p>あなたにぴったりの本が見つかるかも？</p>
      <a href="#{BASE_URL}index.html" class="back-link">← ホームに戻る</a>
    </div>
    <div class="recommend-grid">
  HTML

  # 書籍カード部分をループで生成
  if books.empty?
    puts "<p>おすすめの書籍を読み込めませんでした。</p>"
  else
    books.each do |book|
      isbn = book.elements['isbn']&.text || ''
      title = book.elements['title']&.text || 'タイトル不明'
      creator = book.elements['creator']&.text || '著者不明'
      
      puts <<-CARD
      <div class="book-card">
        <div class="book-info">
          <h3 class="book-title">#{title}</h3>
          <p class="book-author">#{creator}</p>
        </div>
      </div>
      CARD
    end
  end

  # HTMLの骨格（フッター部分）
  puts <<-HTML
    </div>
  </div>
</body>
</html>
  HTML
end

# --- メイン処理 ---
begin
  books = get_random_books(XML_FILE_PATH, RECOMMEND_COUNT)
  generate_html(books)
rescue => e
  # 予期せぬエラーをキャッチした場合の最終防衛ライン
  puts "Content-Type: text/html; charset=utf-8"
  puts ""
  puts "<html><body><h1>500 Internal Server Error</h1><p>CGI script encountered an error.</p>"
  puts "<pre>#{e.message}\n#{e.backtrace.join("\n")}</pre>"
  puts "</body></html>"
end
