<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exslt="http://exslt.org/common"
                extension-element-prefixes="exslt">
    <xsl:import href="../component/layout.xsl"/>
    <xsl:output method="html" encoding="UTF-8" indent="yes" doctype-system="about:legacy-compat"/>

    <xsl:param name="base_url" select="''"/>

    <xsl:template match="/">
        <xsl:variable name="page_title" select="'おすすめの本'"/>

        <xsl:variable name="css_paths">
            <path>
                <xsl:value-of select="concat($base_url, 'css/common.css')"/>
            </path>
            <path>
                <xsl:value-of select="concat($base_url, 'css/recommend.css')"/>
            </path>
        </xsl:variable>

        <xsl:variable name="page_content">
            <div class="header">
                <h1>🌟 おすすめの本</h1>
                <p>あなたにぴったりの本が見つかるかも？</p>
                <a href="{concat($base_url, 'index.html')}" class="back-link">← ホームに戻る</a>
            </div>
            <div class="recommend-grid">
                <xsl:for-each select="/items/item">
                    <div class="book-card">
                        <div class="book-info">
                            <h3 class="book-title">
                                <xsl:value-of select="title"/>
                            </h3>
                            <p class="book-author">
                                <xsl:value-of select="creator"/>
                            </p>
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
