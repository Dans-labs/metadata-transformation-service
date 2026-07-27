<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:j="http://www.w3.org/2005/xpath-functions"
    version="3.0"
    exclude-result-prefixes="xs j">

    <xsl:output method="text" omit-xml-declaration="yes" indent="no"/>

    <xsl:template match="data">
        <xsl:apply-templates select="json-to-xml(.)"/>
    </xsl:template>

    <xsl:template match="/j:map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:variable name="sourceRoot" select="(map[@key='metadata'][1], .)[1]"/>
        <xsl:variable name="citationFields" select="$sourceRoot/map[@key='datasetVersion']/map[@key='metadataBlocks']/map[@key='citation']/array[@key='fields']/map"/>
        <xsl:variable name="title" select="normalize-space(($citationFields[string[@key='typeName']='title']/string[@key='value'])[1])"/>
        <xsl:variable name="safeTitle" select="if ($title != '') then $title else 'Untitled dataset from Dataverse'"/>

        <xsl:variable name="distributionDate" select="normalize-space(($citationFields[string[@key='typeName']='distributionDate']/string[@key='value'])[1])"/>
        <xsl:variable name="topPublicationDate" select="normalize-space($sourceRoot/string[@key='publicationDate'])"/>
        <xsl:variable name="rawDate" select="($distributionDate, $topPublicationDate)[. != ''][1]"/>
        <xsl:variable name="pubDate">
            <xsl:choose>
                <xsl:when test="matches($rawDate, '^\d{4}-\d{2}-\d{2}$')">
                    <xsl:value-of select="$rawDate"/>
                </xsl:when>
                <xsl:when test="matches($rawDate, '^\d{4}$')">
                    <xsl:value-of select="concat($rawDate, '-01-01')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat(year-from-date(current-date()), '-01-01')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="descNode" select="$citationFields[string[@key='typeName']='dsDescription']/array[@key='value']/map[1]/map[@key='dsDescriptionValue']/string[@key='value']"/>
        <xsl:variable name="description" select="normalize-space(($descNode, 'Imported from OAI-PMH dataverse_json')[1])"/>

        <xsl:variable name="authorValues" select="$citationFields[string[@key='typeName']='author']/array[@key='value']/map"/>
        <xsl:variable name="subjectValues" select="$citationFields[string[@key='typeName']='subject']/array[@key='value']/(string|map/string[@key='value'])[normalize-space(.) != '']"/>

        <xsl:variable name="payload" as="element(j:map)">
            <j:map>
                <j:map key="metadata">
                    <j:string key="upload_type">dataset</j:string>
                    <j:string key="title"><xsl:value-of select="$safeTitle"/></j:string>
                    <j:string key="publication_date"><xsl:value-of select="$pubDate"/></j:string>
                    <j:string key="description"><xsl:value-of select="$description"/></j:string>
                    <j:string key="access_right">open</j:string>
                    <j:string key="license">cc-by-4.0</j:string>
                    <j:array key="communities">
                        <j:map>
                            <j:string key="identifier">rda</j:string>
                        </j:map>
                    </j:array>
                    <j:array key="creators">
                        <xsl:choose>
                            <xsl:when test="count($authorValues) &gt; 0">
                                <xsl:for-each select="$authorValues">
                                    <xsl:variable name="name" select="normalize-space(map[@key='authorName']/string[@key='value'])"/>
                                    <xsl:variable name="affiliation" select="normalize-space(map[@key='authorAffiliation']/string[@key='value'])"/>
                                    <j:map>
                                        <j:string key="name"><xsl:value-of select="if ($name != '') then $name else 'Unknown'"/></j:string>
                                        <xsl:if test="$affiliation != ''">
                                            <j:string key="affiliation"><xsl:value-of select="$affiliation"/></j:string>
                                        </xsl:if>
                                    </j:map>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <j:map>
                                    <j:string key="name">Unknown</j:string>
                                </j:map>
                            </xsl:otherwise>
                        </xsl:choose>
                    </j:array>
                    <xsl:if test="count($subjectValues) &gt; 0">
                        <j:array key="keywords">
                            <xsl:for-each select="$subjectValues">
                                <j:string><xsl:value-of select="normalize-space(.)"/></j:string>
                            </xsl:for-each>
                        </j:array>
                    </xsl:if>
                </j:map>
            </j:map>
        </xsl:variable>

        <xsl:value-of select="xml-to-json($payload)"/>
    </xsl:template>
</xsl:stylesheet>
