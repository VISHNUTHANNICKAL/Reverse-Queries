
-----------------Repayment Plan Setup,Repayment Plan Receipt of Signed Agreemen,Repayment Plan Down Payment,Repayment Plan Completion---------------------
IF OBJECT_ID('tempdb..#tempTbl') IS NOT NULL
    DROP TABLE #tempTbl;
select b.loan_skey, a.workflow_instance_skey, a.created_date,a.created_by,a.responsible_party_id,a.complete_date,a.workflow_task_description
,case when (a.workflow_task_description = 'Notify Borrower of Approved Repayment Plan' 
and a.created_date > =   DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))  
and a.created_date <   DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
or (a.workflow_task_description <> 'Notify Borrower of Approved Repayment Plan' and a.workflow_task_description <> 'Repayment Plan Installment Due') 
and a.complete_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and a.complete_date <  DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and a.complete_date is not null
)
then 1 else 0 end as credit
into #tempTbl
from [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
join [ReverseQuest].[rms].[v_WorkflowInstance] b
on a.workflow_instance_skey=b.workflow_instance_skey
where 
a.workflow_task_description in ('Notify Borrower of Approved Repayment Plan','Receipt of Signed Repayment Plan'
,'Down Payment Installment Due','Repayment Plan Installment Due','Repayment Plan Satisfied')
and a.status_description = 'Active' and a.responsible_party_id in ('Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad')
--and b.loan_skey = '203017'
--and a.created_date > DATEADD(m,-0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
--and a.created_date < DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
order by a.created_date;
--select * from #tempTbl where credit=1;
--select * from #tempTbl where loan_skey = '215672';

IF OBJECT_ID('tempdb..#tempTbl1') IS NOT NULL
    DROP TABLE #tempTbl1;
select * into #tempTbl1 from 
(select ROW_NUMBER() OVER (PARTITION BY workflow_instance_skey  ORDER BY created_date,
case when responsible_party_id not in ('RMS.RepaymentPlan' , 'System.Default') then 1 else 2 end ) rn,* from #tempTbl 
--where responsible_party_id <> 'RMS.RepaymentPlan'
) q


--select * from #tempTbl1 where loan_skey = '215672'
--where workflow_instance_skey = '436537'
--order by loan_skey;
--order by rn;


update a 
set a.credit = b.credits
from 
(select * from #tempTbl1 where rn=1) a
join
(select workflow_instance_skey
,sum(credit) credits from #tempTbl1
where credit = 1  
group by workflow_instance_skey) b
on a.workflow_instance_skey=b.workflow_instance_skey;

update a 
set a.complete_date = b.completed_date
from 
(select * from #tempTbl1 where rn=1) a
join
(select workflow_instance_skey
,max(complete_date) completed_date from #tempTbl1
where credit = 1 
group by workflow_instance_skey) b
on a.workflow_instance_skey=b.workflow_instance_skey;

delete from #tempTbl1 where rn>1;

insert into #tempTbl1 
SELECT distinct 1 as rn,  b.loan_skey, a.workflow_instance_skey
--c.note_type_description,
,a.created_date,c.created_by,c.created_by as 'responsible_party_id',a.complete_date,
a.workflow_task_description,2 as 'credits through life of the workflow'
--,c.created_date,c.created_by
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
	join [ReverseQuest].[rms].[v_WorkflowInstance] b
	join
	(select loan_skey,created_by,created_date,note_type_description from(
select loan_skey,created_by,created_date,note_type_description,
row_number() over(partition by loan_skey order by created_date desc) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Loss Mit Referral – SS'
and created_by in ('Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad')
) as T where rn=1
) c
	on b.loan_skey=c.loan_skey
on a.workflow_instance_skey=b.workflow_instance_skey
  where (a.workflow_task_description = 'Receipt of Short Sale Closing Proceeds' 
  or a.workflow_task_description = 'Receipt of Family Sale Proceeds')
  and a.status_description = 'Active' and c. note_type_description = 'Loss Mit Referral – SS'
and a.complete_date >=    DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and 
a.complete_date <   DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and c.created_date < a.created_date 
and responsible_party_id not in ('RMS.RepaymentPlan' , 'System.Default') 
;
--------------------DIL Credit-------------------------
insert into #tempTbl1 
SELECT distinct 1 as rn,  b.loan_skey, a.workflow_instance_skey
--c.note_type_description,
,a.created_date,a.created_by,c.created_by as 'responsible_party_id',a.complete_date,
a.workflow_task_description,3 as 'credits through life of the workflow'
--,c.created_date,c.created_by
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
	join [ReverseQuest].[rms].[v_WorkflowInstance] b
	join
	(select loan_skey,created_by,created_date,note_type_description from(
select loan_skey,created_by,created_date,note_type_description,
row_number() over(partition by loan_skey order by created_date desc ) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Loss Mit Referral – DIL'
and created_by in ('Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad')
) as T where rn=1
) c
	on b.loan_skey=c.loan_skey
on a.workflow_instance_skey=b.workflow_instance_skey
  where (a.workflow_task_description = 'Receipt of Executed Deed -Instruct Attorney to record')
  and a.status_description = 'Active' and c. note_type_description = 'Loss Mit Referral – DIL'
--and a.created_date > DATEADD(m,-0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
--and a.created_date < DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
and a.complete_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and 
a.complete_date <  DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and c.created_date < a.created_date
and responsible_party_id not in ('RMS.RepaymentPlan' , 'System.Default') 
;

insert into #tempTbl1 
SELECT 1 as rn,  a.loan_skey, a.workflow_instance_skey
--c.note_type_description,
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
  and a.complete_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and 
a.complete_date <  DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
)as T where rn=1) a
	join
	(select loan_skey,created_by,created_date,note_type_description from(
select loan_skey,created_by,created_date,note_type_description,
row_number() over(partition by loan_skey order by created_date) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Promise Occupancy '
and created_by in ('Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad')
) as T where rn=1
) c
	on a.loan_skey=c.loan_skey
  where datediff(day,c.created_date,a.complete_date) >= 0 and datediff(day,c.created_date,a.complete_date) <=30
  and c.created_by not in ('RMS.RepaymentPlan' , 'System.Default') 
;

insert into #tempTbl1 
SELECT 1 as rn,  a.loan_skey, a.workflow_instance_skey
--c.note_type_description,
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
  and a.complete_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and 
a.complete_date <  DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
)as T where rn=1) a
	join
	(select loan_skey,created_by,created_date,note_type_description from(
select loan_skey,created_by,created_date,note_type_description,
row_number() over(partition by loan_skey order by created_date desc) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Promise Tax & Ins Doc'
and created_by in ('Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad')
) as T where rn=1
) c
	on a.loan_skey=c.loan_skey
  where datediff(day,c.created_date,a.complete_date) >= 0 
  and datediff(day,c.created_date,a.complete_date)  <=30
  and c.created_by not in ('RMS.RepaymentPlan' , 'System.Default') 
;


insert into #tempTbl1 
SELECT 1 as rn,  a.loan_skey, a.workflow_instance_skey
--c.note_type_description,
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
  and a.complete_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and 
a.complete_date <  DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
)as T where rn=1) a
	join
	(select loan_skey,created_by,created_date,note_type_description from(
select loan_skey,created_by,created_date,note_type_description,
row_number() over(partition by loan_skey order by created_date desc) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Promise Tax & Ins Doc'
and created_by in ('Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad')
) as T where rn=1
) c
	on a.loan_skey=c.loan_skey
  where datediff(day,c.created_date,a.complete_date)  >= 0 
  and datediff(day,c.created_date,a.complete_date)  <=30
  and c.created_by  not in ('RMS.RepaymentPlan' , 'System.Default') 
 ;

 
 
 insert into #tempTbl1 
select 1 as rn, a.loan_skey, '-' as 'Workflow_instance_skey',a.created_date
,a.created_by,a.created_by as 'responsible_party_id',a.created_date as 'complete_date', 'Covid Plan' as workflow_task_description
,1 as 'credits through life of the workflow'
--,b.created_date as 'alert date',dateadd(dd,30,a.created_date) as 'diff'
from
(select loan_skey,created_by,created_date,note_type_description from(
select loan_skey,created_by,created_date,note_type_description,
row_number() over(partition by loan_skey order by created_date desc) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Loss Mit Referral – COVID'
and created_by in ('Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad')
and created_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and created_date < DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
) as T where rn=1
) a
join
[ReverseQuest].[rms].[v_Alert] b
on a.loan_skey=b.loan_skey
where 
a.note_type_description = 'Loss Mit Referral – COVID'  and b.alert_status_description = 'Active' and b.alert_type_description = 'ML 2020-06 Extension Approved'
and a.created_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and a.created_date < DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and b.created_date >=a.created_date 
--and b.created_date <= dateadd(dd,30,a.created_date)
and a.created_by  not in ('RMS.RepaymentPlan' , 'System.Default') 
;


 insert into #tempTbl1 
select 1 as rn, a.loan_skey, '-' as 'Workflow_instance_skey',a.created_date
,a.created_by,a.created_by as 'responsible_party_id',a.created_date as 'complete_date', 'Marketing Extn Credit' as workflow_task_description
,1 as 'credits through life of the workflow'
--,b.created_date as 'alert date',dateadd(dd,30,a.created_date) as 'diff'
from
(select loan_skey,created_by,created_date,note_type_description from(
select loan_skey,created_by,created_date,note_type_description,
row_number() over(partition by loan_skey order by created_date desc) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Loss Mit Referral–Mktg. Ext.'
and created_by in ('Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad')
and created_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and created_date < DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
) as T where rn=1
)  a
join
[ReverseQuest].[rms].[v_Alert] b
on a.loan_skey=b.loan_skey
where 
a.note_type_description = 'Loss Mit Referral–Mktg. Ext.'  
and b.alert_status_description = 'Active' and b.alert_type_description = 'Pending Marketing Extension Request'
and a.created_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and a.created_date < DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and b.created_date >=a.created_date 
--and b.created_date >=a.created_date and b.created_date <= dateadd(dd,30,a.created_date)
and a.created_by  not in ('RMS.RepaymentPlan' , 'System.Default') 
;


insert into #tempTbl1 
select 1 as rn, a.loan_skey, '-' as 'Workflow_instance_skey',a.created_date
,a.created_by,a.created_by as 'responsible_party_id',a.created_date as 'complete_date', 'At Risk Extn Credit' as workflow_task_description
,1 as 'credits through life of the workflow'
--,b.created_date as 'alert date',dateadd(dd,30,a.created_date) as 'diff'
from
(select loan_skey,created_by,created_date,note_type_description from(
select loan_skey,created_by,created_date,note_type_description,
row_number() over(partition by loan_skey order by created_date desc) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Loss Mit Referral–At-Risk Ext.'
and created_by in ('Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad')
and created_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and created_date < DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and created_by in ('Clarisa Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi',
'Don Anthony Eusebio',
'Jerrick Natividad'
)
) as T where rn=1
) a
join
[ReverseQuest].[rms].[v_Alert] b
on a.loan_skey=b.loan_skey
where 
a.note_type_description = 'Loss Mit Referral–At-Risk Ext.'  
and b.alert_status_description = 'Active' and b.alert_type_description = 'At Risk Extension'
and a.created_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and a.created_date < DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and b.created_date >=a.created_date 
--and b.created_date >=a.created_date and b.created_date <= dateadd(dd,30,a.created_date)
and a.created_by not in ('RMS.RepaymentPlan' , 'System.Default') 
;


insert into #tempTbl1 
SELECT 1 as rn,  a.loan_skey, a.workflow_instance_skey
--c.note_type_description,
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
  where a.workflow_task_description = 'Foreclosure Sale Scheduled'
  and a.status_description = 'Active' 
  and a.complete_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and 
a.complete_date <  DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
)as T where rn=1) a
	join
	(select loan_skey,created_by,created_date,note_type_description from(
select loan_skey,created_by,created_date,note_type_description,
row_number() over(partition by loan_skey order by created_date desc) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Not interested - Walking away'
and created_by in ('Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad')
) as T where rn=1
) c
	on a.loan_skey=c.loan_skey
  where datediff(day,c.created_date,a.complete_date) >= 0 
  and datediff(day,c.created_date,a.complete_date)  <=120
  and c.created_by not in ('RMS.RepaymentPlan' , 'System.Default') 
;



-------------------------Payoff-----------------------------
insert into #tempTbl1 
SELECT 1 as rn,  a.loan_skey, 
' ' as workflow_instance_skey
--c.note_type_description,
,a.created_date,a.created_by,c.created_by as 'responsible_party_id',a.transaction_date as 'complete_date',
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
and created_by in  ('Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad') 
) as T where rn=1
) c
	on a.loan_skey=c.loan_skey
  where a.long_transaction_description like 'Payoff%'
  and datediff(day,c.created_date,a.transaction_date)  >= 0 
  and datediff(day,c.created_date,a.transaction_date)  <=30
  and a.transaction_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and 
a.transaction_date <  DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
  and c.created_by  in ('Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad') 
 ;

 ------------------------Reinstatement credit for >$2000 and <$2000------------------
--select * from #tempTbl1 
insert into #tempTbl1 
select 1 as rn,a.loan_skey,'' as workflow_instance_skey,a.created_date
,'' as created_by,a.created_by as 'responsible_party_id',c.created_date as 'complete_date'
,c.long_transaction_description as workflow_task_description,
case when c.total_remittance_amount >= 2000 and b.tots_balance=0 then 3
when c.total_remittance_amount < 2000 and b.tots_balance=0 then 1
else 0 end as 'credits through life of the workflow'
from(
select loan_skey,created_by,created_date,note_type_description from(
select loan_skey,created_by,created_date,note_type_description,
row_number() over(partition by loan_skey order by created_date desc) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Promise Reinstatement Funds'
and created_by  in  ('Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad') 
) as T where rn=1
--and created_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
--and created_date <   DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
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
and  a.transaction_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and a.transaction_date <  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
/*and  a.created_by not in ('Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad')*/
and b.created_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
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
and created_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and created_date <  DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
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
and created_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and created_date <  DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
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







 -------------------------------------------------------------------SHRD Review Credits

DECLARE @ActivePipeline AS INT;
set @ActivePipeline = 0;
IF OBJECT_ID('tempdb..#rtempTbl') IS NOT NULL
    DROP TABLE #rtempTbl;
SELECT [loan_skey],alert_skey
      --,format([created_date],'MM/dd/yyyy') as 'Intake date',
	  ,[created_date] as 'Assignment date',
	  REPLACE(REPLACE(REPLACE(alert_note, CHAR(13),' '), CHAR(10),' '), CHAR(9),' ') as 'Assignment Note'
	  --alert_note as 'Agent note'
	  --,alert_date
      ,[created_by] as 'Assignment By',
       case when alert_note like '%Repeat Call%' then 'Repeat Calls'
	   when alert_note like '%Repeat Complaint%' then 'Repeat Complaints'
	   when alert_note like '%Duplicate Request%' then 'Duplicate Requests'
	   when alert_note like '%Escalation%' then 'Adhoc Requests'
	   when alert_note like '%Open ICW%' then 'Open Cases'
	   end as 'Channel'
	   ,alert_status_description
	   into #rtempTbl
  FROM [ReverseQuest].[rms].[v_Alert]
  where alert_type_description = 'Escalation'
  --and alert_status_description = 'Active'
  --and created_date  >=  DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-0, 0)
  and created_date  >=   DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))   -45
  --and created_date  <  DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())+1, 0);
  and created_date  <    DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
  --and created_date  <  Convert(datetime, '2022-12-01' )
  --select * from #tempTbl where loan_skey = '26129';


	IF OBJECT_ID('tempdb..#rtempTbl1') IS NOT NULL
    DROP TABLE #rtempTbl1;
select distinct x.loan_skey,x.[Assignment date],x.[Assignment Note],x.[Assignment By],x.Channel
--,CASE WHEN MIN(CASE WHEN x.[Intake Date] IS NULL THEN 0 ELSE 1 END) = 0
--        THEN MIN(x.[Intake Date])
--END
,MIN(x.[Intake Date]) as [Intake Date]
-- ,x.[Intake Date]
,x.alert_skey
,[Intake by] into #rtempTbl1
from
(
select distinct a.*,b.created_date as 'Intake Date',b.[Intake by]
	--,datediff(day,a.[Assignment date],b.created_date) as 'Intake in (Days)',
	--case when datediff(day,a.[Assignment date],b.created_date) > 1 or datediff(day,a.[Assignment date],b.created_date) is null then 0 else 1 end as 'Within SLA'
	from #rtempTbl a
	join
	(select loan_skey,min(created_date) as created_date,created_by as 'Intake by' from  [ReverseQuest].[rms].[v_Note]
	where note_type_description = 'Specialized Escalation Review' group by loan_skey,created_by
	) b
	on a.loan_skey=b.loan_skey
	and b.created_date>a.[Assignment date]
	union
	select a.*,b.modified_date as 'Intake Date',b.modified_by as 'Intake By'
	--,datediff(day,a.[Assignment date],b.modified_date) as 'Intake in (Days)',
	--case when datediff(day,a.[Assignment date],b.modified_date) > 1 or datediff(day,a.[Assignment date],b.modified_date) is null then 0 else 1 end as 'Within SLA'
	from #rtempTbl a
	 join
	( select loan_skey,alert_skey,max(modified_date) as modified_date,modified_by
		from [ReverseQuest].[rms].[v_Alert] where alert_type_description = 'Escalation' and alert_status_description = 'Inactive'
		group by loan_skey,alert_skey,modified_by
		) b
	on a.alert_skey=b.alert_skey ) x
	group by x.loan_skey,x.[Assignment date],x.[Assignment Note],x.[Assignment By],x.Channel,[Intake by],x.alert_skey
	;

	--select * from #tempTbl1 where loan_skey = '44686';

	/*IF OBJECT_ID('tempdb..#tempTbl2') IS NOT NULL
    DROP TABLE #tempTbl2;
	select loan_skey,[Intake Date] into #tempTbl2 
	from #tempTbl1
	where loan_skey in (
	select loan_skey from #tempTbl1 where [Intake Date] is null);*/
	IF OBJECT_ID('tempdb..#rtempTbl2') IS NOT NULL
    DROP TABLE #rtempTbl2;
	select x.loan_skey,format([Intake Date],'MM/dd/yyyy') as 'Intake Date',format(x.[Assignment date],'MM/dd/yyyy') as 'Date' ,x.alert_skey,NULL as 'Intake in (Bus Days)'
	into #rtempTbl2 
	from #rtempTbl x
	left join
	#rtempTbl1 y on x.alert_skey=y.alert_skey
	where [Intake Date] is null;

	--select loan_skey,count(loan_skey) as 'cnt'
	--from #tempTbl2 group by loan_skey having count(loan_skey) =1;
	--select * from #tempTbl1 where [Intake Date] is null and loan_skey not in (select loan_skey
	--from #tempTbl2 group by loan_skey having count(loan_skey) =1);

/*	select * from (
	select ROW_NUMBER() over (partition by alert_skey order by [Intake Date]) rn,* from #tempTbl1 ) q
	where rn=1
	 ;*/

	
	delete from #rtempTbl1 where [Intake Date] is null and loan_skey not in (select loan_skey
	from #rtempTbl2 group by loan_skey having count(loan_skey) =1);

	IF OBJECT_ID('tempdb..#rtempTbl3') IS NOT NULL
    DROP TABLE #rtempTbl3;
	select loan_skey,[Assignment date],[Assignment Note],[Assignment By],Channel
	,min([Intake Date]) as [Intake Date],alert_skey into #rtempTbl3
	from 
	(select * from (
	select ROW_NUMBER() over (partition by alert_skey order by [Intake Date]) rn,* from #rtempTbl1 ) q
	where rn=1 ) p
	group by loan_skey,[Assignment date],[Assignment Note],[Assignment By],Channel,alert_skey
	order by loan_skey;

		
	IF OBJECT_ID('tempdb..#rtempTbl4') IS NOT NULL
    DROP TABLE #rtempTbl4;
	select distinct a.loan_skey,format(a.[Assignment date],'MM/dd/yyyy') as 'Date',a.[Assignment Note],a.[Assignment By],a.Channel,
	format(a.[Intake Date],'MM/dd/yyyy') as  'Intake Date' ,b.[Intake by]
	,a.alert_skey
	into #rtempTbl4
	from #rtempTbl3 a left join (select * from (
	select ROW_NUMBER() over (partition by alert_skey order by [Intake Date]) rn,* from #rtempTbl1 ) q
	where rn=1 )  b on a.loan_skey=b.loan_skey and a.alert_skey=b.alert_skey
	--where a.[Intake Date]=b.[Intake Date] 
	order by loan_skey;

	
	IF OBJECT_ID('tempdb..#rtempTbl5') IS NOT NULL
    DROP TABLE #rtempTbl5;
	select *
	--,datediff(day,[date],[Intake Date]) as 'Intake in (Days)'
	,(DATEDIFF(dd, [date], [Intake Date]) )
		-(DATEDIFF(WW, [date], [Intake Date]) * 2)
		-CASE			
       WHEN DATEPART(WEEKDAY,[date]) IN (1, 7) THEN 1 ELSE 0			
       END			
       - CASE			
       WHEN DATEPART(WEEKDAY,[Intake Date]) IN (1, 7) THEN 1 ELSE 0		
	   end as 'Intake in (Bus Days)'
	into #rtempTbl5
	from #rtempTbl4;

	IF OBJECT_ID('tempdb..#rtempTbl6') IS NOT NULL
    DROP TABLE #rtempTbl6;
	select *,
	case when [Intake in (Bus Days)] is null then
		(DATEDIFF(dd, [date], getdate()) )
			-(DATEDIFF(WW, [date], getdate()) * 2)
			-CASE			
		   WHEN DATEPART(WEEKDAY,[date]) IN (1, 7) THEN 1 ELSE 0			
		   END			
		   - CASE			
		   WHEN DATEPART(WEEKDAY,getdate()) IN (1, 7) THEN 1 ELSE 0		
		   end 
	   else
			[Intake in (Bus Days)]
		end
	   as 'Aging'
	into #rtempTbl6
	from #rtempTbl5;


	IF OBJECT_ID('tempdb..#rtempTbl7') IS NOT NULL
    DROP TABLE #rtempTbl7;
	select *,
	case when ([Intake in (Bus Days)] > 2  or [Intake in (Bus Days)] is null and Aging > 2) then 0 else 1 end as 'Within SLA', 1 as 'Credit'
	into #rtempTbl7
	from #rtempTbl6
	--where [intake date] > DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
	--and [intake date] < DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
	;

	/*select b.rn,* from
	#rtempTbl7 a
	join
	(select ROW_NUMBER() over (partition by loan_skey,[intake by] order by [Intake Date]) rn,* from #rtempTbl7) b
	on a.loan_skey=b.loan_skey
	where b.rn =1;*/


	
	--select * from #rtempTbl7 where loan_skey = '16893'
	/*select * from #tempTbl3 where [Intake Date] is null;
	select * from #tempTbl4 where [Intake Date] is null;
	select * from #tempTbl5 where [Intake Date] is null;*/
	--select * from #rtempTbl7 order by  [Intake Date]
	--where [Date] >=   DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-0, 0) order by Date;
	update a set a.Credit = 0
	from #rtempTbl7 a
	join
	#rtempTbl7 b on a.loan_skey=b.loan_skey and a.[Intake by]=b.[Intake by] and a.[Intake Date]  > b.[Intake Date] ;
	
	
	/*select a.loan_skey from #tempTbl1 a
	join #rtempTbl7 b
	on a.loan_skey=b.loan_skey and a.responsible_party_id = b.[Intake by]
	order by a.loan_skey
	;*/
	
	/*select a.*,b.loan_skey
	,replace(b.responsible_party_id,'.',' ') as 'Resp'
	from #rtempTbl7 a 
	join #tempTbl1 b
	on a.loan_skey=b.loan_skey 
	and a.[Intake by] = replace(b.responsible_party_id,'.',' ');*/

	delete  #rtempTbl7 from
	#rtempTbl7 a
	join #tempTbl1 b
	on a.loan_skey=b.loan_skey and a.[Intake by] = replace(b.responsible_party_id,'.',' '); 

	

	insert into #tempTbl1
	select 1 as rn,a.loan_skey,0 as 'workflow_instance_skey',a.[Intake Date] as 'created_date',a.[Intake by] as 'created_by'
	,a.[Intake by] as 'responsible_party_id',a.[Intake Date] as 'complete_date','Review_task' as 'workflow_task_description', a.Credit
	from  #rtempTbl7 a
	where a.[Intake Date] > DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
	and a.[intake date] < DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
	;

	
	

select loan_skey,workflow_instance_skey,created_date,created_by
,responsible_party_id, complete_date,workflow_task_description,credit as [credits through life of the workflow]
from #tempTbl1
where credit>0  
order by created_date,loan_skey;

--select * from #tempTbl1 where loan_skey = '307314';


select responsible_party_id as 'Agent',  workflow_task_description,sum(credit) as credits from #tempTbl1
 group by responsible_party_id,workflow_task_description order by responsible_party_id;



 
 select responsible_party_id as 'Agent', 
 sum(credit) as credits from #tempTbl1
 group by responsible_party_id order by responsible_party_id;



