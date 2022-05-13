<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="root">
        <artistProfile>
            <xsl:attribute name="artistName">
                <xsl:value-of select="./name" />
            </xsl:attribute>
            <globalListeners>
                <xsl:value-of select="./listeners" />
            </globalListeners>
            <globalPlays>
                <xsl:value-of select="./plays"/>
            </globalPlays>
            <topSong>
                <xsl:value-of select="./top"/>
            </topSong>
            <recommendations>
                <xsl:for-each select="//similar">
                    <recommend>
                        <artistName>
                            <xsl:value-of select="./name" />
                        </artistName>
                        <topSong>
                            <xsl:value-of select="./top" />
                        </topSong>
                        <globalPlays>
                            <xsl:value-of select="./plays" />
                        </globalPlays>
                    </recommend>
                </xsl:for-each>
            </recommendations>
            <biography>
                <xsl:value-of select="./bio" />
            </biography>
        </artistProfile>
    </xsl:template>
</xsl:stylesheet>