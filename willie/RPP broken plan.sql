select a.loan_skey,
b.start_date1 'Notify Borrower of Approved Repayment Plan start date',
c.due_date 'Repayment Plan Broken complete date'
from
[rms].[v_LoanMaster] a 
left join (
select * from 
(
SELECT b.loan_skey,convert(date,a.schedule_date) start_date1,
ROW_NUMBER() over (partition by b.loan_skey order by convert(date,a.schedule_date) desc ) sn
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join  [ReverseQuest].[rms].[v_WorkflowInstance] b on a.workflow_instance_skey=b.workflow_instance_skey
where 
    a.workflow_task_description in ('Notify Borrower of Approved Repayment Plan')
  and a.status_description in('Active','Workflow Completed')
  and b.workflow_type_description in ('Repayment Plan')
  and b.status_description in('Active','Workflow Completed')
  ) a where sn=1
) b on a.loan_skey=b.loan_skey
left join(
select * from 
(
SELECT b.loan_skey,convert(date,a.due_date) due_date,
ROW_NUMBER() over (partition by b.loan_skey order by convert(date,a.due_date) desc ) sn
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join  [ReverseQuest].[rms].[v_WorkflowInstance] b on a.workflow_instance_skey=b.workflow_instance_skey
where 
    a.workflow_task_description in ('Repayment Plan Broken')
  and a.status_description in('Active','Workflow Completed')
  and b.workflow_type_description in ('Repayment Plan')
  and b.status_description in('Active','Workflow Completed')
  ) a where sn=1
)c on a.loan_skey=c.loan_skey
where 
 a.loan_skey in ('14777',
'15698',
'22324',
'24849',
'81257',
'99732',
'100151',
'104602',
'110004',
'113877',
'121486',
'132424',
'143865',
'146864',
'148212',
'149738',
'162967',
'169453',
'169946',
'173809',
'179537',
'183329',
'184092',
'185575',
'187353',
'188483',
'200844',
'200893',
'200911',
'201447',
'202127',
'202167',
'203755',
'204452',
'205604',
'209547',
'210434',
'211980',
'216309',
'218591',
'219809',
'220196',
'220325',
'220679',
'221101',
'221181',
'223354',
'223825',
'223825',
'223890',
'223894',
'224903',
'227171',
'230289',
'231039',
'237095',
'240204',
'240626',
'248495',
'254198',
'259110',
'259234',
'261196',
'261962',
'262220',
'262841',
'262929',
'263018',
'263431',
'263499',
'264454',
'264953',
'265219',
'265277',
'265347',
'265455',
'265687',
'265783',
'265976',
'266888',
'266979',
'267128',
'267129',
'268500',
'270652',
'270956',
'273608',
'276140',
'276348',
'285178',
'285495',
'302252',
'304226',
'307013',
'316477',
'320479',
'322544',
'322924',
'324783',
'355237',
'357068',
'527561',
'602003')
  order by a.loan_skey