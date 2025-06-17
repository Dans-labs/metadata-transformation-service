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
                <xsl:when test="@key='interviewee'">
                    "<xsl:value-of select="@key"/>": 
                    <xsl:for-each select="./array/map">
                        {
                        <xsl:for-each select="./map">
                            <xsl:choose>
                                <xsl:when test="./array">
                                    "<xsl:value-of select="@key"/>": "<xsl:value-of select="./array/string"/>"
                                    <xsl:if test="@key='interviewee_public'">,</xsl:if>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test=" (@key='interviewee_first_name' or  @key='interviewee_last_name') ">
                                            <xsl:if test="(string-length(./following-sibling::map[@key='interviewee_public']/array/string) = 0)">
                                                "<xsl:value-of select="@key"/>": "<xsl:value-of select="./string[@key='value']"/>",
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            "<xsl:value-of select="@key"/>": "<xsl:value-of select="./string[@key='value']"/>"
                                            <xsl:if test="position() != last()">
                                                <xsl:text>,</xsl:text>
                                            </xsl:if>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                   
                                </xsl:otherwise>
                            </xsl:choose>
                            
                        </xsl:for-each>
                        } ,
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="(@key='interviewer')">
                    "<xsl:value-of select="@key"/>": [
                    <xsl:for-each select="./array/map">
                        {
                        <xsl:for-each select="./map">
                            <xsl:choose>
                                <xsl:when test="./array">
                                    "<xsl:value-of select="@key"/>": "<xsl:value-of select="./array/string"/>"
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test=" (@key='interviewer_first_name' or  @key='interviewer_last_name')">
                                            <xsl:if test="(string-length(./following-sibling::map[@key='interviewer_public']/array/string) = 0)">
                                                "<xsl:value-of select="@key"/>": "<xsl:value-of select="./string[@key='value']"/>"
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            "<xsl:value-of select="@key"/>": "<xsl:value-of select="./string[@key='value']"/>"
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:if test="(position() != last()) and (string-length(./following-sibling::map[@key='interviewer_public']/array/string) = 0)">
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
                <xsl:when test="(@key='interpreter')">
                    "<xsl:value-of select="@key"/>": [
                    <xsl:for-each select="./array/map">
                        {
                        <xsl:for-each select="./map">
                            <xsl:choose>
                                <xsl:when test="./array">
                                    "<xsl:value-of select="@key"/>": "<xsl:value-of select="./array/string"/>"
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test=" (@key='interpreter_first_name' or  @key='interpreter_last_name')">
                                             <xsl:if test="(string-length(./following-sibling::map[@key='interpreter_public']/array/string) = 0)">
                                                "<xsl:value-of select="@key"/>": "<xsl:value-of select="./string[@key='value']"/>"
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            "<xsl:value-of select="@key"/>": "<xsl:value-of select="./string[@key='value']"/>"
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:if test="(position() != last()) and (string-length(./following-sibling::map[@key='interpreter_public']/array/string) = 0)">
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
                <xsl:when test="(@key='others')">
                    "<xsl:value-of select="@key"/>": [
                    <xsl:for-each select="./array/map">
                            {
                            <xsl:for-each select="./map">
                                    <xsl:choose>
                                        <xsl:when test="./array">
                                            "<xsl:value-of select="@key"/>": "<xsl:value-of select="./array/string"/>"
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test=" (@key='others_first_name' or  @key='others_last_name')">
                                                    <xsl:if test="(string-length(./following-sibling::map[@key='others_public']/array/string) = 0)">
                                                      "<xsl:value-of select="@key"/>": "<xsl:value-of select="./string[@key='value']"/>"
                                                    </xsl:if>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    "<xsl:value-of select="@key"/>": "<xsl:value-of select="./string[@key='value']"/>"
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                <xsl:if test="(position() != last()) and (string-length(./following-sibling::map[@key='others_public']/array/string) = 0)">
                                    <xsl:text>,</xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                            } 
                        <xsl:if test="position() = last()">
                            <xsl:text>],</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="(@key='transcript_human')">
                    "<xsl:value-of select="@key"/>": [
                    <xsl:for-each select="./array/map">
                        <xsl:message><xsl:value-of select="string-length(./map[@key='transcript_human_consent']/array)!=0"/></xsl:message>
                        <xsl:if test="string-length(./map[@key='transcript_human_consent']/array)!=0"> 
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
                            } 
                        </xsl:if>
                        <xsl:if test="position() = last()">
                            <xsl:text>],</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:when>
            </xsl:choose>
            
        </xsl:for-each>
        <xsl:text>"file-metadata": [ </xsl:text>
        <xsl:for-each select="//array[@key = 'file-metadata']/map[boolean[@key = 'private' and text() = 'true']]">
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
