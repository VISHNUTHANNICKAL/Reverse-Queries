

------------Duplicate Request
IF OBJECT_ID('tempdb..#tempTbl') IS NOT NULL
    DROP TABLE #tempTbl;
select loan_skey,document_description,
CONVERT(date,created_date) as created_date into #tempTbl
from 
rqer.dbo.app_document b
	where (b.document_description in ('Email MyRMloan-Inb Multi Dept','Email MyRMloan-Inb-Complaints',
	'ACH Direct Deposit Request','Document Request-CS','Line of Credit Draw Request','Payoff Request')
	or b.document_description like ('Fax-Inbound%'))
	and b.created_date 
	>=    DATEADD(DAY, DATEDIFF(DAY, 30, getdate()), 0)
	-->=   DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 14))
	--and b.created_date <   DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0));

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
	and b.created_date 
	>=    DATEADD(DAY, DATEDIFF(DAY, 30, getdate()), 0)
	-->=   DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 14))
	--and b.created_date <    DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0));

	--select distinct * from #tempTbl order by created_date;
	--select * from #tempTbl2 ;

	/*select a.loan_skey,a.document_description,b.document_type_skey,b.document_description as 'doc_description',b.created_date as 'r_created_date' from #tempTbl1 a
	join
	#tempTbl2 b on a.loan_skey=b.loan_skey;*/

	

	IF OBJECT_ID('tempdb..#tmpDupeInfo') IS NOT NULL
    DROP TABLE #tmpDupeInfo;
	select a.*, convert(int,case when (a.loan_skey in (select loan_skey from #tempTbl1 
	where (created_date > a.created_date and created_date < = dateadd(DAY,10,a.created_date))
		and document_description = a.document_description
and loan_skey=a.loan_skey)) then 1 else 0 end) as 'Has Dupe'
into #tmpDupeInfo
from #tempTbl1 a
order by a.loan_skey;
--,a.created_time;

--select * from #tmpDupeInfo order by loan_skey,created_date;
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
	select a.*,convert(int, case when (a.loan_skey in (select loan_skey from #tempTbl2 where (a.created_date > dateadd(DAY,10,created_date))
and loan_skey=a.loan_skey)) then 1 else 0 end) as 'Is Dupe'
into #tmpDupeInfo1
from #tempTbl1 a
order by a.loan_skey;

/*select a.loan_skey,a.document_description,a.created_date,b.[Is Dupe],b.loan_skey,b.document_description,b.created_date from #tempTbl2 a
join #tmpDupeInfo1 b on a.loan_skey=b.loan_skey
order by a.loan_skey,a.created_date;*/

--select * from #tmpDupeInfo1 order by loan_skey,created_date;

IF OBJECT_ID('tempdb..#tmpFinalDupeInfo1') IS NOT NULL
    DROP TABLE #tmpFinalDupeInfo1;
select a.loan_skey,
'Duplicate Request' as'Request Type',
convert(int,a.Duplicates+b.Duplicates) as 'Sum dup' 
into #tmpFinalDupeInfo1
from
(select loan_skey, convert(int,sum([Has Dupe])) as 'Duplicates'
from #tmpDupeInfo  group by loan_skey) a
 join
(select loan_skey, convert(int,sum([Is Dupe])) as 'Duplicates'
from #tmpDupeInfo1  group by loan_skey) b on a.loan_skey=b.loan_skey;

--select * from #tmpFinalDupeInfo1 where [Sum dup]>=4 order by loan_skey,[Sum dup] desc ;
/*CONVERT(INT,
        CASE
        WHEN IsNumeric(CONVERT(VARCHAR(12), 'Sum dup')) = 1 THEN CONVERT(VARCHAR(12),'Sum dup')
        ELSE 0 END)
		*/
--select loan_skey,sum([Has Dupe]) from #tmpDupeInfo where loan_skey = '240472' group by loan_skey;
--select loan_skey, sum([Is Dupe]) from #tmpDupeInfo1 where loan_skey = '240472' group by loan_skey;

------OCR

IF OBJECT_ID('tempdb..#tempTbl4') IS NOT NULL
    DROP TABLE #tempTbl4;
select a.*,b.loan_status_description 
into #tempTbl4
from reversequest.rms.v_note a
join reversequest.rms.v_LoanMaster b
on a.loan_skey=b.loan_skey
where a.created_date
>=    DATEADD(DAY, DATEDIFF(DAY, 15, getdate()), 0)
-->=    dateadd(d,-1,dateadd(mm,datediff(m,0,getdate()),1 ))
-->=     DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,'2022-09-03 00:00:00.000'), 14))
--and a.created_date <   DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
and a.created_date <    DATEADD(DAY, DATEDIFF(DAY, -0, GETDATE()), 0)
and (a.note_type_description like '%Incom%' or note_type_description like 'Spoc Incom%')
and b.loan_status_description in ('ACTIVE','CLAIM','INACTIVE','BANKRUPTCY');

delete from #tempTbl4 where note_type_description in ('Email Incoming-Customer Servic');
delete from #tempTbl4 where note_type_description in('Incoming') and created_by='System Load'

--select * from #tempTbl4;

IF OBJECT_ID('tempdb..#tempTbl5') IS NOT NULL
    DROP TABLE #tempTbl5;
select loan_skey,Convert(date,created_date) as created_date,created_date as created_time,created_by,note_type_description
into #tempTbl5
from #tempTbl4 

--select * from #tempTbl where created_by = 'Kayla Dupre';
--select * from #tempTbl where loan_skey = '227524';
--select * from #tempTbl  order by created_date
--select * from #tempTbl1 order by loan_skey,created_time;

IF OBJECT_ID('tempdb..#tempTbl6') IS NOT NULL
    DROP TABLE #tempTbl6;
SELECT * into #tempTbl6
FROM ( 
  SELECT loan_skey, created_date, created_time,created_by, note_type_description,
    RANK() OVER (PARTITION BY loan_skey,created_date ORDER BY created_time DESC) dest_rank
    FROM #tempTbl5
  ) a --where dest_rank = 1
  ;

--select * from #tempTbl5 order by loan_skey,created_date;

IF OBJECT_ID('tempdb..#tempTotalCalls') IS NOT NULL
    DROP TABLE #tempTotalCalls;
select created_by as EMP_NAME,count(note_type_description) as total_calls into #tempTotalCalls
from #tempTbl5
--where created_by not like 'System.Load'
group by created_by;

--select * from #tempTbl5 order by EMP_NAME;

IF OBJECT_ID('tempdb..#tmpRepeatInfo') IS NOT NULL
    DROP TABLE #tmpRepeatInfo;
select a.*, case when (a.loan_skey in (select loan_skey from #tempTbl6 where (created_date > a.created_date and created_date < = dateadd(DAY,7,a.created_date))
and loan_skey=a.loan_skey)) then 1 else 0 end as Repeat,
case when (a.loan_skey not in (select loan_skey from #tempTbl6 where (created_date > a.created_date and created_date < =dateadd(DAY,7,a.created_date))
and loan_skey=a.loan_skey))  and  dateadd(DAY,7,created_date) > =getdate() then 1 else 0 end as TOTAL_CALLS_PENDING
into #tmpRepeatInfo
from #tempTbl6 a
where created_by not like 'System.Load'
order by a.loan_skey,a.created_time;

--select * from #tempTbl6


IF OBJECT_ID('tempdb..#tempOCR') IS NOT NULL
    DROP TABLE #tempOCR;
select loan_skey,
'Repeat Calls' as 'Request Type',
convert(int,sum(Repeat)) as 'repeat count'
into #tempOCR
--created_date,created_time,created_by,note_type_description,Repeat,TOTAL_CALLS_PENDING 
from #tmpRepeatInfo 
group by loan_skey

-- select * from #tempOCR order by 'repeat count' desc;
/*
---------------Repeat Complaints
IF OBJECT_ID('tempdb..#tmprepeatcomplaints') IS NOT NULL
    DROP TABLE #tmprepeatcomplaints;
select * into #tmprepeatcomplaints from
(
select 116096 as Loan_skey, 3 as Business_Unit UNION All
select 167572 as Loan_skey, 3 as Business_Unit UNION All
select 167957 as Loan_skey, 4 as Business_Unit UNION All
select 223335 as Loan_skey, 3 as Business_Unit UNION All
select 227751 as Loan_skey, 3 as Business_Unit UNION All
select 261471 as Loan_skey, 3 as Business_Unit UNION All
select 264551 as Loan_skey, 3 as Business_Unit UNION All
select 268318 as Loan_skey, 3 as Business_Unit UNION All
select 315955 as Loan_skey, 3 as Business_Unit UNION All
select 316354 as Loan_skey, 4 as Business_Unit UNION All
select 317985 as Loan_skey, 3 as Business_Unit UNION All
select 351978 as Loan_skey, 3 as Business_Unit UNION All
select 526206 as Loan_skey, 3 as Business_Unit UNION All
select 93322 as Loan_skey, 3 as Business_Unit 


) x
--select * from #tmprepeatcomplaints;
*/
IF OBJECT_ID('tempdb..#tmprepeatcomplaints2') IS NOT NULL
    DROP TABLE #tmprepeatcomplaints2;
select loan_skey,note_type_description,rep_count
into #tmprepeatcomplaints2
from (
select loan_skey,note_type_description,COUNT(sn) rep_count from (
select loan_skey,'Repeat Complaints' note_type_description,convert(date,created_date) created_date,
ROW_NUMBER() over (PARTITION by loan_skey,convert(date,created_date) order by convert(date,created_date) ,loan_skey) sn
from rms.v_Note
where note_type_description in ('Complaint-Verbal')
and created_date>=DATEADD(DAY, DATEDIFF(DAY,10, GETDATE()), 0)
) a where sn=1
group by loan_skey,note_type_description
) a
where rep_count>=4;

--select loan_skey,note_type_description,rep_count from #tmprepeatcomplaints2;
/*
IF OBJECT_ID('tempdb..#tmpfinalrepeatcomplaints') IS NOT NULL
    DROP TABLE #tmpfinalrepeatcomplaints;
select Loan_skey,count(Business_Unit) as 'Count of BU' 
into #tmpfinalrepeatcomplaints
from #tmprepeatcomplaints
--where convert(int,'Count of BU')>4
group by Loan_skey

--select Loan_skey,'Repeat Complaints' as 'Request type',[Count of BU] from #tmpfinalrepeatcomplaints where [Count of BU]>3 and Loan_skey<>'' order by Loan_skey
----------ICASE
IF OBJECT_ID('tempdb..#tempIcase') IS NOT NULL
    DROP TABLE #tempIcase;
select * into #tempIcase from (
select 219388 as Loan_skey, '119969998' as Case_number, '' as Assigned_to, 13 as Days_open Union all
select 237265 as Loan_skey, '119991596' as Case_number, 'Jerrick Natividad' as Assigned_to, 13 as Days_open Union all
select 237932 as Loan_skey, '119986298' as Case_number, '' as Assigned_to, 13 as Days_open Union all
select 238289 as Loan_skey, '120015805' as Case_number, 'Jennalyn Pepa' as Assigned_to, 13 as Days_open Union all
select 298007 as Loan_skey, '119968618' as Case_number, 'Faith Salen' as Assigned_to, 13 as Days_open Union all
select 322862 as Loan_skey, '119963741' as Case_number, '' as Assigned_to, 13 as Days_open Union all
select 352592 as Loan_skey, '119967011' as Case_number, 'Don Anthony Eusebio' as Assigned_to, 13 as Days_open 


) y
--select * from #tempIcase
*/
--select * from #tmpfinalIcase;
-------Call Request - Specialized
IF OBJECT_ID('tempdb..#tempSpecialized') IS NOT NULL
    DROP TABLE #tempSpecialized;
select *
into #tempSpecialized from (
select  loan_skey,note_type_description,note_text,created_date,created_by,
ROW_NUMBER() OVER (PARTITION BY loan_skey  ORDER BY created_date desc) as 'rn'
from rms.v_Note where note_type_description='Call Request - Specialized'
and created_date >  DATEADD(DAY, DATEDIFF(DAY, 10, GETDATE()), 0)
and  created_date <   DATEADD(DAY, DATEDIFF(DAY,0, GETDATE()), 0)
) a where rn=1


--select * from  #tempSpecialized







-----Adding an Employee for round robin process
IF OBJECT_ID('tempdb..#Employee') IS NOT NULL
    DROP TABLE #Employee;
Create Table #Employee (id Int , Name nvarchar(20)) 
--Insert into   #Employee Values (1,'Ashima Burton');
Insert into   #Employee Values (2,'Clarisa Centeno');
Insert into   #Employee Values (3,'Don Anthony Eusebio');
--Insert into   #Employee Values (4,'Gina Martin');
Insert into   #Employee Values (5,'Jerrick Natividad');

--select * from #Employee
---------------------------------------------------------
IF OBJECT_ID('tempdb..#tmpEscalation') IS NOT NULL
    DROP TABLE #tmpEscalation;
	select * into #tmpEscalation
	from
(SELECT a.[loan_skey]
        ,max(created_date) as 'created_date'
        ,' ' as 'created_by'
        ,a.alert_type_description
        ,ROW_NUMBER() OVER (PARTITION BY a.loan_skey ORDER BY a.loan_skey)  num
     FROM [ReverseQuest].[rms].[v_Alert] a
  where alert_type_description = 'Escalation'
  and alert_status_description = 'Active'
  --and loan_skey=266688
  group by loan_skey,alert_type_description) r
  where r.num=1
-------------------------------------------------------LAST 90 days
  IF OBJECT_ID('tempdb..#tmpEscalation_90_days') IS NOT NULL
    DROP TABLE #tmpEscalation_90_days;
	select * into #tmpEscalation_90_days
	from
(
SELECT a.[loan_skey]
        ,max(modified_date) as 'modified_date'
        ,modified_by as 'modified_by'
        ,a.alert_type_description
		,a.alert_status_description
        ,ROW_NUMBER() OVER (PARTITION BY a.loan_skey ORDER BY a.loan_skey)  num
     FROM [ReverseQuest].[rms].[v_Alert] a
  where alert_type_description = 'Escalation'
  --and alert_status_description = 'Inactive'
  --and loan_skey=266688
  and modified_date > DATEADD(d,-90,DATEDIFF(d,0,GETDATE()))
  group by loan_skey,alert_type_description,alert_status_description,modified_by
) r
  where r.num=1

 -- select * from #tmpEscalation_90_days


IF OBJECT_ID('tempdb..#tempfinalsummary') IS NOT NULL
    DROP TABLE #tempfinalsummary;
select * into #tempfinalsummary from (

select loan_skey,[Request Type],[Sum dup] as Total from #tmpFinalDupeInfo1 where [Sum dup]>=4 --order by [Sum dup] desc 
union all
select loan_skey,[Request Type],[repeat count] from #tempOCR where [repeat count]>=4 --order by[repeat count] desc 
/*union all
select Loan_skey,'Repeat Complaints' as 'Request type',Business_Unit from #tmprepeatcomplaints where Business_Unit>2 
and Loan_skey<>''
union all
select Loan_skey,'Icase' as 'Request type',convert(int,Days_open) from #tempIcase --where Loan_skey<>''
*/
union all
select loan_skey,note_type_description,rn from  #tempSpecialized
union all
select loan_skey,note_type_description,rep_count from #tmprepeatcomplaints2
) ten order by [Request Type],Total desc;
--select * from #tempfinalsummary order by loan_skey;

IF OBJECT_ID('tempdb..#tempfinal') IS NOT NULL
    DROP TABLE #tempfinal;
select distinct loan_skey,
STUFF((SELECT '/ ' + [Request Type]
          FROM #tempfinalsummary a
          WHERE a.loan_skey= b.loan_skey
          FOR XML PATH('')), 1, 1, '') [Request Type],
STUFF((SELECT '/ ' + convert(varchar,Total)
          FROM #tempfinalsummary a
          WHERE a.loan_skey= b.loan_skey
          FOR XML PATH('')), 1, 1, '') Total
into #tempfinal
from #tempfinalsummary b
group by loan_skey
order by loan_skey;

--select * from #tempfinal

/*delete from #tempfinal where cast (loan_skey AS bigint) in(
--Monday
'85833',
'93322',
'116096',
'146245',
'209161',
'219309',
'223335',
'227751',
'240882',
'256568',
'257446',
'262313',
'263903',
'264551',
'266376',
'270085',
'285505',
'309240',
'359393',
'360924',
'526206',
'586107',



--tuesday




--wednesday
'11294',
'17032',
'91496',
'123779',
'145273',
'201214',
'202790',
'211434',
'212224',
'224522',
'227798',
'235156',
'251101',
'251340',
'264099',
'268318',
'284528',
'301701',
'303915',
'306777',
'315231',
'317985',
'320931',
'325205',
'351539',
'351559',
'351978',
'357405',
'361012',
'361463',



--Thursday

'14902',
'35887',
'90305',
'113110',
'167572',
'211601',
'220343',
'220908',
'221055',
'223075',
'229193',
'229530',
'238984',
'240109',
'248400',
'249132',
'263206',
'292672',
'323866',
'352035',
'357595',



--Friday
'1300',
'17772',
'94984',
'117613',
'137534',
'167957',
'215370',
'223209',
'235246',
'238599',
'249933',
'256722',
'261707',
'262257',
'264117',
'267702',
'305139',
'309662',
'310513',
'315955',
'316354',
'316747',
'321569',
'323641',
'352080',
'358151',
'613341'

);*/

--,created_time,created_by;
---- Round Robin logic
IF OBJECT_ID('tempdb..#temprr') IS NOT NULL
    DROP TABLE #temprr;
WITH    ten1 AS  (
        SELECT  *, ROW_NUMBER() OVER (ORDER BY loan_skey) AS rn
        FROM   #tempfinal 
        ),
        emp AS (
	   SELECT  *,ROW_NUMBER() OVER (ORDER BY id) AS rn
        FROM   #Employee
        )
SELECT  ten1.loan_skey,
ten1.[Request Type],ten1 .Total,
emp.Name into #temprr
FROM    ten1
JOIN    emp
ON      emp.rn =
        (ten1.rn - 1) %
        (
        SELECT  COUNT(*)
        FROM     #Employee
        ) + 1
order by loan_skey;

--select * from #temprr;

---------ESCaltion alert
IF OBJECT_ID('tempdb..#tempescalert') IS NOT NULL
    DROP TABLE #tempescalert;
select 
f.loan_skey,
case when f.loan_skey=e.loan_skey then e.alert_type_description else f.[Request Type] end as 'Request Type',
convert(varchar ,case when f.loan_skey=e.loan_skey then convert(varchar,e.num) else f.Total end) as 'Total',
case when f.loan_skey=e.loan_skey then e.created_by else f.Name end as 'Employee Name'
into #tempescalert
from #temprr f
left join #tmpEscalation e on f.loan_skey=e.loan_skey 
order by f.loan_skey
;

--select * from #tmpEscalation
--select * from #tmpEscalation_90_days

update #tempescalert 
set [Employee Name]=b.modified_by from #tempescalert a join #tmpEscalation_90_days b on  a.loan_skey=b.loan_skey
where a.loan_skey=b.loan_skey
;


--exclude for 5 days --note --'Specialized Escalation Review'

delete from #tempescalert where loan_skey in (
select loan_skey from rms.v_Note 
where note_type_description='Specialized Escalation Review'
and created_date >=DATEADD(DAY, DATEDIFF(DAY, 5, GETDATE()), 0)
)



--FIRST tab resultset


select [Employee Name],COUNT([Request Type]) 'Request Type' from #tempescalert 
where [Request Type] not in ('Escalation')
group by [Employee Name]
union all
select 'TOTAL ',COUNT([Request Type]) 'Request Type' from #tempescalert 
where [Request Type] not in ('Escalation')
--group by [Request Type]
;



-- SECOND TAB RESULTSET---




select  distinct loan_skey,[Request Type],Total,[Employee Name] from #tempescalert 
where [Request Type] not in ('Escalation')
order by loan_skey;

/*
select  loan_skey,
STUFF((SELECT '/ ' + [Request Type]
          FROM #tempescalert a
          WHERE a.loan_skey= b.loan_skey
          FOR XML PATH('')), 1, 1, '') [Request Type],[Employee Name]
from #tempescalert b
*/

/*
---------------------Dupes---------------

select loan_skey,document_description,created_date,[Has Dupe] from #tmpDupeInfo --order by loan_skey,created_date
union all
select loan_skey,document_description,created_date,[Is Dupe] from #tmpDupeInfo1 --order by loan_skey,created_date
-----------OCR
select * from #tmpRepeatInfo order by loan_skey
-----------Repeat Complaints
select * from #tmprepeatcomplaints where Loan_skey<>'' and   Business_Unit>2 order by Loan_skey;

---------Icase
select * from #tempIcase where  Days_open='13'  order by Loan_skey;

--- Call Request - Specialized
select loan_skey,note_type_description,note_text,created_date,created_by from #tempSpecialized order by Loan_skey;
*/