<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="../component/layout.xsl"/>
    <xsl:output method="html" encoding="UTF-8" indent="yes" doctype-system="about:legacy-compat"/>

    <xsl:param name="author_name" select="''"/>
    <xsl:param name="base_url" select="''"/>

    <xsl:template match="/">
        <xsl:variable name="page_title">
            <xsl:value-of select="$author_name"/> - 著者詳細
        </xsl:variable>

        <xsl:variable name="css_paths">
            <path>
                <xsl:value-of select="concat($base_url, 'css/common.css')"/>
            </path>
            <path>
                <xsl:value-of select="concat($base_url, 'css/author_detail.css')"/>
            </path>
        </xsl:variable>

        <xsl:variable name="page_content">
            <div class="header">
                <h1>
                    <xsl:value-of select="$author_name"/>
                </h1>
                <div>
                    <a href="{concat($base_url, 'index.html')}" class="back-link">← ホームに戻る</a>
                    <a href="{concat($base_url, 'authors/')}" class="back-link">← 著者一覧に戻る</a>
                </div>
            </div>

            <div class="content">
                <div class="author-stats detail">
                    <xsl:variable name="author_books"
                                  select="//item[normalize-space(creator) = normalize-space($author_name)]"/>
                    <xsl:variable name="total_books" select="count($author_books)"/>
                    <xsl:variable name="avg_price" select="sum($author_books/price) div $total_books"/>

                    <p>
                        <strong>総書籍数:</strong>
                        <xsl:value-of select="$total_books"/>冊
                    </p>
                    <p>
                        <strong>平均価格:</strong>
                        ¥<xsl:value-of select="format-number($avg_price, '#,##0')"/>
                    </p>


                </div>

                <h2>著書一覧</h2>
                <table>
                    <thead>
                        <tr>
                            <th>タイトル</th>
                            <th>出版社</th>
                            <th>価格</th>
                            <th>ISBN</th>
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:for-each select="//item[normalize-space(creator) = normalize-space($author_name)]">
                            <tr>
                                <td>
                                    <xsl:value-of select="title"/>
                                </td>
                                <td>
                                    <xsl:value-of select="publisher"/>
                                </td>
                                <td>
                                    <span class="price">¥<xsl:value-of select="format-number(price, '#,##0')"/>
                                    </span>
                                </td>
                                <td>
                                    <xsl:value-of select="isbn"/>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </tbody>
                </table>
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
