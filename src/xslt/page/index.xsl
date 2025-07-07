<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="../component/layout.xsl"/>
    <xsl:output method="html" encoding="UTF-8" indent="yes" doctype-system="about:legacy-compat"/>
    <xsl:key name="authors-by-name" match="creator" use="."/>
    <xsl:param name="base_url" select="''"/>
    <xsl:param name="cgi_base_url" select="''"/>

    <xsl:template match="/">
        <xsl:variable name="page_title" select="'書籍検索システム'"/>

        <xsl:variable name="css_paths">
            <path>
                <xsl:value-of select="concat($base_url, 'css/common.css')"/>
            </path>
            <path>
                <xsl:value-of select="concat($base_url, 'css/index.css')"/>
            </path>
        </xsl:variable>

        <xsl:variable name="page_content">
            <div class="header">
                <h1>📚 書籍アーカイブ</h1>
                <p>書籍・著者検索システム</p>
            </div>

            <div class="content">
                <div class="search-section">
                    <h2>🔍 書籍検索</h2>
                    <!--
                    入力された各条件は AND として扱われる。
                    （例: タイトル「夏」と著者「漱石」で検索すると、両方を満たす書籍のみが対象）
                    -->
                    <form method="GET" action="{concat($cgi_base_url, 'search.rb')}" class="search-form">
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
                        <button type="submit" class="search-button">🔍 検索実行</button>
                    </form>
                    <p class="search-note">
                        ※複数の条件を入力した場合、AND検索（すべての条件を満たすもの）となります。
                    </p>
                </div>

                <div class="navigation">
                    <!--
                    書籍一覧ページへ遷移する。
                    ここではフィルタリング条件を指定していないため、常に全件表示となる。
                    詳細な絞り込みロジックは books.xsl を参照のこと。
                    -->
                    <a href="{concat($base_url, 'books/')}" class="nav-card">
                        <h3>📖 書籍一覧</h3>
                        <p>全ての書籍を閲覧<br/>ページネーション対応
                        </p>
                    </a>
                    <a href="{concat($base_url, 'authors/')}" class="nav-card">
                        <h3>👤 著者一覧</h3>
                        <p>著者別の詳細情報<br/>統計情報付き
                        </p>
                    </a>
                </div>

                <div class="stats">
                    <xsl:variable name="total_books" select="count(//item)"/>
                    <!--
                    generate-id() を用いることで、重複しない一意な ID を得られる。
                    要するに、ハッシュ関数のようにとらえられる。
                    それを用いて、ここでは、ID が一致しないもの、
                    つまり、著者名がユニークになるようにしている。
                    -->
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
        </xsl:variable>

        <xsl:call-template name="page_layout">
            <xsl:with-param name="title" select="$page_title"/>
            <xsl:with-param name="css_paths" select="$css_paths"/>
            <xsl:with-param name="content" select="$page_content"/>
            <xsl:with-param name="base_url" select="$base_url"/>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>
