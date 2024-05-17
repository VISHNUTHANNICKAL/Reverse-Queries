DROP TABLE #INVESTOR_MATRIX;

CREATE TABLE #INVESTOR_MATRIX (SERVICER_NAME NVARCHAR(200), INVESTOR_NAME NVARCHAR(200),
             AMC_ALERT NVARCHAR(1), PRIVACY_CATEGORY NVARCHAR(50));

INSERT INTO #INVESTOR_MATRIX (SERVICER_NAME, INVESTOR_NAME, AMC_ALERT, PRIVACY_CATEGORY)
VALUES 
('American National Bank','American National Bank','N','Private Label'),
('Citizens First Wholesale Mortgage Co.','Fannie Mae','N','Private Label'),
('Ent Credit Union','Ent CU','N','Private Label'),
('GTE Federal Credit Union','GTE FCU','N','Private Label'),
('Mid-Hudson Valley Federal Credit Union','Mid Hudson Valley FCU','N','Private Label'),
('Moneyhouse','Moneyhouse','N','Private Label'),
('PHH Mortgage Corporation','PHH Mortgage Services','N','Liberty'),
('PHH Mortgage Services','Blue Plains Trust','N','PHH Investor'),
('PHH Mortgage Services','Seattle Bank Texas Insured','N','Seattle Bank'),
('PHH Mortgage Services','FNMA','Y','MAM'),
('PHH Mortgage Services','Cascade Funding Mortgage Trust - HB2','Y','MAM'),
('PHH Mortgage Services','SHAP Acquisitions Trust HB2 Nomura','Y','MAM'),
('PHH Mortgage Services','WV POG RM Grantor Trust','Y','MAM'),
('PHH Mortgage Services','SHAP Acquisitions Trust HB3 CS','Y','MAM'),
('PHH Mortgage Services','Cascade Funding Mortgage Trust - HB4','Y','MAM'),
('PHH Mortgage Services','SMS Financial NCU','N','SMS Financial'),
('PHH Mortgage Services','Cascade Funding Mortgage Trust 2018-RM2','Y','MAM'),
('PHH Mortgage Services','MECA 2007-FF1','Y','MAM'),
('PHH Mortgage Services','TRM, LLC','N','PHH Investor'),
('PHH Mortgage Services','Reverse Mortgage Solutions, Inc. 2018-09','Y','MAM'),
('PHH Mortgage Services','Reverse Mortgage Solutions, Inc.','Y','MAM'),
('PHH Mortgage Services','MECA 2007-FF2','Y','MAM'),
('PHH Mortgage Services','Seattle Mortgage Company ','N','Seattle Bank'),
('PHH Mortgage Services','Low Valley Trust','N','PHH Investor'),
('PHH Mortgage Services','Bank of America','Y','MAM'),
('PHH Mortgage Services','SHAP Acquisitions Trust HB1','Y','MAM'),
('PHH Mortgage Services','Cascade Funding Mortgage Trust - HB1','Y','MAM'),
('PHH Mortgage Services','Cascade Funding Mortgage Trust 2019 - RM3','Y','MAM'),
('PHH Mortgage Services','Cascade Funding RM1 Acquisitions Grantor Tr','Y','MAM'),
('PHH Mortgage Services','Cascade Funding Mortgage Trust - AB1','Y','MAM'),
('PHH Mortgage Services','Seattle Bank Uninsured','N','Seattle Bank'),
('PHH Mortgage Services','Mortgage Equity Conversion Asset Trust 2010-1','Y','MAM'),
('PHH Mortgage Services','NexBank SSB','N','NexBank'),
('PHH Mortgage Services','HB1 Alternative Holdings, LLC','Y','MAM'),
('PHH Mortgage Services','Fannie Mae','Y','MAM'),
('PHH Mortgage Services','Cascade Funding RM1 Alternative Holdings, LLC','Y','MAM'),
('PHH Mortgage Services','BoA Merrill Lynch','N','BAML'),
('PHH Mortgage Services','BAML','N','BAML'),
('PHH Mortgage Services','Cascade Funding Mortgage Trust - HB1 Alt Holdings','Y','MAM'),
('PHH Mortgage Services','Cascade Funding Mortgage Trust - HB5','Y','MAM'),
('PHH Mortgage Services','Midland National Life','N','Midland'),
('PHH Mortgage Services','Reverse Mortgage Loan Trust 2008-1','N','PHH Investor'),
('PHH Mortgage Services','Cascade Funding Mortgage Trust - HB7','Y','MAM'),
('PHH Mortgage Services','SHAP Acquisitions Trust HB1 Barclays','Y','MAM'),
('PHH Mortgage Services','Cascade Funding Mortgage Trust - HB3','Y','MAM'),
('PHH Mortgage Services','Cascade Funding RM4 Acquisitions Grantor Tr','Y','MAM'),
('PHH Mortgage Services','MECA Trust 2010-1','Y','MAM'),
('PHH Mortgage Services','MECA 2007-FF3','Y','MAM'),
('Suncoast Credit Union','Suncoast Credit Union','N','Private Label'),
('Teachers Federal Credit Union','Teachers FCU','N','Private Label'),
('Visions Federal Credit Union','Visions FCU','N','Private Label'),
('PHH Mortgage Corporation','FNMA','N','Liberty'),
('PHH Mortgage Services','Waterfall Victoria III-NB Grantor Trust','Y','MAM'),
('PHH Mortgage Services','F.N.M.A.','Y','MAM'),
('PHH Mortgage Services','First National Bank of Pennsylvania','N','Private Label'),
('PHH Mortgage Services','Cascade Funding Mortgage Trust - AB2','Y','MAM'),
('PHH Mortgage Services','MECA 2011','Y','MAM'),
('PHH Mortgage Services','Ivory Cove Trust','Y','MAM'),
('PHH Mortgage Services','WF BOA Repurchase','Y','MAM'),
('PHH Mortgage Services','Wells Fargo NA','Y','MAM'),
('PHH Mortgage Services','Guggenheim Life and Annuity Company GLAC','Y','MAM'),
('PHH Mortgage Services','Everbank 2008 AKA TIAA','Y','MAM'),
('PHH Mortgage Services','Everbank 2015 AKA TIAA','Y','MAM'),
('PHH Mortgage Services','Cascade Funding Mortgage Trust - HB8','Y','MAM'),
('PHH Mortgage Services','Mr Cooper HUD Reconveyance','Y','MAM'),
('PHH Mortgage Services','SHAP Acquisition Trust HB0','Y','MAM'),
('PHH Mortgage Services','HB2 Alternative Holdings, LLC','Y','MAM'),
('PHH Mortgage Services','Guggenheim Life and Annuity Company (GLAC)','Y','MAM'),
('PHH Mortgage Services','MAM Holdings','Y','MAM'),
('PHH Mortgage Services','VF1-NA Trust','Y','MAM'),
('PHH Mortgage Services','Cascade Funding Mortgage Trust - HB9','Y','MAM'),
('PHH Mortgage Services','Cascade Funding Mortgage Trust - HB10','Y','MAM'),
('PHH Mortgage Services','Home Preservation Partnership, LLC','N','Private Label'),
('PHH Mortgage Services','Cascade Funding Mortgage Trust – HB11','Y','MAM'),
('PHH PIF Portfolio','PIF Loans - Celink','N','N/A'),
('PHH Mortgage Corporation','Ocwen Loan Acquisition Trust 2023-HB1','N','PHH'),
('PHH Mortgage Services', 'Black Reef Trust', 'Y', 'Mortgage Assets Management, LLC'),
('PHH Mortgage Services', 'Riverview HECM Trust 2007-1', 'Y', 'Mortgage Assets Management, LLC'),
('PHH Mortgage Services', 'Wilmington Savings Fund Society FSB', 'Y', 'Mortgage Assets Management, LLC'),
('PHH Mortgage Services', 'RBS Financial Products fka Greenwich', 'Y', 'Mortgage Assets Management, LLC'),
('PHH Mortgage Services', 'Cascade Funding Mortgage Trust - HB11', 'Y', 'Mortgage Assets Management, LLC'),
('PHH Mortgage Services', 'Reverse Mortgage Loan Trust Series REV 2007-2', 'Y', 'Mortgage Assets Management, LLC'),
('PHH Mortgage Services', 'Rocktop Asset Management, LLC', 'Y', 'Mortgage Assets Management, LLC'),
('PHH Mortgage Services', 'SASCO 1999-RM1', 'Y', 'Mortgage Assets Management, LLC'),
('PHH Mortgage Services', 'NARRE Titling Trust', 'Y', 'Mortgage Assets Management, LLC'),
('PHH Mortgage Services', 'HPP Property, LLC', 'N', ' Reliant Trust, Series HPP2')
;

-- Missing Investor

SELECT DISTINCT A.SERVICER_NAME, A.INVESTOR_NAME
FROM RMS.V_LOANMASTER A
LEFT JOIN #INVESTOR_MATRIX B ON UPPER(A.SERVICER_NAME) = UPPER(B.SERVICER_NAME) AND UPPER(A.INVESTOR_NAME) = UPPER(B.INVESTOR_NAME)
WHERE UPPER(A.LOAN_STATUS_DESCRIPTION) IN ('ACTIVE','BANKRUPTCY','BNK/DEF','BNK/FCL','DEFAULT','FORECLOSURE')
      AND B.SERVICER_NAME IS NULL 
;

DROP TABLE #PRIVACY_CHECK;

SELECT DISTINCT A.* 
INTO #PRIVACY_CHECK
FROM
(SELECT A.LOAN_SKEY, B.MAIL_STATE_CODE AS MAIL_STATE, C.STATE_CODE AS PROP_STATE, A.SERVICER_NAME, A.INVESTOR_NAME,
        FORMAT(CLOSING_DATE,'d','us') AS CLOSING_DATE, FORMAT(A.FUNDED_DATE,'d','us') AS FUNDED_DATE,
              FORMAT(A.CREATED_DATE,'d','us') AS CREATED_DATE, A.LOAN_STATUS_DESCRIPTION, D.PRIVACY_CATEGORY,
              E.ALERT_STATUS_DESCRIPTION, E.ALERT_TYPE_DESCRIPTION, E.ALERT_NOTE, FORMAT(E.CREATED_DATE,'d','us') AS ALERT_DATE, E.CREATED_BY,
              CASE WHEN B.MAIL_STATE_CODE = 'CA' THEN 'CA'
                   WHEN C.STATE_CODE = 'CA' THEN 'CA'
                      ELSE 'OTHERS' END AS PRIVACY_ST
FROM RMS.V_LOANMASTER A
LEFT JOIN RMS.V_CONTACTMASTER B ON A.LOAN_SKEY = B.LOAN_SKEY AND UPPER(B.CONTACT_TYPE_DESCRIPTION) = 'BORROWER'
LEFT JOIN RMS.V_PROPERTYMASTER C ON A.LOAN_SKEY = C.LOAN_SKEY
LEFT JOIN #INVESTOR_MATRIX D ON A.SERVICER_NAME = D.SERVICER_NAME AND A.INVESTOR_NAME = D.INVESTOR_NAME
LEFT JOIN RMS.V_ALERT E ON A.LOAN_SKEY = E.LOAN_SKEY AND UPPER(E.ALERT_TYPE_DESCRIPTION) = 'PRIVACY NOTICE - OPT OUT RECEIVED'
                           AND UPPER(E.ALERT_STATUS_DESCRIPTION) = 'ACTIVE'
LEFT JOIN RMS.V_LOANDEFAULTINFORMATION F ON A.LOAN_SKEY = F.LOAN_SKEY
WHERE UPPER(A.LOAN_STATUS_DESCRIPTION) IN ('ACTIVE','BANKRUPTCY','BNK/DEF','BNK/FCL','DEFAULT','FORECLOSURE')
      AND F.DATE_FORECLOSURE_SALE_HELD IS NULL
) A
;

--Multiple Alerts
SELECT * FROM #PRIVACY_CHECK A
WHERE LOAN_SKEY IN (SELECT A.LOAN_SKEY FROM
(SELECT A.LOAN_SKEY, COUNT(A.LOAN_SKEY) AS COUNT
FROM #PRIVACY_CHECK A
GROUP BY A.LOAN_SKEY) A WHERE COUNT > 1)
;

-- No Alert
SELECT * FROM #PRIVACY_CHECK A
WHERE ALERT_TYPE_DESCRIPTION IS NULL AND CREATED_DATE < GETDATE() - 2
;

--Incorrect Format
SELECT * FROM #PRIVACY_CHECK A
WHERE UPPER(LEFT(LTRIM(A.ALERT_NOTE),8)) NOT IN ('B - PHH ','1 - PHH ','2 - PHH ','D - Cust ','0 - PHH ','F - This ','6 - PHH ',
       '7 - PHH ','8 - PHH ','9 - PHH ','A - Cust ','H - PHH ','I - PHH ','J - PHH ','K - PHH ','0 - PHH ','7- PHH P');

--Incorrect Opt Out Code
SELECT A.*, 'UPDATE 7' AS COMMENT FROM #PRIVACY_CHECK A
WHERE UPPER(LEFT(LTRIM(A.ALERT_NOTE),1)) <> '7' AND UPPER(PRIVACY_CATEGORY) IN ('MAM','MIDLAND NATIONAL LIFE (SFG)','RMS') AND PRIVACY_ST = 'CA'
UNION
SELECT A.*, 'UPDATE B' AS COMMENT  FROM #PRIVACY_CHECK A
WHERE UPPER(LEFT(LTRIM(A.ALERT_NOTE),1)) <> 'B'
      AND UPPER(PRIVACY_CATEGORY) IN ('MAM','MIDLAND NATIONAL LIFE (SFG)','RMS','NEXBANK SSB','HOWARD BANK','SEATTLE BANK','SMS FINANCIAL NCU')
         AND PRIVACY_ST <> 'CA'
UNION
SELECT A.*, 'UPDATE 9' AS COMMENT  FROM #PRIVACY_CHECK A
WHERE UPPER(LEFT(LTRIM(A.ALERT_NOTE),1)) <> '9'
      AND UPPER(PRIVACY_CATEGORY) IN ('NEXBANK SSB','HOWARD BANK','SEATTLE BANK','SMS FINANCIAL NCU') AND PRIVACY_ST = 'CA'
UNION
SELECT A.*, 'UPDATE F' AS COMMENT  FROM #PRIVACY_CHECK A
WHERE UPPER(LEFT(LTRIM(A.ALERT_NOTE),1)) <> 'F' AND PRIVACY_CATEGORY = 'PRIVATE LABEL'
UNION
SELECT A.*, 'INCORRECT STATE CODE' AS COMMENT  FROM #PRIVACY_CHECK A
WHERE UPPER(LEFT(LTRIM(A.ALERT_NOTE),1)) IN ('6','7','8','9','H','I','J','K','A') AND PRIVACY_ST = 'OTHERS'
UNION
SELECT A.*, 'INCORRECT STATE CODE' AS COMMENT  FROM #PRIVACY_CHECK A
WHERE UPPER(LEFT(LTRIM(A.ALERT_NOTE),1)) IN ('B','2','1','0','D') AND PRIVACY_ST = 'CA'
;

--Mailing Address VT and ND
SELECT A.LOAN_SKEY, A.AUDIT_TYPE_DESCRIPTION, A.ORIGINAL_VALUE, A.NEW_VALUE, A.CREATED_DATE AS CHANGE_DATE, B.LOAN_STATUS_DESCRIPTION
FROM [REVERSEQUEST].RMS.V_LOGCOLUMNDATACHANGE A
INNER JOIN [REVERSEQUEST].RMS.V_LOANMASTER B ON A.LOAN_SKEY = B.LOAN_SKEY
WHERE A.AUDIT_TYPE_DESCRIPTION = 'Borrower Mailing State Code' AND (A.NEW_VALUE IN ('North Dakota','Vermont') OR A.NEW_KEY IN ('ND','VT'))
AND A.CREATED_DATE > '01-OCT-2021' AND UPPER(B.LOAN_STATUS_DESCRIPTION) IN ('ACTIVE','BANKRUPTCY','BNK/DEF','BNK/FCL','DEFAULT','FORECLOSURE');
