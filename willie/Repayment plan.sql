select 
an.loan_skey,
an.workflow_task_description,
an.[Notify Borrower of Approved Repayment Plan],
an.[Receipt of Signed Repayment Plan],
an.status_description,
an.workflow_task_description,
c.original_filename
from (
select b.loan_skey,
a.workflow_task_description,
a.status_description,
--convert(date,a.created_date),
convert(date,a.schedule_date) as 'Notify Borrower of Approved Repayment Plan',
convert(date,a.due_date) as 'Receipt of Signed Repayment Plan',
convert(date,b.created_date) as 'Mail Repayment Plan Coupons'
--c.original_filename as 'Document Type',
--c.created_date
--*
  --,a.workflow_instance_skey,a.complete_date
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a join [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
   where a.workflow_task_description in ( 'Notify Borrower of Approved Repayment Plan'
,'Missed Payment - 1st Call'
,'Missed Payment - 2nd Call'
,'Unreturned Signed Agreement - 1st Call'
,'Unreturned Signed Agreement - 2nd Call')
and a.status_description ='Active' and b.status_description = 'Active'
and a.complete_date is null
) an left join rqer.dbo.app_document c on an.loan_skey=c.loan_skey
where c.document_description like'Repayment Plan Coupons'
--and c.document_description like'Repayment Plan Coupons'
--and b.loan_skey='226374'




 
