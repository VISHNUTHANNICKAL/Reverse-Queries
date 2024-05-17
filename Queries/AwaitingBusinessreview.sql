IF OBJECT_ID('tempdb..#tempTbl') IS NOT NULL
    DROP TABLE #tempTbl;
select b.loan_skey,b.note_text,b.created_by,b.created_date
into #tempTbl 
FROM [ReverseQuest].[rms].[v_Alert] a
join
reversequest.rms.v_note b
on a.loan_skey=b.loan_skey
where a.alert_type_description in ('Research request pending','DVN Research Request Pend','BBB Research Request Pending')
  and a.alert_status_description = 'Active'
and (b.note_text like ('%Awaiting Business Review%')
);

IF OBJECT_ID('tempdb..#tmpTbl') IS NOT NULL
    DROP TABLE #tmpTbl;
select * into #tmpTbl from(
SELECT  RANK() OVER (PARTITION BY loan_skey ORDER BY created_date DESC) dest_rank,*
    FROM #tempTbl
  ) a where dest_rank = 1;

  IF OBJECT_ID('tempdb..#tmpTbl1') IS NOT NULL
    DROP TABLE #tmpTbl1;
  select distinct a.loan_skey,a.note_text,a.created_by,a.created_date into #tmpTbl1 from #tmpTbl a
  --select distinct a.loan_skey,a.note_text,a.created_by,a.created_date, count(*) from #tmpTbl a
  --group by a.loan_skey,a.note_text,a.created_by,a.created_date
  --having  count(*) >1;


IF OBJECT_ID('tempdb..#tmpTbl2') IS NOT NULL
    DROP TABLE #tmpTbl2;
select  distinct a.* into #tmpTbl2
from #tmpTbl1 a
left outer join
[ReverseQuest].[rms].[v_Note] b
on a.loan_skey = b.loan_skey
and b.note_text like ('%Research Response sent for QC%') and b.created_date > a.created_date
order by a.loan_skey;

IF OBJECT_ID('tempdb..#tempTbl1') IS NOT NULL
    DROP TABLE #tempTbl1;
select loan_skey,note_text,
case when SUBSTRING(note_text,1,4) = 'Step' then substring(note_text,9,25)
else substring(note_text,1,24) end as note_txt,
SUBSTRING(
        note_text, 
        CHARINDEX(':', note_text)+1, 
              len(note_text)) as  'BU'
,created_by,created_date
into #tempTbl1
from #tmpTbl2;

--select * from #tempTbl1;

IF OBJECT_ID('tempdb..#tempTbl2') IS NOT NULL
    DROP TABLE #tempTbl2;
select loan_skey, note_txt as 'Note Text',SUBSTRING(BU,CHARINDEX(':', BU)+1,(len(BU))) as BU, created_by,created_date
into #tempTbl2 from #tempTbl1;
--select * from #tempTbl2;

select loan_skey, [Note Text], case when (CHARINDEX('Comments', BU)) = 0 then BU else SUBSTRING(BU,1,(CHARINDEX('Comments', BU))-1) end as BU 
,created_by,convert(date,created_date) as 'created_date'
from #tempTbl2

