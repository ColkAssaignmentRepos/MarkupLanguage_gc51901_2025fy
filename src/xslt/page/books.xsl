<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exslt="http://exslt.org/common" extension-element-prefixes="exslt">
    <xsl:import href="../component/layout.xsl"/>
    <xsl:import href="../component/pagination.xsl"/>
    <xsl:output method="html" encoding="UTF-8" indent="yes" doctype-system="about:legacy-compat"/>

    <!--
    ページネーションのためのパラメーター。
    とりあえず 50 件ずつにしてある。
    -->
    <xsl:param name="page" select="1"/>
    <xsl:param name="per_page" select="50"/>
    <xsl:param name="filter_title" select="''"/>
    <xsl:param name="filter_author" select="''"/>
    <xsl:param name="filter_publisher" select="''"/>
    <xsl:param name="hashes_xml_path"/>
    <xsl:param name="base_url" select="''"/>

    <!--
    著者名は sha256 でハッシュ化して、別で xml で管理している。
    -->
    <xsl:variable name="author_hashes" select="document($hashes_xml_path)/authors/author"/>

    <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'"/>
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

    <xsl:template match="/">
        <xsl:variable name="page_title" select="'書籍一覧 - 書籍アーカイブ'"/>

        <xsl:variable name="css_paths">
            <path>
                <xsl:value-of select="concat($base_url, 'css/common.css')"/>
            </path>
            <path>
                <xsl:value-of select="concat($base_url, 'css/books.css')"/>
            </path>
        </xsl:variable>

        <xsl:variable name="page_content">
            <div class="header">
                <h1>📖 書籍一覧</h1>
                <a href="{concat($base_url, 'index.html')}" class="back-link">← ホームに戻る</a>
            </div>

            <div class="content">
                <!--
                書籍リストをフィルタリングするための変数。
                パラメータが空の場合、or 条件が true となり、実質的に全件取得となる。
                これにより、検索機能が実装されていない現状でも、全書籍を対象として正しく動作する。
                -->
                <xsl:variable name="all_books" select="//item[
                    (contains(translate(title, $lowercase, $uppercase), translate($filter_title, $lowercase, $uppercase)) or $filter_title = '') and
                    (contains(translate(creator, $lowercase, $uppercase), translate($filter_author, $lowercase, $uppercase)) or $filter_author = '') and
                    (contains(translate(publisher, $lowercase, $uppercase), translate($filter_publisher, $lowercase, $uppercase)) or $filter_publisher = '')
                ]"/>

                <xsl:variable name="total_books" select="count($all_books)"/>
                <xsl:variable name="total_pages" select="ceiling($total_books div $per_page)"/>
                <xsl:variable name="start_index" select="($page - 1) * $per_page + 1"/>
                <xsl:variable name="end_index" select="$page * $per_page"/>

                <div class="book-count">
                    全
                    <strong>
                        <xsl:value-of select="$total_books"/>
                    </strong>
                    件中
                    <strong>
                        <xsl:value-of select="$start_index"/>-
                        <xsl:choose>
                            <xsl:when test="$end_index > $total_books">
                                <xsl:value-of select="$total_books"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$end_index"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </strong>
                    件表示 (ページ
                    <strong>
                        <xsl:value-of select="$page"/>
                        /
                        <xsl:value-of select="$total_pages"/>
                    </strong>
                    )
                </div>

                <!-- Pagination (top) -->
                <xsl:call-template name="pagination">
                    <xsl:with-param name="page" select="$page"/>
                    <xsl:with-param name="total_pages" select="$total_pages"/>
                    <xsl:with-param name="base_url" select="concat($base_url, 'books/')"/>
                </xsl:call-template>

                <table>
                    <thead>
                        <tr>

                            <th>タイトル</th>
                            <th>著者</th>
                            <th>出版社</th>
                            <th>価格</th>
                            <th>ISBN</th>
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:for-each select="$all_books">
                            <xsl:if test="position() >= $start_index and position() &lt;= $end_index">
                                <tr>
                                    <td>
                                        <a href="{concat($base_url, 'books/detail_', normalize-space(isbn), '.html')}">
                                            <xsl:value-of select="title"/>
                                        </a>
                                    </td>
                                    <td>
                                        <xsl:variable name="author_name" select="normalize-space(creator)"/>
                                        <xsl:variable name="author_name_slug"
                                                      select="translate($author_name, ' ', '+')"/>
                                        <xsl:variable name="author_hash"
                                                      select="$author_hashes[name=$author_name_slug]/hash"/>
                                        <a href="{concat($base_url, 'authors/', $author_hash, '.html')}"
                                           class="author-link">
                                            <xsl:value-of select="creator"/>
                                        </a>
                                    </td>
                                    <td>
                                        <xsl:value-of select="publisher"/>
                                    </td>
                                    <td class="price">¥<xsl:value-of select="format-number(price, '#,##0')"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="isbn"/>
                                    </td>
                                </tr>
                            </xsl:if>
                        </xsl:for-each>
                    </tbody>
                </table>

                <!-- Pagination (bottom) -->
                <xsl:call-template name="pagination">
                    <xsl:with-param name="page" select="$page"/>
                    <xsl:with-param name="total_pages" select="$total_pages"/>
                    <xsl:with-param name="base_url" select="concat($base_url, 'books/')"/>
                </xsl:call-template>
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
