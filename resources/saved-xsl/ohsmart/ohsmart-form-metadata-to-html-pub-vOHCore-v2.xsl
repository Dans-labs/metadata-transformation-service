<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs math" version="3.0">

    <xsl:output method="html" html-version="5" indent="yes" encoding="UTF-8"/>

    <xsl:template match="data">
        <xsl:apply-templates select="json-to-xml(.)"/>
    </xsl:template>

    <!-- ========================================================= -->
    <!-- Helpers (no XPath on the source tree, so no namespace needed) -->
    <!-- ========================================================= -->

    <!-- "interview_location" -> "Interview location" -->
    <xsl:template name="pretty-label">
        <xsl:param name="key"/>
        <xsl:value-of select="concat(upper-case(substring($key, 1, 1)), translate(substring($key, 2), '_', ' '))"/>
    </xsl:template>

    <!-- One table row; skipped when the content is empty -->
    <xsl:template name="row">
        <xsl:param name="key"/>
        <xsl:param name="content"/>
        <xsl:if test="normalize-space($content) != ''">
            <tr>
                <th>
                    <xsl:call-template name="pretty-label">
                        <xsl:with-param name="key" select="$key"/>
                    </xsl:call-template>
                </th>
                <td>
                    <xsl:copy-of select="$content"/>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>

    <!-- Renders a {label, value} map: "label (value)" -->
    <xsl:template name="label-value" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:param name="item"/>
        <xsl:variable name="label" select="string($item/string[@key = 'label'])"/>
        <xsl:variable name="value" select="string($item/string[@key = 'value'])"/>
        <xsl:variable name="extra" select="string($item/string[@key = 'extraLabel'])"/>
        <div>
            <xsl:choose>
                <xsl:when test="$label != ''">
                    <xsl:value-of select="$label"/>
                    <xsl:if test="$extra != ''">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$extra"/>
                    </xsl:if>
                    <xsl:if test="$value != '' and $value != $label">
                        <xsl:text> </xsl:text>
                        <span class="sub">(<xsl:value-of select="$value"/>)</span>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$value"/>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>

    <!-- ========================================================= -->
    <!-- Fields inside a repeated group (interviewee, interviewer, ...) -->
    <!-- ========================================================= -->

    <!-- The "_public" flags only control visibility, don't print them -->
    <xsl:template match="map[ends-with(@key, '_public')]" mode="field" priority="2"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions"/>

    <xsl:template match="map" mode="field" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:variable name="key" select="@key"/>
        <xsl:variable name="pub" select="following-sibling::map[ends-with(@key, '_public')]"/>
        <xsl:variable name="pubValue" select="string-join($pub/array[@key = 'value']/string, '')"/>
        <!-- Same rule as the text version: a *_public sibling with an empty value hides the field -->
        <xsl:variable name="hidden" select="exists($pub) and $pubValue = ''"/>
        <xsl:if test="not($hidden)">
            <xsl:variable name="content">
                <xsl:choose>
                    <xsl:when test="string[@key = 'value']">
                        <xsl:value-of select="string[@key = 'value']"/>
                    </xsl:when>
                    <xsl:when test="map[@key = 'value'] and $key = 'relation_type'">
                        <xsl:value-of select="map[@key = 'value']/string[@key = 'value']"/>
                    </xsl:when>
                    <xsl:when test="map[@key = 'value']">
                        <xsl:call-template name="label-value">
                            <xsl:with-param name="item" select="map[@key = 'value']"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="array[@key = 'value']">
                        <xsl:for-each select="array[@key = 'value']/string">
                            <div><xsl:value-of select="."/></div>
                        </xsl:for-each>
                        <xsl:for-each select="array[@key = 'value']/map">
                            <xsl:call-template name="label-value">
                                <xsl:with-param name="item" select="."/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:call-template name="row">
                <xsl:with-param name="key" select="$key"/>
                <xsl:with-param name="content" select="$content"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- ========================================================= -->
    <!-- Main template -->
    <!-- ========================================================= -->

    <xsl:template match="/map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:variable name="m" select="./map[@key = 'metadata']"/>
        <xsl:variable name="title" select="string($m/map[@key = 'title']/string[@key = 'value'])"/>
        <xsl:variable name="subtitle" select="string($m/map[@key = 'subtitle']/string[@key = 'value'])"/>
        <xsl:variable name="description" select="string($m/map[@key = 'description']/string[@key = 'value'])"/>

        <html lang="en">
            <head>
                <meta charset="utf-8"/>
                <title><xsl:value-of select="if ($title != '') then $title else 'Oral History metadata'"/></title>
                <style>
                    @page { size: A4; margin: 20mm 18mm; }
                    body { font-family: "DejaVu Sans", Arial, sans-serif; font-size: 10pt; line-height: 1.4; color: #222; }
                    h1 { font-size: 20pt; margin: 0 0 4pt 0; }
                    h2 { font-size: 13pt; margin: 18pt 0 6pt 0; border-bottom: 1px solid #999; padding-bottom: 2pt; }
                    .subtitle { font-size: 12pt; color: #555; margin: 0 0 8pt 0; }
                    .ref { font-size: 8pt; color: #777; margin-bottom: 12pt; }
                    .desc { white-space: pre-wrap; margin: 8pt 0; }
                    table { width: 100%; border-collapse: collapse; margin-bottom: 10pt; page-break-inside: avoid; }
                    th, td { text-align: left; vertical-align: top; padding: 3pt 6pt; border-bottom: 1px solid #ddd; }
                    th { width: 32%; color: #444; font-weight: bold; }
                    table.files th { width: auto; background: #f0f0f0; }
                    td { white-space: pre-wrap; word-wrap: break-word; }
                    .sub { color: #777; font-size: 8pt; }
                    .footer { margin-top: 24pt; font-size: 8pt; color: #888; }
                </style>
            </head>
            <body>
                <xsl:if test="$title != ''">
                    <h1><xsl:value-of select="$title"/></h1>
                </xsl:if>
                <xsl:if test="$subtitle != ''">
                    <p class="subtitle"><xsl:value-of select="$subtitle"/></p>
                </xsl:if>
                <p class="ref">
                    <xsl:text>Reference: </xsl:text>
                    <xsl:value-of select="./string[@key = 'id']"/>
                    <xsl:text> | Generated: </xsl:text>
                    <xsl:value-of select="format-dateTime(current-dateTime(), '[Y0001]-[M01]-[D01] [H01]:[m01]')"/>
                </p>
                <xsl:if test="$description != ''">
                    <p class="desc"><xsl:value-of select="$description"/></p>
                </xsl:if>

                <!-- General fields -->
                <xsl:variable name="detailRows">
                    <!-- plain string fields -->
                    <xsl:for-each select="('recording_equipment', 'personal_data', 'contact_email', 'transcript_machine')">
                        <xsl:variable name="k" select="."/>
                        <xsl:call-template name="row">
                            <xsl:with-param name="key" select="$k"/>
                            <xsl:with-param name="content">
                                <xsl:value-of select="$m/map[@key = $k]/string[@key = 'value']"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:for-each>
                    <!-- single {label, value} fields -->
                    <xsl:for-each select="('publisher', 'language_metadata', 'rightsholder', 'licence_type')">
                        <xsl:variable name="k" select="."/>
                        <xsl:call-template name="row">
                            <xsl:with-param name="key" select="$k"/>
                            <xsl:with-param name="content">
                                <xsl:for-each select="$m/map[@key = $k]/map[@key = 'value']">
                                    <xsl:call-template name="label-value">
                                        <xsl:with-param name="item" select="."/>
                                    </xsl:call-template>
                                </xsl:for-each>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:for-each>
                    <!-- lists of {label, value} -->
                    <xsl:for-each select="('recording_format', 'audience', 'collections', 'language_interview',
                        'interview_location', 'subject_location', 'subject_keywords_aat',
                        'subject_keywords_wikidata', 'subject_keywords_freetext')">
                        <xsl:variable name="k" select="."/>
                        <xsl:call-template name="row">
                            <xsl:with-param name="key" select="$k"/>
                            <xsl:with-param name="content">
                                <xsl:for-each select="$m/map[@key = $k]/array[@key = 'value']/map">
                                    <xsl:call-template name="label-value">
                                        <xsl:with-param name="item" select="."/>
                                    </xsl:call-template>
                                </xsl:for-each>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:if test="exists($detailRows/*)">
                    <h2>Details</h2>
                    <table>
                        <xsl:copy-of select="$detailRows"/>
                    </table>
                </xsl:if>

                <!-- Repeated groups: interviewee, interviewer, interpreter, others, author, relation, ... -->
                <xsl:for-each select="$m/map[array[@key = 'value']/map/map]">
                    <xsl:variable name="groupRows">
                        <xsl:for-each select="array[@key = 'value']/map">
                            <xsl:variable name="itemRows">
                                <xsl:apply-templates
                                    select="map[boolean[@key = 'private'] = 'false' or not(boolean[@key = 'private'])]"
                                    mode="field"/>
                            </xsl:variable>
                            <xsl:if test="exists($itemRows/*)">
                                <table>
                                    <xsl:copy-of select="$itemRows"/>
                                </table>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:if test="exists($groupRows/*)">
                        <h2>
                            <xsl:call-template name="pretty-label">
                                <xsl:with-param name="key" select="@key"/>
                            </xsl:call-template>
                        </h2>
                        <xsl:copy-of select="$groupRows"/>
                    </xsl:if>
                </xsl:for-each>

                <!-- Public files only -->
                <xsl:variable name="files"
                    select="//array[@key = 'file-metadata']/map[not(boolean[@key = 'private' and text() = 'true'])]"/>
                <xsl:if test="exists($files)">
                    <h2>Files</h2>
                    <table class="files">
                        <tr>
                            <th>Name</th>
                            <th>Role</th>
                            <th>Embargo</th>
                        </tr>
                        <xsl:for-each select="$files">
                            <tr>
                                <td><xsl:value-of select="string[@key = 'name']"/></td>
                                <td><xsl:value-of select="map[@key = 'role']/string[@key = 'label']"/></td>
                                <td><xsl:value-of select="string[@key = 'embargo']"/></td>
                            </tr>
                        </xsl:for-each>
                    </table>
                </xsl:if>

                <p class="footer">Public metadata only. Private fields and restricted files are not included.</p>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
