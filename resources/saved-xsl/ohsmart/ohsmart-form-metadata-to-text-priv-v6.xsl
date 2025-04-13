<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs math" version="3.0">
    <xsl:output method="text" indent="yes" omit-xml-declaration="yes"/>
    <xsl:template match="data">
        <xsl:apply-templates select="json-to-xml(.)"/>
    </xsl:template>
    <xsl:template match="/map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:variable name="currentDateTime" select="current-dateTime()" />
        <xsl:variable name="cdt">
            <xsl:value-of select="format-dateTime($currentDateTime, '[Y0001][M01][D01][H01][m01][s01]')" />
        </xsl:variable>
        <!-- Extract the ID -->
        <xsl:text>id=</xsl:text>
        <xsl:value-of select="concat(./string[@key='id'],'-', $cdt)" />
        <xsl:text>&#10;</xsl:text>
        
        <!-- Process metadata -->
        <xsl:for-each select="./map[@key='metadata']/map">
            <xsl:variable name="entity" select="@key" />
            <xsl:for-each select="array[@key='value']/map/map[boolean[@key='private']='true']">
                <xsl:variable name="key" select="@key" />
                <xsl:choose>
                    <!-- Handle string values -->
                    <xsl:when test="string[@key='value']">
                        <xsl:text>ohs.metadata.</xsl:text>
                        <xsl:value-of select="$entity" />
                        <xsl:text>.</xsl:text>
                        <xsl:value-of select="$key" />
                        <xsl:text>=</xsl:text>
                        <xsl:value-of select="string[@key='value']" />
                        <xsl:text>&#10;</xsl:text>
                    </xsl:when>
                    <!-- Handle array values -->
                    <xsl:when test="array[@key='value']">
                        <xsl:for-each select="array[@key='value']/string">
                            <xsl:text>ohs.metadata.</xsl:text>
                            <xsl:value-of select="$entity" />
                            <xsl:text>.</xsl:text>
                            <xsl:value-of select="$key" />
                            <xsl:text>=</xsl:text>
                            <xsl:value-of select="." />
                            <xsl:text>&#10;</xsl:text>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>