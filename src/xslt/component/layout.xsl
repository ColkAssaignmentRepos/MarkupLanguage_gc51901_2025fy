<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exslt="http://exslt.org/common"
                extension-element-prefixes="exslt">

    <xsl:template name="page_layout">
        <xsl:param name="title"/>
        <xsl:param name="css_paths"/>
        <xsl:param name="content"/>
        <xsl:param name="base_url"/>

        <html lang="ja">
            <head>
                <meta charset="UTF-8"/>
                <title>
                    <xsl:value-of select="$title"/>
                </title>
                <xsl:for-each select="exslt:node-set($css_paths)/path">
                    <link rel="stylesheet" type="text/css">
                        <xsl:attribute name="href">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                    </link>
                </xsl:for-each>
            </head>
            <body>
                <div class="container">
                    <xsl:copy-of select="$content"/>
                </div>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>