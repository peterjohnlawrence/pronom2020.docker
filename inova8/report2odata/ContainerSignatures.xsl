<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0">
    <!-- The input JSON file -->
    <xsl:param name="ContainerSignature" select="'url to json file'"/>
    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
    <xsl:template match="data">
        <!--      Used to output raw trabnsformation to make it easier to navigate tree -->
        <!--                <xsl:copy-of select="json-to-xml(.)"/>-->
        <xsl:apply-templates select="json-to-xml(.)"/>
    </xsl:template>

    <xsl:template match="map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">

        <xsl:apply-templates select="array[@key = 'value']/map"/>

    </xsl:template>
    <xsl:template match="array[@key = 'value']/map"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <ContainerSignature>
            <xsl:attribute name="Id">
                <xsl:value-of select="number[@key = 'containerSignature_ID']"/>
            </xsl:attribute>
            <xsl:attribute name="ContainerType">
                <xsl:value-of select="array[@key = 'containerSignature_ContainerType']/map/string[@key = 'label']"/>
            </xsl:attribute>
            <Description>
                <xsl:value-of select="string[@key = 'comment']"/>
            </Description>
            <Files>
                <xsl:apply-templates select="array[@key = 'containerSignature_ContainerFile']/map">
                    <xsl:with-param name="Id" select="number[@key = 'containerSignature_ID']"/>
                </xsl:apply-templates>
            </Files>
        </ContainerSignature>
    </xsl:template>
    <xsl:template match="array[@key = 'containerSignature_ContainerFile']/map"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:param name="Id"/>
        <File>
            <Path>
                <xsl:value-of select="string[@key = 'containerFile_FilePath']"/>
            </Path>
            <xsl:apply-templates select="array[@key = 'containerFile_ByteSequence']">
            </xsl:apply-templates>
        </File>
    </xsl:template>
    <xsl:template match="array[@key = 'containerFile_ByteSequence']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <BinarySignatures>
            <InternalSignatureCollection>
				<xsl:for-each-group select="map" group-by="number[@key = 'internalSignature_ID']"> 
                <InternalSignature>
                    <xsl:attribute name="Id">
                        <xsl:value-of select="number[@key = 'internalSignature_ID']"/> 
						 <!-- <xsl:value-of select="current-grouping-key()"/> -->
                    </xsl:attribute>
                    <ByteSequence >
						<xsl:attribute name="Reference">
							<xsl:choose>  
								<xsl:when test="map[@key = 'byteSequence_ByteSequencePosition']/string[@key = 'label']  = 'Absolute from BOF'">
									<xsl:value-of select="'BOFoffset'"/> 
								</xsl:when>
								<xsl:otherwise> 
									<xsl:value-of select="'Unknown'"/> 
								 </xsl:otherwise> 
							</xsl:choose> 
						</xsl:attribute> 
					<xsl:for-each select="current-group()">  
                        <SubSequence>
							<xsl:attribute name="Position">
                                <xsl:value-of select="number[@key = 'byteSequence_Position']"/>
                            </xsl:attribute>
                            <xsl:attribute name="SubSeqMaxOffset">
                                <xsl:value-of select="number[@key = 'byteSequence_MaxOffset']"/>
                            </xsl:attribute>
                            <xsl:attribute name="SubSeqMinOffset">
                                <xsl:value-of select="number[@key = 'byteSequence_Offset']"/>
                            </xsl:attribute>
                            <Sequence>
                                <xsl:value-of select="string[@key = 'byteSequence_Value']"/>
                            </Sequence>
                        </SubSequence>
					</xsl:for-each> 

                    </ByteSequence>
                    <!-- <xsl:apply-templates select="string[@key = 'comment']"/> -->
                </InternalSignature>
				</xsl:for-each-group>  
            </InternalSignatureCollection> 
        </BinarySignatures>
    </xsl:template>
</xsl:stylesheet>
