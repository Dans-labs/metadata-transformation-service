<?xml version="1.0" encoding="UTF-8"?>
<!--
    Builds the per-file Dataverse metadata (the "jsonData" sent with each file upload),
    keyed by file name, from the "file-metadata" array in the form JSON.

    The JSON is built as an XPath map and serialized, so quotes, backslashes, ampersands
    and non-ASCII characters in file names and labels are escaped correctly, and there
    is no manual comma handling.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    exclude-result-prefixes="xs map" version="3.0">

    <xsl:output method="text" encoding="UTF-8"/>

    <!-- Dataverse category used by ACP to recognise generated files (see __reingest_files) -->
    <xsl:variable name="generated-category" select="'__generated__files'"/>
    <xsl:variable name="form-file-prefix" select="'__generated__form-metadata-'"/>
    <xsl:variable name="metadata-folder" select="'Oral History metadata'"/>

    <!-- Generated files known by name. Kept for safety: ACP also marks every generated
         file with state = 'generated', which is what covers e.g. the merged PDFs. -->
    <xsl:variable name="known-generated-names" select="(
        'Oral History metadata private.txt',
        'Oral History metadata public.txt',
        'Oral History metadata private.pdf',
        'Oral History metadata public.pdf')"/>

    <xsl:template match="data">
        <xsl:apply-templates select="json-to-xml(.)"/>
    </xsl:template>

    <xsl:template match="/map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">

        <xsl:variable name="entries" as="map(*)*">
                <xsl:for-each select="array[@key = 'file-metadata']/map">
                    <xsl:variable name="name" select="string(string[@key = 'name'])"/>
                    <xsl:variable name="private" select="string(boolean[@key = 'private'])"/>
                    <xsl:variable name="embargo" select="string(string[@key = 'embargo'])"/>

                    <xsl:variable name="is-form-file" select="starts-with($name, $form-file-prefix)"/>
                    <xsl:variable name="is-generated" select="
                        $is-form-file
                        or string[@key = 'state'] = 'generated'
                        or $name = $known-generated-names"/>

                    <xsl:variable name="description" select="
                        if (map[@key = 'role'])
                        then concat('Role: ', map[@key = 'role']/string[@key = 'label'])
                        else ''"/>

                    <xsl:variable name="directory-label" select="
                        if ($is-form-file) then $generated-category
                        else if ($is-generated) then $metadata-folder
                        else ''"/>

                    <xsl:sequence select="
                        map:entry($name, map:merge((
                            map {
                                'description': $description,
                                'directoryLabel': $directory-label,
                                'categories': array { if ($is-generated) then $generated-category else () },
                                'tabIngest': 'false'
                            },
                            if ($private = ('true', 'false'))
                                then map { 'restrict': $private } else (),
                            if ($embargo != '')
                                then map { 'embargo': $embargo, 'embargo-reason': '' } else ()
                        )))"/>
                </xsl:for-each>
        </xsl:variable>

        <!-- If a file name occurs twice, the last entry wins (instead of an error) -->
        <xsl:variable name="files" select="map:merge($entries, map { 'duplicates': 'use-last' })"/>

        <xsl:sequence select="serialize($files, map { 'method': 'json', 'indent': true() })"/>
    </xsl:template>

</xsl:stylesheet>
