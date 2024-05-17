IF OBJECT_ID('tempdb..#tempTbl5') IS NOT NULL
    DROP TABLE #tempTbl5;
select * 
into #tempTbl5
from (
select 
b.loan_skey,b.default_reason_description
,b.default_date,b.workflow_type_description,b.status_description,
b.created_date
,b.created_by
,ROW_NUMBER() OVER (PARTITION BY b.loan_skey ORDER BY b.created_date desc) rn
from(select
b.loan_skey,b.default_reason_description
,b.default_date,b.workflow_type_description,b.status_description,max(b.created_date) as created_date,b.created_by
	from   [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
	 join [ReverseQuest].[rms].[v_WorkflowInstance] b
	 on a.workflow_instance_skey=b.workflow_instance_skey
	 where --b.loan_skey=1930 and
	  b.workflow_type_description in ('Pre Due & Payable w/HUD Approval','Due & Payable w/ HUD Approval','Due & Payable w/o HUD Approval')
	--and a.workflow_task_description='HUD Decision - Denied'
	and b.status_description='Active'
  group by b.loan_skey,b.default_reason_description
,b.default_date,b.workflow_type_description,b.status_description,b.created_by
) b 
) a
where --loan_skey =210068 and 
rn=1
-- select distinct workflow_type_description from [ReverseQuest].[rms].[v_WorkflowInstance]  where workflow_type_description
-- select * from  #tempTbl6 where loan_skey=1300

IF OBJECT_ID('tempdb..#tempTbl6') IS NOT NULL
    DROP TABLE #tempTbl6;
select * 
into #tempTbl6
from (
select 
b.loan_skey,b.default_reason_description
,b.default_date,b.workflow_type_description,b.status_description,
b.created_date
,b.created_by
,ROW_NUMBER() OVER (PARTITION BY b.loan_skey ORDER BY b.created_date desc) rn
from(select
b.loan_skey,b.default_reason_description
,b.default_date,b.workflow_type_description,b.status_description,max(b.created_date) as created_date,b.created_by
	from   [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
	 join [ReverseQuest].[rms].[v_WorkflowInstance] b
	 on a.workflow_instance_skey=b.workflow_instance_skey
	 where --b.loan_skey=1930 and
	  b.workflow_type_description in ('Pre Due & Payable w/HUD Approval','Due & Payable w/ HUD Approval','Due & Payable w/o HUD Approval')
	--and a.workflow_task_description='HUD Decision - Denied'
	and b.status_description='Workflow Completed'
  group by b.loan_skey,b.default_reason_description
,b.default_date,b.workflow_type_description,b.status_description,b.created_by
) b 
) a
where --loan_skey =210068 and 
rn=1


select a.loan_skey,a.loan_status_description 
,case when a.loan_status_description='FORECLOSURE' then j.default_reason_description else  i.default_reason_description end  as 'Default Reason'
,case when a.loan_status_description='FORECLOSURE' then j.default_date else  i.default_date end  as 'Default Date'
from rms.v_LoanMaster a
left join #tempTbl5 i on a.loan_skey=i.loan_skey
left join #tempTbl6 j on a.loan_skey=j.loan_skey
where loan_status_description in ('Default','Foreclosure')