<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs math" version="3.0">
    <xsl:output indent="yes" omit-xml-declaration="yes" />
    <xsl:template match="data">
        <!-- create a new root tag -->        <!-- apply the xml structure generated from JSON -->
        <xsl:apply-templates select="json-to-xml(.)" />
    </xsl:template>    <!-- template for the         first tag -->
    <xsl:template match="/map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        {
            "datasetVersion": {
                "license": { "name": "CC0 1.0", "uri": "http://creativecommons.org/publicdomain/zero/1.0" },
                "metadataBlocks": {
                    "citation": {
                        "fields": [
                            {
                                "value": "<xsl:value-of select="//map[@key='metadata']/map[@key='title']/string[@key='value']/." />",
                                "typeClass": "primitive",
                                "multiple": false,
                                "typeName": "title"
                            },
                            {
                                "value": [
                                    {
                                        "authorName": {
                                            "value": "<xsl:value-of select="//map[@key='metadata']/map[@key='author']/string[@key='value']" />",
                                            "typeClass": "primitive",
                                            "multiple": false,
                                            "typeName": "authorName"
                                         }
                                     }
                                    <!-- ,
                                     {
                                        "authorName": {
                                            "value": "<xsl:value-of select="//map[@key='metadata']/map[@key='software_author']/string[@key='value']" />",
                                            "typeClass": "primitive",
                                            "multiple": false,
                                            "typeName": "authorName"
                                        }
                                     }-->
                                    <xsl:for-each select="//map[@key='metadata']/map[@key='additional_authors']/array/map">
                                        <xsl:if test="./map[@key='additional_author_type']/map/string[@key='value']='Dataset author'">
                                            ,
                                            {
                                                "authorName": {
                                                "typeName": "authorName",
                                                "multiple": false,
                                                "typeClass": "primitive",
                                                "value": "<xsl:value-of select="./map[@key='additional_author']/string"/>"
                                                }
                                            }
                                        </xsl:if>
                                    </xsl:for-each>
                                ],
                                "typeClass": "compound",
                                "multiple": true,
                                "typeName": "author"
                          },
                          {
                            "typeName": "dataSources",
                            "multiple": true,
                            "typeClass": "primitive",
                            "value": [ "<xsl:value-of select="//string[@key='swh-staging-api'] /." />"]
                          },
                          {
                            "value": [
                                {
                                    "datasetContactEmail" : {
                                    "typeClass": "primitive",
                                    "multiple": false,
                                    "typeName": "datasetContactEmail",
                                    "value" : "<xsl:value-of select="//map[@key='metadata']/map[@key='contact_email']/string[@key='value']/." />"
                                    }
                                }
                            ],
                            "typeClass": "compound",
                            "multiple": true,
                            "typeName": "datasetContact"
                         },
        <xsl:variable name="escapedDescription">
            <xsl:call-template name="escape-json">
                <xsl:with-param name="text" select="//map[@key='metadata']/map[@key='description']/string[@key='value']"/>
            </xsl:call-template>
        </xsl:variable>
                         {
                            "value": [
                                {
                                    "dsDescriptionValue": {
                                    "value": "<xsl:value-of select="$escapedDescription"/>",
                                        "multiple":false,
                                        "typeClass": "primitive",
                                        "typeName": "dsDescriptionValue"
                                     }
                                 }
                            ],
                            "typeClass": "compound",
                            "multiple": true,
                            "typeName": "dsDescription"
                        },
                        {
                            "value": [ "<xsl:value-of select="//map[@key='metadata']/map[@key='subject']/map[@key='value']/string[@key='value']"/>"],
                            "typeClass": "controlledVocabulary",
                            "multiple": true,
                            "typeName": "subject"
                        }
                    ],
                    "displayName": "Citation Metadata"
                  }
                }
              }
            }
        <xsl:message><xsl:value-of select="$escapedDescription"/></xsl:message>
            </xsl:template>
            <!-- Define the escape-json template -->
            <xsl:template name="escape-json">
                <xsl:param name="text" />
                <xsl:value-of select="replace(replace($text, '&#10;', '\\n'), '&quot;', '\\&quot;')" />
            </xsl:template>
</xsl:stylesheet>









