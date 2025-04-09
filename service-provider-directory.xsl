<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:re="http://www.realestate-platform.com/schema">

    <xsl:output method="html" indent="yes"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>Service Provider Directory</title>
                <style>
                    body { 
                        font-family: Arial, sans-serif; 
                        margin: 20px;
                        background: #f8fafc;
                    }
                    .container {
                        max-width: 1200px;
                        margin: 0 auto;
                        padding: 20px;
                    }
                    .provider-card { 
                        border: 1px solid #e2e8f0; 
                        margin: 15px 0; 
                        padding: 20px;
                        border-radius: 8px;
                        background: white;
                        box-shadow: 0 1px 3px rgba(0,0,0,0.1);
                    }
                    .service-list {
                        display: grid;
                        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                        gap: 15px;
                        margin-top: 15px;
                    }
                    .service-item {
                        background: #f7fafc;
                        padding: 15px;
                        border-radius: 5px;
                        border: 1px solid #e2e8f0;
                    }
                    .rating {
                        color: #2c5282;
                        font-weight: bold;
                        margin: 10px 0;
                        padding: 10px;
                        background: #f7fafc;
                        border-radius: 5px;
                    }
                    .certification {
                        background: #e6fffa;
                        padding: 10px;
                        margin: 5px 0;
                        border-radius: 3px;
                    }
                    .contact-info {
                        background: #f0fff4;
                        padding: 15px;
                        margin: 10px 0;
                        border-radius: 5px;
                    }
                    .filters {
                        margin: 20px 0;
                        padding: 15px;
                        background: white;
                        border-radius: 8px;
                        box-shadow: 0 1px 2px rgba(0,0,0,0.05);
                    }
                    select {
                        padding: 8px;
                        border-radius: 4px;
                        border: 1px solid #e2e8f0;
                        width: 200px;
                    }
                    h1 {
                        color: #2d3748;
                        margin-bottom: 1em;
                    }
                    h2 {
                        color: #2c5282;
                        margin: 0 0 1em 0;
                    }
                    h3 {
                        color: #4a5568;
                        margin: 1em 0 0.5em 0;
                    }
                    .service-type {
                        display: inline-block;
                        background: #ebf8ff;
                        color: #2c5282;
                        padding: 4px 8px;
                        border-radius: 4px;
                        font-size: 0.9em;
                    }
                    .price {
                        color: #2c5282;
                        font-weight: bold;
                    }
                    .rating-score {
                        color: #d69e2e;
                        font-size: 1.2em;
                    }
                </style>
            </head>
            <body>
                <div class="container">
                    <h1>Service Provider Directory</h1>
                    <div class="filters">
                        <h3>Filter by Service Type</h3>
                        <select id="serviceTypeFilter">
                            <option value="">All Services</option>
                            <xsl:for-each select="//re:serviceProvider/re:serviceType[not(. = preceding::re:serviceType)]">
                                <option value="{.}"><xsl:value-of select="."/></option>
                            </xsl:for-each>
                        </select>
                    </div>
                    <xsl:apply-templates select="//re:serviceProvider"/>
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="re:serviceProvider">
        <div class="provider-card">
            <h2><xsl:value-of select="re:n"/></h2>
            <p class="service-type"><xsl:value-of select="re:serviceType"/></p>
            <p><xsl:value-of select="re:description"/></p>

            <div class="contact-info">
                <h3>Contact Information</h3>
                <p>
                    Email: <xsl:value-of select="re:contactInfo/re:email"/><br/>
                    Phone: <xsl:value-of select="re:contactInfo/re:phone"/><br/>
                    Preferred Contact: <xsl:value-of select="re:contactInfo/re:preferredContactMethod"/>
                </p>
            </div>

            <div class="ratings">
                <h3>Ratings</h3>
                <xsl:choose>
                    <xsl:when test="re:ratings/re:rating">
                        <xsl:for-each select="re:ratings/re:rating">
                            <div class="rating">
                                <span class="rating-score">★ <xsl:value-of select="re:score"/>/5</span>
                                <p><xsl:value-of select="re:comment"/></p>
                                <small>Date: <xsl:value-of select="re:date"/></small>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <p>No ratings yet</p>
                    </xsl:otherwise>
                </xsl:choose>
            </div>

            <div class="certifications">
                <h3>Certifications</h3>
                <xsl:choose>
                    <xsl:when test="re:certifications/re:certification">
                        <xsl:for-each select="re:certifications/re:certification">
                            <div class="certification">
                                <strong><xsl:value-of select="re:name"/></strong><br/>
                                Issued by: <xsl:value-of select="re:issuingBody"/><br/>
                                Issue Date: <xsl:value-of select="re:issueDate"/>
                                <xsl:if test="re:expiryDate">
                                    <br/>Expires: <xsl:value-of select="re:expiryDate"/>
                                </xsl:if>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <p>No certifications listed</p>
                    </xsl:otherwise>
                </xsl:choose>
            </div>

            <div class="services">
                <h3>Available Services</h3>
                <div class="service-list">
                    <xsl:for-each select="re:services/re:service">
                        <div class="service-item">
                            <h4><xsl:value-of select="re:n"/></h4>
                            <p><xsl:value-of select="re:description"/></p>
                            <p class="price">Price: $<xsl:value-of select="format-number(re:price, '#,##0')"/></p>
                            <xsl:if test="re:duration">
                                <p>Duration: <xsl:value-of select="re:duration"/></p>
                            </xsl:if>
                        </div>
                    </xsl:for-each>
                </div>
            </div>
        </div>
    </xsl:template>

</xsl:stylesheet> 