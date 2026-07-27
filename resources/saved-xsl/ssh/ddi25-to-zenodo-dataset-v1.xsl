<?xml version="1.0" encoding="UTF-8"?>
<!--
    Transform: DDI Codebook 2.5 (OAI-PMH harvested) → Zenodo deposit metadata JSON (v1 API)

    Input:  DDI 2.5 <codeBook> document (namespace ddi:codebook:2_5)
    Output: JSON string conforming to Zenodo legacy deposit API /api/deposit/depositions

    Field mapping:
      DDI stdyDscr/citation/titlStmt/titl            → metadata.title
      DDI stdyDscr/citation/titlStmt/IDNo[@agency='DOI'] → metadata.doi (optional)
      DDI stdyDscr/citation/rspStmt/AuthEnty          → metadata.creators[].name + affiliation
      DDI stdyDscr/citation/prodStmt/fundAg            → metadata.grants (skipped if absent)
      DDI stdyDscr/citation/distStmt/distDate          → metadata.publication_date
      DDI stdyDscr/stdyInfo/abstract/p                 → metadata.description
      DDI stdyDscr/stdyInfo/subject/keyword            → metadata.keywords
      DDI stdyDscr/stdyInfo/subject/topcClas           → appended to keywords
      DDI stdyDscr/dataAccs/useStmt/restrctn           → metadata.notes (access note)
      DDI stdyDscr/citation/distStmt/distrbtr          → metadata.publisher (notes only)

    Defaults (when DDI field is absent or empty):
      upload_type    = "dataset"
      access_right   = "open"
      license        = "cc-by-4.0"
      publication_date = current year (YYYY-01-01 fallback)
-->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ddi="ddi:codebook:2_5"
    exclude-result-prefixes="xs ddi"
    version="3.0">

    <xsl:output method="text" omit-xml-declaration="yes" indent="no"/>

    <!-- ── entry point: handle both namespaced and bare codeBook roots ── -->
    <xsl:template match="ddi:codeBook | codeBook">
        <xsl:variable name="stdy"
            select="(ddi:stdyDscr, stdyDscr)[1]"/>
        <xsl:variable name="cit"
            select="($stdy/ddi:citation, $stdy/citation)[1]"/>
        <xsl:variable name="titlStmt"
            select="($cit/ddi:titlStmt, $cit/titlStmt)[1]"/>
        <xsl:variable name="rspStmt"
            select="($cit/ddi:rspStmt, $cit/rspStmt)[1]"/>
        <xsl:variable name="prodStmt"
            select="($cit/ddi:prodStmt, $cit/prodStmt)[1]"/>
        <xsl:variable name="distStmt"
            select="($cit/ddi:distStmt, $cit/distStmt)[1]"/>
        <xsl:variable name="stdyInfo"
            select="($stdy/ddi:stdyInfo, $stdy/stdyInfo)[1]"/>
        <xsl:variable name="subject"
            select="($stdyInfo/ddi:subject, $stdyInfo/subject)[1]"/>
        <xsl:variable name="dataAccs"
            select="($stdy/ddi:dataAccs, $stdy/dataAccs)[1]"/>

        <!-- title -->
        <xsl:variable name="title"
            select="normalize-space(($titlStmt/ddi:titl, $titlStmt/titl)[1])"/>

        <!-- DOI (optional) -->
        <xsl:variable name="doi"
            select="normalize-space(($titlStmt/ddi:IDNo[@agency='DOI'], $titlStmt/IDNo[@agency='DOI'])[1])"/>

        <!-- description: join all <p> elements inside abstract -->
        <xsl:variable name="abstract"
            select="($stdyInfo/ddi:abstract, $stdyInfo/abstract)[1]"/>
        <xsl:variable name="description">
            <xsl:for-each select="($abstract/ddi:p, $abstract/p)">
                <xsl:if test="position() &gt; 1">&#10;</xsl:if>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:for-each>
        </xsl:variable>

        <!-- publication date: prefer distDate, fall back to prodDate, then current year -->
        <xsl:variable name="rawDate"
            select="normalize-space((
                ($distStmt/ddi:distDate, $distStmt/distDate)[1]/@date,
                ($distStmt/ddi:distDate, $distStmt/distDate)[1],
                ($prodStmt/ddi:prodDate,  $prodStmt/prodDate)[1]/@date,
                ($prodStmt/ddi:prodDate,  $prodStmt/prodDate)[1]
            )[. != ''][1])"/>
        <xsl:variable name="pubDate">
            <xsl:choose>
                <!-- full ISO date -->
                <xsl:when test="matches($rawDate, '^\d{4}-\d{2}-\d{2}$')">
                    <xsl:value-of select="$rawDate"/>
                </xsl:when>
                <!-- year only -->
                <xsl:when test="matches($rawDate, '^\d{4}$')">
                    <xsl:value-of select="concat($rawDate, '-01-01')"/>
                </xsl:when>
                <!-- year-month -->
                <xsl:when test="matches($rawDate, '^\d{4}-\d{2}$')">
                    <xsl:value-of select="concat($rawDate, '-01')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat(year-from-date(current-date()), '-01-01')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- access restriction note -->
        <xsl:variable name="restriction"
            select="normalize-space(($dataAccs/ddi:useStmt/ddi:restrctn,
                                     $dataAccs/useStmt/restrctn)[1])"/>

        <!-- keywords: keyword + topcClas -->
        <xsl:variable name="kwNodes"
            select="($subject/ddi:keyword, $subject/keyword,
                     $subject/ddi:topcClas, $subject/topcClas)
                    [normalize-space(.) != '']"/>

{
  "metadata": {
    "upload_type": "dataset",
    "title": "<xsl:value-of select="replace($title, '&quot;', '\\&quot;')"/>",
    "publication_date": "<xsl:value-of select="$pubDate"/>",
    "description": "<xsl:value-of select="replace(replace(string($description), '&quot;', '\\&quot;'), '&#10;', '\n')"/>",
    "access_right": "open",
    "license": "cc-by-4.0",
    "creators": [
<xsl:for-each select="($rspStmt/ddi:AuthEnty, $rspStmt/AuthEnty)">
      <xsl:variable name="affil" select="normalize-space(@affiliation)"/>
      {
        "name": "<xsl:value-of select="replace(normalize-space(.), '&quot;', '\\&quot;')"/>"<xsl:if test="$affil != ''">,
        "affiliation": "<xsl:value-of select="replace($affil, '&quot;', '\\&quot;')"/>"</xsl:if>
      }<xsl:if test="position() != last()">,</xsl:if>
</xsl:for-each>
<xsl:if test="not(($rspStmt/ddi:AuthEnty, $rspStmt/AuthEnty))">
      { "name": "Unknown" }
</xsl:if>
    ]<xsl:if test="$kwNodes">,
    "keywords": [
<xsl:for-each select="$kwNodes">
      "<xsl:value-of select="replace(normalize-space(.), '&quot;', '\\&quot;')"/>"<xsl:if test="position() != last()">,</xsl:if>
</xsl:for-each>
    ]</xsl:if><xsl:if test="$doi != ''">,
    "doi": "<xsl:value-of select="$doi"/>"</xsl:if><xsl:if test="$restriction != ''">,
    "notes": "<xsl:value-of select="replace($restriction, '&quot;', '\\&quot;')"/>"</xsl:if>
  }
}
    </xsl:template>

    <!-- suppress stray text -->
    <xsl:template match="text()"/>

</xsl:stylesheet>
