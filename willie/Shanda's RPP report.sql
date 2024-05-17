  select a.loan_skey,a.loan_status_description,a.investor_name,
  c.state_code 'Property State',
  b.workflow_task_description,b.task_status_description,
  b.workflow_type_description,b.type_status_description
  ,convert(date,b.schedule_date) 'Start Date'
  ,d.workflow_task_description,d.task_status_description,
  d.workflow_type_description,d.type_status_description
  ,convert(date,d.complete_date) 'Complete Date'
  ,case when convert(date,d.complete_date) is not null then d.repayment_plan_amount
  else b.repayment_plan_amount end as
  [Orig. Repayment Amt]
  from rms.v_LoanMaster a
  left join (
  select * from (
  SELECT b.loan_skey,a.schedule_date--,a.complete_date
  ,b.repayment_plan_amount
  ,a.workflow_task_description,a.status_description 'task_status_description',
   b.workflow_type_description, b.status_description 'type_status_description'
   ,ROW_NUMBER() over (partition by b.loan_skey order by a.schedule_date desc,b.loan_skey) sn
    FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join  [ReverseQuest].[rms].[v_WorkflowInstance] b on a.workflow_instance_skey=b.workflow_instance_skey
  where 
    a.workflow_task_description in ('Notify Borrower of Approved Repayment Plan')
  and a.status_description in('Active')
  and b.workflow_type_description in ('Repayment Plan')
  and b.status_description in ('Active','Workflow Completed')
  and a.schedule_date >= convert(date,'2023-08-01')
  and a.schedule_date <= convert(date,'2024-12-31')
  ) a where sn=1
  )b on a.loan_skey=b.loan_skey
  join rms.v_PropertyMaster c on a.loan_skey=c.loan_skey
  left join (
  select * from (
  SELECT b.loan_skey--,a.schedule_date--
  ,a.complete_date,b.repayment_plan_amount
  ,a.workflow_task_description,a.status_description 'task_status_description',
   b.workflow_type_description, b.status_description 'type_status_description'
   ,ROW_NUMBER() over (partition by b.loan_skey order by a.complete_date desc,b.loan_skey) sn
    FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join  [ReverseQuest].[rms].[v_WorkflowInstance] b on a.workflow_instance_skey=b.workflow_instance_skey
  where 
    a.workflow_task_description in ('Repayment Plan Satisfied')
  and a.status_description in('Active')
  and b.workflow_type_description in ('Repayment Plan')
  and b.status_description in ('Active','Workflow Completed')
  and a.complete_date >= convert(date,'2023-08-01')
  and a.complete_date <= convert(date,'2024-12-31')
  ) a where sn=1
  )d on a.loan_skey=d.loan_skey
  /*left join (
  select 
		b.loan_skey,
		b.workflow_instance_skey,
		b.workflow_type_description,
  --b.default_date,
 -- b.due_and_payable_date,
		round(b.repayment_plan_amount/ b.repayment_plan_term, 2) as 'Monthly Repayment Amt',
		b.repayment_plan_amount as 'Orig. Repayment Amt',
		b.repayment_plan_term as 'Repayment Plan Term',
		b.status_description,
		b.surplus_income_amount,
		b.down_payment_amount,
		max(b.created_date) as 'created_date',
		b.created_by
		FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
		join  [ReverseQuest].[rms].[v_WorkflowInstance] b
		on a.workflow_instance_skey=b.workflow_instance_skey
		join ReverseQuest.rms.v_LoanMaster c  on b.loan_skey=c.loan_skey
		where 
		--b.loan_skey=1930 and
		b.workflow_type_description ='Repayment Plan'
		and b.status_description='Active'
		and a.workflow_task_description='Repayment Plan Installment Due'
		and a.status_description='Active'
		group by   b.loan_skey, b.workflow_instance_skey,
  b.workflow_type_description,b.down_payment_amount,
  --b.default_date,
 -- b.due_and_payable_date,
  b.repayment_plan_amount,
  b.repayment_plan_term,b.status_description,b.created_by,b.surplus_income_amount
  )e on a.loan_skey=e.loan_skey*/
  where a.investor_name in('Fannie Mae','F.N.M.A.','FNMA','MECA 2011')
 -- and b.loan_skey=6577
  order by investor_name ;


  /*select distinct workflow_task_description from [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  select 
		b.loan_skey,
		b.workflow_instance_skey,
		b.workflow_type_description,
  --b.default_date,
 -- b.due_and_payable_date,
		round(b.repayment_plan_amount/ b.repayment_plan_term, 2) as 'Monthly Repayment Amt',
		b.repayment_plan_amount as 'Orig. Repayment Amt',
		b.repayment_plan_term as 'Repayment Plan Term',
		b.status_description,
		b.surplus_income_amount,
		b.down_payment_amount,
		max(b.created_date) as 'created_date',
		b.created_by
		FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
		join  [ReverseQuest].[rms].[v_WorkflowInstance] b
		on a.workflow_instance_skey=b.workflow_instance_skey
		join ReverseQuest.rms.v_LoanMaster c  on b.loan_skey=c.loan_skey
		where 
		--b.loan_skey=1930 and
		b.workflow_type_description ='Repayment Plan'
		and b.status_description='Active'
		and a.workflow_task_description='Repayment Plan Installment Due'
		and a.status_description='Active'
		group by   b.loan_skey, b.workflow_instance_skey,
  b.workflow_type_description,b.down_payment_amount,
  --b.default_date,
 -- b.due_and_payable_date,
  b.repayment_plan_amount,
  b.repayment_plan_term,b.status_description,b.created_by,b.surplus_income_amount*/


  select * from (
  SELECT b.loan_skey--,a.schedule_date--
  ,a.complete_date,b.repayment_plan_amount
  ,a.workflow_task_description,a.status_description 'task_status_description',
   b.workflow_type_description, b.status_description 'type_status_description'
   ,ROW_NUMBER() over (partition by b.loan_skey order by a.complete_date desc,b.loan_skey) sn
    FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join  [ReverseQuest].[rms].[v_WorkflowInstance] b on a.workflow_instance_skey=b.workflow_instance_skey
  where 
    a.workflow_task_description in ('Repayment Plan Satisfied')
  and a.status_description in('Active')
  and b.workflow_type_description in ('Repayment Plan')
  and b.status_description in ('Active','Workflow Completed')
  and a.complete_date >= convert(date,'2023-08-01')
  and a.complete_date <= convert(date,'2024-12-31')
  ) a where sn=1 and loan_skey=6577