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
            <xsl:for-each select="array[@key='value']/map/map[boolean[@key='private']='false' or not(boolean[@key='private'])]">
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
                    <xsl:when test="string[@key='value']">
                        <xsl:text>ohs.metadata.XXXX</xsl:text>
                        <xsl:value-of select="$entity" />
                        <xsl:text>.</xsl:text>
                        <xsl:value-of select="$key" />
                        <xsl:text>=</xsl:text>
                        <xsl:value-of select="string[@key='value']" />
                        <xsl:text>&#10;</xsl:text>
                    </xsl:when>
                    <xsl:when test="map[@key='value'] and $key='relation_type'">
                        <xsl:text>ohs.metadata.</xsl:text>
                        <xsl:value-of select="$entity" />
                        <xsl:text>.</xsl:text>
                        <xsl:value-of select="$key" />
                        <xsl:text>=</xsl:text>
                        <xsl:value-of select="./map/string[@key='value']" />
                        <xsl:text>&#10;</xsl:text>
                    </xsl:when>
                    <xsl:when test="map[@key='value'] and $key='name'">
                        <xsl:text>ohs.metadata.</xsl:text>
                        <xsl:value-of select="$entity" />
                        <xsl:text>.</xsl:text>
                        <xsl:value-of select="$key" />
                        <xsl:text>.label=</xsl:text>
                        <xsl:value-of select="./map/string[@key='label']" />
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>ohs.metadata.</xsl:text>
                        <xsl:value-of select="$entity" />
                        <xsl:text>.</xsl:text>
                        <xsl:value-of select="$key" />
                        <xsl:text>.value=</xsl:text>
                        <xsl:value-of select="./map/string[@key='value']" />
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>ohs.metadata.</xsl:text>
                        <xsl:value-of select="$entity" />
                        <xsl:text>.</xsl:text>
                        <xsl:value-of select="$key" />
                        <xsl:text>.extraLabel=</xsl:text>
                        <xsl:value-of select="./map/string[@key='extraLabel']" />
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
        <xsl:if test="./map[@key='metadata']/map[@key='recording_format']/array[@key='value']">         
            <xsl:text>ohs.metadata.recording_format=</xsl:text>
            <xsl:value-of select="./map[@key='metadata']/map[@key='recording_format']/array[@key='value']/map/string" />
            <xsl:text>&#10;</xsl:text>
        </xsl:if>
        <xsl:if test="./map[@key='metadata']/map[@key='recording_equipment']/string[@key='value']">         
            <xsl:text>ohs.metadata.recording_equipment=</xsl:text>
            <xsl:value-of select="./map[@key='metadata']/map[@key='recording_equipment']/string[@key='value']" />
            <xsl:text>&#10;</xsl:text>
        </xsl:if>
        <!-- Explicitly handle audience -->
        <xsl:for-each select="./map[@key='metadata']/map[@key='audience']/array[@key='value']/map">
            <xsl:text>ohs.metadata.audience.</xsl:text>
            <xsl:value-of select="string[@key='label']" />
            <xsl:text>=</xsl:text>
            <xsl:value-of select="string[@key='value']" />
            <xsl:text>&#10;</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="./map[@key='metadata']/map[@key='subject_location']/array[@key='value']/map">
            <xsl:text>ohs.metadata.subject_location.</xsl:text>
            <xsl:value-of select="string[@key='label']" />
            <xsl:text>=</xsl:text>
            <xsl:value-of select="string[@key='value']" />
            <xsl:text>&#10;</xsl:text>
        </xsl:for-each>
        
        <xsl:for-each select="./map[@key='metadata']/map[@key='collections']/array[@key='value']/map">
            <xsl:text>ohs.metadata.collections.</xsl:text>
            <xsl:value-of select="string[@key='label']" />
            <xsl:text>=</xsl:text>
            <xsl:value-of select="string[@key='value']" />
            <xsl:text>&#10;</xsl:text>
        </xsl:for-each>
        
        <xsl:for-each select="./map[@key='metadata']/map[@key='language_interview']/array[@key='value']/map">
            <xsl:text>ohs.metadata.language_interview.</xsl:text>
            <xsl:value-of select="string[@key='label']" />
            <xsl:text>=</xsl:text>
            <xsl:value-of select="string[@key='value']" />
            <xsl:text>&#10;</xsl:text>
        </xsl:for-each>
        
        <xsl:if test="./map[@key='metadata']/map[@key='language_metadata']/map[@key='value']">
            <xsl:text>ohs.metadata.language_metadata.</xsl:text>
            <xsl:value-of select="./map[@key='metadata']/map[@key='language_metadata']/map[@key='value']/string[@key='label']" />
            <xsl:text>=</xsl:text>
            <xsl:value-of select="./map[@key='metadata']/map[@key='language_metadata']/map[@key='value']/string[@key='value']" />
            <xsl:text>&#10;</xsl:text>
        </xsl:if>
        
        <xsl:if test="./map[@key='metadata']/map[@key='rightsholder']/map[@key='value']">
            <xsl:text>ohs.metadata.rightsholder.</xsl:text>
            <xsl:value-of select="./map[@key='metadata']/map[@key='rightsholder']/map[@key='value']/string[@key='label']" />
            <xsl:text>=</xsl:text>
            <xsl:value-of select="./map[@key='metadata']/map[@key='rightsholder']/map[@key='value']/string[@key='value']" />
            <xsl:text>&#10;</xsl:text>
        </xsl:if>
        
        <xsl:if test="./map[@key='metadata']/map[@key='licence_type']/map[@key='value']">
            <xsl:text>ohs.metadata.licence_type.</xsl:text>
            <xsl:value-of select="./map[@key='metadata']/map[@key='licence_type']/map[@key='value']/string[@key='label']" />
            <xsl:text>=</xsl:text>
            <xsl:value-of select="./map[@key='metadata']/map[@key='licence_type']/map[@key='value']/string[@key='value']" />
            <xsl:text>&#10;</xsl:text>
        </xsl:if>
        
        <xsl:if test="./map[@key='metadata']/map[@key='personal_data']/string[@key='value']">
            <xsl:text>ohs.metadata.personal_data=</xsl:text>
            <xsl:value-of select="./map[@key='metadata']/map[@key='personal_data']/string[@key='value']" />
            <xsl:text>&#10;</xsl:text>
        </xsl:if>
        
        <xsl:if test="./map[@key='metadata']/map[@key='contact_email']/string[@key='value']">
            <xsl:text>ohs.metadata.contact_email=</xsl:text>
            <xsl:value-of select="./map[@key='metadata']/map[@key='contact_email']/string[@key='value']" />
            <xsl:text>&#10;</xsl:text>
        </xsl:if>
        
        <xsl:if test="./map[@key='metadata']/map[@key='transcript_machine']/string[@key='value']">
            <xsl:text>ohs.metadata.transcript_machine=</xsl:text>
            <xsl:value-of select="./map[@key='metadata']/map[@key='transcript_machine']/string[@key='value']" />
            <xsl:text>&#10;</xsl:text>
        </xsl:if>
        
        <xsl:for-each select="./map[@key='metadata']/map[@key='interview_location']/array[@key='value']/map">
            <xsl:text>ohs.metadata.interview_location.</xsl:text>
            <xsl:value-of select="string[@key='label']" />
            <xsl:text>=</xsl:text>
            <xsl:value-of select="string[@key='value']" />
            <xsl:text>&#10;</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="./map[@key='metadata']/map[@key='subject_keywords']/array[@key='value']/map">
            <xsl:text>ohs.metadata.subject_keywords.</xsl:text>
            <xsl:value-of select="string[@key='label']" />
            <xsl:text>=</xsl:text>
            <xsl:value-of select="string[@key='value']" />
            <xsl:text>&#10;</xsl:text>
        </xsl:for-each>
        
        <xsl:if test="./map[@key='metadata']/map[@key='title']/string[@key='value']">
            <xsl:text>ohs.metadata.title=</xsl:text>
            <xsl:value-of select="./map[@key='metadata']/map[@key='title']/string[@key='value']" />
            <xsl:text>&#10;</xsl:text>
        </xsl:if>
        
        <xsl:if test="./map[@key='metadata']/map[@key='subtitle']/string[@key='value']">
            <xsl:text>ohs.metadata.subtitle=</xsl:text>
            <xsl:value-of select="./map[@key='metadata']/map[@key='subtitle']/string[@key='value']" />
            <xsl:text>&#10;</xsl:text>
        </xsl:if>
        
        <xsl:if test="./map[@key='metadata']/map[@key='description']/string[@key='value']">
            <xsl:text>ohs.metadata.description=</xsl:text>
            <xsl:value-of select="./map[@key='metadata']/map[@key='description']/string[@key='value']" />
            <xsl:text>&#10;</xsl:text>
        </xsl:if>
        
        <xsl:if test="./map[@key='metadata']/map[@key='publisher']/map[@key='value']">
            <xsl:text>ohs.metadata.publisher.</xsl:text>
            <xsl:value-of select="./map[@key='metadata']/map[@key='publisher']/map[@key='value']/string[@key='label']" />
            <xsl:text>=</xsl:text>
            <xsl:value-of select="./map[@key='metadata']/map[@key='publisher']/map[@key='value']/string[@key='value']" />
            <xsl:text>&#10;</xsl:text>
        </xsl:if>
        
<!--        <xsl:for-each select="./map[@key='metadata']/map[@key='author']/array[@key='value']/map">
            <xsl:text>ohs.metadata.author.</xsl:text>
            <xsl:value-of select="string[@key='label']" />
            <xsl:text>=</xsl:text>
            <xsl:value-of select="string[@key='value']" />
            <xsl:text>&#10;</xsl:text>
        </xsl:for-each>-->
        
        <xsl:variable name="FileMetadata">file-metadata</xsl:variable>
        <xsl:for-each select="//array[@key = 'file-metadata']/map">
            <xsl:variable name="isExcluded"
                select="boolean(./boolean[@key = 'private' and text() = 'true'])"/>
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
                    <xsl:text>.embargo=</xsl:text>
                    <xsl:value-of select="string[@key = 'embargo']"/>
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