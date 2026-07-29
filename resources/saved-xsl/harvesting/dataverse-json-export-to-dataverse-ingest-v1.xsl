<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:j="http://www.w3.org/2005/xpath-functions"
    xmlns:m="urn:acp:mts:dataverse-json"
    version="3.0"
    exclude-result-prefixes="xs j m">

    <xsl:output method="text" omit-xml-declaration="yes" indent="no"/>

    <xsl:function name="m:license-code" as="xs:string">
        <xsl:param name="licenseText" as="xs:string?"/>
        <xsl:variable name="text" select="lower-case(normalize-space($licenseText))"/>
        <xsl:choose>
            <xsl:when test="contains($text, 'cc by-nc-nd 4.0')">cc-by-nc-nd-4.0</xsl:when>
            <xsl:when test="contains($text, 'cc by-nc-sa 4.0')">cc-by-nc-sa-4.0</xsl:when>
            <xsl:when test="contains($text, 'cc by-nc 4.0')">cc-by-nc-4.0</xsl:when>
            <xsl:when test="contains($text, 'cc by-nd 4.0')">cc-by-nd-4.0</xsl:when>
            <xsl:when test="contains($text, 'cc by-sa 4.0')">cc-by-sa-4.0</xsl:when>
            <xsl:when test="contains($text, 'cc by 4.0')">cc-by-4.0</xsl:when>
            <xsl:when test="contains($text, 'cc0 1.0')">cc0-1.0</xsl:when>
            <xsl:otherwise>cc-by-4.0</xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="m:first-non-empty" as="xs:string">
        <xsl:param name="values" as="item()*"/>
        <xsl:sequence select="normalize-space(string(($values[normalize-space(string(.)) != ''], '')[1]))"/>
    </xsl:function>

    <xsl:template match="data">
        <xsl:apply-templates select="json-to-xml(.)"/>
    </xsl:template>

    <xsl:template match="/j:map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:variable name="sourceRoot" select="(map[@key='metadata'][1], .)[1]"/>
        <xsl:variable name="datasetVersion" select="$sourceRoot/map[@key='datasetVersion'][1]"/>
        <xsl:variable name="metadataBlocks" select="$datasetVersion/map[@key='metadataBlocks'][1]"/>
        <xsl:variable name="termsOfUse" select="normalize-space($datasetVersion/string[@key='termsOfUse'])"/>
        <xsl:variable name="fileAccessRequestNode" select="($datasetVersion/boolean[@key='fileAccessRequest'], $datasetVersion/string[@key='fileAccessRequest'])[1]"/>
        <xsl:variable name="licenseFromSource" select="
            m:first-non-empty((
                $datasetVersion/map[@key='license']/string[@key='rightsIdentifier'],
                $datasetVersion/map[@key='license']/string[@key='name'],
                $datasetVersion/map[@key='license']/string[@key='value'],
                $sourceRoot/string[@key='license']
            ))
        "/>
        <xsl:variable name="license" select="
            if ($licenseFromSource != '') then $licenseFromSource
            else m:license-code($termsOfUse)
        "/>

        <xsl:variable name="payload" as="element(j:map)">
            <j:map>
                <j:string key="license"><xsl:value-of select="$license"/></j:string>
                <xsl:if test="$termsOfUse != ''">
                    <j:string key="termsOfAccess"><xsl:value-of select="$termsOfUse"/></j:string>
                </xsl:if>
                <j:boolean key="fileAccessRequest">
                    <xsl:value-of select="if (lower-case(normalize-space(string($fileAccessRequestNode))) = 'true') then 'true' else 'false'"/>
                </j:boolean>
                <j:map key="metadataBlocks">
                    <xsl:copy-of select="$metadataBlocks/*"/>
                </j:map>
            </j:map>
        </xsl:variable>

        <xsl:value-of select="xml-to-json($payload)"/>
    </xsl:template>
</xsl:stylesheet>
