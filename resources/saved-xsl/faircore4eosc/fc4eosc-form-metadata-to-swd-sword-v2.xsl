<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs math" version="3.0">
    <xsl:output indent="yes" omit-xml-declaration="no"/>
    <xsl:template match="data">
        <!-- create a new root tag -->
        <!-- apply the xml structure generated from JSON -->
        <xsl:apply-templates select="json-to-xml(.)"/>
    </xsl:template>
    <!-- template for the first tag -->
    <xsl:template match="/map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <entry xmlns="http://www.w3.org/2005/Atom"
            xmlns:codemeta="https://doi.org/10.5063/SCHEMA/CODEMETA-2.0"
            xmlns:schema="http://schema.org/"
            xmlns:swh="https://www.softwareheritage.org/schema/2018/deposit">
            <title><xsl:value-of select="//map[@key='metadata']/map[@key='title']/string[@key='value']/."/></title>
            <id><xsl:value-of
                select="replace(//string[@key = 'doi'], 'doi:', '')"/></id>
            <author>
                <name><xsl:value-of select="//map[@key='metadata']/map[@key='author']/string[@key='value']" /></name>
                <email><xsl:value-of select="//map[@key='metadata']/map[@key='contact_email']/string[@key='value']/." /></email>
            </author>
            <codemeta:name><xsl:value-of select="//map[@key='metadata']/map[@key='title']/string[@key='value']/."/></codemeta:name>
            <codemeta:url><xsl:value-of select="//map[@key='metadata']/map[@key='repository_url']/string[@key='value']/."/></codemeta:url>
            <codemeta:description><xsl:value-of select="//map[@key='metadata']/map[@key='description']/string[@key='value']/." /></codemeta:description>
            <codemeta:identifier>https://doi.org/<xsl:value-of
                    select="replace(//string[@key = 'doi'], 'doi:', '')"/></codemeta:identifier>
       	<codemeta:author>
       	    <codemeta:name><xsl:value-of select="//map[@key='metadata']/map[@key='software_author']/string[@key='value']" /></codemeta:name>
           </codemeta:author>
            <xsl:for-each select="//map[@key='metadata']/map[@key='additional_authors']/array/map">
                <xsl:if test="./map[@key='additional_author_type']/map/string[@key='value']='Software author'">
                <codemeta:author>
                    <codemeta:name><xsl:value-of select="./map[@key='additional_author']/string"/></codemeta:name>
                </codemeta:author>
                </xsl:if>
            </xsl:for-each>
            <codemeta:applicationCategory>test</codemeta:applicationCategory>
            <swh:deposit>
                <swh:reference>
                    <swh:object>
                        <xsl:attribute name="swhid"><xsl:value-of select="//string[@key = 'swh-staging-api']/."/></xsl:attribute>
                    </swh:object>
                </swh:reference>
                <swh:metadata-provenance>
                    <schema:url>https://dans.knaw.nl/<xsl:value-of select="//string[@key = 'swh-staging-api']/."/></schema:url>
                </swh:metadata-provenance>
            </swh:deposit>
        </entry>
    </xsl:template>
    <!-- template to output a number value -->
</xsl:stylesheet>

