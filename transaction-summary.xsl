<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:re="http://www.realestate-platform.com/schema">

    <xsl:output method="html" indent="yes"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>Transaction Summary Report</title>
                <style>
                    body { font-family: Arial, sans-serif; margin: 20px; }
                    .transaction { 
                        border: 1px solid #e2e8f0; 
                        margin: 20px 0; 
                        padding: 20px;
                        border-radius: 5px;
                    }
                    .section { margin: 15px 0; }
                    .timeline { 
                        border-left: 2px solid #cbd5e0;
                        padding-left: 20px;
                        margin-left: 10px;
                    }
                    .timeline-event {
                        position: relative;
                        margin-bottom: 15px;
                    }
                    .timeline-event:before {
                        content: '';
                        width: 10px;
                        height: 10px;
                        background: #4299e1;
                        border-radius: 50%;
                        position: absolute;
                        left: -26px;
                        top: 5px;
                    }
                    .status-badge {
                        display: inline-block;
                        padding: 5px 10px;
                        border-radius: 3px;
                        font-weight: bold;
                        background: #ebf8ff;
                        color: #2c5282;
                    }
                    .documents { 
                        background: #f7fafc;
                        padding: 15px;
                        border-radius: 5px;
                    }
                    .financials {
                        background: #f0fff4;
                        padding: 15px;
                        border-radius: 5px;
                    }
                </style>
            </head>
            <body>
                <h1>Transaction Summary Report</h1>
                <xsl:apply-templates select="//re:realEstatePlatform/transactions/transaction"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="transaction">
        <div class="transaction">
            <h2>Transaction #<xsl:value-of select="transactionId"/></h2>
            
            <div class="section">
                <span class="status-badge">
                    <xsl:value-of select="status"/>
                </span>
                <p>Type: <xsl:value-of select="transactionType"/></p>
            </div>

            <div class="section">
                <h3>Property Information</h3>
                <xsl:variable name="propertyId" select="propertyId"/>
                <xsl:apply-templates select="//re:realEstatePlatform/properties/property[propertyId=$propertyId]"/>
            </div>

            <div class="section financials">
                <h3>Financial Details</h3>
                <p>
                    <strong>Price:</strong> $<xsl:value-of select="format-number(financials/price, '#,##0')"/><br/>
                    <strong>Payment Method:</strong> <xsl:value-of select="financials/paymentMethod"/>
                </p>
                
                <xsl:if test="financials/financingDetails">
                    <div>
                        <h4>Financing Information</h4>
                        <p>
                            Lender: <xsl:value-of select="financials/financingDetails/lender"/><br/>
                            Loan Amount: $<xsl:value-of select="format-number(financials/financingDetails/loanAmount, '#,##0')"/><br/>
                            Interest Rate: <xsl:value-of select="financials/financingDetails/interestRate"/>%<br/>
                            Term: <xsl:value-of select="financials/financingDetails/term"/> months
                        </p>
                    </div>
                </xsl:if>

                <h4>Fees</h4>
                <ul>
                    <xsl:for-each select="financials/fees/fee">
                        <li>
                            <strong><xsl:value-of select="type"/>:</strong>
                            $<xsl:value-of select="format-number(amount, '#,##0')"/>
                            <xsl:if test="description">
                                - <xsl:value-of select="description"/>
                            </xsl:if>
                        </li>
                    </xsl:for-each>
                </ul>
            </div>

            <div class="section documents">
                <h3>Documents</h3>
                <ul>
                    <xsl:for-each select="documents/document">
                        <li>
                            <strong><xsl:value-of select="title"/></strong>
                            (<xsl:value-of select="type"/>)<br/>
                            Status: <xsl:value-of select="status"/><br/>
                            Uploaded: <xsl:value-of select="uploadDate"/>
                            <xsl:if test="signedBy">
                                <br/>Signed by: <xsl:value-of select="signedBy"/>
                            </xsl:if>
                        </li>
                    </xsl:for-each>
                </ul>
            </div>

            <div class="section">
                <h3>Timeline</h3>
                <div class="timeline">
                    <xsl:for-each select="timeline/event">
                        <div class="timeline-event">
                            <strong><xsl:value-of select="type"/></strong><br/>
                            Date: <xsl:value-of select="date"/><br/>
                            <xsl:value-of select="description"/><br/>
                            Status: <xsl:value-of select="status"/>
                            <xsl:if test="responsibleParty">
                                <br/>Responsible: <xsl:value-of select="responsibleParty"/>
                            </xsl:if>
                        </div>
                    </xsl:for-each>
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="property">
        <div>
            <p>
                <strong><xsl:value-of select="title"/></strong><br/>
                <xsl:value-of select="address/street"/><br/>
                <xsl:value-of select="address/city"/>, 
                <xsl:value-of select="address/state"/> 
                <xsl:value-of select="address/postalCode"/>
            </p>
        </div>
    </xsl:template>

</xsl:stylesheet> 