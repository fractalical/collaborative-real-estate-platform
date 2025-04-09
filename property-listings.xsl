<?xml version="1.0" encoding="UTF-8"?>
<!-- This XSLT creates a property listings page with detailed property information -->
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:re="http://www.realestate-platform.com/schema">

    <xsl:output method="html" indent="yes"/>

    <!-- Main template sets up the listings page layout -->
    <xsl:template match="/">
        <html xmlns:re="http://www.realestate-platform.com/schema">
            <head>
                <title>Property Listings</title>
                <style>
                    body { font-family: Arial, sans-serif; margin: 20px; }
                    .property { border: 1px solid #ccc; margin: 10px; padding: 15px; border-radius: 5px; }
                    .price { color: #2c5282; font-size: 1.2em; font-weight: bold; }
                    .features { margin-top: 10px; }
                    .amenities { color: #4a5568; }
                    .status { 
                        display: inline-block;
                        padding: 5px 10px;
                        border-radius: 3px;
                        font-weight: bold;
                    }
                    .status-available { background-color: #c6f6d5; color: #2f855a; }
                    .status-under-contract { background-color: #feebc8; color: #c05621; }
                    img { 
                        max-width: 300px; 
                        margin: 10px 0; 
                        border: 1px solid #e2e8f0;
                        border-radius: 5px;
                    }
                    .image-container {
                        position: relative;
                        display: inline-block;
                    }
                    .image-fallback {
                        width: 300px;
                        height: 200px;
                        background-color: #f7fafc;
                        border: 1px solid #e2e8f0;
                        border-radius: 5px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: #718096;
                        font-style: italic;
                    }
                </style>
            </head>
            <body>
                <h1>Available Properties</h1>
                <xsl:apply-templates select="/re:realEstatePlatform/properties/property"/>
            </body>
        </html>
    </xsl:template>

    <!-- Template for displaying individual property details -->
    <xsl:template match="property">
        <div class="property">
            <h2><xsl:value-of select="title"/></h2>
            <div>
                <span class="status">
                    <xsl:attribute name="class">
                        status <xsl:choose>
                            <xsl:when test="@status='AVAILABLE'">status-available</xsl:when>
                            <xsl:otherwise>status-under-contract</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:value-of select="@status"/>
                </span>
            </div>
            <p><xsl:value-of select="description"/></p>
            
            <div class="location">
                <h3>Location</h3>
                <p>
                    <xsl:value-of select="address/street"/><br/>
                    <xsl:value-of select="address/city"/>, 
                    <xsl:value-of select="address/state"/>, 
                    <xsl:value-of select="address/postalCode"/>
                </p>
            </div>

            <div class="details">
                <h3>Property Details</h3>
                <ul>
                    <li>Type: <xsl:value-of select="propertyDetails/propertyType"/></li>
                    <li>Bedrooms: <xsl:value-of select="propertyDetails/bedrooms"/></li>
                    <li>Bathrooms: <xsl:value-of select="propertyDetails/bathrooms"/></li>
                    <li>Total Area: <xsl:value-of select="propertyDetails/totalArea"/> sq ft</li>
                </ul>
            </div>

            <div class="price">
                <xsl:choose>
                    <xsl:when test="@listingType='RENT'">
                        $<xsl:value-of select="format-number(pricing/monthlyRent, '#,##0')"/> per month
                    </xsl:when>
                    <xsl:otherwise>
                        $<xsl:value-of select="format-number(pricing/listPrice, '#,##0')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>

            <div class="features">
                <h3>Features</h3>
                <div class="amenities">
                    <xsl:for-each select="features/amenities/amenity">
                        <span style="margin-right: 10px;">• <xsl:value-of select="."/></span>
                    </xsl:for-each>
                </div>
            </div>

            <xsl:if test="media/images/image[@isPrimary='true']">
                <div class="images">
                    <div class="image-container">
                        <img>
                            <xsl:attribute name="src">
                                <xsl:value-of select="media/images/image[@isPrimary='true']/url"/>
                            </xsl:attribute>
                            <xsl:attribute name="alt">
                                <xsl:value-of select="concat(title, ' - ', media/images/image[@isPrimary='true']/caption)"/>
                            </xsl:attribute>
                            <xsl:attribute name="onerror">
                                this.style.display='none';
                                this.nextElementSibling.style.display='flex';
                            </xsl:attribute>
                        </img>
                        <div class="image-fallback" style="display: none;">
                            <span>Image not available</span>
                        </div>
                    </div>
                </div>
            </xsl:if>
        </div>
    </xsl:template>

</xsl:stylesheet> 