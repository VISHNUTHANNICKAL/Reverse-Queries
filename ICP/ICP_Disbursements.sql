IF OBJECT_ID('tempdb..#tempTbl1') IS NOT NULL
    DROP TABLE #tempTbl1;
SELECT  [loan_skey]
      ,[note_type_description] as 'Description'
	  --,[note_text]
      ,[created_date]
      ,[created_by]
	  into #tempTbl1
  FROM [ReverseQuest].[rms].[v_Note]
  where 
  note_type_description in ('Declined LOC Draw Request' ,'Processed LOC Draw Request','CT 22 HUD Payment Pended', 'Research Response sent for QC%', 'LOC Draw QC Pass'
  ,'LOC Draw QC Pass - Corrections','LOC Draw QC Fail','Disbursement Void Request','Scheduled Payment Request','Disbursement Misc Intake'
  ,'Disbursement Penalty Paid','ACH returned - Pymt Reissued')
  --where   loan_skey = '1930'
 and created_date >=  
    dateadd(m,-1,dateadd(mm,datediff(m,0,getdate()),0 ))
and created_date <     dateadd(m,0,dateadd(mm,datediff(m,0,getdate()),0 ))
union

SELECT  [loan_skey]
      ,[alert_type_description] as 'Description'
	--,[alert_date]
      ,[created_date]
      ,[created_by]
  FROM [ReverseQuest].[rms].[v_Alert]
  --where alert_type_description in ('Research request pending','DVN Research Request Pend','BBB Research Request Pending')
  where alert_type_description in ('Disbursement Request received From Borrower')
  --and alert_status_description = 'Active'
and created_date >=  
   dateadd(m,-1,dateadd(mm,datediff(m,0,getdate()),0 ))
and created_date <    dateadd(m,0,dateadd(mm,datediff(m,0,getdate()),0 ));	

select * from #tempTbl1;

IF OBJECT_ID('tempdb..#tempTbl1Time') IS NOT NULL
    DROP TABLE #tempTbl1Time;
select *,case when Description = 'Declined LOC Draw Request' then 30
	 when Description = 'Processed LOC Draw Request' then 30
	 when Description = 'CT 22 HUD Payment Pended' then 30
	 when Description = 'LOC Draw QC Pass' then 30
	 when Description = 'LOC Draw QC Pass - Corrections' then 30
	 when Description = 'LOC Draw QC Fail' then 30
	 when Description = 'Disbursement Void Request' then 10
	 when Description = 'Scheduled Payment Request' then 5
	 when Description = 'Disbursement Misc Intake' then 5
	 when Description = 'Disbursement Penalty Paid' then 5
	 when Description = 'ACH returned - Pymt Reissued' then 5
	 when Description = 'Disbursement Request received From Borrower' then 11
end as 'Time spent' 
into #tempTbl1Time
from #tempTbl1;
select * from #tempTbl1Time;

select created_by as 'Agent', count(created_by) as tasks,sum([Time Spent]) as 'Total Time Spent'
from
#tempTbl1Time
group by created_by;


------------------------------Disbursements - Intake--------------------------
IF OBJECT_ID('tempdb..#tempTbl') IS NOT NULL
    DROP TABLE #tempTbl;
SELECT  [loan_skey]
      ,[alert_type_description]
	,[alert_date]
      ,[created_date]
      ,[created_by]
	  into #tempTbl
  FROM [ReverseQuest].[rms].[v_Alert]
  --where alert_type_description in ('Research request pending','DVN Research Request Pend','BBB Research Request Pending')
  where alert_type_description in ('Disbursement Request received From Borrower')
  --and alert_status_description = 'Active'
  and created_date >=  
  dateadd(m,-1,dateadd(mm,datediff(m,0,getdate()),0 ))
and created_date <    dateadd(m,0,dateadd(mm,datediff(m,0,getdate()),0 ));	

select * from #tempTbl order by loan_skey;

select created_by as 'Agent', count(created_by) as tasks from
#tempTbl
group by created_by;


----------------Processing----------------------
IF OBJECT_ID('tempdb..#tempTbl1') IS NOT NULL
    DROP TABLE #tempTbl1;
SELECT  [loan_skey]
      ,[note_type_description]
	  ,[note_text]
      ,[created_date]
      ,[created_by]
	  into #tempTbl1
  FROM [ReverseQuest].[rms].[v_Note]
  where [note_type_description] in ('Declined LOC Draw Request','Processed LOC Draw Request','CT 22 HUD Payment Pended')
 --where  loan_skey = '225275'
 and created_date >=  
  dateadd(m,-1,dateadd(mm,datediff(m,0,getdate()),0 ))
and created_date <    dateadd(m,0,dateadd(mm,datediff(m,0,getdate()),0 ));	

select * from #tempTbl1;

select created_by as 'Agent', count(created_by) as tasks from
#tempTbl1
group by created_by;

--------QC-----

IF OBJECT_ID('tempdb..#tempTbl2') IS NOT NULL
    DROP TABLE #tempTbl2;
SELECT  [loan_skey]
      ,[note_type_description]
      ,[created_date]
      ,[created_by]
	  into #tempTbl2
  FROM [ReverseQuest].[rms].[v_Note]
  where [note_type_description] in ('LOC Draw QC Pass','LOC Draw QC Pass - Corrections','LOC Draw QC Fail')
 --where  loan_skey = '225275'
 and created_date >=  
  dateadd(m,-1,dateadd(mm,datediff(m,0,getdate()),0 ))
and created_date <    dateadd(m,0,dateadd(mm,datediff(m,0,getdate()),0 ));	

select * from #tempTbl2;

select created_by as 'Agent', count(created_by) as tasks from
#tempTbl2
group by created_by;



-----------------------------------QA

--select * from #tempTbl1 where loan_skey=226120;
--select * from #tempTbl2 where loan_skey=226120;

IF OBJECT_ID('tempdb..#tempTbl4') IS NOT NULL
    DROP TABLE #tempTbl4;
select a.loan_skey,a.created_by as Agent, a.note_type_description,a.created_date as Processed_By,b.note_type_description as 'QC Note'
--,b.created_by as QC_by
,max(b.created_date) as QC_Date
,case when b.note_type_description = 'LOC Draw QC Pass' then 1 else 0 end as 'QC Pass',
case when b.note_type_description='LOC Draw QC Pass - Corrections' then 1 else 0 end as 'QC Pass - Corrections',
case when b.note_type_description='LOC Draw QC Fail' then 1 else 0 end as 'QC Fail'
into #tempTbl4
from #tempTbl1 a
join #tempTbl2 b on a.loan_skey=b.loan_skey and b.created_date > a.created_date
group by a.loan_skey,a.created_by,a.note_type_description,a.created_date,b.note_type_description
--,b.created_by
;
--select * from #tempTbl4;
select Agent,sum([QC Pass]) as 'QC_Pass',
sum([QC Pass - Corrections]) as 'QC_Pass_Correction',
sum([QC Pass]+[QC Pass - Corrections]) as 'Total QC_Pass',
sum([QC Fail]) as 'QC_Fail',
sum([QC Pass]+[QC Pass - Corrections]+[QC Fail]) as 'Total QC',
concat(format(CAST(sum([QC Pass]+[QC Pass - Corrections]) as float)/ cast(sum([QC Pass]+[QC Pass - Corrections]+[QC Fail]) as float)*100,'N2'),'%') as 'QC %'
from #tempTbl4
group by Agent;



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
       END AS DISBURSEMENT_AGING
	   --,d.column_name,d.original_value,d.new_value, d.created_date as created_dt
	   INTO #tempTblTat		
 FROM reversequest.RMS.V_ALERT A			
 LEFT JOIN reversequest.RMS.V_LOANMASTER B ON A.LOAN_SKEY = B.LOAN_SKEY			
 LEFT JOIN reversequest.RMS.V_PROPERTYMASTER C ON A.LOAN_SKEY = C.LOAN_SKEY		
 --join  [rms].[v_LogColumnDataChange]  D
 --on A.loan_skey	= D.loan_skey 
WHERE UPPER(A.ALERT_TYPE_DESCRIPTION) = 'Disbursement Request received From Borrower'			
AND A.ALERT_STATUS_DESCRIPTION = 'INACTIVE' AND A.created_date >=  
   dateadd(m,-1,dateadd(mm,datediff(m,0,getdate()),0 ))
and a.created_date <    dateadd(m,0,dateadd(mm,datediff(m,0,getdate()),0 ));			

select * from #tempTblTat order by DISBURSEMENT_AGING;

IF OBJECT_ID('tempdb..#tempTblTat1') IS NOT NULL
    DROP TABLE #tempTblTat1;
SELECT A.loan_skey,A.[LOAN STATUS],a.[LOAN SUB STATUS],a.alert_type_description,a.ALERT_DATE,a.CREATED_DATE,a.MODIFIED_DATE,a.servicer_name,a.investor_name,a.state_code,a.DISBURSEMENT_AGING
--,a.column_name,a.original_value,a.new_value,a.created_dt as 'change date',
     /*  ,CASE WHEN DISBURSEMENT_AGING <= 5 THEN '0-5 DAYS'			
	        WHEN DISBURSEMENT_AGING <= 7 THEN '6-7 DAYS'		
			WHEN DISBURSEMENT_AGING <= 10 THEN '7-10 DAYS'
	        ELSE 'GT 10 DAYS' END AS AGE_BUCKET, CONCAT(DATEPART(MM,A.CREATED_DATE),'-',DATEPART(YY,A.CREATED_DATE)) AS MONTH*/
			,case when DISBURSEMENT_AGING > 3 then 1 else 0 End as 'TAT_MISSED'
			into #tempTblTat1
			FROM 
			#tempTblTat A
			--#rtemp1 A;
			select * from #tempTblTat1;

			select count(*) as 'Total', sum(TAT_MISSED) as 'TAT MISSED'
			,format(((count(*)-sum(TAT_MISSED))/ cast(count(*) as float))*100,'N2') as 'Department TAT %'
			from #tempTblTat1
