<?xml version="1.0"?>
<xsl:stylesheet xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs math" version="3.0">
    <xsl:output method="text" indent="yes" omit-xml-declaration="yes"/>
    <xsl:import href="./ohsmart-form-metadata-to-DV-commons.xsl"/>
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
                <xsl:when test="(@key='interviewee') and (string-length(./array/map/map[@key='interviewee_public']/array) != 0 )">
                    "<xsl:value-of select="@key"/>": 
                    <xsl:for-each select="./array/map">
                        {
                        <xsl:for-each select="./map">
                            <xsl:if test="@key='interviewee_first_name' or  @key='interviewee_last_name' ">
                            <xsl:choose>
                                <xsl:when test="./array">
                                    "<xsl:value-of select="@key"/>": "<xsl:value-of select="./array/string"/>"
                                </xsl:when>
                                <xsl:otherwise>
                                    "<xsl:value-of select="@key"/>": "<xsl:value-of select="./string[@key='value']"/>"
                                </xsl:otherwise>
                            </xsl:choose>
                                <xsl:if test="@key='interviewee_first_name'">
                                <xsl:text>,</xsl:text>
                            </xsl:if>
                            </xsl:if>
                        </xsl:for-each>
                        } ,
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="(@key='interview_date_time') or (@key='recorded_by') 
                    or (@key='grant') or (@key='subject_date_time') or (@key='relation')">
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
                <xsl:when test="(@key='transcript_machine') or (@key='recording_equipment') or (@key='title') or (@key='subtitle') or (@key='description')  or (@key='contact_email') or (@key='personal_data')">
                    "<xsl:value-of select="@key"/>":"<xsl:value-of select="./string"/>", 
                </xsl:when>
                <xsl:when test="(@key = 'publisher')  or (@key='language_metadata') or (@key='rightsholder') or (@key='licence_type') ">
                    "<xsl:value-of select="@key"/>": {
                    <xsl:for-each select="./map/string">
                        <xsl:variable name="escapedText">
                            <xsl:call-template name="escape-json">
                                <xsl:with-param name="text" select="text()"/>
                            </xsl:call-template>
                        </xsl:variable>
                        "<xsl:value-of select="@key"/>": "<xsl:value-of select="$escapedText"/>"
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
        <xsl:text>"file-metadata": [ </xsl:text>
        <xsl:for-each select="//array[@key = 'file-metadata']/map[boolean[@key = 'private' and text() = 'false']]">
            <xsl:text>{ "name": "</xsl:text>
            <xsl:value-of select="string[@key = 'name']"/>
            <xsl:text>", </xsl:text>
            <xsl:if test="./number[@key = 'lastModified']">
                <xsl:text>"lastModified": </xsl:text>
                <xsl:value-of select="number[@key = 'lastModified']"/>
                <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:text>"private": </xsl:text>
            <xsl:value-of select="boolean[@key = 'private']"/>
            <xsl:if test="map[@key = 'role']">
                <xsl:text>, "role": { "label": "</xsl:text>
                <xsl:value-of select="map[@key = 'role']/string[@key = 'label']"/>
                <xsl:text>", "value": "</xsl:text>
                <xsl:value-of select="map[@key = 'role']/string[@key = 'value']"/>
                <xsl:text>" }</xsl:text>
            </xsl:if>
            <xsl:if test="string[@key = 'embargo']">
                <xsl:text>, "embargo": "</xsl:text>
                <xsl:value-of select="string[@key = 'embargo']"/>
                <xsl:text>"</xsl:text>
            </xsl:if>
            <xsl:if test="string[@key = 'mimetype']">
                <xsl:text>, "mimetype": "</xsl:text>
                <xsl:value-of select="string[@key = 'mimetype']"/>
                <xsl:text>"</xsl:text>
            </xsl:if>
            <xsl:if test="number[@key = 'size']">
                <xsl:text>, "size": </xsl:text>
                <xsl:value-of select="number[@key = 'size']"/>
            </xsl:if>
            <xsl:if test="string[@key = 'state']">
                <xsl:text>, "state": "</xsl:text>
                <xsl:value-of select="string[@key = 'state']"/>
                <xsl:text>"</xsl:text>
            </xsl:if>
            <xsl:text>}</xsl:text>
            <xsl:if test="position() != last()">
                <xsl:text>, </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>] } </xsl:text>
        }
       
    </xsl:template>
</xsl:stylesheet>
