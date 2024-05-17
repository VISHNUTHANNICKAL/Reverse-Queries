IF OBJECT_ID('tempdb..#PAYOFF_AGING_TABLE') IS NOT NULL
DROP TABLE #PAYOFF_AGING_TABLE;			
			
SELECT A.LOAN_SKEY, B.loan_status_description as 'LOAN STATUS',b.loan_sub_status_description as 'LOAN SUB STATUS'
,A.ALERT_TYPE_DESCRIPTION, FORMAT(A.ALERT_DATE,'d','us') AS ALERT_DATE,			
       FORMAT(A.CREATED_DATE,'d','us') AS CREATED_DATE, FORMAT(A.MODIFIED_DATE,'d','us') AS MODIFIED_DATE,			
	   B.SERVICER_NAME, B.INVESTOR_NAME, C.STATE_CODE,		
	   DATEDIFF(DD,A.ALERT_DATE,A.MODIFIED_DATE) - DATEDIFF(WW,A.ALERT_DATE,A.MODIFIED_DATE)*2		
       - CASE			
       WHEN DATEPART(WEEKDAY,A.ALERT_DATE) IN (1, 7) THEN 1 ELSE 0			
       END			
       - CASE			
       WHEN DATEPART(WEEKDAY,A.MODIFIED_DATE) IN (1, 7) THEN 1 ELSE 0			
       END AS PAYOFF_AGING
	   ,d.column_name,d.original_value,d.new_value, d.created_date as created_dt
	   INTO #PAYOFF_AGING_TABLE			
 FROM reversequest.RMS.V_ALERT A			
 LEFT JOIN reversequest.RMS.V_LOANMASTER B ON A.LOAN_SKEY = B.LOAN_SKEY			
 LEFT JOIN reversequest.RMS.V_PROPERTYMASTER C ON A.LOAN_SKEY = C.LOAN_SKEY		
 join [ReverseQuest]. [rms].[v_LogColumnDataChange]  D
 on A.loan_skey	= D.loan_skey 
WHERE UPPER(A.ALERT_TYPE_DESCRIPTION) = 'PAYOFF QUOTE - NEW REQUEST RECEIVED'			
AND A.ALERT_STATUS_DESCRIPTION = 'INACTIVE' AND 
--A.CREATED_DATE  
A.modified_date
>=    dateadd(d,-1,dateadd(mm,datediff(m,0,getdate()),1 )) 
-- >=DATEADD(m, DATEDIFF(m, 0, GETDATE())-1, 0)
 AND 
 A.modified_date
 --< dateadd(d,-1,dateadd(mm,datediff(m,0,getdate()),1 )) 
-- >=select DATEADD(m, DATEDIFF(m, 0, GETDATE())-1, 0)
 --select DATEADD(MM,DATEDIFF(MM, -1, getdate())-1,-1)
<  DATEADD(DAY, DATEDIFF(DAY, -0, GETDATE()+1), 0)
--< '2022-08-01 00:00:00.000'
and  column_name in( 'loan_status')
;			

/*
select * from #PAYOFF_AGING_TABLE;
		
		IF OBJECT_ID('tempdb..#rtemp1') IS NOT NULL
    DROP TABLE #rtemp1;
select * into #rtemp1 from 
(select ROW_NUMBER() OVER (PARTITION BY loan_skey,column_name ORDER BY created_dt desc) rn,* from #PAYOFF_AGING_TABLE) q
WHERE   rn = 1;
select loan_skey,column_name,original_value,new_value, created_dt as 'change date' from #rtemp1 order by loan_skey,rn;
*/
/*SELECT A.loan_skey,A.[LOAN STATUS],a.[LOAN SUB STATUS],a.alert_type_description,a.ALERT_DATE,a.CREATED_DATE,a.MODIFIED_DATE,a.servicer_name,a.investor_name,a.state_code,a.PAYOFF_AGING
,a.column_name
,a.original_value,a.new_value,a.created_dt as 'change date'
       ,CASE WHEN PAYOFF_AGING <= 5 THEN '0-5 DAYS'			
	        WHEN PAYOFF_AGING <= 7 THEN '6-7 DAYS'		
			WHEN PAYOFF_AGING <= 10 THEN '7-10 DAYS'
	        ELSE 'GT 10 DAYS' END AS AGE_BUCKET, CONCAT(DATEPART(MM,A.CREATED_DATE),'-',DATEPART(YY,A.CREATED_DATE)) AS MONTH
			FROM 
			#PAYOFF_AGING_TABLE A
			--#rtemp1 A;*/

---------------------------------------------------------------------------
select loan_skey,column_name,original_value,new_value,created_dt as 'change date'
from #PAYOFF_AGING_TABLE
