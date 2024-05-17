IF OBJECT_ID('tempdb..#rtemp') IS NOT NULL
    DROP TABLE #rtemp;
SELECT 
      a.[loan_skey]
	   ,d.last_name
	   ,e.loan_status_description
	   ,e.loan_sub_status_description
      ,a.[transaction_code],
	  a.long_transaction_description
	  ,a.transaction_date
	  --,b.workflow_instance_skey
	  --,c.workflow_task_description
	  into #rtemp
  FROM [ReverseQuest].[rms].[v_Transaction] a
  join 
  [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.loan_skey	=b.loan_skey
  join [ReverseQuest].[rms].[v_WorkflowTaskActivity] c
  on b.workflow_instance_skey=c.workflow_instance_skey
  join reversequest.rms.v_ContactMaster d
  on a.loan_skey=d.loan_skey
  join  reversequest.rms.v_LoanMaster e
  on a.loan_skey=e.loan_skey
  where
  c.workflow_task_description in 
  ('Receipt of M&M Lien Waiver','Receipt of Paid Receipts') and c.status_description = 'Active' and c.complete_date is not null
   and a.transaction_code = '6320' 
   and e.loan_status_description <> 'INACTIVE'
   and d.contact_type_description = 'Borrower';

   select distinct * from #rtemp;
  
  select distinct * from #rtemp where loan_skey not in (
   select x.loan_skey from #rtemp x
   join [ReverseQuest].[rms].[v_Transaction] y
   on x.loan_skey=y.loan_skey
   where y.transaction_code = '6351' 
   and y.transaction_date > x.transaction_date
   )
   and transaction_date > Convert(datetime, '2022-03-31' );

   select x.* from #rtemp x
   join [ReverseQuest].[rms].[v_Transaction] y
   on x.loan_skey=y.loan_skey
   where y.transaction_code = '6351' 
   and y.transaction_date > x.transaction_date