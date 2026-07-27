<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs math" version="3.0">
    <xsl:output indent="yes" omit-xml-declaration="yes" method="text"/>
    
    <!-- Helper template to convert date format from DD-MM-YYYY to YYYY-MM-DD -->
    <xsl:template name="convert-date">
        <xsl:param name="date"/>
        <xsl:variable name="day" select="substring($date, 1, 2)"/>
        <xsl:variable name="month" select="substring($date, 4, 2)"/>
        <xsl:variable name="year" select="substring($date, 7, 4)"/>
        <xsl:value-of select="concat($year, '-', $month, '-', $day)"/>
    </xsl:template>
    
    <xsl:template match="data">
        <xsl:apply-templates select="json-to-xml(.)" />
    </xsl:template>
    
    <xsl:template match="/map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        {
        "metadata": {
        "creators": [
        {
        "name": "<xsl:value-of select="map[@key='metadata']/map[@key='depositor']/string[@key='value']"/>"
        }
        ],
        "language": "<xsl:value-of select="map[@key='metadata']/map[@key='language']/map[@key='value']/string[@key='value']"/>",
        <xsl:if test="map[@key='metadata']/map[@key='doi']/string[@key='value']!=''">"doi":"<xsl:value-of select="map[@key='metadata']/map[@key='doi']/string[@key='value']"/>",</xsl:if>
        "imprint_publisher": "<xsl:value-of select="map[@key='metadata']/map[@key='publisher']/map[@key='value']/string[@key='label']"/>",
        "communities": [{"identifier": "<xsl:value-of select="map[@key='metadata']/map[@key='zenodoCommunity']/map[@key='value']/string[@key='value']"/>"}],
        "title": "<xsl:value-of select="map[@key='metadata']/map[@key='title']/string[@key='value']"/>",
        <xsl:if test="map[@key='metadata']/map[@key='version']/string[@key='value'] != ''">"version": "<xsl:value-of select="map[@key='metadata']/map[@key='version']/string[@key='value']"/>",
        </xsl:if>"publication_date": "<xsl:call-template name="convert-date"><xsl:with-param name="date" select="map[@key='metadata']/map[@key='publicationDate']/string[@key='value']"/></xsl:call-template>",
        "description": "<xsl:value-of select="map[@key='metadata']/map[@key='description']/string[@key='value']"/>",
        "contributors": [
        <xsl:if test="map[@key='metadata']/map[@key='firstAuthor']/map[@key='value']/string[@key='label'] != ''">
            {
            "name": "<xsl:value-of select="map[@key='metadata']/map[@key='firstAuthor']/map[@key='value']/string[@key='label']"/>",
            <xsl:if test="map[@key='metadata']/map[@key='firstAuthor']/map[@key='value']/string[@key='id'] != ''">"orcid": "<xsl:value-of select="map[@key='metadata']/map[@key='firstAuthor']/map[@key='value']/string[@key='id']"/>",
            </xsl:if>"type": "Editor"
            }<xsl:if test="map[@key='metadata']/map[@key='contributors']/array[@key='value']/map[map[@key='contributor']/map[@key='value']/string[@key='label'] != ''] or map[@key='metadata']/map[@key='rightsholders']/array[@key='value']/map[map[@key='rightsholder']/map[@key='value']/string[@key='label'] != '']">,</xsl:if>
        </xsl:if>
        <xsl:for-each select="map[@key='metadata']/map[@key='contributors']/array[@key='value']/map[map[@key='contributor']/map[@key='value']/string[@key='label'] != '']">
            {
            "name": "<xsl:value-of select="map[@key='contributor']/map[@key='value']/string[@key='label']"/>",
            <xsl:if test="map[@key='contributor']/map[@key='value']/string[@key='id'] != ''">"orcid": "<xsl:value-of select="map[@key='contributor']/map[@key='value']/string[@key='id']"/>",
            </xsl:if>"type": "<xsl:value-of select="if (map[@key='contributorType']/map[@key='value']/string[@key='value'] = 'Author') then 'Editor' else map[@key='contributorType']/map[@key='value']/string[@key='value']"/>"
            }<xsl:if test="position() != last() or ancestor::map/map[@key='metadata']/map[@key='rightsholders']/array[@key='value']/map[map[@key='rightsholder']/map[@key='value']/string[@key='label'] != '']">,</xsl:if>
        </xsl:for-each>
        <xsl:for-each select="map[@key='metadata']/map[@key='rightsholders']/array[@key='value']/map[map[@key='rightsholder']/map[@key='value']/string[@key='label'] != '']">
            {
            "name": "<xsl:value-of select="map[@key='rightsholder']/map[@key='value']/string[@key='label']"/>",
            <xsl:if test="map[@key='rightsholder']/map[@key='value']/string[@key='id'] != ''">"orcid": "<xsl:value-of select="map[@key='rightsholder']/map[@key='value']/string[@key='id']"/>",
            </xsl:if>"type": "RightsHolder"
            }<xsl:if test="position() != last()">,</xsl:if>
        </xsl:for-each>
        ],
        "keywords": [
        <xsl:variable name="vocabKeywords" select="(map[@key='metadata']/map[@key='keywordsDomain']/array[@key='value']/map,
            map[@key='metadata']/map[@key='keywordsPathways']/array[@key='value']/map,
            map[@key='metadata']/map[@key='keywordsGorc']/array[@key='value']/map,
            map[@key='metadata']/map[@key='keywordsSdg']/array[@key='value']/map)"/>
        <xsl:variable name="otherKw" select="map[@key='metadata']/map[@key='otherKeywords']/array[@key='value']/map[string[@key='value'] != '']"/>
        <xsl:for-each select="$vocabKeywords">
            "<xsl:value-of select="string[@key='label']"/>"<xsl:if test="position() != last() or $otherKw">,</xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$otherKw">
            "<xsl:value-of select="string[@key='value']"/>"<xsl:if test="position() != last()">,</xsl:if>
        </xsl:for-each>
        ],
        "related_identifiers": [
        <xsl:for-each select="map[@key='metadata']/map[@key='relatedWorks']/array[@key='value']/map[map[@key='relationIdentifier']/string[@key='value'] != '']">
            {
            "relation": "<xsl:value-of select="map[@key='relationType']/map[@key='value']/string[@key='value']"/>",
            "identifier": "<xsl:value-of select="map[@key='relationIdentifier']/string[@key='value']"/>",
            "resource_type": "<xsl:value-of select="map[@key='relationResourceType']/map[@key='value']/string[@key='value']"/>"
            }<xsl:if test="position() != last()">,</xsl:if>
        </xsl:for-each>
        ],
        "access_right": "<xsl:value-of select="map[@key='metadata']/map[@key='accessTypes']/map[@key='value']/string[@key='value']"/>",
        "license": "<xsl:value-of select="lower-case(map[@key='metadata']/map[@key='licence']/map[@key='value']/string[@key='id'])"/>",
        "upload_type": "<xsl:value-of select="if (contains(map[@key='metadata']/map[@key='resourceType']/map[@key='value']/string[@key='value'], '-')) then substring-before(map[@key='metadata']/map[@key='resourceType']/map[@key='value']/string[@key='value'], '-') else map[@key='metadata']/map[@key='resourceType']/map[@key='value']/string[@key='value']"/>"<xsl:if test="contains(map[@key='metadata']/map[@key='resourceType']/map[@key='value']/string[@key='value'], '-')">,
            "publication_type": "<xsl:value-of select="substring-after(map[@key='metadata']/map[@key='resourceType']/map[@key='value']/string[@key='value'], '-')"/>"</xsl:if>
        }
        }
    </xsl:template>
</xsl:stylesheet>
