<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template name="pagination">
        <xsl:param name="page"/>
        <xsl:param name="total_pages"/>
        <xsl:param name="base_url" select="''"/>

        <xsl:if test="$total_pages > 1">
            <div class="pagination">
                <xsl:if test="$page > 1">
                    <a href="{$base_url}page_1.html">&lt;&lt; 最初</a>
                    <a href="{$base_url}page_{$page - 1}.html">&lt; 前へ</a>
                </xsl:if>

                <xsl:variable name="start_page">
                    <xsl:choose>
                        <xsl:when test="$page > 5">
                            <xsl:value-of select="$page - 4"/>
                        </xsl:when>
                        <xsl:otherwise>1</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:variable name="end_page">
                    <xsl:choose>
                        <xsl:when test="$page + 4 > $total_pages">
                            <xsl:value-of select="$total_pages"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$page + 4"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:call-template name="page-links">
                    <xsl:with-param name="current" select="$start_page"/>
                    <xsl:with-param name="end" select="$end_page"/>
                    <xsl:with-param name="page" select="$page"/>
                    <xsl:with-param name="base_url" select="$base_url"/>
                </xsl:call-template>

                <xsl:if test="$page &lt; $total_pages">
                    <a href="{$base_url}page_{$page + 1}.html">次へ &gt;</a>
                    <a href="{$base_url}page_{$total_pages}.html">最後 &gt;&gt;</a>
                </xsl:if>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="page-links">
        <xsl:param name="current"/>
        <xsl:param name="end"/>
        <xsl:param name="page"/>
        <xsl:param name="base_url"/>

        <xsl:if test="$current &lt;= $end">
            <xsl:choose>
                <xsl:when test="$current = $page">
                    <span class="current">
                        <xsl:value-of select="$current"/>
                    </span>
                </xsl:when>
                <xsl:otherwise>
                    <a href="{$base_url}page_{$current}.html">
                        <xsl:value-of select="$current"/>
                    </a>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:call-template name="page-links">
                <xsl:with-param name="current" select="$current + 1"/>
                <xsl:with-param name="end" select="$end"/>
                <xsl:with-param name="page" select="$page"/>
                <xsl:with-param name="base_url" select="$base_url"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
