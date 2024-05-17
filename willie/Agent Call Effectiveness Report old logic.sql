 IF OBJECT_ID('tempdb..#Temp1') IS NOT NULL
    DROP TABLE #Temp1;
select 
loan_skey,upper(replace(Agent_name,', ',',')) Agent_name1,
--replace(LEFT(upper(replace(Agent_name,', ',',')), CHARINDEX(',', upper(replace(Agent_name,', ',',')))),',','') last_name,
--REPLACE(SUBSTRING(upper(replace(Agent_name,', ',',')), CHARINDEX(',', upper(replace(Agent_name,', ',','))), LEN(upper(replace(Agent_name,', ',',')))), ',', '') first_name,
CONCAT(REPLACE(SUBSTRING(upper(replace(Agent_name,', ',',')), CHARINDEX(',', upper(replace(Agent_name,', ',','))), LEN(upper(replace(Agent_name,', ',',')))), ',', ''),' ', replace(LEFT(upper(replace(Agent_name,', ',',')), CHARINDEX(',', upper(replace(Agent_name,', ',',')))),',','')) Agent_name
,[RPC Note category],[RPC Note],[RPC NoteText],[RPC Created by],[RPC created_date]
into #Temp1
from (
select a.loan_skey,
case when substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30) like '%(%' then 
reverse(substring(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30) 
), CHARINDEX('(', reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))+1, len(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))))
when substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30) like '%_%' then
reverse(substring(reverse (

reverse(substring(reverse (
reverse(substring(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30) 
), CHARINDEX('_', reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))+1, len(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))))
), CHARINDEX('_', reverse (
reverse(substring(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30) 
), CHARINDEX('_', reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))+1, len(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))))
))+1, len(reverse (
reverse(substring(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30) 
), CHARINDEX('_', reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))+1, len(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))))
))))
), CHARINDEX('_', reverse (
reverse(substring(reverse (
reverse(substring(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30) 
), CHARINDEX('_', reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))+1, len(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))))
), CHARINDEX('_', reverse (
reverse(substring(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30) 
), CHARINDEX('_', reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))+1, len(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))))
))+1, len(reverse (
reverse(substring(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30) 
), CHARINDEX('_', reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))+1, len(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))))
))))
))+1, len(reverse (
reverse(substring(reverse (
reverse(substring(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30) 
), CHARINDEX('_', reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))+1, len(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))))
), CHARINDEX('_', reverse (
reverse(substring(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30) 
), CHARINDEX('_', reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))+1, len(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))))
))+1, len(reverse (
reverse(substring(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30) 
), CHARINDEX('_', reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))+1, len(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))))
))))
))))
else 
''
end 
as Agent_name
--,substring(note_text,CHARINDEX('Contact_RPC_', note_text)+22,30) as notetext_date
,a.note_type_category_description 'RPC Note category'
,a.note_type_description 'RPC Note',a.note_text 'RPC NoteText',a.created_by 'RPC Created by',convert(date,a.created_date) 'RPC created_date'
/*,b.note_type_category_description 'Loss Note category',
b.note_type_description 'Loss Note type',
b.note_text 'Loss Note text',
b.created_by 'Loss Created by',
b.created_date 'Loss Created Date'*/
from rms.v_Note a
/*join (
select loan_skey,note_type_category_description,
note_type_description,note_text,upper(created_by) created_by,convert(date,created_date) created_date from rms.v_Note
where note_type_description in ('Loss Mit Referral – DIL','Loss Mit Referral – SS','Loss Mit Referral–At-Risk Ext.'
,'Loss Mit Referral–Mktg. Ext.','Promise Occupancy ','Promise Payoff ','Promise Reinstatement Funds',
'Promise Tax & Ins Doc')
and created_date >= convert(date,'2024-03-18')
) b on a.loan_skey=b.loan_skey and convert(date,a.created_date)=b.created_date*/
where a.note_type_description='Contact - RPC'
and a.created_by ='System Load'
and a.created_date>=convert(date,'2024-03-18')
--and a.created_date<=convert(date,'2024-03-28')
and a.created_date <  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
/*and loan_skey in(select loan_skey
--,note_type_description,note_text,created_by,convert(date,created_date) created_date 
from rms.v_Note
where note_type_description in ('Loss Mit Referral – DIL','Loss Mit Referral – SS','Loss Mit Referral–At-Risk Ext.'
,'Loss Mit Referral–Mktg. Ext.','Promise Occupancy ','Promise Payoff ','Promise Reinstatement Funds',
'Promise Tax & Ins Doc')
and created_date >= convert(date,'2024-03-18') -- to fetch one day prior data
and created_date <=DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
--order by loan_skey,note_type_description;
)*/
) b
where loan_skey in (
select loan_skey from rms.v_LoanMaster
where investor_name in ('Bank of America',
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
)
order by b.loan_skey;

---select * from #Temp1 where loan_skey=21186

IF OBJECT_ID('tempdb..#Temp2') IS NOT NULL
    DROP TABLE #Temp2;
select 
rn,
loan_skey,
note_type_description,
convert(date,created_date) created_date,
created_by,
responsible_party_id,
convert(date,complete_date) complete_date,
workflow_task_description,
[credits through life of the workflow]
into  #Temp2
from(
---Promise Payoff-----
SELECT 1 as rn,  a.loan_skey, 
--' ' as workflow_instance_skey
c.note_type_description,
a.created_date,a.created_by,c.created_by as 'responsible_party_id',a.transaction_date as 'complete_date',
a.long_transaction_description as workflow_task_description,2 as 'credits through life of the workflow'
--,c.created_date,c.created_by,datediff(day,c.created_date,a.complete_date) as diff
  FROM 
  [ReverseQuest].[rms].[v_Transaction] a
	join
	(select loan_skey,created_by,created_date,note_type_description from(
select loan_skey,created_by,created_date,note_type_description,
row_number() over(partition by loan_skey order by created_date desc) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Promise Payoff '
and created_by not in  ('Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad') 
) as T where rn=1
) c
	on a.loan_skey=c.loan_skey
  where a.long_transaction_description like 'Payoff%'
  and datediff(day,c.created_date,a.transaction_date)  >= 0 and datediff(day,c.created_date,a.transaction_date)  <=30
  and a.transaction_date >=   DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and 
a.transaction_date <  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
  and c.created_by not in ('Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad') 
union all
------Promise Tax & Ins Doc with Receipt of Borrower Policy Information
SELECT 1 as rn,  a.loan_skey, --a.workflow_instance_skey
c.note_type_description
,a.created_date,a.created_by,c.created_by as 'responsible_party_id',a.complete_date,
a.workflow_task_description,1 as 'credits through life of the workflow'
--,c.created_date,c.created_by,datediff(day,c.created_date,a.complete_date) as diff
  FROM 
  (select loan_skey,workflow_instance_skey,[workflow_task_description],status_description,created_by,created_date,complete_date from
(
SELECT b.loan_skey
      ,[workflow_task_description]
	  ,a.workflow_instance_skey
	  ,a.status_description
	  ,a.created_by
	  ,a.created_date
	  ,complete_date,
	  row_number() over(partition by loan_skey order by a.created_date desc) as rn
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join
  [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
  where a.workflow_task_description = 'Receipt of Borrower Policy Information'
  and a.status_description = 'Active' 
  and a.complete_date >= DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and 
a.complete_date <  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
)as T where rn=1) a
	join
	(select loan_skey,created_by,created_date,note_type_description from(
select loan_skey,created_by,created_date,note_type_description,
row_number() over(partition by loan_skey order by created_date desc) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Promise Tax & Ins Doc') as T where rn=1
) c
	on a.loan_skey=c.loan_skey
  where datediff(day,c.created_date,a.complete_date) >= 0 and datediff(day,c.created_date,a.complete_date)  <=30
  and c.created_by not in ('RMS.RepaymentPlan' , 'System.Default','Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad') 
union all
------Promise Tax & Ins Doc with Receipt of Proof of Taxes Paid
SELECT 1 as rn,  a.loan_skey,-- a.workflow_instance_skey
c.note_type_description
,a.created_date,a.created_by,c.created_by as 'responsible_party_id',a.complete_date,
a.workflow_task_description,1 as 'credits through life of the workflow'
--,c.created_date,c.created_by,datediff(day,c.created_date,a.complete_date) as diff
  FROM (select loan_skey,workflow_instance_skey,[workflow_task_description],status_description,created_by,created_date,complete_date from
(
SELECT b.loan_skey
      ,[workflow_task_description]
	  ,a.workflow_instance_skey
	  ,a.status_description
	  ,a.created_by
	  ,a.created_date
	  ,complete_date,
	  row_number() over(partition by loan_skey order by a.created_date desc) as rn
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join
  [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
  where a.workflow_task_description = 'Receipt of Proof of Taxes Paid'
  and a.status_description = 'Active' 
  and a.complete_date >=  DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and 
a.complete_date <  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
)as T where rn=1) a
	join
	(select loan_skey,created_by,created_date,note_type_description from(
select loan_skey,created_by,created_date,note_type_description,
row_number() over(partition by loan_skey order by created_date desc) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Promise Tax & Ins Doc') as T where rn=1
) c
	on a.loan_skey=c.loan_skey
  where datediff(day,c.created_date,a.complete_date)  >= 0 and datediff(day,c.created_date,a.complete_date)  <=30
  and c.created_by  not in ('RMS.RepaymentPlan' , 'System.Default','Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad') 
union all
--Loss Mit Referral – DIL with Receipt of Executed Deed -Instruct Attorney to record
SELECT distinct 1 as rn,  b.loan_skey,-- a.workflow_instance_skey,
c.note_type_description
,a.created_date,a.created_by,c.created_by as 'responsible_party_id',a.complete_date,
a.workflow_task_description,2 as 'credits through life of the workflow'
--,c.created_date,c.created_by
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
	join [ReverseQuest].[rms].[v_WorkflowInstance] b
	join
	(select loan_skey,created_by,created_date,note_type_description from(
select loan_skey,created_by,created_date,note_type_description,
row_number() over(partition by loan_skey order by created_date desc) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Loss Mit Referral – DIL') as T where rn=1
) c
	on b.loan_skey=c.loan_skey
on a.workflow_instance_skey=b.workflow_instance_skey
  where (a.workflow_task_description = 'Receipt of Executed Deed -Instruct Attorney to record')
  and a.status_description = 'Active' and c. note_type_description = 'Loss Mit Referral – DIL'
--and a.created_date > DATEADD(m,-0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
--and a.created_date < DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and a.complete_date >= DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and 
a.complete_date <  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and c.created_date < a.created_date
and responsible_party_id not in ('RMS.RepaymentPlan','System.Default','Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad') 
union all

--Loss Mit Referral – SS

SELECT distinct 1 as rn,  b.loan_skey, --a.workflow_instance_skey
c.note_type_description
,a.created_date,c.created_by,c.created_by as 'responsible_party_id',a.complete_date,
a.workflow_task_description,3 as 'credits through life of the workflow'
--,c.created_date,c.created_by
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
	join [ReverseQuest].[rms].[v_WorkflowInstance] b
	join
	(select loan_skey,created_by,created_date,note_type_description from(
select loan_skey,created_by,created_date,note_type_description,
row_number() over(partition by loan_skey order by created_date desc) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Loss Mit Referral – SS') as T where rn=1 
) c
	on b.loan_skey=c.loan_skey
on a.workflow_instance_skey=b.workflow_instance_skey
  where (a.workflow_task_description = 'Receipt of Short Sale Closing Proceeds' 
  or a.workflow_task_description = 'Receipt of Family Sale Proceeds')
  and a.status_description = 'Active' and c. note_type_description = 'Loss Mit Referral – SS'
and a.complete_date >=    DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))  
and 
a.complete_date <   DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and c.created_date < a.created_date 
and responsible_party_id not in ('RMS.RepaymentPlan' , 'System.Default'
--,'Clarisa Centeno','Clarisa.Centeno',
--'Don Anthony Eusebio',
--'Don Anthony.Eusebio',
--'Vincent Gherardi','Vincent.Gherardi',
--'Jerrick Natividad','Jerrick.Natividad'
) 
union all
--Loss Mit Referral–At-Risk Ext.

select 1 as rn, a.loan_skey,-- '-' as 'Workflow_instance_skey'
a.note_type_description
,a.created_date
,a.created_by,a.created_by as 'responsible_party_id',a.created_date as 'complete_date', 'At Risk Extn Credit' as workflow_task_description
,1 as 'credits through life of the workflow'
--,b.created_date as 'alert date',dateadd(dd,30,a.created_date) as 'diff'
from
(select loan_skey,created_by,created_date,note_type_description from(
select loan_skey,created_by,created_date,note_type_description,
row_number() over(partition by loan_skey order by created_date desc) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Loss Mit Referral–At-Risk Ext.'
and created_date > = DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and created_date < DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
) as T where rn=1
) a
join
[ReverseQuest].[rms].[v_Alert] b
on a.loan_skey=b.loan_skey
where 
a.note_type_description = 'Loss Mit Referral–At-Risk Ext.'  
and b.alert_status_description = 'Active' and b.alert_type_description = 'At Risk Extension'
and a.created_date >=  DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and a.created_date < DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and b.created_date >=a.created_date 
--and b.created_date >=a.created_date and b.created_date <= dateadd(dd,30,a.created_date)
and a.created_by not in ('RMS.RepaymentPlan' , 'System.Default','Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad') 

union all

--Loss Mit Referral–Mktg. Ext.

select 1 as rn, a.loan_skey, --'-' as 'Workflow_instance_skey'
a.note_type_description
,a.created_date
,a.created_by,a.created_by as 'responsible_party_id',a.created_date as 'complete_date', 'Marketing Extn Credit' as workflow_task_description
,1 as 'credits through life of the workflow'
--,b.created_date as 'alert date',dateadd(dd,30,a.created_date) as 'diff'
from
(select loan_skey,created_by,created_date,note_type_description from(
select loan_skey,created_by,created_date,note_type_description,
row_number() over(partition by loan_skey order by created_date desc) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Loss Mit Referral–Mktg. Ext.'
and created_date >=  DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and created_date < DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
) as T where rn=1
)  a
join
[ReverseQuest].[rms].[v_Alert] b
on a.loan_skey=b.loan_skey
where 
a.note_type_description = 'Loss Mit Referral–Mktg. Ext.'  
and b.alert_status_description = 'Active' and b.alert_type_description = 'Pending Marketing Extension Request'
and a.created_date >= DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and a.created_date < DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and b.created_date >=a.created_date 
--and b.created_date >=a.created_date and b.created_date <= dateadd(dd,30,a.created_date)
and a.created_by  not in ('RMS.RepaymentPlan' , 'System.Default','Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad') 

union all
--'Promise Occupancy ','Verbal Occ Obtained'
SELECT 1 as rn,  a.loan_skey, --a.workflow_instance_skey
c.note_type_description
,a.created_date,a.created_by,c.created_by as 'responsible_party_id',a.complete_date,
a.workflow_task_description,1 as 'credits through life of the workflow'
--,c.created_date,c.created_by,datediff(day,c.created_date,a.complete_date) as diff
  FROM 
  
  (select loan_skey,workflow_instance_skey,[workflow_task_description],status_description,created_by,created_date,complete_date from
(
SELECT b.loan_skey
      ,[workflow_task_description]
	  ,a.workflow_instance_skey
	  ,a.status_description
	  ,a.created_by
	  ,a.created_date
	  ,complete_date,
	  row_number() over(partition by loan_skey order by a.created_date desc) as rn
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join
  [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
  where a.workflow_task_description = 'Receipt of Annual Occupancy Certification Letter'
  and a.status_description = 'Active' 
  and a.complete_date >=   DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and 
a.complete_date <  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
--and b.loan_skey in('221050','188739')
)as T where rn=1) a
	join
	(select loan_skey,created_by,created_date,note_type_description from(
select loan_skey,created_by,created_date,note_type_description,
row_number() over(partition by loan_skey order by created_date desc) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description in ('Promise Occupancy ','Verbal Occ Obtained')
--and loan_skey in('221050','188739')
) as T where rn=1
) c
	on a.loan_skey=c.loan_skey
  where datediff(day,c.created_date,a.complete_date) >= 0 and datediff(day,c.created_date,a.complete_date) <=30
  and c.created_by not in ('RMS.RepaymentPlan' , 'System.Default','Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad') 

union all
--Promise Reinstatement Funds

select 1 as rn,a.loan_skey,--'' as workflow_instance_skey
a.note_type_description
,a.created_date
,'' as created_by,a.created_by as 'responsible_party_id',c.created_date as 'complete_date'
,--c.long_transaction_description 
'Received of Tots Balance' as workflow_task_description,
case when c.total_remittance_amount >= 2000 and b.tots_balance=0 then 3
when c.total_remittance_amount < 2000 and b.tots_balance=0 then 2
else 0 end as 'credits through life of the workflow'
from(
select loan_skey,created_by,created_date,note_type_description from(
select loan_skey,created_by,created_date,note_type_description,
row_number() over(partition by loan_skey order by created_date desc) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Promise Reinstatement Funds'
and created_by not in  ('Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad') 
) as T where rn=1 
--and created_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
--and created_date <   DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
) a 
 join
(
select 
a.loan_skey,a.long_transaction_description,b.tots_balance
--,sum(a.principal_amount + a.interest_amount + a.mip_amount + a.service_fee_amount + a.corporate_advance_borrower_amount) as Tots
/*case when sum(a.principal_amount + a.interest_amount + a.mip_amount + a.service_fee_amount + a.corporate_advance_borrower_amount) <=0 then 0 else
sum(a.principal_amount + a.interest_amount + a.mip_amount + a.service_fee_amount + a.corporate_advance_borrower_amount) end as Tots*/
from [rms].[v_Transaction] a
join rms.v_MonthlyLoanDefaultSummary b on a.loan_skey=b.loan_skey
where a.long_transaction_description
in('Part Repay - Reduce Loan Bal ERNPL Revrs',
'Part Repay - Reduce Loan Balance',
'Part Repay - Reduce Loan Balance ERNPL')
and  a.transaction_date >=  DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and a.transaction_date <  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
/*and  a.created_by not in ('Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad')*/
and b.created_date >= DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and b.created_date <  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
and b.tots_balance=0
--group by a.loan_skey,a.long_transaction_description--,a.transaction_date
) b on a.loan_skey=b.loan_skey
left join (
select a.*,b.created_date,created_by from(
select loan_skey,short_transaction_description,long_transaction_description,
sum(total_remittance_amount) as total_remittance_amount--,effective_date,
--row_number() over (partition by loan_skey order by created_date desc ) sn,created_date,created_by
from  [rms].[v_LoanRemitHeader] where 
--loan_skey=283905 and 
 long_transaction_description  
 in('Part Repay - Reduce Loan Bal ERNPL Revrs',
'Part Repay - Reduce Loan Balance',
'Part Repay - Reduce Loan Balance ERNPL')
and status_description='Active'
and created_date >=  DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and created_date <  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
/*and created_by not in ('Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad')*/
group by loan_skey,short_transaction_description,long_transaction_description
--,effective_date,created_date,created_by
)a 
left join
(
select * from (
select loan_skey,short_transaction_description,long_transaction_description,
--sum(total_remittance_amount) as total_remittance_amount,effective_date,
row_number() over (partition by loan_skey order by created_date desc ) sn,created_date,created_by
from  [rms].[v_LoanRemitHeader] where 
--loan_skey=283905 and 
 long_transaction_description  
 in('Part Repay - Reduce Loan Bal ERNPL Revrs',
'Part Repay - Reduce Loan Balance',
'Part Repay - Reduce Loan Balance ERNPL')
and status_description='Active'
and created_date >= DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and created_date <  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
/*and created_by not in ('Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad')*/
group by loan_skey,short_transaction_description,long_transaction_description
,effective_date,created_date,created_by
)a where sn=1
) b on a.loan_skey=b.loan_skey
--where a.loan_skey=159721
)c on a.loan_skey=c.loan_skey
where --a.loan_skey=159721
datediff(day,c.created_date,a.created_date)  >= 0 
and datediff(day,c.created_date,a.created_date)  <=30
union all
--CFW

select 1 as rn, a.loan_skey, --'-' as 'Workflow_instance_skey'
a.workflow_type_description note_type_description
,'' created_date
,'' created_by,a.created_by as 'responsible_party_id',a.start_date as 'complete_date',a.workflow_task_description
,1 as 'credits through life of the workflow'

from
(
select loan_skey,workflow_type_description,workflow_task_description
,workflow_task_result_description,task_note,created_by,created_date,start_date
from (
  select 
b.loan_skey--,convert(date,a.complete_date) complete_date 
,convert(date,a.schedule_date) start_date
,a.workflow_task_description
,b.workflow_type_description
,a.workflow_task_result_description
,a.task_note
,upper(a.created_by) created_by,convert(date,a.created_date) created_date
--,a.workflow_task_result_description
--,a.task_note
--,a.workflow_task_description
,ROW_NUMBER() over (partition by b.loan_skey order by convert(date,a.original_schedule_date) desc,b.loan_skey) sn
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
   --and b.loan_skey=4123
 ) a where  sn=1 
 --and loan_skey=316578
 )a

) a


IF OBJECT_ID('tempdb..#Temp3') IS NOT NULL
    DROP TABLE #Temp3;
select 
a.[loan_skey],
a.[Agent_name],
a.[RPC Note category],
a.[RPC Note],
a.[RPC NoteText],
a.[RPC Created by],
a.[RPC created_date],
--a.loan_skey,
a.[Loss Mitigation category],
a.[Loss Note type],
a.[Loss Note text],
a.[Loss Created by],
a.[Loss Created Date],
a.cfw_wf_type,a.cfw_wf_task_result_desc,
a.cfw_task_note,
a.cfw_created_by,a.cfw_created_date,

--b.note_type_description,
b.workflow_task_description,
b.complete_date
into #Temp3
from(


select
a.loan_skey,a.Agent_name,a.[RPC Note category],
a.[RPC Note],a.[RPC NoteText],a.[RPC Created by],a.[RPC created_date]--,b.loan_skey 'LM Loan_skey'
,b.note_type_category_description 'Loss Mitigation category',
b.note_type_description 'Loss Note type',
b.note_text 'Loss Note text',
b.created_by 'Loss Created by',
b.created_date 'Loss Created Date',
b.workflow_type_description 'cfw_wf_type',
b.workflow_task_result_description 'cfw_wf_task_result_desc',
b.task_note 'cfw_task_note',
b.cfw_created_by,b.cfw_created_date
from #Temp1 a
 left  join (



select a.loan_skey,a.note_type_category_description,
a.note_type_description,a.note_text,upper(a.created_by) created_by,convert(date,a.created_date) created_date, 
b.workflow_type_description,b.workflow_task_result_description,b.task_note,b.created_by 'cfw_created_by',b.created_date 'cfw_created_date'
from rms.v_Note a
left join (
select loan_skey,workflow_type_description
,workflow_task_result_description,task_note,created_by,created_date
from (
  select 
b.loan_skey--,convert(date,a.complete_date) complete_date 
--,convert(date,a.created_date) created_date
,b.workflow_type_description
,a.workflow_task_result_description
,a.task_note
,upper(a.created_by) created_by,convert(date,a.created_date) created_date
--,a.workflow_task_result_description
--,a.task_note
--,a.workflow_task_description
,ROW_NUMBER() over (partition by b.loan_skey order by convert(date,a.created_date) desc,b.loan_skey) sn
    FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join
  [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
   join ReverseQuest.rms.v_LoanMaster c  on b.loan_skey=c.loan_skey
   where-- b.loan_skey=221558 and 
    b.workflow_type_description  in ('Cash Flow Analysis')
   and a.workflow_task_description in ('Complete Cash Flow Financial Analysis Form'/*,'Repayment Plan Manager Review'*/)
   and b.status_description in ('Active','Workflow Completed')
   and a.status_description in ('Active','Workflow Completed')
   --and b.loan_skey=4123
 ) a where sn=1 and created_date >= CONVERT(date,'2024-03-18')
 and created_date <  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
) b on a.loan_skey=b.loan_skey

where a.note_type_description in ('Loss Mit Referral – DIL','Loss Mit Referral – SS','Loss Mit Referral–At-Risk Ext.'
,'Loss Mit Referral–Mktg. Ext.','Promise Occupancy ','Promise Payoff ','Promise Reinstatement Funds',
'Promise Tax & Ins Doc','Verbal Occ Obtained','Promise Reinstatement Funds')
and a.created_date >= convert(date,'2024-03-18')
 and a.created_date <  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))






) b on a.loan_skey=b.loan_skey --and a.Agent_name=b.created_by 
and replace(a.Agent_name,' ','')=replace (b.created_by,' ','')
and a.[RPC created_date]=b.created_date


--where a.Agent_name not like ''
union all

select * from (
select
b.loan_skey 'LM Loan_skey',--a.loan_skey,
coalesce(a.Agent_name, b.created_by) 'Agent_name',
coalesce(a.[RPC Note category],'Call') [RPC Note category],
coalesce(a.[RPC Note],'Contact - RPC') [RPC Note],
a.[RPC NoteText],
coalesce(a.[RPC Created by],'System Load') [RPC Created by],
coalesce(a.[RPC created_date],b.created_date) [RPC created_date]
,b.note_type_category_description 'Loss Mitigation category',
b.note_type_description 'Loss Note type',
b.note_text 'Loss Note text',
b.created_by 'Loss Created by',
b.created_date 'Loss Created Date',
b.workflow_type_description 'cfw_wf_type',
b.workflow_task_result_description 'cfw_wf_task_result_desc',
b.task_note 'cfw_task_note',
b.cfw_created_by,b.cfw_created_date
from #Temp1 a
right join (
select a.loan_skey,a.note_type_category_description,
a.note_type_description,a.note_text,upper(a.created_by) created_by,convert(date,a.created_date) created_date, 
b.workflow_type_description,b.workflow_task_result_description,b.task_note,b.created_by 'cfw_created_by',b.created_date 'cfw_created_date'
from rms.v_Note a
left join (
select loan_skey,workflow_type_description
,workflow_task_result_description,task_note,created_by,created_date
from (
  select 
b.loan_skey--,convert(date,a.complete_date) complete_date 
--,convert(date,a.created_date) created_date
,b.workflow_type_description
,a.workflow_task_result_description
,a.task_note
,upper(a.created_by) created_by,convert(date,a.created_date) created_date
--,a.workflow_task_result_description
--,a.task_note
--,a.workflow_task_description
,ROW_NUMBER() over (partition by b.loan_skey order by convert(date,a.created_date) desc,b.loan_skey) sn
    FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join
  [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
   join ReverseQuest.rms.v_LoanMaster c  on b.loan_skey=c.loan_skey
   where-- b.loan_skey=221558 and 
    b.workflow_type_description  in ('Cash Flow Analysis')
   and a.workflow_task_description in ('Complete Cash Flow Financial Analysis Form'/*,'Repayment Plan Manager Review'*/)
   and b.status_description in ('Active','Workflow Completed')
   and a.status_description in ('Active','Workflow Completed')
   --and b.loan_skey=4123
 ) a where sn=1 and created_date >= CONVERT(date,'2024-03-18')
 and created_date <  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
) b on a.loan_skey=b.loan_skey

where a.note_type_description in ('Loss Mit Referral – DIL','Loss Mit Referral – SS','Loss Mit Referral–At-Risk Ext.'
,'Loss Mit Referral–Mktg. Ext.','Promise Occupancy ','Promise Payoff ','Promise Reinstatement Funds',
'Promise Tax & Ins Doc','Verbal Occ Obtained','Promise Reinstatement Funds')
and a.created_date >= convert(date,'2024-03-18')
 and a.created_date <  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))

) b on a.loan_skey=b.loan_skey --and a.Agent_name=b.created_by 
and replace(coalesce(a.Agent_name,b.created_by),' ','')=replace (b.created_by,' ','')
and a.[RPC created_date]=b.created_date
where a.[RPC NoteText] is null

)a 


/*
EXCEPT  

select * from (
select
b.loan_skey 'LM Loan_skey',--a.loan_skey,
coalesce(a.Agent_name, b.cfw_created_by) 'Agent_name',
coalesce(a.[RPC Note category],'Call') [RPC Note category],
coalesce(a.[RPC Note],'Contact - RPC') [RPC Note],
a.[RPC NoteText],
coalesce(a.[RPC Created by],'System Load') [RPC Created by],
coalesce(a.[RPC created_date],b.cfw_created_date) [RPC created_date]
,NULL 'Loss Mitigation category',
NULL 'Loss Note type',
NULL 'Loss Note text',
NULL 'Loss Created by',
NULL 'Loss Created Date',
b.workflow_type_description 'cfw_wf_type',
b.workflow_task_result_description 'cfw_wf_task_result_desc',
b.task_note 'cfw_task_note',
b.cfw_created_by,b.cfw_created_date
from #Temp1 a
right join (

select loan_skey,workflow_type_description
,workflow_task_result_description,task_note,created_by cfw_created_by,created_date cfw_created_date
from (
  select 
b.loan_skey--,convert(date,a.complete_date) complete_date 
--,convert(date,a.created_date) created_date
,b.workflow_type_description
,a.workflow_task_result_description
,a.task_note
,upper(a.created_by) created_by,convert(date,a.created_date) created_date
--,a.workflow_task_result_description
--,a.task_note
--,a.workflow_task_description
,ROW_NUMBER() over (partition by b.loan_skey order by convert(date,a.created_date) desc,b.loan_skey) sn
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
   --and b.loan_skey=4123
 ) a where sn=1 and created_date >= CONVERT(date,'2024-03-18')
 and created_date <  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
--where note_type_category_description is null 


) b on a.loan_skey=b.loan_skey --and a.Agent_name=b.created_by 
--and replace(coalesce(a.Agent_name,b.cfw_created_by),' ','')=replace (b.created_by,' ','')
and a.[RPC created_date]=b.cfw_created_date
where a.[RPC NoteText] is null

)a */

) a
left join #Temp2 b on a.loan_skey=b.loan_skey and  a.[Loss Note type]=b.note_type_description  --or a.cfw_wf_type=b.note_type_description)
order by a.[RPC created_date];

/*
select * from #Temp3 a
--where loan_skey='278871'
order by a.[RPC created_date];*/

IF OBJECT_ID('tempdb..#Temp4') IS NOT NULL
    DROP TABLE #Temp4;
select 
a.[loan_skey],
a.[Agent_name],
a.[RPC Note category],
a.[RPC Note],
a.[RPC NoteText],
a.[RPC Created by],
a.[RPC created_date],
a.[cfw_wf_type],
a.[cfw_wf_task_result_desc],
a.[cfw_task_note],
--a.[cfw_created_by],
--a.[cfw_created_date],
a.[Loss Mitigation category],
a.[Loss Note type],
a.[Loss Note text],
--a.[Loss Created by],
--a.[Loss Created Date],
a.[workflow_task_description],
a.[complete_date]
 into #Temp4
from 
(

select 
a.[loan_skey],
a.[Agent_name],
a.[RPC Note category],
a.[RPC Note],
a.[RPC NoteText],
a.[RPC Created by],
a.[RPC created_date],
a.[Loss Mitigation category],
a.[Loss Note type],
a.[Loss Note text],
a.[Loss Created by],
a.[Loss Created Date],
a.[cfw_wf_type],
a.[cfw_wf_task_result_desc],
a.[cfw_task_note],
a.[cfw_created_by],
a.[cfw_created_date],
a.[workflow_task_description],
a.[complete_date]
from #Temp3 a
union 


select 
a.[loan_skey],
a.[Agent_name],
a.[RPC Note category],
a.[RPC Note],
a.[RPC NoteText],
a.[RPC Created by],
a.[RPC created_date],
a.[Loss Mitigation category],
a.[Loss Note type],
a.[Loss Note text],
a.[Loss Created by],
a.[Loss Created Date],
a.[cfw_wf_type],
a.[cfw_wf_task_result_desc],
a.[cfw_task_note],
a.[cfw_created_by],
a.[cfw_created_date],
b.workflow_task_description,
b.complete_date
from (
select
b.loan_skey ,--a.loan_skey,
coalesce(a.Agent_name, b.cfw_created_by) 'Agent_name',
coalesce(a.[RPC Note category],'Call') [RPC Note category],
coalesce(a.[RPC Note],'Contact - RPC') [RPC Note],
a.[RPC NoteText],
coalesce(a.[RPC Created by],'System Load') [RPC Created by],
coalesce(a.[RPC created_date],b.cfw_created_date) [RPC created_date]
,'Loss Mitigation' 'Loss Mitigation category',
NULL 'Loss Note type',
NULL 'Loss Note text',
NULL 'Loss Created by',
NULL 'Loss Created Date',
b.workflow_type_description 'cfw_wf_type',
b.workflow_task_result_description 'cfw_wf_task_result_desc',
b.task_note 'cfw_task_note',
b.cfw_created_by,b.cfw_created_date
from #Temp1 a
right join (

select loan_skey,workflow_type_description
,workflow_task_result_description,task_note,created_by cfw_created_by,created_date cfw_created_date
from (
  select 
b.loan_skey--,convert(date,a.complete_date) complete_date 
--,convert(date,a.created_date) created_date
,b.workflow_type_description
,a.workflow_task_result_description
,a.task_note
,upper(a.created_by) created_by,convert(date,a.created_date) created_date
--,a.workflow_task_result_description
--,a.task_note
--,a.workflow_task_description
,ROW_NUMBER() over (partition by b.loan_skey order by convert(date,a.created_date) desc,b.loan_skey) sn
    FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join
  [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
   join ReverseQuest.rms.v_LoanMaster c  on b.loan_skey=c.loan_skey
   where-- b.loan_skey=221558 and 
    b.workflow_type_description  in ('Cash Flow Analysis')
   and a.workflow_task_description in ('Complete Cash Flow Financial Analysis Form'/*,'Repayment Plan Manager Review'*/)
   and b.status_description in ('Active','Workflow Completed')
   and a.status_description in ('Active','Workflow Completed')
   --and b.loan_skey=4123
 ) a where sn=1 and created_date >= CONVERT(date,'2024-03-18')
 and created_date <  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
--where note_type_category_description is null 


) b on a.loan_skey=b.loan_skey --and a.Agent_name=b.created_by 
--and replace(coalesce(a.Agent_name,b.cfw_created_by),' ','')=replace (b.created_by,' ','')
and a.[RPC created_date]=b.cfw_created_date
where a.[RPC NoteText] is null

)a 
left join #Temp2 b on a.loan_skey=b.loan_skey and a.cfw_wf_type=b.note_type_description
)a 
order by a.[RPC created_date]
;

/*
select 
a.[loan_skey],
a.[Agent_name],
a.[RPC Note category],
a.[RPC Note],
a.[RPC NoteText],
a.[RPC Created by],
a.[RPC created_date],
a.[cfw_wf_type],
a.[cfw_wf_task_result_desc],
a.[cfw_task_note],
--b.workflow_task_result_description review_result,
--b.task_note review_note,
a.[Loss Mitigation category],
a.[Loss Note type],
a.[Loss Note text],
a.[workflow_task_description],
a.[complete_date]
--,dense_rank() over (partition by a.loan_skey order by a.[RPC created_date] asc,a.loan_skey )
from #Temp4 a
where a.loan_skey=21186
order by [RPC created_date]
;*/


IF OBJECT_ID('tempdb..#Temp5') IS NOT NULL
    DROP TABLE #Temp5;
select * 
into #temp5
from #Temp4
where cfw_wf_type is not null or [Loss Note type] is not null

--select * from #temp5 where loan_skey=4123


delete a
 from #Temp4 a 
 join #temp5 b on a.loan_skey=b.loan_skey and (a.[RPC created_date]>b.[RPC created_date] and a.[RPC created_date]<  dateadd(DAY,30,b.[RPC created_date])   )

--where a.loan_skey=4123
--order by a.loan_skey
/*delete a
 from #Temp4 a 
 join #temp5 b on a.loan_skey=b.loan_skey and (a.[RPC created_date]>b.[RPC created_date] and a.[RPC created_date]<  dateadd(DAY,30,b.[RPC created_date])   )
 and a.[Loss Mitigation category]
 */


IF OBJECT_ID('tempdb..#Temp6') IS NOT NULL
    DROP TABLE #Temp6;
select 
a.[loan_skey],
a.[servicer_name],
a.[investor_name],
a.[Default Reason],
a.[Agent_name],
a.[RPC Note category],
a.[RPC Note],
a.[RPC NoteText],
a.[RPC Created by],
a.[RPC created_date],
a.[cfw_wf_type],
a.[cfw_wf_task_result_desc],
a.[cfw_task_note],
a.[Loss Mitigation category],
a.[Loss Note type],
a.[Loss Note text],
a.[workflow_task_description],
a.[complete_date],
ROW_NUMBER() over ( partition by a.loan_skey order by a.[RPC created_date], a.[Loss Mitigation category] asc,a.loan_skey ) dn,
case when a.[Loss Mitigation category]='No Promise' then 1
when  a.[Loss Mitigation category]='Loss Mitigation' then ROW_NUMBER() over ( partition by a.loan_skey order by a.[Loss Mitigation category] asc,a.loan_skey )
when a.[Loss Mitigation category]='No Promise' then ROW_NUMBER() over ( order by a.[Loss Mitigation category] asc,a.loan_skey )+1 end as
sn
into #Temp6
from (
select 
a.[loan_skey],
b.servicer_name,
b.investor_name,
a.[Default Reason],
a.[Agent_name],
a.[RPC Note category],
a.[RPC Note],
a.[RPC NoteText],
a.[RPC Created by],
a.[RPC created_date],
a.[cfw_wf_type],
a.[cfw_wf_task_result_desc],
a.[cfw_task_note],
case when  a.[Loss Mitigation category] is null then 'No Promise' else a.[Loss Mitigation category] end as  'Loss Mitigation category',
a.[Loss Note type],
a.[Loss Note text],
case when 
a.[Loss Mitigation category] ='Loss Mitigation' and a.[workflow_task_description] IS null then 'Loss Mitigation Pending Completion'
else a.[workflow_task_description] end as [workflow_task_description],
a.[complete_date]
from(
select 
a.[loan_skey],
b.default_reason_description 'Default Reason',
a.[Agent_name],
a.[RPC Note category],
a.[RPC Note],
a.[RPC NoteText],
a.[RPC Created by],
a.[RPC created_date],
a.[cfw_wf_type],
a.[cfw_wf_task_result_desc],
a.[cfw_task_note],
case 
when a.[cfw_wf_type]='Cash Flow Analysis' and a.[Loss Mitigation category] IN (NULL,'NULL','','Servicing') 
then 'Loss Mitigation'
when a.[Loss Mitigation category] IN ('Servicing') then 'Loss Mitigation'

else a.[Loss Mitigation category]
end 'Loss Mitigation category',
a.[Loss Note type],
a.[Loss Note text],
a.[workflow_task_description],
a.[complete_date]
from #Temp4 a
left join /*(
select * from (
select loan_skey,default_reason_description,convert(date,created_date) created_date,
ROW_NUMBER() over (partition by loan_skey order by convert(date,created_date) desc  ) th 
from [rms].[v_LoanDefaultInformation]
) a where th=1
)*/
[rms].[v_LoanDefaultInformation] b on a.loan_skey=b.loan_skey
) a 
 join rms.v_LoanMaster b on a.loan_skey=b.loan_skey
where a.loan_skey in (
select loan_skey from rms.v_LoanMaster
where investor_name in ('Bank of America',
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
)
) a
--where a.loan_skey=1300
order by a.loan_skey,a.[RPC created_date];
/*
delete
select a.* 
from #Temp6 a order by a.loan_skey,a.[RPC created_date]
join #Temp6 b on a.loan_skey=b.loan_skey and a.[Loss Mitigation category]='Loss Mitigation'
and a.sn>b.sn
order by a.loan_skey,a.[RPC created_date]*/


--select * from #Temp6 a order by a.loan_skey,a.[RPC created_date];



IF OBJECT_ID('tempdb..#Temp7') IS NOT NULL
    DROP TABLE #Temp7;
select *
into #Temp7
from (
select 
a.[loan_skey],
a.[servicer_name],
a.[investor_name],
a.[Default Reason],
a.[Agent_name],
a.[RPC Note category],
a.[RPC Note],
a.[RPC NoteText],
a.[RPC Created by],
a.[RPC created_date],
a.[cfw_wf_type],
a.[cfw_wf_task_result_desc],
a.[cfw_task_note],
a.[Loss Mitigation category],
a.[Loss Note type],
a.[Loss Note text],
a.[workflow_task_description],
a.[complete_date],
ROW_NUMBER() over ( partition by a.loan_skey order by a.[RPC created_date], a.[Loss Mitigation category] asc,a.loan_skey ) dn,
case when a.[Loss Mitigation category]='No Promise' then 1
when  a.[Loss Mitigation category]='Loss Mitigation' then ROW_NUMBER() over ( partition by a.loan_skey order by a.[Loss Mitigation category] asc,a.loan_skey )
when a.[Loss Mitigation category]='No Promise' then ROW_NUMBER() over ( order by a.[Loss Mitigation category] asc,a.loan_skey )+1 end as
sn
from (
select 
a.[loan_skey],
b.servicer_name,
b.investor_name,
a.[Default Reason],
a.[Agent_name],
a.[RPC Note category],
a.[RPC Note],
a.[RPC NoteText],
a.[RPC Created by],
a.[RPC created_date],
a.[cfw_wf_type],
a.[cfw_wf_task_result_desc],
a.[cfw_task_note],
case when  a.[Loss Mitigation category] is null then 'No Promise' else a.[Loss Mitigation category] end as  'Loss Mitigation category',
a.[Loss Note type],
a.[Loss Note text],
case when 
a.[Loss Mitigation category] ='Loss Mitigation' and a.[workflow_task_description] IS null then 'Loss Mitigation Pending Completion'
else a.[workflow_task_description] end as [workflow_task_description],
a.[complete_date]
from(
select 
a.[loan_skey],
b.default_reason_description 'Default Reason',
a.[Agent_name],
a.[RPC Note category],
a.[RPC Note],
a.[RPC NoteText],
a.[RPC Created by],
a.[RPC created_date],
a.[cfw_wf_type],
a.[cfw_wf_task_result_desc],
a.[cfw_task_note],
case 
when a.[cfw_wf_type]='Cash Flow Analysis' and a.[Loss Mitigation category] IN (NULL,'NULL','','Servicing') 
then 'Loss Mitigation'
when a.[Loss Mitigation category] IN ('Servicing') then 'Loss Mitigation'

else a.[Loss Mitigation category]
end 'Loss Mitigation category',
a.[Loss Note type],
a.[Loss Note text],
a.[workflow_task_description],
a.[complete_date]
from #Temp4 a
left join /*(
select * from (
select loan_skey,default_reason_description,convert(date,created_date) created_date,
ROW_NUMBER() over (partition by loan_skey order by convert(date,created_date) desc  ) th 
from [rms].[v_LoanDefaultInformation]
) a where th=1
)*/
[rms].[v_LoanDefaultInformation] b on a.loan_skey=b.loan_skey
) a 
 join rms.v_LoanMaster b on a.loan_skey=b.loan_skey
where a.loan_skey in (
select loan_skey from rms.v_LoanMaster
where investor_name in ('Bank of America',
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
)
) a
) a 
where sn=1 and [Loss Mitigation category]='Loss Mitigation'
--where a.loan_skey=1300
order by a.loan_skey,a.[RPC created_date];


--select * from #Temp6 where loan_skey=1300;

select 
a.[loan_skey],
a.[servicer_name],
a.[investor_name],
a.[Default Reason],
a.[Agent_name],
a.[RPC Note category],
a.[RPC Note],
a.[RPC NoteText],
a.[RPC Created by],
a.[RPC created_date],
a.[cfw_wf_type],
a.[cfw_wf_task_result_desc],
a.[cfw_task_note],
a.[Loss Mitigation category],
a.[Loss Note type],
a.[Loss Note text],
a.[workflow_task_description],
a.[complete_date]
from #Temp6 a 
join #Temp7 b on a.loan_skey=b.loan_skey and a.[RPC created_date]  <= b.[RPC created_date] 
where a.sn=1
order by a.loan_skey,a.[RPC created_date];





--select * from [rms].[v_LoanDefaultInformation] where loan_skey='1300'

/*
select loan_skey,default_reason,convert(date,created_date) created_date,
ROW_NUMBER() over (partition by loan_skey order by convert(date,created_date) desc  ) th 
from [rms].[v_MonthlyLoanDefaultSummary] where loan_skey=35955

select * from [rms].[v_MonthlyLoanDefaultSummary] where loan_skey=35955 order by reporting_period_skey

select * from (
select loan_skey,default_reason_description,convert(date,default_date) default_date,
ROW_NUMBER() over (partition by loan_skey order by convert(date,default_date) desc  ) th 
from [rms].[v_LoanDefaultInformation]
) a where th=1

left join (
select loan_skey,workflow_type_description
,workflow_task_result_description,task_note,upper(created_by) cfw_created_by,created_date cfw_created_date
from (
  select 
b.loan_skey--,convert(date,a.complete_date) complete_date 
--,convert(date,a.created_date) created_date
,b.workflow_type_description
,a.workflow_task_result_description
,a.task_note
,upper(a.created_by) created_by,convert(date,a.created_date) created_date
--,a.workflow_task_result_description
--,a.task_note
--,a.workflow_task_description
,ROW_NUMBER() over (partition by b.loan_skey order by convert(date,a.created_date) desc,b.loan_skey) sn
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
   --and b.loan_skey=4123
 ) a where sn=1 and created_date >= CONVERT(date,'2024-03-18')
 and created_date <  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
--where note_type_category_description is null 
)b on a.loan_skey=b.loan_skey and a.[RPC created_date]=b.cfw_created_date*/
--where a.loan_skey=4123
--order by [RPC created_date]
;

--delete from #Temp4 where (cfw_wf_type is not null or [Loss Note type] is not null)

--select reverse(substring(reverse ('abc, 123_@_gmail.com'), CHARINDEX('_', reverse ('abc, 123_@_gmail.com'))+3, len(reverse ('abc, 123_@_gmail.com'))));

