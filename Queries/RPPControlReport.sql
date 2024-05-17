/****** Script for SelectTopNRows command from SSMS  ******/
IF OBJECT_ID('tempdb..#tempTbl') IS NOT NULL
    DROP TABLE #tempTbl;
SELECT b.loan_skey, a.created_date as 'Notify Borrower of Approved Repayment Plan'
into #tempTbl
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join
  [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
  where workflow_task_description like 'Notify Borrower of Approved%'
  and a.created_date >= DATEADD(DAY, DATEDIFF(DAY, 30, GETDATE()), 0)
  --and b.loan_skey = '543798'
  order by b.loan_skey;


IF OBJECT_ID('tempdb..#tempTbl1') IS NOT NULL
    DROP TABLE #tempTbl1;
  select a.*,
  z.complete_date as 'Receipt of Signed Repayment Plan' 
  into #tempTbl1
  from #tempTbl a
  join
   (
  SELECT max(x.complete_date) as complete_date,y.loan_skey
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] x
  join
  [ReverseQuest].[rms].[v_WorkflowInstance] y
  on x.workflow_instance_skey=y.workflow_instance_skey
  where workflow_task_description = 'Receipt of Signed Repayment Plan'
  and x.created_date >= DATEADD(DAY, DATEDIFF(DAY, 30, GETDATE()), 0)
  and x.complete_date is not null
  group by y.loan_skey
  ) z
  on a.loan_skey=z.loan_skey;


  IF OBJECT_ID('tempdb..#tempTbl2') IS NOT NULL
    DROP TABLE #tempTbl2;
  select a.*,
  z.complete_date as 'Mail Repayment Plan Coupons' 
  into #tempTbl2
  from #tempTbl1 a
  join
   (
  SELECT max(x.complete_date) as complete_date,y.loan_skey
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] x
  join
  [ReverseQuest].[rms].[v_WorkflowInstance] y
  on x.workflow_instance_skey=y.workflow_instance_skey
  where workflow_task_description = 'Mail Repayment Plan Coupons'
  and x.created_date >= DATEADD(DAY, DATEDIFF(DAY, 30, GETDATE()), 0)
  and x.complete_date is not null
  group by y.loan_skey
  ) z
  on a.loan_skey=z.loan_skey;

  select a.*,b.original_filename as 'Document Type',b.created_date
  from #tempTbl2 a
  join
  (select * from 
  [RQER].[dbo].[app_document]  
  where document_description = 'Repayment Plan Coupons'
  and created_date
  >= DATEADD(DAY, DATEDIFF(DAY, 30, GETDATE()), 0)
  )b
  on a.loan_skey=b.loan_skey;


