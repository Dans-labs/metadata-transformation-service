<?xml version="1.0"?>
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
    <!-- template for the first tag -->
    <xsl:template match="map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
       
        {
        "id": "<xsl:value-of select="/map/string[@key = 'id']"/>",
        "metadata": {
        <xsl:for-each select="//map[@key='metadata']/map">
            <xsl:choose>
                <xsl:when test="(@key='interviewee')">
                    "<xsl:value-of select="@key"/>": 
                    <xsl:for-each select="./array/map">
                        {
                        <xsl:for-each select="./map">
                            <xsl:choose>
                                <xsl:when test="./array">
                                    "<xsl:value-of select="@key"/>": "<xsl:value-of select="./array/string"/>"
                                </xsl:when>
                                <xsl:otherwise>
                                    "<xsl:value-of select="@key"/>": "<xsl:value-of select="./string[@key='value']"/>"
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:if test="position() != last()">
                                <xsl:text>,</xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                        } ,
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="(@key='interviewer') or (@key='interpreter') or (@key='others') or (@key='interview_date_time') or (@key='recorded_by') 
                    or (@key='transcript_human') or (@key='grant') or (@key='subject_date_time') or (@key='relation')">
                   "<xsl:value-of select="@key"/>": [
                        <xsl:for-each select="./array/map">
                        {
                            <xsl:for-each select="./map">
                                <xsl:choose>
                                    <xsl:when test="./map">
                                        "<xsl:value-of select="@key"/>": "<xsl:value-of select="./map/string[@key='value']"/>"
                                    </xsl:when>
                                    <xsl:when test="./array">
                                        "<xsl:value-of select="@key"/>": "<xsl:value-of select="./array/string"/>"
                                    </xsl:when>
                                    <xsl:otherwise>
                                        "<xsl:value-of select="@key"/>": "<xsl:value-of select="./string[@key='value']"/>"
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:if test="position() != last()">
                                    <xsl:text>,</xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        } <xsl:if test="position() != last()">
                            <xsl:text>,</xsl:text>
                        </xsl:if>
                        <xsl:if test="position() = last()">
                            <xsl:text>],</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="(@key = 'interview_location') or (@key='subject_location')">
                     "<xsl:value-of select="@key"/>": [
                    <xsl:for-each select="./array/map">
                        
                        {
                        "label": "<xsl:value-of select="./string[@key='label']/text()"/>",
                        "value": "<xsl:value-of select="./string[@key='value']/text()"/>",
                        "coordinates": [
                        <xsl:for-each select="./array/number">"<xsl:value-of select="."/>"<xsl:if test="position() != last()">
                                <xsl:text>,</xsl:text>
                        </xsl:if></xsl:for-each>
                      ]
                            
                        } <xsl:if test="position() != last()">
                            <xsl:text>,</xsl:text>
                        </xsl:if>
                        <xsl:if test="position() = last()">
                            <xsl:text>],</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="(@key='recording_format') or (@key='subject_keywords') or (@key='audience') or (@key='collections') or (@key='language_interview') ">
                    "<xsl:value-of select="@key"/>": [
                    <xsl:for-each select="./array/map">
                        
                        {
                        "label": "<xsl:value-of select="./string[@key='label']/text()"/>",
                        "value": "<xsl:value-of select="./string[@key='value']/text()"/>"
                        
                        
                        
                        } <xsl:if test="position() != last()">
                            <xsl:text>,</xsl:text>
                        </xsl:if>
                        <xsl:if test="position() = last()">
                            <xsl:text>],</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="(@key='recording_equipment') or (@key='title') or (@key='subtitle') or (@key='description')  or (@key='contact_email') or (@key='personal_data')">
                    "<xsl:value-of select="@key"/>":"<xsl:value-of select="./string"/>", 
                </xsl:when>
                <xsl:when test="(@key = 'publisher')  or (@key='language_metadata') or (@key='rightsholder') or (@key='licence_type') ">
                    "<xsl:value-of select="@key"/>": {
                    <xsl:for-each select="./map/string">
                        "<xsl:value-of select="@key"/>": "<xsl:value-of select="text()"/>"
                        <xsl:if test="position() != last()">
                            <xsl:text>,</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    } ,
                </xsl:when>
                <xsl:when test="(@key='author')">
                    "<xsl:value-of select="@key"/>": [
                    <xsl:for-each select="./array/map">{
                        <xsl:for-each select="./map">
                            "<xsl:value-of select="@key"/>":
                            <xsl:if test="@key='name'">{
                            <xsl:for-each select="./map/string">
                                "<xsl:value-of select="./@key"/>":"<xsl:value-of select="./text()"/>"
                                <xsl:if test="position() != last()">
                                    <xsl:text>,</xsl:text>
                                </xsl:if>
                                <xsl:if test="position() = last()">
                                    <xsl:text>},</xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                            </xsl:if>
                            <xsl:if test="@key='affiliation'">
                            "<xsl:value-of select="./string"/>"
                            </xsl:if>
                        </xsl:for-each>
                        } <xsl:if test="position() != last()">
                            <xsl:text>,</xsl:text>
                        </xsl:if>
                        <xsl:if test="position() = last()">
                            <xsl:text>],</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:when>
            </xsl:choose>
            
           
        </xsl:for-each>
        
        "file-metadata": [
        {
        "name": "- kepmendiknas_105O2000.pdf",
        "lastModified": 1737470181556,
        "private": true,
        "role": {
        "value": "data_dictionary_other",
        "label": "Data dictionary - other"
        },
        "embargo": "2025-03-31"
        }
        ]
        }
        }
    </xsl:template>
</xsl:stylesheet>
