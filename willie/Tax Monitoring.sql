select 
a.loan_skey,
a.loan_status_description,
a.due_and_payable_date,
a.workflow_instance_skey,
a.workflow_type_description,
a.workflow_task_skey,
a.workflow_task_description,
a.workflow_task_description1,
a.schedule_date,
a.tax_year,
a.tax_authority_name,
a.workflow_type_skey,
a.[Create date]
from (
SELECT  a.[loan_skey],c.loan_status_description,e.due_and_payable_date,a.workflow_instance_skey,a.workflow_type_description,
b.workflow_task_skey,b.workflow_task_description,f.workflow_task_description as workflow_task_description1 ,
b.schedule_date,d.tax_year,d.tax_authority_name,a.workflow_type_skey,b.created_date  as'Create date',
b.created_date, row_number() over (partition by a.workflow_instance_skey order by b.created_date asc) sn
  FROM [ReverseQuest].[rms].[v_WorkflowInstance] a 
  join ReverseQuest.rms.v_WorkflowTaskActivity  b 
  on a.workflow_instance_skey=b.workflow_instance_skey 
  join rms.v_LoanMaster c on a.loan_skey=c.loan_skey and c.loan_status_description not in('Inactive','Deleted')
join rms.v_TaxPayment d on a.workflow_instance_skey=d.workflow_instance_skey and d.status_description='Active'
 left join [ReverseQuest].[rms].[v_LoanDefaultInformation] e on a.loan_skey=e.loan_skey
 left join (
 SELECT  a.[loan_skey],a.workflow_instance_skey,b.workflow_task_skey,b.workflow_task_description,b.schedule_date,a.workflow_type_skey 
 FROM [ReverseQuest].[rms].[v_WorkflowInstance] a 
  join ReverseQuest.rms.v_WorkflowTaskActivity  b 
  on a.workflow_instance_skey=b.workflow_instance_skey 
  where workflow_type_description like 'Tax Monitoring' 
and a.status_description='Active' 
and b.workflow_task_description in('Receipt of Delinquent Tax Notification')  
and b.status_description='Active'
 )f on  a.workflow_instance_skey=f.workflow_instance_skey 
where a.workflow_type_description like 'Tax Monitoring' 
and a.status_description='Active' 
and b.workflow_task_description in('Loan Record Sent for Tax Monitoring')  
and b.status_description='Active'
--and b.schedule_date between '2022-01-01' and '2023-12-31'
--and a.loan_skey=4289

)a where sn=1
	order by a.loan_skey;





