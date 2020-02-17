<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output omit-xml-declaration="yes" method="text"/>
<xsl:template match="package"><xsl:value-of select="@docName"/> &amp; {\tt <xsl:value-of select="@homeVar"/>} \\</xsl:template>
</xsl:stylesheet>
