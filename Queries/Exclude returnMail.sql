select loan_skey from(
select distinct x.loan_skey,workflow_task_description,x.status_description,loan_status_description,complete_date
 from (
SELECT b.loan_skey, a.workflow_instance_skey,a.complete_date,
a.workflow_task_description,b.status_description
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
	join [ReverseQuest].[rms].[v_WorkflowInstance] b
on a.workflow_instance_skey=b.workflow_instance_skey
  where (a.workflow_task_description = 'Receipt of Short Sale Closing Proceeds' 
  or a.workflow_task_description = 'Receipt of Family Sale Proceeds' or 
	a.workflow_task_description = 'Receipt of Executed Deed -Instruct Attorney to record')
  and b.status_description = 'Active' and a.complete_date is not null
  ) x
  join
	(
	select loan_skey,loan_status_description from
	reversequest.rms.v_LoanMaster 
	where loan_status_description not in ('Inactive','Deleted')
	)y
on x.loan_skey=y.loan_skey
) m

union

select loan_skey from
	reversequest.rms.v_LoanMaster 
	where loan_sub_status_description in ('FCL- 3rd Party Sale- Funds Pending')
	;
