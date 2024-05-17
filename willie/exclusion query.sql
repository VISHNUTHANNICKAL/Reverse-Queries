SELECT  a.[loan_skey],a.workflow_type_description,b.workflow_task_description,a.status_description 
  FROM [ReverseQuest].[rms].[v_WorkflowInstance] a
  join
  [ReverseQuest].rms.v_WorkflowTaskActivity b
  on a.workflow_instance_skey=b.workflow_instance_skey
  where a.workflow_type_description = 'Due & Payable w/ HUD Approval'
  and a.status_description in ('Active')
  and b.workflow_task_description = 'Request to Rescind D&P'
  and b.status_description='Active'

  union

  SELECT  a.[loan_skey],a.workflow_type_description,b.workflow_task_description,a.status_description 
  FROM [ReverseQuest].[rms].[v_WorkflowInstance] a
  join
  [ReverseQuest].rms.v_WorkflowTaskActivity b
  on a.workflow_instance_skey=b.workflow_instance_skey
  where a.workflow_type_description = 'Foreclosure - Judicial'
  and a.status_description= 'Active'
  and b.workflow_task_description = 'Send Rescission Request to HUD'
  and b.status_description='Active'
  union

  SELECT  a.[loan_skey],a.workflow_type_description,b.workflow_task_description,a.status_description 
  FROM [ReverseQuest].[rms].[v_WorkflowInstance] a
  join
  [ReverseQuest].rms.v_WorkflowTaskActivity b
  on a.workflow_instance_skey=b.workflow_instance_skey
  where a.workflow_type_description = 'Foreclosure - Non Judicial'
  and a.status_description= 'Active'
  and b.workflow_task_description = 'Send Rescission Request to HUD'
   and b.status_description='Active'
  
  SELECT  a.* 
  FROM [ReverseQuest].[rms].[v_WorkflowInstance] a
  join
  [ReverseQuest].rms.v_WorkflowTaskActivity b
  on a.workflow_instance_skey=b.workflow_instance_skey
  where a.workflow_type_description = 'Foreclosure - Non Judicial'
  and a.status_description= 'Active'
  and b.workflow_task_description = 'Send Rescission Request to HUD'


  select top 10 * from [ReverseQuest].[rms].[v_WorkflowInstance] 
  where workflow_type_description = 'Foreclosure - Non Judicial'
  and status_description= 'Active'