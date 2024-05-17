IF OBJECT_ID('tempdb..#tempTbl') IS NOT NULL
    DROP TABLE #tempTbl;
select b.*
into #tempTbl
from 
--reversequest.rms.v_LoanMaster a
--join
reversequest.rms.v_note b
--on a.loan_skey=b.loan_skey
where b.note_type_description = 'Payoff Request'
and b.created_date >=  
 DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
and b.created_date <
 DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()),0))
--and b.note_text in ('PAYOFF ALERT RAISED','PAYOFF UNAUTHORIZED REQUEST','PAYOFF NO ACTION REQUIRED','PAYOFF DUPLICATE REQUEST');
--and (b.note_text like ('PAYOFF ALERT RAISED%')
--or b.note_text like ('PAYOFF UNAUTHORIZED REQUEST%') or b.note_text like ('PAYOFF NO ACTION REQUIRED%') or b.note_text like ('PAYOFF DUPLICATE REQUEST%')
--);

select distinct note_text from
#tempTbl;

select * from #tempTbl;

select created_by as 'Agent',note_text,  count(note_text) as tasks from
#tempTbl
group by created_by,note_text;

select created_by as 'Agent', count(created_by) as tasks from
#tempTbl
group by created_by;


---------------------------------TAT-----
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
	   --,d.column_name,d.original_value,d.new_value, d.created_date as created_dt
	   INTO #PAYOFF_AGING_TABLE			
 FROM reversequest.RMS.V_ALERT A			
 LEFT JOIN reversequest.RMS.V_LOANMASTER B ON A.LOAN_SKEY = B.LOAN_SKEY			
 LEFT JOIN reversequest.RMS.V_PROPERTYMASTER C ON A.LOAN_SKEY = C.LOAN_SKEY		
 --join  [rms].[v_LogColumnDataChange]  D
 --on A.loan_skey	= D.loan_skey 
WHERE UPPER(A.ALERT_TYPE_DESCRIPTION) = 'PAYOFF QUOTE - NEW REQUEST RECEIVED'			
AND A.ALERT_STATUS_DESCRIPTION = 'INACTIVE' AND A.CREATED_DATE BETWEEN 
--dateadd(d,-1,dateadd(mm,datediff(m,0,getdate()),1 )) 
DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
AND 
--DATEADD(DAY, DATEDIFF(DAY, -0, GETDATE()), 0)
DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()),0))
--and  column_name in( 'loan_status')
;			


SELECT A.loan_skey,A.[LOAN STATUS],a.[LOAN SUB STATUS],a.alert_type_description,a.ALERT_DATE,a.CREATED_DATE,a.MODIFIED_DATE,a.servicer_name,a.investor_name,a.state_code,a.PAYOFF_AGING
--,a.column_name,a.original_value,a.new_value,a.created_dt as 'change date',
       ,CASE WHEN PAYOFF_AGING <= 5 THEN '0-5 DAYS'			
	        WHEN PAYOFF_AGING <= 7 THEN '6-7 DAYS'		
			WHEN PAYOFF_AGING <= 10 THEN '7-10 DAYS'
	        ELSE 'GT 10 DAYS' END AS AGE_BUCKET, CONCAT(DATEPART(MM,A.CREATED_DATE),'-',DATEPART(YY,A.CREATED_DATE)) AS MONTH
			FROM 
			#PAYOFF_AGING_TABLE A order by CREATED_DATE;
			--#rtemp1 A;

			IF OBJECT_ID('tempdb..#tmpTbl') IS NOT NULL
			DROP TABLE #tmpTbl;			
			select count(*) as 'Total Tasks',(select count(payoff_aging)  from #PAYOFF_AGING_TABLE where  PAYOFF_AGING >5)as 'Off TAT'
			into #tmpTbl
			from #PAYOFF_AGING_TABLE A;

			select *,format((cast(([Total Tasks]-[Off TAT])as float)/cast([Total Tasks]as float))*100,'N2') as 'TAT%' from #tmpTbl;


			-------------------------Actives---------------------------------

IF OBJECT_ID('tempdb..#tempTblActive') IS NOT NULL
DROP TABLE #tempTblActive;

SELECT  [alert_skey]
      ,[loan_skey]
      ,[alert_type_skey]
      ,[alert_type_description]
      ,[alert_category_skey]
      ,[alert_category_description]
      ,[alert_severity_skey]
      ,[alert_severity_description]
      ,[reference_skey]
      ,[alert_date]
      ,[alert_expiration_date]
      ,[alert_note]
      ,[status_skey]
      ,[alert_status_description]
      ,[alert_category_status_skey]
      ,[alert_category_status_description]
      ,[alert_severity_status_skey]
      ,[alert_severity_status_description]
      ,[created_date]
      ,[created_by]
      ,[modified_date]
      ,[modified_by]
	  into #tempTblActive
  FROM [ReverseQuest].[rms].[v_Alert]

  where alert_type_description  ='Payoff Quote - New Request Received'
  and [alert_date] >=  
DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
and created_date <
DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()),0));

/*[9:26 PM] Shah, Mittal
Loan SkeyLoan #FHA Case #Loan StatusLoan Sub-StatusAlert DateAlert TypeAlert StatusAlert Expiration DateCreated ByCreate DateLoan ManagerAlert NoteBorrower Last NameBorrower First NameBorrower Full NameInvestor Loan #Product TypePayment PlanChanged ByChange DateLoan ChannelProperty StateAlert Skey

[9:27 PM] Shah, Mittal
Payoff Quote - New Request Received*/

------------Default processors

IF OBJECT_ID('tempdb..#tempTblDefault') IS NOT NULL
    DROP TABLE #tempTblDefault;
select b.*
into #tempTblDefault
from 
--reversequest.rms.v_LoanMaster a
--join
reversequest.rms.v_note b
--on a.loan_skey=b.loan_skey
where b.note_type_description in('Payoff QC Review completed','Payoff Support Docs')
and b.created_date >=  
 DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
and b.created_date <=
 DATEADD(d,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()),0))
--and b.note_text in ('PAYOFF ALERT RAISED','PAYOFF UNAUTHORIZED REQUEST','PAYOFF NO ACTION REQUIRED','PAYOFF DUPLICATE REQUEST');
--and (b.note_text like ('PAYOFF ALERT RAISED%')
--or b.note_text like ('PAYOFF UNAUTHORIZED REQUEST%') or b.note_text like ('PAYOFF NO ACTION REQUIRED%') or b.note_text like ('PAYOFF DUPLICATE REQUEST%')
--);

select * from #tempTblDefault;

select created_by as 'Agent', count(created_by) as tasks from
#tempTblDefault
group by created_by;