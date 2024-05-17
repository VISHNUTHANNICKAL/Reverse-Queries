
-----------------Repayment Plan Setup,Repayment Plan Receipt of Signed Agreemen,Repayment Plan Down Payment,Repayment Plan Completion---------------------
IF OBJECT_ID('tempdb..#tempTbl') IS NOT NULL
    DROP TABLE #tempTbl;
select b.loan_skey, a.workflow_instance_skey, a.created_date,a.created_by,a.responsible_party_id,a.complete_date,a.workflow_task_description
,case when (a.workflow_task_description = 'Notify Borrower of Approved Repayment Plan' 
and a.created_date > =    DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))   
and a.created_date <     DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
or (a.workflow_task_description <> 'Notify Borrower of Approved Repayment Plan' 
--and a.workflow_task_description <> 'Repayment Plan Installment Due'
) 
and a.complete_date >   DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))   
and a.complete_date < DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
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
and a.status_description = 'Active' and a.responsible_party_id not in ('Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad')
--and b.loan_skey = '203017'
--and a.created_date > DATEADD(m,-0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
--and a.created_date <DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
order by a.created_date;
--select * from #tempTbl where credit >0 order by loan_skey;

/*select * from #tempTbl1 where
loan_skey = '6577' and
 workflow_task_description = 'Repayment Plan Installment Due' and rn =1*/

IF OBJECT_ID('tempdb..#tempTbl1') IS NOT NULL
    DROP TABLE #tempTbl1;
select * into #tempTbl1 from 
(select ROW_NUMBER() OVER (PARTITION BY workflow_instance_skey  ORDER BY created_date,
case when responsible_party_id not in ('RMS.RepaymentPlan' , 'System.Default','Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad') then 1 else 2 end,
case when workflow_task_description = 'Notify Borrower of Approved Repayment Plan' then 1 else 2 end ) rn,  * from
(select distinct * from #tempTbl ) m
--where responsible_party_id <> 'RMS.RepaymentPlan'
) q;


--select distinct * from #tempTbl1 where workflow_instance_skey = '4139486';
--select * from #tempTbl1 where workflow_task_description = 'Repayment Plan Installment Due' and loan_skey='126828';
/*
update a 
set a.responsible_party_id=b.responsible_party_id
from
(select * from #tempTbl1 where rn=1 and workflow_task_description = 'Repayment Plan Installment Due') a
join
(select 
b.loan_skey,a.workflow_instance_skey,a.workflow_task_description,a.responsible_party_id,a.status_skey
,format(a.modified_date,'yyyy-MM-dd')as modified_date
,a.modified_by
from  [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
join [ReverseQuest].[rms].[v_WorkflowInstance] b
on a.workflow_instance_skey=b.workflow_instance_skey
where
a.workflow_task_description in ('Notify Borrower of Approved Repayment Plan')
and a.status_skey=1
and b.status_description='Active'
and b.workflow_type_description in ('Repayment Plan')
) b
on a.workflow_instance_skey=b.workflow_instance_skey;

*/


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

delete a from  
#tempTbl1 a
 join
 (select *,month(DATEADD(day,30,created_date)) as 'Month of credit'
 ,year(DATEADD(day,30,created_date)) as 'Year of credit'
  from #tempTbl1 where
 workflow_task_description 
in ('Notify Borrower of Approved Repayment Plan') and credit =1
) b
on a.loan_skey=b.loan_skey and a.workflow_instance_skey=b.workflow_instance_skey and
 b.[Month of credit] >  month(DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))  )
 and b.[Year of credit] >= 2023;

/*select * from #tempTbl1 where
loan_skey = '6577' and
 workflow_task_description = 'Repayment Plan Installment Due' and credit >0;
 */

 /*IF OBJECT_ID('tempdb..#tempTbl1') IS NOT NULL
    DROP TABLE #tempTbl1;
	select * into #tempTbl1 from 
(select 1 as 'rn', * from #tempTbl 
	where responsible_party_id not in ('RMS.RepaymentPlan' , 'System.Default','Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad') and credit >0
) q;*/

--select * from #tempTbl where loan_skey = '234817' and credit >0;
--select * from #tempTbl1 where loan_skey = '234817';

insert into #tempTbl1 
SELECT distinct 1 as rn,  b.loan_skey, a.workflow_instance_skey
--c.note_type_description,
,a.created_date,c.created_by,c.created_by as 'responsible_party_id',a.complete_date,
a.workflow_task_description,1 as 'credits through life of the workflow'
--,c.created_date,c.created_by
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
	join [ReverseQuest].[rms].[v_WorkflowInstance] b
	join
	(select loan_skey,created_by,created_date,note_type_description from(
select loan_skey,created_by,created_date,note_type_description,
row_number() over(partition by loan_skey order by created_date) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Loss Mit Referral – SS') as T where rn=1 
) c
	on b.loan_skey=c.loan_skey
on a.workflow_instance_skey=b.workflow_instance_skey
  where (a.workflow_task_description = 'Receipt of Short Sale Closing Proceeds' 
  or a.workflow_task_description = 'Receipt of Family Sale Proceeds')
  and a.status_description = 'Active' and c. note_type_description = 'Loss Mit Referral – SS'
and a.complete_date >    DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))   
and 
a.complete_date <  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and c.created_date < a.created_date 
and responsible_party_id not in ('RMS.RepaymentPlan' , 'System.Default','Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad') 
;

insert into #tempTbl1 
SELECT distinct 1 as rn,  b.loan_skey, a.workflow_instance_skey
--c.note_type_description,
,a.created_date,a.created_by,c.created_by as 'responsible_party_id',a.complete_date,
a.workflow_task_description,1 as 'credits through life of the workflow'
--,c.created_date,c.created_by
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
	join [ReverseQuest].[rms].[v_WorkflowInstance] b
	join
	(select loan_skey,created_by,created_date,note_type_description from(
select loan_skey,created_by,created_date,note_type_description,
row_number() over(partition by loan_skey order by created_date) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Loss Mit Referral – DIL') as T where rn=1
) c
	on b.loan_skey=c.loan_skey
on a.workflow_instance_skey=b.workflow_instance_skey
  where (a.workflow_task_description = 'Receipt of Executed Deed -Instruct Attorney to record')
  and a.status_description = 'Active' and c. note_type_description = 'Loss Mit Referral – DIL'
--and a.created_date > DATEADD(m,-0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
--and a.created_date <DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and a.complete_date >  DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))   
and 
a.complete_date < DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and c.created_date < a.created_date
and responsible_party_id not in ('RMS.RepaymentPlan','System.Default','Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad') 
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
  and a.complete_date >  DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))   
and 
a.complete_date < DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
)as T where rn=1) a
	join
	(select loan_skey,created_by,created_date,note_type_description from(
select loan_skey,created_by,created_date,note_type_description,
row_number() over(partition by loan_skey order by created_date) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Promise Occupancy ') as T where rn=1
) c
	on a.loan_skey=c.loan_skey
  where datediff(day,c.created_date,a.complete_date) > 0 and datediff(day,c.created_date,a.complete_date) <=30
  and c.created_by not in ('RMS.RepaymentPlan' , 'System.Default','Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad') 
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
  and a.complete_date >  DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))   
and 
a.complete_date < DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
)as T where rn=1) a
	join
	(select loan_skey,created_by,created_date,note_type_description from(
select loan_skey,created_by,created_date,note_type_description,
row_number() over(partition by loan_skey order by created_date) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Promise Tax & Ins Doc') as T where rn=1
) c
	on a.loan_skey=c.loan_skey
  where datediff(day,c.created_date,a.complete_date) > 0 and datediff(day,c.created_date,a.complete_date)  <=30
  and c.created_by not in ('RMS.RepaymentPlan' , 'System.Default','Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad') 
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
  and a.complete_date >  DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))   
and 
a.complete_date < DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
)as T where rn=1) a
	join
	(select loan_skey,created_by,created_date,note_type_description from(
select loan_skey,created_by,created_date,note_type_description,
row_number() over(partition by loan_skey order by created_date) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Promise Tax & Ins Doc') as T where rn=1
) c
	on a.loan_skey=c.loan_skey
  where datediff(day,c.created_date,a.complete_date)  > 0 and datediff(day,c.created_date,a.complete_date)  <=30
  and c.created_by  not in ('RMS.RepaymentPlan' , 'System.Default','Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad') 
 ;

 
 
 insert into #tempTbl1 
select 1 as rn, a.loan_skey, '-' as 'Workflow_instance_skey',a.created_date
,a.created_by,a.created_by as 'responsible_party_id',a.created_date as 'complete_date', 'Covid Plan' as workflow_task_description
,1 as 'credits through life of the workflow'
--,b.created_date as 'alert date',dateadd(dd,30,a.created_date) as 'diff'
from
(select loan_skey,created_by,created_date,note_type_description from(
select loan_skey,created_by,created_date,note_type_description,
row_number() over(partition by loan_skey order by created_date) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Loss Mit Referral – COVID'
and created_date >  DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))   
and created_date <DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
) as T where rn=1
) a
join
[ReverseQuest].[rms].[v_Alert] b
on a.loan_skey=b.loan_skey
where 
a.note_type_description = 'Loss Mit Referral – COVID'  and b.alert_status_description = 'Active' and b.alert_type_description = 'ML 2020-06 Extension Approved'
and a.created_date >  DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))   
and a.created_date <DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and b.created_date >=a.created_date 
--and b.created_date <= dateadd(dd,30,a.created_date)
and a.created_by  not in ('RMS.RepaymentPlan' , 'System.Default','Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad') 
;


 insert into #tempTbl1 
select 1 as rn, a.loan_skey, '-' as 'Workflow_instance_skey',a.created_date
,a.created_by,a.created_by as 'responsible_party_id',a.created_date as 'complete_date', 'Marketing Extn Credit' as workflow_task_description
,1 as 'credits through life of the workflow'
--,b.created_date as 'alert date',dateadd(dd,30,a.created_date) as 'diff'
from
(select loan_skey,created_by,created_date,note_type_description from(
select loan_skey,created_by,created_date,note_type_description,
row_number() over(partition by loan_skey order by created_date) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Loss Mit Referral–Mktg. Ext.'
and created_date >  DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))   
and created_date <DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
) as T where rn=1
)  a
join
[ReverseQuest].[rms].[v_Alert] b
on a.loan_skey=b.loan_skey
where 
a.note_type_description = 'Loss Mit Referral–Mktg. Ext.'  
and b.alert_status_description = 'Active' and b.alert_type_description = 'Pending Marketing Extension Request'
and a.created_date >  DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))   
and a.created_date <DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and b.created_date >=a.created_date 
--and b.created_date >=a.created_date and b.created_date <= dateadd(dd,30,a.created_date)
and a.created_by  not in ('RMS.RepaymentPlan' , 'System.Default','Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad') 
;


insert into #tempTbl1 
select 1 as rn, a.loan_skey, '-' as 'Workflow_instance_skey',a.created_date
,a.created_by,a.created_by as 'responsible_party_id',a.created_date as 'complete_date', 'At Risk Extn Credit' as workflow_task_description
,1 as 'credits through life of the workflow'
--,b.created_date as 'alert date',dateadd(dd,30,a.created_date) as 'diff'
from
(select loan_skey,created_by,created_date,note_type_description from(
select loan_skey,created_by,created_date,note_type_description,
row_number() over(partition by loan_skey order by created_date) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Loss Mit Referral–At-Risk Ext.'
and created_date >  DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))   
and created_date <DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
) as T where rn=1
) a
join
[ReverseQuest].[rms].[v_Alert] b
on a.loan_skey=b.loan_skey
where 
a.note_type_description = 'Loss Mit Referral–At-Risk Ext.'  
and b.alert_status_description = 'Active' and b.alert_type_description = 'At Risk Extension'
and a.created_date >  DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))   
and a.created_date <DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and b.created_date >=a.created_date 
--and b.created_date >=a.created_date and b.created_date <= dateadd(dd,30,a.created_date)
and a.created_by not in ('RMS.RepaymentPlan' , 'System.Default','Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad') 
;


-------------------------Payoff-----------------------------
insert into #tempTbl1 
SELECT 1 as rn,  a.loan_skey, 
' ' as workflow_instance_skey
--c.note_type_description,
,a.created_date,a.created_by,c.created_by as 'responsible_party_id',a.transaction_date as 'complete_date',
a.long_transaction_description as workflow_task_description,1 as 'credits through life of the workflow'
--,c.created_date,c.created_by,datediff(day,c.created_date,a.complete_date) as diff
  FROM 
  [ReverseQuest].[rms].[v_Transaction] a
	join
	(select loan_skey,created_by,created_date,note_type_description from(
select loan_skey,created_by,created_date,note_type_description,
row_number() over(partition by loan_skey order by created_date) as rn
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
  and datediff(day,c.created_date,a.transaction_date)  > 0 and datediff(day,c.created_date,a.transaction_date)  <=30
  and a.transaction_date >  DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))   
and 
a.transaction_date < DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
  and c.created_by not in ('Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad') 
 ;

 delete from #tempTbl1 where credit=0;

 delete from #tempTbl1 where
workflow_task_description 
in ('Notify Borrower of Approved Repayment Plan','Receipt of Signed Repayment Plan','Repayment Plan Installment Due')
and credit>0 and datediff(day,created_date,GETDATE()) <30;
 

/*select *,DATEADD(day,30,created_date) as 'Month of credit' from  #tempTbl1
where workflow_task_description 
in ('Notify Borrower of Approved Repayment Plan');*/

IF OBJECT_ID('tempdb..#tempTblRPP') IS NOT NULL
    DROP TABLE #tempTblRPP;
select *  into #tempTblRPP from 
(select 
b.loan_skey,a.workflow_task_description,a.responsible_party_id,a.status_skey
,format(a.modified_date,'yyyy-MM-dd')as modified_date
,a.modified_by
,ROW_NUMBER() OVER (PARTITION BY b.loan_skey  ORDER BY a.modified_date desc) as rn
from  [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
left join [ReverseQuest].[rms].[v_WorkflowInstance] b
on a.workflow_instance_skey=b.workflow_instance_skey
where
a.workflow_task_description in ('Notify Borrower of Approved Repayment Plan')
--and a.status_description='Active'
--and a.status_skey=1
--and b.status_description='Active'
and b.workflow_type_description in ('Repayment Plan')
/*group by b.loan_skey,a.workflow_instance_skey,a.workflow_task_description
,a.responsible_party_id,a.status_skey,a.modified_by*/
--order by b.loan_skey,a.modified_date desc
) a 
where rn=1

--
/*select * from #tempTblRPP where loan_skey in('285437',
'277166',
'259258',
'204166',
'104613',
'66980',
'282031',
'259032',
'203522',
'208443',
'263154',
'83339',
'215220',
'274488',
'284941',
'286084',
'266177',
'242539',
'263271',
'266062',
'272619',
'221750',
'307600',
'274825',
'131071',
'204328',
'188721',
'224301',
'265110',
'209319',
'323324',
'281944') order by loan_skey
*/

IF OBJECT_ID('tempdb..#tempTblRC_CSHRD') IS NOT NULL
    DROP TABLE #tempTblRC_CSHRD;
select a.loan_skey,a.workflow_instance_skey,a.created_date,a.created_by
, case when a.workflow_task_description not in('Notify Borrower of Approved Repayment Plan','Receipt of Signed Repayment Plan'
,'Down Payment Installment Due','Repayment Plan Installment Due','Repayment Plan Satisfied') then  a.responsible_party_id
else b.responsible_party_id end as 'responsible_party_id'
--a.responsible_party_id
, a.complete_date,a.workflow_task_description,a.credit as [credits through life of the workflow]
,datediff(day,a.created_date,GETDATE()) as 'Days tilldate'
into #tempTblRC_CSHRD
from #tempTbl1 a
left join #tempTblRPP b on a.loan_skey=b.loan_skey
where a.credit>0  
order by a.created_date,a.loan_skey;

select * from #tempTblRC_CSHRD;

/*select * from #tempTbl1
where
workflow_task_description 
in ('Notify Borrower of Approved Repayment Plan','Receipt of Signed Repayment Plan','Repayment Plan Installment Due')
and credit>0;

select responsible_party_id as 'Agent',  workflow_task_description,sum(credit) as credits from #tempTbl1
 group by responsible_party_id,workflow_task_description order by responsible_party_id;


 
 select responsible_party_id as 'Agent', sum(credit) as credits from #tempTbl1
 group by responsible_party_id order by responsible_party_id;
 */





select responsible_party_id as 'Agent',  workflow_task_description,sum([credits through life of the workflow]) as credits from #tempTblRC_CSHRD
 group by responsible_party_id,workflow_task_description order by responsible_party_id;


 
 select responsible_party_id as 'Agent', sum([credits through life of the workflow]) as credits from #tempTblRC_CSHRD
 group by responsible_party_id order by responsible_party_id;


