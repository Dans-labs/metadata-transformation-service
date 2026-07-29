<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    version="1.0">

    <xsl:output method="text" omit-xml-declaration="yes" indent="no"/>

    <xsl:template match="/">
        <xsl:variable name="doi" select="normalize-space((//dc:identifier)[1])"/>
        <xsl:text>{"doi":"</xsl:text>
        <xsl:value-of select="$doi"/>
        <xsl:text>"}</xsl:text>
    </xsl:template>
</xsl:stylesheet>
