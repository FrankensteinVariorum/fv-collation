<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.tei-c.org/ns/1.0"  
    xmlns:mith="http://mith.umd.edu/sc/ns1#"
    xmlns:pitt="https://github.com/ebeshero/Pittsburgh_Frankenstein"
    xmlns:th="http://www.blackmesatech.com/2017/nss/trojan-horse" exclude-result-prefixes="#all">
<!--2018-07-23 ebb: Adapted from the raising repo. Run at command line here specifying Bridge-P3 input and Bridge-P4 output directories with
        
    
    -->
    <!--* Setup *-->
    <xsl:output method="xml" indent="no"/>

    <!--* Experimental:  try adding a key *-->
    <xsl:key name="start-markers" match="*[@th:sID]" use="@th:sID"/>
    <xsl:key name="end-markers" match="*[@th:eID]" use="@th:eID"/>

<!--    <xsl:variable name="novel"
        as="document-node()+"
        select="collection('../input/frankenstein/novel-coll/')"/>  -->

    <!--* In all modes, do a shallow copy, suppress namespace nodes,
	* and recur in default (unnamed) mode. *-->
    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <!--* th:raise(.):  raise all innermost elements within the document
	passed as parameter *-->
    <xsl:function name="th:raise">
        <xsl:param name="input" as="document-node()"/>
        <xsl:message>raise() called with <xsl:value-of select="count($input//*)"/>-element document (<xsl:value-of select="count($input//*[@th:sID])"/> Trojan pairs)</xsl:message>
        <xsl:choose>
            <xsl:when test="exists($input//*[@th:sID eq following-sibling::*[@th:eID][1]/@th:eID])">
                <!--* If we have more work to do, do it *-->
                <xsl:variable name="result" as="document-node()">
                    <xsl:document>
                        <xsl:apply-templates select="$input" mode="loop"/>
                    </xsl:document>
                </xsl:variable>
                <xsl:sequence select="th:raise($result)"/>
            </xsl:when>
            <xsl:otherwise>
                <!--* We have no more work to do, return the input unchanged. *-->
                <xsl:message>raise() returning.</xsl:message>
                <xsl:sequence select="$input"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!--* On the input document node, call th:raise() *-->
    <xsl:template match="/">
        <xsl:sequence select="th:raise(.)"/>
    </xsl:template>

    <!--* Loop mode (applies to document node only). *-->
    <!--* Loop mode for document node:  just apply templates in
	default unnamed mode. *-->
    <xsl:template match="/" mode="loop">
        <xsl:apply-templates/>
    </xsl:template>

    <!--* Innermost start-marker *-->
    <xsl:template
        match="
            *[@th:sID eq
            following-sibling::*[@th:eID][1]/@th:eID]">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@* except @th:sID"/>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="@th:sID"/>
            </xsl:attribute>
            <!-- content of raised element; no foreign end-markers
		 here (but possibly start-markers); just copy the
		 nodes -->

            <!--* v.Prev had:
            <xsl:copy-of
                select="following-sibling::node()[following-sibling::*[@th:eID eq current()/@th:sID]]"
		/>
		but this requires the processor to scan all following
		siblings, not just those up to the end-marker, because
		the processor cannot know that the th:eID value won't
		repeat.
		
		It might do better with
		select="following-sibling::node()[not(preceding-sibling::*[@th:eID eq current()/@th:sID])]"
		but it's simpler to be more obvious:
		*-->
            <xsl:variable name="end-marker" as="element()" select="key('end-markers', @th:sID)"/>
            <xsl:copy-of select="following-sibling::node()[. &lt;&lt; $end-marker]"/>
        </xsl:copy>
    </xsl:template>

    <!-- nodes inside new wrapper:  do nothing -->
    <xsl:template
        match="node()[preceding-sibling::*[@th:sID][1]/@th:sID eq following-sibling::*[@th:eID][1]/@th:eID]"/>

    <!-- end-tag for new wrapper -->
    <xsl:template match="*[@th:eID eq preceding-sibling::*[@th:sID][1]/@th:sID]"/>

</xsl:stylesheet>
