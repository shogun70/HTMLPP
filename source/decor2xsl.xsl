<?xml version="1.0" encoding="UTF-8"?>
<!-- Copyright 2012 Sean Hogan (http://meekostuff.net/) -->

<xsl:stylesheet version="1.0" exclude-result-prefixes="xsl"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dxsl="http://www.w3.org/1999/XSL/TransformAlias">

<xsl:namespace-alias stylesheet-prefix="dxsl" result-prefix="xsl"/>

<xsl:output method="xml" omit-xml-declaration="no" cdata-section-elements=""/>

<xsl:template match="@*|node()">
	<xsl:copy>
		<xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="/">
	<dxsl:stylesheet version="1.0" exclude-result-prefixes="dxsl"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<dxsl:output method="html" omit-xml-declaration="yes" 
		cdata-section-elements="" />

	<dxsl:template match="@*|node()">
		<dxsl:copy>
			<dxsl:apply-templates select="@*|node()"/>
		</dxsl:copy>
	</dxsl:template>

	<dxsl:template match="head">
		<dxsl:copy>
			<xsl:apply-templates select="/html/head/*" />
			<dxsl:apply-templates select="@*|node()"/>
		</dxsl:copy>
	</dxsl:template>

	<dxsl:template match="body">
		<dxsl:copy>
			<dxsl:apply-templates select="@*"/>
			<xsl:apply-templates select="/html/body/*" />
		</dxsl:copy>
	</dxsl:template>
	
	</dxsl:stylesheet>
</xsl:template>

<xsl:template match="head/*">
	<xsl:copy-of select="."/>
</xsl:template>

<xsl:template match="head/title">
	<dxsl:if test="not(/html/head/title)">
		<xsl:copy-of select="."/>
	</dxsl:if>
</xsl:template>

<xsl:template match="head/meta[@http-equiv]">
</xsl:template>

<xsl:template match="body//*[@id]">
	<xsl:param name="ID" select="@id" />
	<xsl:param name="target">/html/body/*[@id='<xsl:value-of select="$ID"/>'][1]</xsl:param>
	<dxsl:choose>
		<dxsl:when>
			<xsl:attribute name="test"><xsl:value-of select="$target"/></xsl:attribute>
			<dxsl:copy-of>
				<xsl:attribute name="select"><xsl:value-of select="$target"/></xsl:attribute>
			</dxsl:copy-of>
		</dxsl:when>
		<dxsl:otherwise>
			<xsl:copy>
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
		</dxsl:otherwise>
	</dxsl:choose>
</xsl:template>
	
</xsl:stylesheet>
