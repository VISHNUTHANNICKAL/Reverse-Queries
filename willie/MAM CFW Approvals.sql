
select 
a.loan_skey,d.investor_name,d.servicer_name,
a.complete_date 'Complete Cash Flow Financial Analysis Form Complete date',
a.workflow_task_result_description 'Complete Cash Flow Financial Analysis Form Task Result',
a.task_note 'Complete Cash Flow Financial Analysis Form Task Note',
b.complete_date 'Transition to Repayment Plan Complete Date',
c.complete_date 'Repayment Plan Manager Review Complete date',
case when  c.workflow_task_result_description is null then a.workflow_task_result_description  else c.workflow_task_result_description end as 'Repayment Plan Manager Review  Task Result',
c.task_note 'Repayment Plan Manager Review Task Note'
from (
  select 
b.loan_skey,convert(date,a.complete_date) complete_date 
,convert(date,a.created_date) created_date
,a.workflow_task_result_description
,a.task_note
,b.workflow_type_description,a.workflow_task_description
,ROW_NUMBER() over (partition by b.loan_skey order by convert(date,a.due_date) desc,b.loan_skey) sn
    FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join
  [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
   join ReverseQuest.rms.v_LoanMaster c  on b.loan_skey=c.loan_skey
   where-- b.loan_skey=221558 and 
    b.workflow_type_description  in ('Cash Flow Analysis')
   and a.workflow_task_description in ('Complete Cash Flow Financial Analysis Form')
   and b.status_description in ('Active','Workflow Completed')
   and a.status_description in ('Active','Workflow Completed')
    and a.created_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
	--and a.created_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
	and a.created_date <=  DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
	) a 
	left join (
	select 
b.loan_skey,convert(date,a.complete_date) complete_date 
--,convert(date,a.due_date) due_date
,a.workflow_task_result_description
,a.task_note
,b.workflow_type_description,a.workflow_task_description
,ROW_NUMBER() over (partition by b.loan_skey order by convert(date,a.due_date) desc,b.loan_skey) sn
    FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join
  [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
   join ReverseQuest.rms.v_LoanMaster c  on b.loan_skey=c.loan_skey
   where-- b.loan_skey=221558 and 
    b.workflow_type_description  in ('Cash Flow Analysis')
   and a.workflow_task_description in ('Transition to Repayment Plan')
   and b.status_description in ('Active','Workflow Completed')
   and a.status_description in ('Active','Workflow Completed')
   and a.created_date >= DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
   -- and a.created_date >=DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
	and a.created_date <=DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))

	)b on a.loan_skey=b.loan_skey
	left join 
	(
	 select 
b.loan_skey,convert(date,a.complete_date) complete_date 
,convert(date,a.created_date) created_date
,a.workflow_task_result_description
,a.task_note
,b.workflow_type_description,a.workflow_task_description
,ROW_NUMBER() over (partition by b.loan_skey order by convert(date,a.due_date) desc,b.loan_skey) sn
    FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join
  [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
   join ReverseQuest.rms.v_LoanMaster c  on b.loan_skey=c.loan_skey
   where-- b.loan_skey=221558 and 
    b.workflow_type_description  in ('Cash Flow Analysis')
   and a.workflow_task_description in ('Repayment Plan Manager Review')
   and b.status_description in ('Active','Workflow Completed')
   and a.status_description in ('Active','Workflow Completed')
   and a.created_date >= DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
   --and a.created_date >=DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
	and a.created_date <=DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
	--and b.loan_skey=263140
	)c on a.loan_skey=c.loan_skey
	left join rms.v_LoanMaster d on a.loan_skey=d.loan_skey
	where d.investor_name in(
	'Bank of America',
'Black Reef Trust',
'Cascade Funding Alternative Holdings, LLC',
'Cascade Funding Mortgage Trust - AB1',
'Cascade Funding Mortgage Trust - AB2',
'Cascade Funding Mortgage Trust - HB10',
'Cascade Funding Mortgage Trust - HB11',
'Cascade Funding Mortgage Trust - HB4',
'Cascade Funding Mortgage Trust - HB7',
'Cascade Funding Mortgage Trust - HB8',
'Cascade Funding Mortgage Trust - HB9',
'Cascade Funding Mortgage Trust 2018-RM2',
'Cascade Funding Mortgage Trust 2019 - RM3',
'Cascade Funding RM1 Acquisitions Grantor Tr',
'Cascade Funding RM1 Alternative Holdings, LLC',
'Cascade Funding RM4 Acquisitions Grantor Tr',
'Everbank 2008 AKA TIAA',
'Everbank 2015 AKA TIAA',
'Guggenheim Life and Annuity Company (GLAC)',
'HB0 Alternative Holdings, LLC',
'HB1 Alternative Holdings, LLC',
'HB2 Alternative Holdings, LLC',
'Ivory Cove Trust',
'MECA 2007-FF1',
'MECA 2007-FF2',
'MECA 2007-FF3',
'MECA Trust 2010-1',
'Mortgage Equity Conversion Asset Trust 2010-1',
'Mr Cooper HUD Reconveyance',
'NARRE Titling Trust',
'RBS Financial Products fka Greenwich',
'Reverse Mortgage Solutions, Inc.',
'Reverse Mortgage Solutions, Inc. 2018-09',
'Riverview HECM Trust 2007-1',
'SASCO 1999-RM1',
'SHAP Acquisition Trust HB0',
'SHAP Acquisitions Trust HB1 Barclays',
'SHAP Acquisitions Trust HB2 Nomura',
'VF1-NA Trust',
'WF BOA Repurchase',
'Wilmington Savings Fund Society FSB',
'SMS Financial NCU',
'Reverse Mortgage Loan Trust Series REV 2007-2')
	order by a.loan_skey;
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	--where sn=1

  -- select distinct workflow_task_description from [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
   --select distinct workflow_type_description from   [ReverseQuest].[rms].[v_WorkflowInstance] b
/*
   select * from (  select 
b.loan_skey,convert(date,a.complete_date) complete_date 
,convert(date,a.created_date) created_date
,a.workflow_task_result_description
,a.task_note
,b.workflow_type_description,a.workflow_task_description
,ROW_NUMBER() over (partition by b.loan_skey order by convert(date,a.due_date) desc,b.loan_skey) sn
    FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join
  [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
   join ReverseQuest.rms.v_LoanMaster c  on b.loan_skey=c.loan_skey
   where-- b.loan_skey=221558 and 
    b.workflow_type_description  in ('Cash Flow Analysis')
   and a.workflow_task_description in ('Repayment Plan Manager Review')
   and b.status_description in ('Active')
   and a.status_description in ('Active')
     and a.created_date >=convert(date,'2024-02-26')
	and a.created_date <=convert(date,'2024-03-01')
   ) a --where sn=1


    select * from (
  select 
b.loan_skey,convert(date,a.complete_date) complete_date 
--,convert(date,a.due_date) due_date
,a.workflow_task_result_description
,a.task_note
,b.workflow_type_description,a.workflow_task_description
,ROW_NUMBER() over (partition by b.loan_skey order by convert(date,a.due_date) desc,b.loan_skey) sn
    FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join
  [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
   join ReverseQuest.rms.v_LoanMaster c  on b.loan_skey=c.loan_skey
   where-- b.loan_skey=221558 and 
    b.workflow_type_description  in ('Cash Flow Analysis')
   and a.workflow_task_description in ('Transition to Repayment Plan')
   and b.status_description in ('Active')
   and a.status_description in ('Active')
    and a.created_date >=convert(date,'2024-02-26')
	and a.created_date <=convert(date,'2024-03-01')
   ) a --where sn=1*/