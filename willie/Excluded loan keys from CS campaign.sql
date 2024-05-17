
IF OBJECT_ID('tempdb..#CSnotes') IS NOT NULL
    DROP TABLE #CSnotes;
select loan_skey,note_type_description,created_by,created_date 
into #CSnotes
from [ReverseQuest].[rms].[v_Note] 
where --loan_skey=249909
created_date -->= DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
between  DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()-1), 0) + '14:01'--AND   DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0) + '06:00' --Morning Call prior day 2pm to current day 6am 
--created_date between  DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0) + '06:01' 
AND   DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0) + '14:00' --Afternoon Call 6am	current day	to 2pm current day		
and note_type_description in ('Call Req.-Cust. Mail Req. Box',
'Call Request - LOC – 10%',
'Call Request-Claim Assignments',
'Call Request - COP Change',
'Call Request - LOC – 20%',
'Call Request-Follow-Up Disb.',
'Call Request - FEMA Follow-Up',
'Call Request - Proof of Ins.',
'Call Request-Proof of Paid Tax',
'Call Request - Short Payoff ',
'CALL Required – Disbursement',
'Call Request-Active Occupancy',
'CALL REQUIRED – DISBURSEMENTS',
'CALL Required – Disbursement',
'Call Required - DISBURSEMENTS',
'Call Required - ACH',
'Call Required - COP',
'Call Request - LOC – Depleted'
)
-- and loan_skey

--select * from #CSnotes where note_type_description in ('CALL REQUIRED – DISBURSEMENTS') ;
/*
IF OBJECT_ID('tempdb..#HRDnotes') IS NOT NULL
    DROP TABLE #HRDnotes;
select loan_skey,note_type_description,created_by,created_date 
into #HRDnotes
from [ReverseQuest].[rms].[v_Note] 
where 
--created_date >    DATEADD(HOUR, -13, getdate()) and  created_date <   DATEADD(HOUR, -1, getdate())
--created_date between  DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()-3), 0) + '14:01'AND   DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0) + '06:00' --Monday Morning Call prior day 2pm to current day 6am 
created_date between  DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()-1), 0) + '14:01'--AND   DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0) + '06:00' --Morning Call prior day 2pm to current day 6am 
--created_date between  DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0) + '06:01' 
AND   DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0) + '14:00' --Afternoon Call 6am	current day	to 2pm current day		
and note_type_description in ('Call Reques - NY 1st Attempt',
'Call Request - Covid Ext.',
'Call Request - LOC – Depleted',
'Call Request - NY 2nd Attempt',
'Call Request - MAM',
'Call Request-BOA Death Notice',
'Call Request - Borrower Intent',
'Call Request - Cust. Follow-Up',
'Call Request - Mktg. Ext.',
'Call Request - NY 3rd Attempt',
'Call Request - Seattle Bank',
'Call Request-Conveyed Title',
'Call Request - CA ',
'Call Request - DIL',
'Call Request - NBS Follow-Up',
'Call Request - Property Pres.',
'Call Request - Short Sale',
'Call Request-FCReferral Review',
'Call Request - HAF Calls  ',
'Call Request - NV',
'Call Request - Repayment Plan',
'Call Request - WA',
'Call Request-Loss Draft&Repair',
'Call Request - HOA default  ',
'Call Request-At-Risk Ext.  ',
'Call Request-Tax & Ins Default'
)
*/


 IF OBJECT_ID('tempdb..#obexclusion') IS NOT NULL
    DROP TABLE #obexclusion;
select * into #obexclusion
from (
select loan_skey,alert_type_description,created_by,created_date from [ReverseQuest].[rms].[v_Alert]
where alert_type_description  in ('FDCPA -  Call Restrictions','Cease and Desist','Pending Cease and Desist','LITIGATION - Lawsuit Pending','DVN Research Request Pend',
'Identity Theft','Fraud Suspicion','DVN Research Request Pend'
)and alert_status_description = 'Active'
union all
select loan_skey,alert_type_description,created_by,created_date from [ReverseQuest].[rms].[v_Alert]
where alert_type_description  in ('SKPADD','SKPEML','SKPEXH','SKPTRC')
and alert_status_description = 'Active'
union all
select b.loan_skey,a.workflow_task_description,a.created_by,a.created_date
  --,a.workflow_instance_skey,a.complete_date
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a join [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
  where a.workflow_task_description ='3rd Party Sale'
  and a.status_description = 'Active' and b.status_description = 'Active'
  and a.complete_date is not null
union all
select a.loan_skey,a.note_type_description,a.created_by,a.created_date as 'created_date' from (
select *,ROW_NUMBER() OVER (PARTITION BY a.loan_skey  ORDER BY a.created_date desc) as 'rn1' from(
select * from (
select a.loan_skey,a.note_type_description,a.created_by,a.created_date as 'created_date' 
,ROW_NUMBER() OVER (PARTITION BY a.loan_skey  ORDER BY a.created_date desc) as 'rn'
from reversequest.rms.v_note a
where a.created_date
>= DATEADD(d,-6,DATEDIFF(d,0,GETDATE())) and
a.created_date < DATEADD(d,0,DATEDIFF(d,0,GETDATE()))
and (a.note_type_description like '%Incom%' or note_type_description like 'Spoc Incom%')
and a.created_by like 'System Load'
)a where rn=1

Union all

select * from (
select a.loan_skey,a.note_type_description,a.created_by,a.created_date as 'created_date' 
,ROW_NUMBER() OVER (PARTITION BY a.loan_skey  ORDER BY a.created_date desc) as 'rn'
from reversequest.rms.v_note a
where a.created_date
>= DATEADD(d,-7,DATEDIFF(d,0,GETDATE())) and
a.created_date < DATEADD(d,0,DATEDIFF(d,0,GETDATE()))
and (a.note_type_description like '%Incom%' or note_type_description like 'Spoc Incom%')
and a.created_by not like 'System Load'
) a where  rn=1


union all
select * from (
select a.loan_skey,a.note_type_description,a.created_by,a.created_date 
,ROW_NUMBER() OVER (PARTITION BY a.loan_skey  ORDER BY a.created_date desc) as 'rn'
from reversequest.rms.v_note a
where a.created_date
>= DATEADD(d,-6,DATEDIFF(d,0,GETDATE())) and
a.created_date < DATEADD(d,1,DATEDIFF(d,0,GETDATE()))
and a.note_type_description like 'Contact - RPC' and a.created_by in ('Vishnu V Thannickal','Mohit Gandhi')
) a where rn=1

Union all
select * from (
select a.loan_skey,a.note_type_description,a.created_by,a.created_date 
,ROW_NUMBER() OVER (PARTITION BY a.loan_skey  ORDER BY a.created_date desc) as 'rn'
from reversequest.rms.v_note a
where a.created_date
>=  DATEADD(d,-7,DATEDIFF(d,0,GETDATE())) and
a.created_date <  DATEADD(d,0,DATEDIFF(d,0,GETDATE()))
and a.note_type_description like 'Contact - RPC' and a.created_by not in ('Vishnu V Thannickal','Mohit Gandhi')
) a where  rn=1
) a where  rn=1
) a where  rn1=1

union all
SELECT  a.[loan_skey],b.workflow_task_description,b.created_by,b.created_date     
  FROM [ReverseQuest].[rms].[v_WorkflowInstance] a 
  join ReverseQuest.rms.v_WorkflowTaskActivity  b on a.workflow_instance_skey=b.workflow_instance_skey 
where a.workflow_type_description like 'Due & Payable w/ HUD Approval' and a.status_description='Active' and 
    b.workflow_task_description like 'Request to Rescind D&P'  and b.status_description='Active'
union all
SELECT  a.[loan_skey],b.workflow_task_description,b.created_by,b.created_date      
  FROM [ReverseQuest].[rms].[v_WorkflowInstance] a 
  join ReverseQuest.rms.v_WorkflowTaskActivity  b on a.workflow_instance_skey=b.workflow_instance_skey 
  where workflow_type_description = 'Foreclosure - Judicial' and a.status_description='Active'
  and b.workflow_task_description = 'Send Rescission Request to HUD' and b.status_description='Active'
union all
SELECT  a.[loan_skey],b.workflow_task_description,b.created_by,b.created_date     
  FROM [ReverseQuest].[rms].[v_WorkflowInstance] a 
  join ReverseQuest.rms.v_WorkflowTaskActivity  b on a.workflow_instance_skey=b.workflow_instance_skey 
  where  workflow_type_description like 'Foreclosure - Non Judicial' and a.status_description='Active'
  and b.workflow_task_description = 'Send Rescission Request to HUD' and b.status_description='Active'
  ) a

--select * from #obexclusion where loan_skey='249909'

select 
a.loan_skey,a.note_type_description,format(a.created_date,'yyyy/MM/dd') as 'created_date',a.created_by,
b.alert_type_description as 'Exclusion_Reason',format(b.created_date,'yyyy/MM/dd') as 'Exclusion_Created_date',b.created_by as 'Exclusion_Created_by',format(b.created_date+7,'yyyy/MM/dd') as 'Rollover_date'
from #CSnotes a
join #obexclusion b on a.loan_skey=b.loan_skey and a.created_date>b.created_date
where a.note_type_description not in ('CALL REQUIRED – DISBURSEMENTS','Call Required - ACH',
'Call Required - COP')
union all
select 
a.loan_skey,a.note_type_description,format(a.created_date,'yyyy/MM/dd') as 'created_date',a.created_by,
b.alert_type_description as 'Exclusion_Reason',format(b.created_date,'yyyy/MM/dd') as 'Exclusion_Created_date',b.created_by as 'Exclusion_Created_by',format(b.created_date+7,'yyyy/MM/dd') as 'Rollover_date'
from #CSnotes a
join #obexclusion b on a.loan_skey=b.loan_skey and a.created_date<b.created_date
where a.note_type_description in ('CALL REQUIRED – DISBURSEMENTS','Call Required - ACH',
'Call Required - COP')
and b.alert_type_description in('FDCPA -  Call Restrictions','Cease and Desist','Pending Cease and Desist','LITIGATION - Lawsuit Pending','DVN Research Request Pend',
'Identity Theft','Fraud Suspicion','DVN Research Request Pend','SKPADD','SKPEML','SKPEXH','SKPTRC','3rd Party Sale')
order by a.loan_skey;

/*
select 
a.loan_skey,a.note_type_description,format(a.created_date,'yyyy/MM/dd') as 'created_date',a.created_by,
b.note_type_description as 'Exclusion_Reason',format(b.created_date,'yyyy/MM/dd') as 'Exclusion_Created_date',b.created_by as 'Exclusion_Created_by',format(b.created_date+7,'yyyy/MM/dd') as 'Rollover_date'
from #rtempDISBURSEMENTS a
join #finalexclusion b on a.loan_skey=b.loan_skey and a.created_date<b.created_date
where a.note_type_description='CALL REQUIRED – DISBURSEMENTS'
order by a.loan_skey;

select 
a.loan_skey,a.note_type_description,format(a.created_date,'yyyy/MM/dd') as 'created_date',a.created_by,
b.note_type_description as 'Exclusion_Reason',format(b.created_date,'yyyy/MM/dd') as 'Exclusion_Created_date',b.created_by as 'Exclusion_Created_by',format(b.created_date+7,'yyyy/MM/dd') as 'Rollover_date'
from #HRDnotes a
join #finalexclusion b on a.loan_skey=b.loan_skey
order by a.loan_skey;
*/