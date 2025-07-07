<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="../component/layout.xsl"/>
    <xsl:output method="html" encoding="UTF-8" indent="yes" doctype-system="about:legacy-compat"/>

    <xsl:param name="isbn_param"/>
    <xsl:param name="hashes_xml_path"/>
    <xsl:param name="base_url" select="''"/>

    <xsl:variable name="author_hashes" select="document($hashes_xml_path)/authors/author"/>

    <xsl:template match="/">
        <xsl:variable name="page_title">
            <xsl:text>書籍詳細 - </xsl:text>
            <xsl:value-of select="//item[isbn = $isbn_param]/title"/>
        </xsl:variable>

        <xsl:variable name="css_paths">
            <path>
                <xsl:value-of select="concat($base_url, 'css/common.css')"/>
            </path>
            <path>
                <xsl:value-of select="concat($base_url, 'css/book_detail.css')"/>
            </path>
        </xsl:variable>

        <xsl:variable name="page_content">
            <div class="header">
                <h1>📖 書籍詳細</h1>
                <a href="{concat($base_url, 'books/index.html')}" class="back-link">← 書籍一覧に戻る</a>
            </div>

            <div class="content">
                <xsl:for-each select="//item[normalize-space(isbn) = $isbn_param]">
                    <h2>
                        <xsl:value-of select="title"/>
                    </h2>
                    <div class="book-detail">
                        <div class="details">
                            <p>
                                <strong>著者:</strong>
                                <xsl:variable name="author_name" select="normalize-space(creator)"/>
                                <xsl:variable name="author_name_slug"
                                              select="translate($author_name, ' ', '+')"/>
                                <xsl:variable name="author_hash"
                                              select="$author_hashes[name=$author_name_slug]/hash"/>
                                <a href="{concat($base_url, 'authors/', $author_hash, '.html')}"
                                   class="author-link">
                                    <xsl:value-of select="creator"/>
                                </a>
                            </p>
                            <p>
                                <strong>出版社:</strong>
                                <xsl:value-of select="publisher"/>
                            </p>
                            <p>
                                <strong>価格:</strong>
                                ¥<xsl:value-of select="format-number(price, '#,##0')"/>
                            </p>
                            <p>
                                <strong>ISBN:</strong>
                                <xsl:value-of select="isbn"/>
                            </p>
                            <xsl:if test="description != ''">
                                <p>
                                    <strong>説明:</strong>
                                    <xsl:value-of select="description"/>
                                </p>
                            </xsl:if>
                            <xsl:if test="keywords/keyword">
                                <p>
                                    <strong>キーワード:</strong>
                                    <xsl:for-each select="keywords/keyword">
                                        <xsl:value-of select="."/>
                                        <xsl:if test="position() != last()">,</xsl:if>
                                    </xsl:for-each>
                                </p>
                            </xsl:if>
                            <xsl:if test="url/@resource">
                                <p>
                                    <strong>関連URL:</strong>
                                    <a href="{url/@resource}" target="_blank">
                                        <xsl:value-of select="url/@resource"/>
                                    </a>
                                </p>
                            </xsl:if>
                        </div>
                    </div>
                </xsl:for-each>
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
