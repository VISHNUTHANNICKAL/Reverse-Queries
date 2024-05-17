-------------------------------------------------------------------------------------------------
------NEW LOGIC---------
------------------------------------------------------------


------------------------------------
IF OBJECT_ID('tempdb..#tempTbl') IS NOT NULL
   DROP TABLE #tempTbl;
	--insert into #tempTbl2
	select * 
	into #tempTbl from (
SELECT distinct 1 as rn,  b.loan_skey, a.workflow_instance_skey
,a.created_date,a.created_by,c.created_by as 'responsible_party_id',a.complete_date,
a.workflow_task_description,1 as 'credits through life of the workflow'
,c.note_type_description as 'note_type',c.created_date as 'note_created_date',c.created_by as 'note_created_by',c.note_text
,convert(int, a.created_date-c.created_date) as 'diff created_date and reffered date'

  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
	join [ReverseQuest].[rms].[v_WorkflowInstance] b on a.workflow_instance_skey=b.workflow_instance_skey
	join
	(select loan_skey,created_by,created_date,note_type_description,note_text from(
select loan_skey,created_by,created_date,note_type_description,note_text,
row_number() over(partition by loan_skey order by created_date desc) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Loss Mit Referral – SS'
--and created_date >     DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
and created_date <   DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
--and loan_skey=204143
) as T --where rn=1 
) c
	on b.loan_skey=c.loan_skey and a.created_date>=c.created_date

  where (a.workflow_task_description = 'Receipt of Short Sale Closing Proceeds' 
  or a.workflow_task_description = 'Receipt of Family Sale Proceeds'
-- or a.workflow_task_description = 'Receipt of Executed Deed -Instruct Attorney to record'
  )
  and a.status_description = 'Active' and c. note_type_description = 'Loss Mit Referral – SS'
and a.complete_date >     DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and 
a.complete_date <   DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and c.created_date < a.created_date 
--and b.loan_skey=204143
and responsible_party_id not in ('RMS.RepaymentPlan' , 'System.Default'
--,'Clarisa Centeno','Clarisa.Centeno',
--'Don Anthony Eusebio',
--'Don Anthony.Eusebio',
--'Vincent Gherardi','Vincent.Gherardi',
--'Jerrick Natividad','Jerrick.Natividad'
) 

union all
--select * from #tempTbl 
--insert into #tempTbl2
SELECT distinct 1 as rn,  b.loan_skey, a.workflow_instance_skey
,a.created_date,a.created_by,c.created_by as 'responsible_party_id',a.complete_date,
a.workflow_task_description,1 as 'credits through life of the workflow'
,c.note_type_description as'note_type',c.created_date as 'note_created_date',c.created_by as 'note_created_by',c.note_text
,convert(int, a.created_date-c.created_date) as 'diff created_date and reffered date'
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
	join [ReverseQuest].[rms].[v_WorkflowInstance] b on a.workflow_instance_skey=b.workflow_instance_skey
	join
	(select loan_skey,created_by,created_date,note_type_description,note_text from(
select loan_skey,created_by,created_date,note_type_description,note_text,
row_number() over(partition by loan_skey order by created_date desc ) as rn
from [ReverseQuest].[rms].[v_Note] 
where note_type_description = 'Loss Mit Referral – DIL'
--and created_date >     DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
and created_date <   DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
) as T --where rn=1
) c
	on b.loan_skey=c.loan_skey and a.created_date>=c.created_date

  where (a.workflow_task_description = 'Receipt of Executed Deed -Instruct Attorney to record' 
  --or a.workflow_task_description = 'Receipt of Short Sale Closing Proceeds' 
 -- or a.workflow_task_description = 'Receipt of Family Sale Proceeds'
  )
  and a.status_description = 'Active' and c. note_type_description = 'Loss Mit Referral – DIL'
--and a.created_date > DATEADD(m,-0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
--and a.created_date < DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and a.complete_date >  DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and 
a.complete_date <  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and c.created_date < a.created_date
and responsible_party_id not in ('RMS.RepaymentPlan','System.Default','Clarisa Centeno','Clarisa.Centeno',
'Don Anthony Eusebio',
'Don Anthony.Eusebio',
'Vincent Gherardi','Vincent.Gherardi',
'Jerrick Natividad','Jerrick.Natividad') ) a where [diff created_date and reffered date]<=30
;


--select * from #tempTbl where loan_skey in('204143')

--select * from #tempTbl2
select loan_skey,loan_status_description,fha_case_number,servicer_name,investor_name,
responsible_party_id,[note_referred_date],note_type,note_text,workflow_task_description_created_by,created_date,
workflow_task_description,Workout,complete_date,SPOC,[SPOC Payout],'' as 'team_lead', [lead_payout]
from (
select a.loan_skey,
b.loan_status_description,b.fha_case_number,b.servicer_name,b.investor_name,a.responsible_party_id,a.note_type,
a.note_created_date as 'note_referred_date',a.note_created_by as 'SPOC',a.created_by as 'workflow_task_description_created_by'
,a.created_date, a.complete_date,a.note_text--,a.workflow_instance_skey,
,a.workflow_task_description
,case when a.workflow_task_description='Receipt of Short Sale Closing Proceeds' then 'Short Sale'
when a.workflow_task_description='Receipt of Executed Deed -Instruct Attorney to record' then 'Deed in Lieu'
when a.workflow_task_description='Receipt of Family Sale Proceeds' then 'Heir Payoff'
else NULL end as 'Workout',
case when a.workflow_task_description='Receipt of Short Sale Closing Proceeds' then '$300'
when a.workflow_task_description='Receipt of Executed Deed -Instruct Attorney to record' then '$150'
when a.workflow_task_description='Receipt of Family Sale Proceeds' then '$300'
else '$0' end as 'SPOC Payout',
'$50' as 'lead_payout',
ROW_NUMBER() over (partition by a.loan_skey order by a.note_created_date asc) sn,
convert(int, a.created_date-a.note_created_date) as 'diff created_date and reffered date'
--,a.credit as [credits through life of the workflow]
--,datediff(day,a.created_date,GETDATE()) as 'Days tilldate'
from #tempTbl a
join rms.v_Loanmaster b on a.loan_skey=b.loan_skey
where a.created_date>a.note_created_date
--a.[credits through life of the workflow]>0  
--and a.workflow_task_description in('Receipt of Short Sale Closing Proceeds','Receipt of Executed Deed -Instruct Attorney to record','Receipt of Family Sale Proceeds')

)b where --loan_skey in('203948','205536') and
sn=1 and [diff created_date and reffered date] <=30
order by loan_skey
;

