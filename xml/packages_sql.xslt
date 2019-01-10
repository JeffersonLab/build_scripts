<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="package">  
INSERT INTO package SET name="<xsl:value-of select="@name"/>";
</xsl:template>

</xsl:stylesheet>
