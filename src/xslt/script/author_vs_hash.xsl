<?xml version="1.0" encoding="UTF-8"?>

<!--
<authors>
    <author>
        <name>フェルディナント・フォン・シーラッハ+(著)、+酒寄+進一+(翻訳)</name>
        <hash>211b7128d836827d091db062ff5033d58b187c9dd94e93905c1079bd29499325</hash>
    </author>
    ...
</authors>

といった具合で、Ruby で計算された SHA256 を xml 形式に変換するためのもの。
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text" encoding="UTF-8"/>

    <xsl:key name="authors-by-name" match="creator" use="."/>

    <xsl:template match="/">
        <xsl:for-each select="//item/creator[generate-id(.) = generate-id(key('authors-by-name', .)[1])]">
            <xsl:sort select="."/>
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
