IF OBJECT_ID('tempdb..#tempTbl') IS NOT NULL
    DROP TABLE #tempTbl;
select a.*,b.loan_status_description 
into #tempTbl
from reversequest.rms.v_note a
join reversequest.rms.v_LoanMaster b
on a.loan_skey=b.loan_skey
where a.created_date
-->=   DATEADD(DAY, DATEDIFF(DAY, 30, GETDATE()), 0)
-->=      DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
>=   DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 1))
and a.created_date <  DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 25))
--and a.created_date <    DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 30))
and (a.note_type_description like '%Incom%' or note_type_description like 'Spoc Incom%')
and b.loan_status_description in ('ACTIVE','CLAIM','INACTIVE','BANKRUPTCY');

delete from #tempTbl where note_type_description in ('Email Incoming-Customer Servic');
delete from #tempTbl where note_type_description in('Incoming') and created_by='System Load'

--select * from #tempTbl;

IF OBJECT_ID('tempdb..#tempTbl1') IS NOT NULL
    DROP TABLE #tempTbl1;
select loan_skey,Convert(date,created_date) as created_date,created_date as created_time,created_by,note_type_description
into #tempTbl1
from #tempTbl 

--select * from #tempTbl where created_by = 'Kayla Dupre';
--select * from #tempTbl where loan_skey = '227524';
--select * from #tempTbl  order by created_date
--select * from #tempTbl1 order by loan_skey,created_time;

IF OBJECT_ID('tempdb..#tempTbl2') IS NOT NULL
    DROP TABLE #tempTbl2;
SELECT * into #tempTbl2
FROM ( 
  SELECT loan_skey, created_date, created_time,created_by, note_type_description,
    RANK() OVER (PARTITION BY loan_skey,created_date ORDER BY created_time DESC) dest_rank
    FROM #tempTbl1
  ) a where dest_rank = 1;

--select * from #tempTbl2 order by loan_skey,created_date;

IF OBJECT_ID('tempdb..#tempTotalCalls') IS NOT NULL
    DROP TABLE #tempTotalCalls;
select created_by as EMP_NAME,count(note_type_description) as total_calls into #tempTotalCalls
from #tempTbl2
group by created_by;

--select * from #tempTotalCalls order by EMP_NAME;

IF OBJECT_ID('tempdb..#tmpRepeatInfo') IS NOT NULL
    DROP TABLE #tmpRepeatInfo;
select a.*, case when (a.loan_skey in (select loan_skey from #tempTbl2 where (created_date > a.created_date and created_date < = dateadd(DAY,7,a.created_date))
and loan_skey=a.loan_skey)) then 1 else 0 end as Repeat,
case when (a.loan_skey not in (select loan_skey from #tempTbl2 where (created_date > a.created_date and created_date < =dateadd(DAY,7,a.created_date))
and loan_skey=a.loan_skey))  and  dateadd(DAY,7,created_date) > =getdate() then 1 else 0 end as TOTAL_CALLS_PENDING
into #tmpRepeatInfo
from #tempTbl2 a
order by a.loan_skey,a.created_time;

select loan_skey,created_date,created_time,created_by,note_type_description,Repeat,TOTAL_CALLS_PENDING from #tmpRepeatInfo order by loan_skey,created_time,created_by;


IF OBJECT_ID('tempdb..#tmpRepeatcount') IS NOT NULL
    DROP TABLE #tmpRepeatcount;
select created_by, sum(Repeat)as Total_Repeat_Calls, sum(TOTAL_CALLS_PENDING)as Total_Calls_Pending  into #tmpRepeatcount
from
#tmpRepeatInfo group by created_by;

/*select a.EMP_NAME,a.total_calls - b.TOTAL_CALLS_PENDING as Total_calls
,b.Total_Repeat_Calls,b.Total_Calls_Pending
from #tempTotalCalls a join #tmpRepeatcount b
on a.EMP_NAME=b.created_by
*/
IF OBJECT_ID('tempdb..#tempFinal') IS NOT NULL
    DROP TABLE #tempFinal;
select a.EMP_NAME,a.total_calls - b.TOTAL_CALLS_PENDING as Total_calls,
b.Total_Repeat_Calls,b.TOTAL_CALLS_PENDING into #tempFinal
from #tempTotalCalls a join #tmpRepeatcount b
on a.EMP_NAME=b.created_by;

select a.*,
Case when a.Total_calls<=0 then null
Else concat(FORMAT(cast(a.Total_calls-a.Total_Repeat_Calls as float)/cast(a.Total_calls as float)*100,'N2'),'%')
End as OCR from #tempFinal a