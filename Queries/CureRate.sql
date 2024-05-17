/****** Script for SelectTopNRows command from SSMS  ******/

IF OBJECT_ID('tempdb..#tempTbl') IS NOT NULL
    DROP TABLE #tempTbl;
SELECT [period_description]
      ,[start_date]
      ,[end_date]
      ,[loan_skey]
      ,[prior_loan_status_description]
      ,[current_loan_status_description]
      ,[loan_sub_status_description]
      ,[created_date]
	  into #tempTbl
  FROM [ReverseQuest].[rms].[v_MonthlyLoanSummary]
  where period_description = 'June 2023'
  and current_loan_status_description in ('DEFAULT','FORECLOSURE')
  
  select * from #tempTbl;

  select count(*) as cured from (
select a.loan_skey,a.current_loan_status_description as 'old',b.current_loan_status_description as 'new',b.loan_sub_status_description
from #tempTbl a
left join  
[ReverseQuest].[rms].[v_MonthlyLoanSummary] b
on a.loan_skey=b.loan_skey
  where b.period_description = 'May 2023'
  and a.current_loan_status_description <> b.current_loan_status_description
  and b.current_loan_status_description in ('ACTIVE','INACTIVE')
  ) x;
  


  --select distinct period_description
  --FROM [ReverseQuest].[rms].[v_MonthlyLoanSummary]