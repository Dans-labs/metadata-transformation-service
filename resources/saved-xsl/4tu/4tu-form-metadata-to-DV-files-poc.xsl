<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs math" version="3.0">
    <xsl:output indent="yes" omit-xml-declaration="yes"/>

    <xsl:template match="data">
        <!-- create a new root tag -->

        <!-- apply the xml structure generated from JSON -->
        <xsl:apply-templates select="json-to-xml(.)"/>

    </xsl:template>

    <!-- template for the first tag -->
    <xsl:template match="/map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions"> 
      {
      <xsl:for-each select="/map/array[@key='file-metadata']/map">
        "<xsl:value-of select="./string[@key='name']"/>":
        {
        "description": "<xsl:if test="./map[@key='role']">Role: <xsl:value-of select="./map/string[@key='label']"/></xsl:if>",
        "directoryLabel": "",
        "categories": [],
        <xsl:if test="./boolean[@key='private']='true'">
        "restrict": "true",
        </xsl:if>
        <xsl:if test="./boolean[@key='private']='false'">
        "restrict": "false",
        </xsl:if>
        <xsl:if test="./string[@key='embargo']">
         "embargo": "<xsl:value-of select="./string[@key='embargo']"/>",
        </xsl:if>
        "tabIngest": "false"
        }
        <xsl:if test="position() != last()">
          <xsl:text>,</xsl:text>
        </xsl:if>
      </xsl:for-each>
      }
    </xsl:template>

</xsl:stylesheet>
