/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  top 1 [loan_skey]
	  ,y.due_date as 'due date'
	  ,y.complete_date
  FROM [ReverseQuest].[rms].[v_WorkflowInstance] x
  join
   [ReverseQuest].[rms].[v_WorkflowTaskActivity] y on x.workflow_instance_skey=y.workflow_instance_skey
  where y.workflow_task_description = 'Repayment Plan Installment Due'
  and x.status_description = 'Active'
  and y.complete_date is null
  and x.loan_skey='94658'
  order by y.due_date ;


  select *
  FROM [ReverseQuest].[rms].[v_WorkflowInstance]
  where loan_skey = '94658'
  and status_description = 'Active'

  select * from [ReverseQuest].[rms].[v_WorkflowTaskActivity]
  where workflow_instance_skey in (select workflow_instance_skey
  FROM [ReverseQuest].[rms].[v_WorkflowInstance]
  where loan_skey = '94658'
  and status_description = 'Active')
  
  select distinct workflow_task_description
  from
  [ReverseQuest].[rms].[v_WorkflowTaskActivity]

  select * from [RQER].[dbo].[rep_monthly_portfolio_analysis_extract]
  where loan_skey = '2621';

  SELECT[loan_skey],y.workflow_task_description
	  ,max(y.due_date) as 'due date'
	  ,y.complete_date
  FROM [ReverseQuest].[rms].[v_WorkflowInstance] x
  join
   [ReverseQuest].[rms].[v_WorkflowTaskActivity] y on x.workflow_instance_skey=y.workflow_instance_skey
  where y.workflow_task_description = 'Repayment Plan Installment Due'
  and x.status_description = 'Active'
  and y.complete_date is null
  group by loan_skey,y.workflow_task_description,y.complete_date