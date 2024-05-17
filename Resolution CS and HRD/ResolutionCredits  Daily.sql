
-----------------Repayment Plan Setup,Repayment Plan Receipt of Signed Agreemen,Repayment Plan Down Payment,Repayment Plan Completion---------------------
IF OBJECT_ID('tempdb..#tempTbl') IS NOT NULL
    DROP TABLE #tempTbl;
select b.loan_skey, a.workflow_instance_skey, a.created_date,a.created_by,a.responsible_party_id,a.complete_date,a.workflow_task_description
,case when (a.workflow_task_description = 'Notify Borrower of Approved Repayment Plan' 
and a.created_date > =    DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and a.created_date <      DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
or (a.workflow_task_description <> 'Notify Borrower of Approved Repayment Plan' 
--and a.workflow_task_description <> 'Repayment Plan Installment Due'
) 
and a.complete_date >=   DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
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
and a.status_description = 'Active'
 and a.responsible_party_id not in ('Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad')
--and b.loan_skey in('277567','164856','221050','188739')
--and a.created_date >  DATEADD(m,-0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
--and a.created_date < DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
order by a.created_date;
select * from #tempTbl where credit >0 
--and loan_skey = '13451'
order by loan_skey;

delete from #tempTbl where credit=0;
delete from #tempTbl where created_date < Convert(datetime, '2022-08-01' );
--select * from #tempTbl where workflow_task_description like 'Repayment%';
--select * from #tempTbl where workflow_instance_skey = '4726038';
--select * from #tempTbl where loan_skey = '13451';

IF OBJECT_ID('tempdb..#tempResp') IS NOT NULL
    DROP TABLE #tempResp;
select x.*,y.responsible_party_id as 'resp_party',y.parent_task,y.crtd_date  
into #tempResp
from #tempTbl x
	join
	(
		select b.loan_skey, a.workflow_instance_skey, 
		a.created_date as 'crtd_date',a.created_by,a.responsible_party_id,a.complete_date,a.workflow_task_description as 'Parent_task'
		from [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
		join [ReverseQuest].[rms].[v_WorkflowInstance] b
		on a.workflow_instance_skey=b.workflow_instance_skey
		where 
		a.workflow_task_description = 'Notify Borrower of Approved Repayment Plan'
		--and a.workflow_instance_skey = '4995171'
	) y
		on x.workflow_instance_skey=y.workflow_instance_skey
		where x.workflow_task_description not in ('Notify Borrower of Approved Repayment Plan');


--select * from #tempResp where workflow_instance_skey = '4995171';
update m 
set m.responsible_party_id=n.resp_party
from
(select * from #tempTbl where 
workflow_task_description not in ('Notify Borrower of Approved Repayment Plan')
) m
join
#tempResp n
on m.workflow_instance_skey=n.workflow_instance_skey;

--select * from #tempTbl where loan_skey = '13451'

/*select x.* from (
select 
distinct
m.*,n.Parent_task,n.crtd_date from #tempTbl m 
left join
#tempResp n
on m.workflow_instance_skey=n.workflow_instance_skey
) x
where x.loan_skey = '1351';
*/

/*select * from #tempTbl1 where
loan_skey = '6577' and
 workflow_task_description = 'Repayment Plan Installment Due' and rn =1*/

/*IF OBJECT_ID('tempdb..#tempTbl1') IS NOT NULL
    DROP TABLE #tempTbl1;
select * into #tempTbl1 from 
(select ROW_NUMBER() OVER (PARTITION BY workflow_instance_skey  ORDER BY created_date,
case when responsible_party_id not in ('RMS.RepaymentPlan' , 'System.Default'
,'Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad'
) then 1 else 2 end,
case when workflow_task_description = 'Notify Borrower of Approved Repayment Plan' then 1 else 2 end ) rn,  * from
(select distinct * from #tempTbl ) m
--where responsible_party_id <> 'RMS.RepaymentPlan'
) q;*/

IF OBJECT_ID('tempdb..#tempTbl0') IS NOT NULL
    DROP TABLE #tempTbl0;

	select * into #tempTbl0 from 
	(select 1 as rn, * from #tempTbl 
	where responsible_party_id not in ('RMS.RepaymentPlan' , 'System.Default'
,'Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad') 
)m;

IF OBJECT_ID('tempdb..#tempTbl1') IS NOT NULL
    DROP TABLE #tempTbl1;
	select distinct * 
	into #tempTbl1
	from #tempTbl0;

	--select distinct * from #tempTbl1 where workflow_instance_skey = '3870801';
--select distinct * from #tempTbl1 where workflow_task_description = 'Repayment Plan Satisfied';

--select distinct * from #tempTbl where loan_skey = '13451';
--select distinct * from #tempTbl1 where credit >0 and workflow_instance_skey = '3870801';

update a 
set a.complete_date = b.completed_date
--set a.created_date = b.created_date
from 
(select * from #tempTbl1
-- where rn=1
) a
join
(select workflow_instance_skey
,max(complete_date) completed_date 
--,max(created_date) created_date 
--,complete_date
from #tempTbl1
--where credit = 1 
--where loan_skey = '13451'
group by workflow_instance_skey) b
on a.workflow_instance_skey=b.workflow_instance_skey;


IF OBJECT_ID('tempdb..#tempTblx') IS NOT NULL
    DROP TABLE #tempTblx;
	select distinct * 
	into #tempTblx
	from #tempTbl1;

delete a from 
#tempTblx a
 join
 (select *,month(DATEADD(day,30,created_date)) as 'Month of credit'
 ,year(DATEADD(day,30,created_date)) as 'Year of credit'
  from #tempTblx 
  where
 workflow_task_description 
in ('Notify Borrower of Approved Repayment Plan') and credit =1
--and workflow_instance_skey = '4995171'
) b
on a.loan_skey=b.loan_skey and a.workflow_instance_skey=b.workflow_instance_skey and
 b.[Month of credit] >   month(DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)))
 and b.[Year of credit] >= 2023;

-- select distinct * from #tempTblx where workflow_instance_skey = '4995171';

--select distinct * from #tempTblx where loan_skey = '13451';

/*update a 
set a.credit = b.credits 
from 
(select * from #tempTblx) a
join
(select loan_skey,workflow_instance_skey,responsible_party_id,workflow_task_description
,sum(credit) credits from #tempTblx
where credit = 1  
group by workflow_instance_skey,responsible_party_id,workflow_task_description,loan_skey) b
on a.workflow_instance_skey=b.workflow_instance_skey;
*/

IF OBJECT_ID('tempdb..#tempTbl1') IS NOT NULL
    DROP TABLE #tempTbl1;
	select distinct * 
	into #tempTbl1
	from #tempTblx;

--delete from #tempTbl1 where rn>1;

delete a
from #tempTbl1 a
 join
 (
select y.*,x.[Broken RPP], DATEDIFF(day,y.created_date,x.[Broken RPP]) as diff from (
select b.loan_skey, a.workflow_instance_skey,a.workflow_task_description,b.status_description as 'Active RPP'
,a.complete_date as 'Broken RPP',a.task_note
,a.modified_date,c.servicer_name,c.investor_name
from [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
join [ReverseQuest].[rms].[v_WorkflowInstance] b
on a.workflow_instance_skey=b.workflow_instance_skey
join reversequest.rms.v_LoanMaster c
on b.loan_skey=c.loan_skey
where
a.workflow_task_description in ('Repayment Plan Broken') 
) x
join
#tempTbl1 y
on x.loan_skey=y.loan_skey and x.workflow_instance_skey=y.workflow_instance_skey
and DATEDIFF(day,y.created_date,x.[Broken RPP]) <=30
) b
on a.loan_skey=b.loan_skey and a.workflow_instance_skey = b.workflow_instance_skey;


/*select *, DATEDIFF(day, a.created_date,a.complete_date) AS DateDiff from #tempTbl1 a
where DATEDIFF(day, a.created_date,a.complete_date) <30;

*/

 --select * from #tempTbl1 order by loan_skey,workflow_instance_skey;
/*select distinct * from #tempTbl1 where
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
and a.complete_date >=    DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and 
a.complete_date <   DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and c.created_date < a.created_date 
and responsible_party_id not in ('RMS.RepaymentPlan' , 'System.Default'
--,'Clarisa Centeno','Clarisa.Centeno',
--'Don Anthony Eusebio',
--'Don Anthony.Eusebio',
--'Vincent Gherardi','Vincent.Gherardi',
--'Jerrick Natividad','Jerrick.Natividad'
) 
;

insert into #tempTbl1 
SELECT distinct 1 as rn,  b.loan_skey, a.workflow_instance_skey
--c.note_type_description,
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
and a.complete_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and 
a.complete_date <  DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
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
  and a.complete_date >=   DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and 
a.complete_date <  DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
--and b.loan_skey in('221050','188739')
)as T where rn=1) a
	join
	(select loan_skey,created_by,created_date,note_type_description from(
select loan_skey,created_by,created_date,note_type_description,
row_number() over(partition by loan_skey order by created_date desc) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Promise Occupancy '
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
where note_type_description = 'Promise Tax & Ins Doc') as T where rn=1
) c
	on a.loan_skey=c.loan_skey
  where datediff(day,c.created_date,a.complete_date) >= 0 and datediff(day,c.created_date,a.complete_date)  <=30
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
  and a.complete_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and 
a.complete_date <  DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
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
row_number() over(partition by loan_skey order by created_date desc) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Loss Mit Referral–Mktg. Ext.'
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
row_number() over(partition by loan_skey order by created_date desc) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Loss Mit Referral–At-Risk Ext.'
and created_date > = DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and created_date < DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
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
  and a.transaction_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and 
a.transaction_date <  DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
  and c.created_by not in ('Clarisa Centeno','Clarisa.Centeno',
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
and  a.transaction_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and a.transaction_date <  DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
/*and  a.created_by not in ('Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad')*/
and b.created_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
and b.created_date <  DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
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

-------------------------------------------



 delete from #tempTbl1 where credit=0;

 delete from #tempTbl1 where
workflow_task_description 
in ('Notify Borrower of Approved Repayment Plan','Receipt of Signed Repayment Plan','Repayment Plan Installment Due')
and credit>0 and datediff(day,created_date,GETDATE()) <30;
 

/*select *,DATEADD(day,30,created_date) as 'Month of credit' from  #tempTbl1
where workflow_task_description 
in ('Notify Borrower of Approved Repayment Plan');*/

select loan_skey,workflow_instance_skey,created_date,created_by
,responsible_party_id, complete_date,workflow_task_description,credit as [credits through life of the workflow]
,datediff(day,created_date,GETDATE()) as 'Days tilldate'
from #tempTbl1 
where credit>0  
order by created_date,loan_skey;

/*select * from #tempTbl1
where
workflow_task_description 
in ('Notify Borrower of Approved Repayment Plan','Receipt of Signed Repayment Plan','Repayment Plan Installment Due')
and credit>0;*/


select responsible_party_id as 'Agent',  workflow_task_description,sum(credit) as credits from #tempTbl1
 group by responsible_party_id,workflow_task_description order by responsible_party_id;


 
 select responsible_party_id as 'Agent', sum(credit) as credits from #tempTbl1
 group by responsible_party_id order by responsible_party_id;


