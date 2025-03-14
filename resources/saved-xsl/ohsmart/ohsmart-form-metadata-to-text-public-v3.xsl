<?xml version="1.0"?>
<xsl:stylesheet xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:id-type="http://easy.dans.knaw.nl/schemas/vocab/identifier-type/"
    exclude-result-prefixes="xs math" version="3.0">
    <xsl:output method="text" indent="yes" omit-xml-declaration="yes"/>
    <xsl:template match="data">
        <xsl:apply-templates select="json-to-xml(.)"/>
    </xsl:template>
    <xsl:template match="map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:text>id=</xsl:text>
        <xsl:value-of select="/map/string[@key = 'id']"/><xsl:text>&#10;</xsl:text>
        <xsl:for-each select="//map[@key = 'metadata']/map/array/map/map">
            <xsl:variable name="Section" select="'ohs'"/>
            <xsl:if test="./boolean[@key='private' and text()='false']">
<!--                <xsl:message><xsl:value-of select="../../../@key"/>.<xsl:value-of select="@key"/>=<xsl:value-of select="./string[@key='value']"/></xsl:message>-->
                <xsl:choose>
                    <xsl:when test="./array[@key='value']/string">
                        <xsl:value-of select="$Section"/>.<xsl:value-of select="../../../@key"/>.<xsl:value-of select="@key"/>=<xsl:value-of select="./array[@key='value']/string"/><xsl:text>&#10;</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="string-length(./string[@key='value'])>0">
                            <xsl:value-of select="$Section"/>.<xsl:value-of select="../../../@key"/>.<xsl:value-of select="@key"/>=<xsl:value-of select="./string[@key='value']"/><xsl:text>&#10;</xsl:text>
                        </xsl:if>

                    </xsl:otherwise>
                </xsl:choose>

            </xsl:if>
            <!--<xsl:if test="./array[@key='value']/string">
                <xsl:message>-\-\-<xsl:value-of select="../../../@key"/>.<xsl:value-of select="@key"/>=<xsl:value-of select="./array[@key='value']/string"/></xsl:message>
                <xsl:value-of select="../../../@key"/>.<xsl:value-of select="@key"/>=<xsl:value-of select="./array[@key='value']/string"/><xsl:text>&#10;</xsl:text>
            </xsl:if>-->
        </xsl:for-each>
        <xsl:variable name="FileMetadata">file-metadata</xsl:variable>
        <xsl:for-each select="//array[@key = 'file-metadata']/map">
            <xsl:variable name="isExcluded"
                select="boolean(boolean[@key = 'private' and text() = 'true'])"/>
            <xsl:choose>
                <xsl:when test="$isExcluded">
                    <xsl:text/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:value-of select="$FileMetadata"/>
                    <xsl:text>.name=</xsl:text>
                    <xsl:value-of select="string[@key = 'name']"/>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:value-of select="$FileMetadata"/>
                    <xsl:text>.lastModified=</xsl:text>
                    <xsl:value-of select="number[@key = 'lastModified']"/>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:value-of select="$FileMetadata"/>
                    <xsl:text>.private=</xsl:text>
                    <xsl:value-of select="boolean[@key = 'private']"/>
                    <xsl:choose>
                        <xsl:when test="map[@key = 'role']">
                            <xsl:text>&#10;</xsl:text>
                            <xsl:value-of select="$FileMetadata"/>
                            <xsl:text>.role.label=</xsl:text>
                            <xsl:value-of select="map[@key = 'role']/string[@key = 'label']"/>
                            <xsl:text>&#10;</xsl:text>
                            <xsl:value-of select="$FileMetadata"/>
                            <xsl:text>.role.value=</xsl:text>
                            <xsl:value-of select="map[@key = 'role']/string[@key = 'value']"/>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="array[@key = 'process']">
                            <xsl:for-each select="array[@key = 'process']/map">
                                <xsl:text>&#10;</xsl:text>
                                <xsl:value-of select="$FileMetadata"/>
                                <xsl:text>.process.label=</xsl:text>
                                <xsl:value-of select="string[@key = 'label']"/>
                                <xsl:text>&#10;</xsl:text>
                                <xsl:value-of select="$FileMetadata"/>
                                <xsl:text>.process.value=</xsl:text>
                                <xsl:value-of select="string[@key = 'value']"/>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>