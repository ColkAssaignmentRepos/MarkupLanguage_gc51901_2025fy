<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="../component/layout.xsl"/>
    <xsl:output method="html" encoding="UTF-8" indent="yes" doctype-system="about:legacy-compat"/>

    <xsl:param name="hashes_xml_path"/>
    <xsl:param name="base_url" select="''"/>
    <xsl:key name="authors-by-name" match="creator" use="."/>
    <xsl:variable name="author_hashes" select="document($hashes_xml_path)/authors/author"/>

    <xsl:template match="/">
        <xsl:variable name="page_title" select="'著者一覧 - 書籍アーカイブ'"/>

        <xsl:variable name="css_paths">
            <path>
                <xsl:value-of select="concat($base_url, 'css/common.css')"/>
            </path>
            <path>
                <xsl:value-of select="concat($base_url, 'css/authors.css')"/>
            </path>
        </xsl:variable>

        <xsl:variable name="page_content">
            <div class="header">
                <h1>👤 著者一覧</h1>
                <a href="{concat($base_url, 'index.html')}" class="back-link">← ホームに戻る</a>
            </div>

            <div class="content">
                <xsl:variable name="unique_authors"
                              select="//item/creator[generate-id(.) = generate-id(key('authors-by-name', .)[1])]"/>
                <xsl:variable name="total_authors" select="count($unique_authors)"/>
                <xsl:variable name="total_books" select="count(//item)"/>

                <div class="stats">
                    登録著者数:
                    <strong>
                        <xsl:value-of select="$total_authors"/>
                    </strong>
                    人 /
                    総書籍数:
                    <strong>
                        <xsl:value-of select="$total_books"/>
                    </strong>
                    冊
                </div>

                <div class="authors-grid">
                    <xsl:for-each select="$unique_authors">
                        <xsl:sort select="."/>
                        <xsl:variable name="author_name" select="normalize-space(.)"/>
                        <xsl:variable name="author_name_slug" select="translate($author_name, ' ', '+')"/>
                        <xsl:variable name="author_hash" select="$author_hashes[name=$author_name_slug]/hash"/>
                        <xsl:variable name="author_books" select="//item[normalize-space(creator) = $author_name]"/>
                        <xsl:variable name="book_count" select="count($author_books)"/>
                        <xsl:variable name="avg_price" select="sum($author_books/price) div $book_count"/>

                        <a href="{concat($base_url, 'authors/', $author_hash, '.html')}" class="author-card">
                            <h3>
                                <xsl:value-of select="$author_name"/>
                            </h3>
                            <div class="author-stats">
                                <div class="stat-item">
                                    <span class="stat-label">著書数</span>
                                    <div class="stat-value">
                                        <xsl:value-of select="$book_count"/>
                                        冊
                                    </div>
                                </div>
                                <div class="stat-item">
                                    <span class="stat-label">平均価格</span>
                                    <div class="stat-value">¥<xsl:value-of
                                            select="format-number($avg_price, '#,##0')"/>
                                    </div>
                                </div>
                            </div>
                        </a>
                    </xsl:for-each>
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
