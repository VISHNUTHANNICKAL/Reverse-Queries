IF OBJECT_ID('tempdb..#tempTbl') IS NOT NULL
    DROP TABLE #tempTbl;
select 
a.loan_skey,
a.investor_name,
a.fha_case_number,
a.loan_status_description,
a.loan_sub_status_description,
b.default_date,
b.due_and_payable_date,
case when d.[due date] is null then 'No' else 'Yes' end as 'Active Repay Plan',
z.complete_date as 'Receipt of Signed Repayment Plan' 
into #tempTbl
from ReverseQuest.rms.v_LoanMaster a
left join [ReverseQuest].[rms].v_LoanDefaultInformation  b on a.loan_skey=b.loan_skey
left join
	(SELECT[loan_skey],y.workflow_task_description
	  ,min(y.due_date) as 'due date'
	  ,y.complete_date,x.workflow_instance_skey,x.created_by
  FROM [ReverseQuest].[rms].[v_WorkflowInstance] x
   join
   [ReverseQuest].[rms].[v_WorkflowTaskActivity] y on x.workflow_instance_skey=y.workflow_instance_skey
  where y.workflow_task_description = 'Repayment Plan Installment Due'
  and x.status_description = 'Active'
  --and y.complete_date is null
  group by loan_skey,y.workflow_task_description,y.complete_date,x.workflow_instance_skey,x.created_by
 -- order by loan_skey
   ) d on a.loan_skey=d.loan_skey

  left join
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
  on a.loan_skey=z.loan_skey
where
a.loan_status_description in ('Default', 'Foreclosure')


select * from #tempTbl;

IF OBJECT_ID('tempdb..#tempTbl2') IS NOT NULL
    DROP TABLE #tempTbl2;
	select a.loan_skey,a.loan_status_description,a.due_and_payable_date,a.[Active Repay Plan]
	,b.workflow_task_description
	--,b.complete_date
	--,count(*)  as term 
	,sum(case when b.complete_date is null then 1 else 0 end) as 'pymts pending',
	sum(case when b.complete_date is not null then 1 else 0 end) as 'pymts made'
	into #tempTbl2
	from #tempTbl a
	left join
	[ReverseQuest].[rms].[v_WorkflowTaskActivity] b
	on a.workflow_instance_skey=b.workflow_instance_skey and b.workflow_task_description = 'Repayment Plan Installment Due'
	group by a.loan_skey,a.loan_skey,a.loan_status_description,a.default_reason_description,a.due_and_payable_date,a.date_foreclosure_sale_scheduled
	,a.[Active Repay Plan],a.Tots,b.workflow_task_description,a.created_by
	--,b.complete_date
	--having a.loan_skey = '1492'
	;
	


--select * from #tempTbl
/*
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
  */










 select top 10 * FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] x
 where  workflow_task_description = 'Repayment Plan Installment Due'

  select  * FROM  [ReverseQuest].[rms].[v_WorkflowInstance] y 
  join [ReverseQuest].[rms].[v_WorkflowTaskActivity] x on y.workflow_instance_skey=x.workflow_instance_skey
 where  workflow_task_description = 'Repayment Plan Installment Due'
 and y.loan_skey='4556'


  select top 10 * from  [ReverseQuest].[rms].v_LoanDefaultInformation where loan_skey in(
    select  y.loan_skey FROM  [ReverseQuest].[rms].[v_WorkflowInstance] y 
  join [ReverseQuest].[rms].[v_WorkflowTaskActivity] x on y.workflow_instance_skey=x.workflow_instance_skey
 where  workflow_task_description = 'Repayment Plan Installment Due')