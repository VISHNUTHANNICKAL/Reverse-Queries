IF OBJECT_ID('tempdb..#tempTbl') IS NOT NULL
    DROP TABLE #tempTbl;
select b.loan_skey, a.workflow_instance_skey, a.created_date,a.created_by,a.responsible_party_id,a.complete_date,a.workflow_task_description
,case when (a.workflow_task_description = 'Notify Borrower of Approved Repayment Plan' 
and a.created_date > = DATEADD(m,-4,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) and a.created_date <  DATEADD(m,-3,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
or (a.workflow_task_description <> 'Notify Borrower of Approved Repayment Plan' and a.workflow_task_description <> 'Repayment Plan Installment Due') 
and a.complete_date >  DATEADD(m,-4,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
and a.complete_date <  DATEADD(m,-3,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
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
-- and a.created_date > DATEADD(m,-3,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
--and a.created_date < DATEADD(m,-2,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
--order by a.created_date;
select distinct responsible_party_id from #tempTbl;

IF OBJECT_ID('tempdb..#tempTbl1') IS NOT NULL
    DROP TABLE #tempTbl1;
select * into #tempTbl1 from 
(select ROW_NUMBER() OVER (PARTITION BY workflow_instance_skey  ORDER BY created_date,
case when responsible_party_id not in ('RMS.RepaymentPlan' , 'System.Default') then 1 else 2 end ) rn,* from #tempTbl 
--where responsible_party_id <> 'RMS.RepaymentPlan'
) q


select * from #tempTbl1 
where workflow_instance_skey = '436537'
--order by loan_skey
order by rn;


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

select loan_skey,workflow_instance_skey,created_date,created_by
,responsible_party_id, complete_date,workflow_task_description,credit as [credits through life of the workflow]
from #tempTbl1
where credit>0 order by created_date,loan_skey;



 
 select responsible_party_id as 'Agent', sum(credit) as credits from #tempTbl1
 group by responsible_party_id order by responsible_party_id


-- select * from #tempTbl1 where workflow_instance_skey = '2976690'
 --order by loan_skey, rn,complete_date;

 1381010
 2607794
