IF OBJECT_ID('tempdb..#tempTbl') IS NOT NULL
    DROP TABLE #tempTbl;
select loan_skey,document_description,
CONVERT(date,created_date) as created_date into #tempTbl
from 
rqer.dbo.app_document b
	where (b.document_description in ('Email MyRMloan-Inb Multi Dept','Email MyRMloan-Inb-Complaints',
	'ACH Direct Deposit Request','Document Request-CS','Line of Credit Draw Request','Payoff Request')
	or b.document_description like ('Fax-Inbound%'))
	and b.created_date >=   DATEADD(DAY, DATEDIFF(DAY, 30, GETDATE()), 0)
	and b.created_date <    DATEADD(DAY, DATEDIFF(DAY, -0, GETDATE()), 0);

IF OBJECT_ID('tempdb..#tempTbl1') IS NOT NULL
    DROP TABLE #tempTbl1;
	select distinct * into #tempTbl1
	from #tempTbl;

/*select loan_skey,document_description,
CONVERT(date,created_date) as created_date  into #tempTbl1
from 
rqer.dbo.app_document b
	where (b.document_description in ('Email MyRMloan-Inb Multi Dept','Email MyRMloan-Inb-Complaints',
	'ACH Direct Deposit Request','Document Request-CS','Line of Credit Draw Request','Payoff Request')
	or b.document_description like ('Fax-Inbound%'))
	and b.created_date >=   DATEADD(DAY, DATEDIFF(DAY, 30, GETDATE()), 0)
	and b.created_date <    DATEADD(DAY, DATEDIFF(DAY, -0, GETDATE()), 0);*/
	--select distinct * from #tempTbl1 order by created_date;

	IF OBJECT_ID('tempdb..#tempTbl2') IS NOT NULL
    DROP TABLE #tempTbl2;
select loan_skey,document_type_skey,document_description,created_date into #tempTbl2
from 
rqer.dbo.app_document b
	where (b.document_description in ('Email MyRMLoan-Outbound CS','Refinance Worksheet','Payoff Statement')
	or b.document_description like ('Fax-Outbound%') or b.document_type_skey = '101040')
	and b.created_date >=   DATEADD(DAY, DATEDIFF(DAY, 30, GETDATE()), 0)
	and b.created_date <    DATEADD(DAY, DATEDIFF(DAY, -0, GETDATE()), 0);

	--select distinct * from #tempTbl order by created_date;
	--select * from #tempTbl2 ;

	/*select a.loan_skey,a.document_description,b.document_type_skey,b.document_description as 'doc_description',b.created_date as 'r_created_date' from #tempTbl1 a
	join
	#tempTbl2 b on a.loan_skey=b.loan_skey;*/

	

	IF OBJECT_ID('tempdb..#tmpDupeInfo') IS NOT NULL
    DROP TABLE #tmpDupeInfo;
	select a.*, case when (a.loan_skey in (select loan_skey from #tempTbl1 
	where (created_date > a.created_date and created_date < = dateadd(DAY,10,a.created_date))
		and document_description = a.document_description
and loan_skey=a.loan_skey)) then 1 else 0 end as 'Has Dupe'
into #tmpDupeInfo
from #tempTbl1 a
order by a.loan_skey;
--,a.created_time;

select * from #tmpDupeInfo order by loan_skey,created_date;
--select * from #tempTbl where loan_skey = '13731';

/*IF OBJECT_ID('tempdb..#tmpDupeInfo1') IS NOT NULL
    DROP TABLE #tmpDupeInfo1;
	select a.*, case when (a.loan_skey in (select loan_skey from #tempTbl2 where (created_date < a.created_date and created_date < = dateadd(DAY,10,a.created_date))
and loan_skey=a.loan_skey)) then 1 else 0 end as 'Is Dupe'
into #tmpDupeInfo1
from #tempTbl1 a
order by a.loan_skey;*/

IF OBJECT_ID('tempdb..#tmpDupeInfo1') IS NOT NULL
    DROP TABLE #tmpDupeInfo1;
	select a.*, case when (a.loan_skey in (select loan_skey from #tempTbl2 where (a.created_date > dateadd(DAY,10,created_date))
and loan_skey=a.loan_skey)) then 1 else 0 end as 'Is Dupe'
into #tmpDupeInfo1
from #tempTbl1 a
order by a.loan_skey;

/*select a.loan_skey,a.document_description,a.created_date,b.[Is Dupe],b.loan_skey,b.document_description,b.created_date from #tempTbl2 a
join #tmpDupeInfo1 b on a.loan_skey=b.loan_skey
order by a.loan_skey,a.created_date;*/

select * from #tmpDupeInfo1 order by loan_skey,created_date;


select a.loan_skey,a.Duplicates + b.Duplicates as 'Sum dup' from
(select loan_skey, sum([Has Dupe]) 'Duplicates'
from #tmpDupeInfo   group by loan_skey) a
 join
(select loan_skey, sum([Is Dupe]) 'Duplicates'
from #tmpDupeInfo1 group by loan_skey) b on a.loan_skey=b.loan_skey;


--select loan_skey,sum([Has Dupe]) from #tmpDupeInfo where loan_skey = '240472' group by loan_skey;
--select loan_skey, sum([Is Dupe]) from #tmpDupeInfo1 where loan_skey = '240472' group by loan_skey;