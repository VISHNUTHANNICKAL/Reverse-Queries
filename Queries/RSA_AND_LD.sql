
IF OBJECT_ID('tempdb..#rtemp') IS NOT NULL
    DROP TABLE #rtemp;
select a.loan_skey,a.workflow_type_description,
A.STATUS_DESCRIPTION
,a.created_date as 'Initiate Repairs Admin Task Complete Date'
,b.created_date as 'Boarding Date'
--,c. note_type_description,c.note_text
into #rtemp
FROM [ReverseQuest].[rms].[v_WorkflowInstance] a
join [ReverseQuest].RMS.v_LoanMaster b
on a.loan_skey=b.loan_skey
--LEFT OUTER JOIN
--reversequest.rms.v_note c
--on a.loan_skey=c.loan_skey
where workflow_type_description = 'Repairs'  and status_description = 'Active' 
and b.loan_status_description in ('ACTIVE','BANKRUPTCY','BNK/DEF','BNK/FCL','DEFAULT','FORECLOSURE')
and b.created_date > '01-JAN-2021'
--and c.note_type_description = 'Repairs'
--and a.loan_skey = '324057';


IF OBJECT_ID('tempdb..#rtemp1') IS NOT NULL
    DROP TABLE #rtemp1;
select a.*,b.note_type_description as [Mail Repairs Introduction Letter Task],b.note_text,b.created_by,b.created_date
,DATEDIFF(DAY,A.[Initiate Repairs Admin Task Complete Date],GETDATE()) AS AGING
into #rtemp1
from #rtemp a
left join reversequest.rms.v_note b
on a.loan_skey = b.loan_skey 
and  b.note_type_description = 'Repairs' and (note_text like '%Intro%' or note_text like '%Welcome%')
where b.note_type_description is  null;
 

select loan_skey,workflow_type_description,status_description,[Initiate Repairs Admin Task Complete Date]
,[Boarding Date],[Mail Repairs Introduction Letter Task],AGING
from #rtemp1  order by AGING desc;

--select * from #rtemp1;


IF OBJECT_ID('tempdb..#rtemp2') IS NOT NULL
    DROP TABLE #rtemp2;
select a.*,b.note_type_description as [Mail Repairs Introduction Letter Task],b.note_text,b.created_by,b.created_date as 'Letter Sent date'
,DATEDIFF(DAY,a.[Initiate Repairs Admin Task Complete Date],b.created_date) AS AGE
into #rtemp2
from #rtemp a
join reversequest.rms.v_note b
on a.loan_skey = b.loan_skey 
and  b.note_type_description = 'Repairs' and (note_text like '%Intro%' or note_text like '%Welcome%')
--where b.note_type_description is  not null;

select * from #rtemp2;