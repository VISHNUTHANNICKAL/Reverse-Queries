

select 
b.loan_skey,
c.loan_status_description,
a.created_by as 'Created By',
convert(varchar,a.created_date,23) as 'Create Date',
a.workflow_task_description as 'Task Description',
convert(varchar,a.original_schedule_date,23) as 'Start Date',
convert(varchar,a.due_date,23) as 'End Date',
convert(varchar,a.complete_date,23) as 'Complete Date',
a.responsible_party_id as 'Task Responsible Party',
DateDiff(DAY,a.created_date,a.complete_date )  as 'Days Pending',
Case when DateDiff(HOUR,a.original_schedule_date,getdate()) <=48 then 'YES' else 'NO' end as 'SLA Met'
--, DateDiff(HOUR,a.original_schedule_date,getdate())
from [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join  [ReverseQuest].[rms].[v_WorkflowInstance] b on a.workflow_instance_skey=b.workflow_instance_skey
   join ReverseQuest.rms.v_LoanMaster c  on b.loan_skey=c.loan_skey
   where  a.workflow_task_description='Repayment Plan Manager Review'
and a.status_description='Active' 
and b.workflow_type_description='Cash Flow Analysis'
and b.status_description='Active'
order by b.loan_skey

/*
select [Task Responsible Party],[Created By],count([Create Date]) as create_date_count from (
select 
b.loan_skey,
c.loan_status_description,
a.created_by as 'Created By',
convert(varchar,a.created_date,23) as 'Create Date',
a.workflow_task_description as 'Task Description',
convert(varchar,a.original_schedule_date,23) as 'Start Date',
convert(varchar,a.due_date,23) as 'End Date',
convert(varchar,a.complete_date,23) as 'Complete Date',
a.responsible_party_id as 'Task Responsible Party',
DateDiff(DAY,a.created_date,a.complete_date )  as 'Days Pending',
Case when DateDiff(HOUR,a.original_schedule_date,getdate()) <=48 then 'YES' else 'NO' end as 'SLA Met'
from [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join  [ReverseQuest].[rms].[v_WorkflowInstance] b on a.workflow_instance_skey=b.workflow_instance_skey
   join ReverseQuest.rms.v_LoanMaster c  on b.loan_skey=c.loan_skey
   where  a.workflow_task_description='Repayment Plan Manager Review'
and a.status_description='Active' 
and b.workflow_type_description='Cash Flow Analysis'
and b.status_description='Active'
)a
group by [Task Responsible Party],[Created By]
order by [Task Responsible Party]
*/

