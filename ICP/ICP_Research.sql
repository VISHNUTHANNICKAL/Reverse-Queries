
IF OBJECT_ID('tempdb..#tempTbl1') IS NOT NULL
    DROP TABLE #tempTbl1;
SELECT  [loan_skey]
      ,[note_type_description]
	  ,[note_text]
      ,[created_date]
      ,[created_by]
	  into #tempTbl1
  FROM [ReverseQuest].[rms].[v_Note]
  where 
  (note_text like ('%Research Request Received%')
  or note_text like ('%Intake not completed%') or note_text like ('%Privacy Notice- Research Intake%') or note_text like ('%Research Response sent for QC%')
  or note_text like ('%Research response QC result%'))
   and note_type_description = 'Research Request'
  --where   loan_skey = '1930'
 and created_date >=  
--select DATEADD(DAY, DATEDIFF(DAY, 30, GETDATE()), 0)
--and created_date <=
--DATEADD(DAY, DATEDIFF(DAY, -0, GETDATE()), 0)
 dateadd(m,-1,dateadd(mm,datediff(m,0,getdate()),0 ))
 and created_date <     dateadd(m,0,dateadd(mm,datediff(m,0,getdate()),0 ))
;

IF OBJECT_ID('tempdb..#tempTbl1Time') IS NOT NULL
    DROP TABLE #tempTbl1Time;
select *,case when note_text like '%Research Request Received%' then 16
	 when note_text like '%Intake not completed%' then 10
	 when note_text like '%Privacy Notice%' then 11
	 when note_text like '%Research Response sent for QC%'  then 60
	 when note_text like '%Research response QC result%'  then 30
end as 'Time spent' 
into #tempTbl1Time
from #tempTbl1
where  note_type_description = 'Research Request' 
and created_date >=  
--DATEADD(DAY, DATEDIFF(DAY, 30, GETDATE()), 0)
--and created_date <=
-- DATEADD(DAY, DATEDIFF(DAY, -0, GETDATE()), 0)
  dateadd(m,-1,dateadd(mm,datediff(m,0,getdate()),0 ))
 and created_date <    dateadd(m,0,dateadd(mm,datediff(m,0,getdate()),0 ))
;

select * from #tempTbl1Time;
select created_by as 'Agent', count(created_by) as tasks,sum([Time Spent]) as 'Total Time Spent'
from
#tempTbl1Time
group by created_by;




----------------------------TAT-------------------------------

IF OBJECT_ID('tempdb..#tempTblTat') IS NOT NULL
    DROP TABLE #tempTblTat;
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
       END AS RESEARCH_AGING
	   --,d.column_name,d.original_value,d.new_value, d.created_date as created_dt
	   INTO #tempTblTat		
 FROM reversequest.RMS.V_ALERT A			
 LEFT JOIN reversequest.RMS.V_LOANMASTER B ON A.LOAN_SKEY = B.LOAN_SKEY			
 LEFT JOIN reversequest.RMS.V_PROPERTYMASTER C ON A.LOAN_SKEY = C.LOAN_SKEY		
 --join  [rms].[v_LogColumnDataChange]  D
 --on A.loan_skey	= D.loan_skey 
WHERE UPPER(A.ALERT_TYPE_DESCRIPTION) in ('Research Request Pending','DVN Research Request Pend','BBB Research Request Pending')
AND A.ALERT_STATUS_DESCRIPTION = 'INACTIVE' AND 
--A.CREATED_DATE BETWEEN DATEADD(DAY, DATEDIFF(DAY, 30, GETDATE()), 0) AND 
--DATEADD(DAY, DATEDIFF(DAY, -0, GETDATE()), 0)
A.CREATED_DATE >=
  dateadd(m,-1,dateadd(mm,datediff(m,0,getdate()),0 ))
 and A.CREATED_DATE <    dateadd(m,0,dateadd(mm,datediff(m,0,getdate()),0 ))
;		

select * from #tempTblTat order by RESEARCH_AGING;

IF OBJECT_ID('tempdb..#tempTblTat1') IS NOT NULL
    DROP TABLE #tempTblTat1;
SELECT A.loan_skey,A.[LOAN STATUS],a.[LOAN SUB STATUS],a.alert_type_description,a.ALERT_DATE,a.CREATED_DATE,a.MODIFIED_DATE,a.servicer_name,a.investor_name,a.state_code,a.RESEARCH_AGING
--,a.column_name,a.original_value,a.new_value,a.created_dt as 'change date',
     /*  ,CASE WHEN DISBURSEMENT_AGING <= 5 THEN '0-5 DAYS'			
	        WHEN DISBURSEMENT_AGING <= 7 THEN '6-7 DAYS'		
			WHEN DISBURSEMENT_AGING <= 10 THEN '7-10 DAYS'
	        ELSE 'GT 10 DAYS' END AS AGE_BUCKET, CONCAT(DATEPART(MM,A.CREATED_DATE),'-',DATEPART(YY,A.CREATED_DATE)) AS MONTH*/
			,case when RESEARCH_AGING > 10 then 1 else 0 End as 'TAT_MISSED'
			into #tempTblTat1
			FROM 
			#tempTblTat A
			--#rtemp1 A;
			select * from #tempTblTat1;

			select count(*) as 'Total', sum(TAT_MISSED) as 'TAT MISSED'
			,format(((count(*)-sum(TAT_MISSED))/ cast(count(*) as float))*100,'N2') as 'Department TAT %'
			from #tempTblTat1