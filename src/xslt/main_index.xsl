<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" encoding="UTF-8" indent="yes" doctype-system="about:legacy-compat"/>
    <xsl:key name="authors-by-name" match="creator" use="."/>

    <xsl:template match="/">
        <html lang="ja">
            <head>
                <meta charset="UTF-8"/>
                <title>📚書籍データベース</title>
                <link rel="stylesheet" href="/css/common.css"/>
                <link rel="stylesheet" href="/css/index.css"/>
            </head>
            <body>
                <div class="container">
                    <div class="header">
                        <h1>>📚書籍データベース</h1>
                        <p>様々な条件で、データベース上の書籍を検索できます</p>
                    </div>

                    <div class="content">
                        <div class="search-section">
                            <h2>🔍 書籍検索</h2>
                            <form method="GET" action="/cgi-bin/search.rb" class="search-form">
                                <div class="form-group">
                                    <label for="title">タイトル</label>
                                    <input type="text" id="title" name="title" placeholder="書籍のタイトルを入力..."/>
                                </div>
                                <div class="form-group">
                                    <label for="author">著者</label>
                                    <input type="text" id="author" name="author" placeholder="著者名を入力..."/>
                                </div>
                                <div class="form-group">
                                    <label for="publisher">出版社</label>
                                    <input type="text" id="publisher" name="publisher" placeholder="出版社名を入力..."/>
                                </div>
                                <button type="submit" class="search-button">🔍 検索</button>
                            </form>
                        </div>

                        <div class="navigation">
                            <a href="books/" class="nav-card">
                                <h3>📖 書籍一覧</h3>
                                <p>全ての書籍を閲覧<br/>ページネーション対応
                                </p>
                            </a>
                            <a href="authors/" class="nav-card">
                                <h3>👤 著者一覧</h3>
                                <p>著者別の詳細情報<br/>統計情報付き
                                </p>
                            </a>
                        </div>

                        <div class="stats">
                            <xsl:variable name="total_books" select="count(//item)"/>
                            <xsl:variable name="unique_authors"
                                          select="//item/creator[generate-id(.) = generate-id(key('authors-by-name', .)[1])]"/>
                            <xsl:variable name="total_authors" select="count($unique_authors)"/>
                            総書籍数:
                            <strong>
                                <xsl:value-of select="$total_books"/>
                            </strong>
                            冊 /
                            著者数:
                            <strong>
                                <xsl:value-of select="$total_authors"/>
                            </strong>
                            人
                        </div>
                    </div>
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
