<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs math" version="3.0">
    <xsl:output indent="yes" omit-xml-declaration="yes"/>
  <xsl:import href="./ohsmart-form-metadata-to-DV-commons.xsl"/>
    <xsl:template match="data">
        <!-- apply the xml structure generated from JSON -->
        <xsl:apply-templates select="json-to-xml(.)"/>
        
    </xsl:template>
    
    <xsl:template match="/map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions"> 
      <xsl:variable name="converted-date">
        <xsl:for-each select="//map[@key='metadata']/map[@key='interview_date_time']/array[@key='value']/map/map[@key='interview_date_time_range']/array/string">     
          <xsl:call-template name="convertdatetime">
            <xsl:with-param name="val" select="."/>
          </xsl:call-template>
        </xsl:for-each>
       
      </xsl:variable>
      <xsl:variable name="pub-date">
        <xsl:for-each select="tokenize($converted-date, ',')">
          <xsl:sort select="." data-type="text" order="descending"></xsl:sort>
          <xsl:if test="position() = 1">
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:message>The most recent: <xsl:value-of select="$pub-date"/></xsl:message>
       {
  "datasetVersion": {
    "productionDate": "<xsl:value-of select="$pub-date"/>",
    <!--"createTime": "2024-04-04T07:33:44Z",-->
    "license": {
    "name": "<xsl:value-of select="//map[@key='metadata']/map[@key='licence_type']/map[@key='value']/string[@key='label']"/>",
    "uri": "<xsl:value-of select="//map[@key='metadata']/map[@key='licence_type']/map[@key='value']/string[@key='value']"/>",
    "iconUri": ""
    },
    "termsOfAccess": "",
    "metadataBlocks": {
      "citation": {
        "displayName": "Citation Metadata",
        "fields": [<!-- CIT01 -->
          {
            "typeName": "title",
            "multiple": false,
            "typeClass": "primitive",
            "value": "<xsl:value-of select="//map[@key='metadata']/map[@key='title']/string[@key='value']"/>"
          },
          {<!-- CIT02 -->
            "typeName": "subtitle",
            "multiple": false,
            "typeClass": "primitive",
            "value": "<xsl:value-of select="//map[@key='metadata']/map[@key='subtitle']/string[@key='value']"/>"
          },
          {
            "typeName": "author",
            "multiple": true,
            "typeClass": "compound",
            "value": [
                <xsl:for-each select="//map[@key='metadata']/map[@key='author']/array/map">
                  {
                    "authorName": {
                          "typeName": "authorName",
                          "multiple": false,
                          "typeClass": "primitive",
                          "value": "<xsl:value-of select="./map[@key='name']/map/string[@key='label']"/>"
                      },
                      "authorAffiliation": {<!-- CITr06 -->
                          "typeName": "authorAffiliation",
                          "multiple": false,
                          "typeClass": "primitive",
                          "value": "<xsl:value-of select="./map[@key='affiliation']/string[@key='value']"/>"
                       }
                  <xsl:if test="./map[@key='name']/map/string[@key='idLabel']='ORCID ID'">
                      ,
                      "authorIdentifierScheme": {
                          "typeName": "authorIdentifierScheme",
                          "multiple": false,
                          "typeClass": "controlledVocabulary",
                          "value": "ORCID"
                      },
                      "authorIdentifier": {
                          "typeName": "authorIdentifier",
                          "multiple": false,
                          "typeClass": "primitive",
                          "value": "<xsl:value-of select="./map[@key='name']/map/string[@key='id']"/>"
                          }
                  </xsl:if>
                  }
                  <xsl:if test="position() != last()">
                    <xsl:text>,</xsl:text>
                  </xsl:if>
                </xsl:for-each>
              ]
          },
          {
          "typeName": "datasetContact",
          "multiple": true,
          "typeClass": "compound",
          "value": [
          {
          "datasetContactEmail": {
          "typeName": "datasetContactEmail",
          "multiple": false,
          "typeClass": "primitive",
          "value": "<xsl:value-of select="//map[@key='metadata']/map[@key='contact_email']/string[@key='value']"/>"
          }
          }
          ]
          },
      <xsl:variable name="escapedDescription">
        <xsl:call-template name="escape-json">
          <xsl:with-param name="text" select="//map[@key='metadata']/map[@key='description']/string[@key='value']"/>
        </xsl:call-template>
      </xsl:variable>
          {<!-- CIT03 -->
            "typeName": "dsDescription",
            "multiple": true,
            "typeClass": "compound",
            "value": [
              {
                "dsDescriptionValue": {
                  "typeName": "dsDescriptionValue",
                  "multiple": false,
                  "typeClass": "primitive",
                  "value": "<xsl:value-of select="$escapedDescription"/>"
                }
              }
            ]
            },
          {
            "typeName": "subject",
            "multiple": true,
            "typeClass": "controlledVocabulary",
            "value": [
      <xsl:for-each select="//map[@key='metadata']/map[@key='audience']/array/map">
        <xsl:variable name="audience">
          <xsl:call-template name="audiencefromkeyword">
            <xsl:with-param name="val" select="./string[@key='id']"/>
          </xsl:call-template>
        </xsl:variable>
        "<xsl:value-of select="$audience"/>"
        <xsl:if test="position() != last()">
          <xsl:text>,</xsl:text>
        </xsl:if>
      </xsl:for-each>
            ]
          },
          {
            "typeName": "keyword",
            "multiple": true,
            "typeClass": "compound",
            "value": [
            <!-- COVx01 -->
                <xsl:for-each select="//map[@key='metadata']/map[@key='subject_keywords']/array/map">
                  {
                  <xsl:choose>
                    <xsl:when test="./boolean[@key='freetext']">

                          "keywordValue": {
                          "typeName": "keywordValue",
                          "multiple": false,
                          "typeClass": "primitive",
                          "value": "<xsl:value-of select="./string[@key='value']"/>"
                      }

                    </xsl:when>
                    <xsl:otherwise>

                         "keywordValue": {
                         "typeName": "keywordValue",
                         "multiple": false,
                         "typeClass": "primitive",
                         "value": "<xsl:value-of select="./string[@key='label']/."/>"
                      },
                      "keywordVocabulary": {
                          "typeName": "keywordVocabulary",
                          "multiple": false,
                          "typeClass": "primitive",
                          "value": "Art and Architecture Thesaurus"
                      },
                      "keywordVocabularyURI": {
                          "typeName": "keywordVocabularyURI",
                          "multiple": false,
                          "typeClass": "primitive",
                          "value": "<xsl:value-of select="./string[@key='value']/."/>"
                      }

                    </xsl:otherwise>
                  </xsl:choose>
                 }
                  <xsl:if test="position() != last()">
                    <xsl:text>,</xsl:text>
                  </xsl:if>
                </xsl:for-each>
            ]
          },
          {
            "typeName": "language",
            "multiple": true,
            "typeClass": "controlledVocabulary",
            "value": [
      <xsl:for-each select="//map[@key='metadata']/map[@key='language_interview']/array/map">
        "<xsl:value-of select="./string[@key='label']"/>"
        <xsl:if test="position() != last()">
          <xsl:text>,</xsl:text>
        </xsl:if>
      </xsl:for-each>
            ]
      },
          {
            "typeName": "productionDate",
            "multiple": false,
            "typeClass": "primitive",
            "value": "<xsl:value-of select="$pub-date"/>"
          },

          {
            "typeName": "grantNumber",
            "multiple": true,
            "typeClass": "compound",
            "value": [
                <xsl:for-each select="//map[@key='metadata']/map[@key='grant']/array/map">
                  <xsl:if test="./map[@key='grant_agency']/string[@key='value']"></xsl:if>
                    {
                    "grantNumberAgency": {<!-- CITr07 -->
                        "typeName": "grantNumberAgency",
                        "multiple": false,
                        "typeClass": "primitive",
                        "value": "<xsl:value-of select="./map[@key='grant_agency']/string[@key='value']"/>"
                    }, 
                    "grantNumberValue": {<!-- CITr08 -->
                        "typeName": "grantNumberValue",
                        "multiple": false,
                        "typeClass": "primitive",
                        "value": "<xsl:value-of select="./map[@key='grant_number']/string[@key='value']"/>"
                    }
                    }
                  <xsl:if test="position() != last()">
                    <xsl:text>,</xsl:text>
                  </xsl:if>
                 </xsl:for-each>


            ]
          },
          {
              "typeName": "distributor",
              "multiple": true,
              "typeClass": "compound",
              "value": [
                  {
                      "distributorName": {
                          "typeName": "distributorName",
                          "multiple": false,
                          "typeClass": "primitive",
                          "value": "<xsl:value-of select="//map[@key='metadata']/map[@key='publisher']/map[@key='value']/string[@key='label']"/>"
                      }
      <xsl:if test="starts-with(//map[@key='metadata']/map[@key='publisher']/map[@key='value']/string[@key='value'],'http') and string-length(//map[@key='metadata']/map[@key='publisher']/map[@key='value']/string[@key='value']) > 0 ">
                         ,
                       "distributorURL": {
                           "typeName": "distributorURL",
                           "multiple": false,
                           "typeClass": "primitive",
                           "value": "<xsl:value-of select="//map[@key='metadata']/map[@key='publisher']/map[@key='value']/string[@key='value']"/>"
                       }
                      </xsl:if>
                  }
              ]
          },
          {
            "typeName": "dateOfDeposit",
            "multiple": false,
            "typeClass": "primitive",
            "value": "<xsl:value-of  select="format-dateTime(current-dateTime(), '[Y0001]-[M01]-[D01]')"/>"
          }
          
        ]
      },
      "dansRights": {
          "displayName": "Rights Metadata",
          "name": "dansRights",
          "fields": [
                {
                  "typeName": "dansRightsHolder",
                  "multiple": true,
                  "typeClass": "primitive",
                  "value": ["<xsl:value-of select="//map[@key='metadata']/map[@key='rightsholder']/map[@key='value']/string[@key='label']"/>"]
                },
                {
                  "typeName": "dansPersonalDataPresent",
                  "multiple": false,
                  "typeClass": "controlledVocabulary",
                  "value": "<xsl:variable name="personal-data">
                                <xsl:value-of select="//map[@key='metadata']/map[@key='personal_data']/string[@key='value']"/>
                            </xsl:variable>
                              <xsl:choose>
                                <xsl:when test="$personal-data = 'personal_data_true'">
                                  <xsl:text>Yes</xsl:text>
                                </xsl:when>
                                <xsl:when test="$personal-data = 'personal_data_unknown'">
                                  <xsl:text>Unknown</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:text>No</xsl:text>
                                </xsl:otherwise>
                              </xsl:choose>"
                },
                {
                  "typeName": "dansMetadataLanguage",
                  "multiple": true,
                  "typeClass": "controlledVocabulary",
                  "value": ["<xsl:value-of select="//map[@key='metadata']/map[@key='language_metadata']/map[@key='value']/string[@key='label']"/>"]                
                }
          ]
      },
      "dansRelationMetadata": {
            "displayName": "Relation Metadata",
            "name": "dansRelationMetadata",
            "fields": [
                  {
                      "typeName": "dansAudience",
                      "multiple": true,
                      "typeClass": "primitive",
                      "value": [<xsl:for-each select="//map[@key='metadata']/map[@key='audience']/array/map">
                        "<xsl:value-of select="./string[@key='value']"/>"
                        <xsl:if test="position() != last()">
                          <xsl:text>,</xsl:text>
                        </xsl:if>
                      </xsl:for-each>]
                  },
                
                  {
                      "typeName": "dansCollection",
                      "multiple": true,
                      "typeClass": "primitive",
                      "value": [
                        <xsl:for-each select="//map[@key='metadata']/map[@key='collections']/array/map">
                          "<xsl:value-of select="./string[@key='value']"/>"
                          <xsl:if test="position() != last()">
                            <xsl:text>,</xsl:text>
                          </xsl:if>
                        </xsl:for-each>
                      ]
                  },                
                {
                    "typeName": "dansRelation",
                    "multiple": true,
                    "typeClass": "compound",
                    "value": [
                        <xsl:for-each select="//map[@key='metadata']/map[@key='relation']/array/map">
                           {
                          <xsl:if test="./map[@key='relation_type']/map/string[@key='value']">
                                "dansRelationType": {
                                      "typeName": "dansRelationType",
                                      "multiple": false,
                                      "typeClass": "controlledVocabulary",
                                      "value": "<xsl:value-of select="./map[@key='relation_type']/map/string[@key='value']"/>"
                                }
                            </xsl:if>
                          <xsl:if test="string-length(./map[@key='relation_item']/string[@key='value'])>0">
                            <xsl:if test="string-length(./map[@key='relation_type']/map/string[@key='value'])>0">
                                ,
                              </xsl:if>
                               "dansRelationText": {
                                    "typeName": "dansRelationText",
                                    "multiple": false,
                                    "typeClass": "primitive",
                                    "value": "<xsl:value-of select="./map[@key='relation_item']/string[@key='value']"/>"
                               }
                              
                            </xsl:if> 
                          <xsl:if test="string-length(./map[@key='relation_reference']/string[@key='value'])>0">
                                <xsl:choose>
                                  <xsl:when test="string-length(/map[@key='relation_item']/string[@key='value'])>0">,</xsl:when>
                                  <xsl:otherwise>
                                    <xsl:if test="string-length(./map[@key='relation_type']/map/string[@key='value'])>0">
                                      ,
                                    </xsl:if>
                                  </xsl:otherwise>
                                </xsl:choose>
                                     "dansRelationURI": {
                                     "typeName": "dansRelationURI",
                                     "multiple": false,
                                     "typeClass": "primitive",
                                     "value": "<xsl:value-of select="./map[@key='relation_reference']/string[@key='value']"/>"
                               }
                              </xsl:if>
                           }
                           <xsl:if test="position() != last()">
                             <xsl:text>,</xsl:text>
                           </xsl:if>
                         </xsl:for-each>
                      ]
                    }
              ]
      },
      "dansTemporalSpatial": {
          "displayName": "Temporal and Spatial Coverage",
          "name": "dansTemporalSpatial",
          "fields": [
              {<!-- COVr03 COVr04 -->
                  "typeName": "dansTemporalCoverage",
                  "multiple": true,
                  "typeClass": "primitive",
                  "value": [
                      <xsl:for-each select="//map[@key='metadata']/map[@key='subject_date_time']/array/map"> 
                        <xsl:choose>
                          <xsl:when test="string-length(./map/array/string[2]) > 0">"start:<xsl:value-of select="./map/array/string[1]"/>  End:<xsl:value-of select="./map/array/string[2]"/>"</xsl:when>
                          <xsl:otherwise>"start:<xsl:value-of select="./map/array/string[1]"/>"</xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="position() != last()">
                          <xsl:text>,</xsl:text>
                        </xsl:if>
                      </xsl:for-each>
                  ]
              },
              {<!-- COVr02 -->
                  "typeName": "dansSpatialCoverageText",
                  "multiple": true,
                  "typeClass": "primitive",
                  "value": [
                        <xsl:for-each select="//map[@key='metadata']//map[@key='subject_location']/array/map">
                          "<xsl:value-of select="./string[@key='label']"/>"
                          <xsl:if test="position() != last()">
                            <xsl:text>,</xsl:text>
                          </xsl:if>
                        </xsl:for-each>
                  ]
              }
          ]
      }
    }
  }
}
       
    </xsl:template>
</xsl:stylesheet>