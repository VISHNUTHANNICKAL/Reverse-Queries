
IF OBJECT_ID('tempdb..#tempTbl') IS NOT NULL
    DROP TABLE #tempTbl;
select
convert(date,GETDATE()) as 'Report date',
a.loan_skey as 'Loan''s Key',
concat(c.first_name,' ',c.last_name) as 'Borrower''s Name',
b.state_code as 'PROPERTY STATE',
 e.alert_type_description  as 'INVENTORY',
--case when c.contact_type_description like 'Attorney' then 'Borrower Represented by Attorney' else 
a.loan_status_description  as 'EXCLUSION REASON',
a.original_loan_number as 'Loan #',
e.alert_status_description as 'Alert Status',
a.loan_status_description  as 'Loan Status',
a.loan_sub_status_description as 'Loan Sub_status',
convert(date,e.alert_date) as 'Alert Raised Date',
e.created_by as 'Alert Raised BY',
DATEDIFF(DAY,e.alert_date,GETDATE()) as 'DAYS_SINCE_Alert raised',
NULL as 'Last Skip Result',
NULL as 'Last Skip Date',
NULL as 'Last Agent Name'
,(case when b.state_code in ('TN') then 'Bangalore' else
case when b.state_code in ('AL','AK','AS','AZ','AR','CA','CO','DE','DC','FL','GA','GU','HI','ID',
'IL','IN','IA','KS','KY','LA','ME','MH','MD','MA','MI','FM','MN','MS','MO','MT','NE','NV','NJ','NM',
'NY','NC','ND','MP','OH','OK','PW','PA','PR','RI','SC','SD','TX','UT','VT','VI','VA','WV','WY') 
then 'Offshore' else
case when b.state_code in ('CT','NH','WA') then 'Onshore' else
case when b.state_code in('OR','WI') then 'Pune/Bangalore' end end end end  ) as 'Location'
--,c.contact_type_description
into #tempTbl
from reversequest.rms.v_LoanMaster a
  join ReverseQuest.rms.v_Alert e
on a.loan_skey=  e.loan_skey 
 /* join ReverseQuest.rms.v_Note d
on a.loan_skey=d.loan_skey */
 join [ReverseQuest].[rms].[v_PropertyMaster] b
on a.loan_skey=b.loan_skey
 join reversequest.rms.v_ContactMaster c
on a.loan_skey = c.loan_skey
where 
e.alert_type_description in('SKPADD','SKPEML','SKPEXH','SKPTRC')
--,'FRAUD SUSPICION','Litigation -  Proceed','LITIGATION - Lawsuit Pending','Bankruptcy Monitoring Started','Bankruptcy Monitoring Stopped',
--'Cease and Desist','Pending Cease and Desist')
 and e.alert_status_description ='Active'
and c.contact_type_description='Borrower'

--and e.modified_by <> 'System Update'
--and a.loan_status_description in('BANKRUPTCY','BNK/DEF','BNK/FCL','INACTIVE','REO')
--and e.alert_category_description in ('Skip Tracing')
/*and d.note_type_description in ('Non-Voice Phone',
'Non-Workable in',
'Phone Exhaust',
'RPC Address',
'RPC Address Email',
'RPC Address Exhaust',
'RPC Email',
'RPC Email Exhaust',
'RPC Exhaust',
'RPC Phone',
'RPC Phone Address',
'RPC Phone Address Email',
'RPC Phone Email',
'RPC Phone Exhaust',
'Skip Exhausted'
)*/
--and a.loan_skey not in()
--and a.loan_status_description in ('BANKRUPTCY')
--select  * from #tempTbl where [Loan's Key]=266744 order by [Loan's Key] 
--where [EXCLUSION REASON] in('BANKRUPTCY','BNK/DEF','BNK/FCL','INACTIVE','REO')


--------Attorney from contact
IF OBJECT_ID('tempdb..#tempTbl1') IS NOT NULL
    DROP TABLE #tempTbl1;
select  f.[Report date],f.[Loan's Key],f.[PROPERTY STATE],f.INVENTORY,
case when c.contact_type_description like 'Attorney' then UPPER('Borrower Represented by Attorney') else f.[EXCLUSION REASON] end as 'EXCLUSION REASON',
f.[Loan #],f.[Loan Status],f.[Loan Sub_status],f.[Alert Raised Date],f.[Alert Raised BY],
f.[DAYS_SINCE_Alert raised],f.[Last Skip Result],f.[Last Skip Date],f.[Last Agent Name],f.Location
,c.contact_type_description
into #tempTbl1
from #tempTbl f
left join  reversequest.rms.v_ContactMaster c
on f.[Loan's Key] = c.loan_skey
where c.contact_type_description = 'Attorney'
--select * from #tempTbl;
--select  * from #tempTbl1;
---------------------
update #tempTbl set [EXCLUSION REASON]='BORROWER REPRESENTED BY ATTORNEY'
where [Loan's Key]in (select  [Loan's Key] from #tempTbl1);

update #tempTbl set [EXCLUSION REASON]='' where [EXCLUSION REASON] in('ACTIVE','DEFAULT','FORECLOSURE','CLAIM')

--select * from #tempTbl where [EXCLUSION REASON] in('ACTIVE','DEFAULT','FORECLOSURE','CLAIM')
----------------------------------------------

/*addition of new Exclusion reason ('FRAUD SUSPICION','Litigation -  Proceed','LITIGATION - Lawsuit Pending','Bankruptcy Monitoring Started','Bankruptcy Monitoring Stopped',
'Cease and Desist','Pending Cease and Desist') */


IF OBJECT_ID('tempdb..#tempTbl5') IS NOT NULL
    DROP TABLE #tempTbl5;
select * 
into #tempTbl5
from (
select e.loan_skey,e.alert_type_description,e.alert_status_description,CONVERT(date,e.alert_date) as alert_date,
ROW_NUMBER() OVER (PARTITION BY e.alert_date ORDER BY e.loan_skey) rn
from ReverseQuest.rms.v_Alert e
 join (select max(alert_date) as alert_date,loan_skey from ReverseQuest.rms.v_Alert 
where 
(alert_type_description in('FRAUD SUSPICION',
'LITIGATION - Lawsuit Pending',
'Cease and Desist','Pending Cease and Desist')
or alert_type_description like'%Cease and Desist%')
and alert_status_description ='Active'
group by loan_skey) f on e.loan_skey=f.loan_skey and e.alert_date=f.alert_date
where 
--e.loan_skey=56 and 
(e.alert_type_description in('FRAUD SUSPICION',
'LITIGATION - Lawsuit Pending',
'Cease and Desist','Pending Cease and Desist')
or alert_type_description like'%Cease and Desist%')
and e.alert_status_description ='Active'
) t where t.rn=1
order by t.loan_skey;

--select * from #tempTbl5 where loan_skey in('200654','18349','101590','201205');
----------------------------------------------------

IF OBJECT_ID('tempdb..#tempTbl2') IS NOT NULL
    DROP TABLE #tempTbl2;
select 
w.[Report date],
w.[Loan's Key],
w.[Borrower's Name],
w.[PROPERTY STATE],
w.INVENTORY,
case when w.[Alert Raised Date]<q.alert_date then q.alert_type_description else w.[EXCLUSION REASON] end as 'EXCLUSION REASON',
w.[Loan #],
w.[Alert Status],
w.[Loan Status],
w.[Loan Sub_status],
case when w.[Alert Raised Date]<q.alert_date then q.alert_date else w.[Alert Raised Date] end as 'Alert Raised Date',
w.[Alert Raised BY],
case when w.[Alert Raised Date]<q.alert_date then DATEDIFF(DAY,q.alert_date,GETDATE())  else  w.[DAYS_SINCE_Alert raised] end as 'DAYS_SINCE_Alert raised',
w.[Last Skip Result],
w.[Last Skip Date],
w.[Last Agent Name],
w.Location
into #tempTbl2
from #tempTbl w
left join #tempTbl5 q on w.[Loan's Key]=q.loan_skey








-------------------------------------note_type_description


IF OBJECT_ID('tempdb..#tempTbl3') IS NOT NULL
    DROP TABLE #tempTbl3;
select distinct (loan_skey),note_type_description,max(convert(date,created_date)) as created_date ,created_by 
into #tempTbl3
from ReverseQuest.rms.v_Note a 
left join #tempTbl1 b on a.loan_skey=b.[Loan's Key]
where created_by <>'System Load'
 and 
note_type_description in ('Non-Voice Phone',
'Non-Workable in',
'Phone Exhaust',
'RPC Address',
'RPC Address Email',
'RPC Address Exhaust',
'RPC Email',
'RPC Email Exhaust',
'RPC Exhaust',
'RPC Phone',
'RPC Phone Address',
'RPC Phone Address Email',
'RPC Phone Email',
'RPC Phone Exhaust',
'Skip Exhausted'
)
group by loan_skey,note_type_description,created_by 
order by loan_skey

IF OBJECT_ID('tempdb..#tempTbl4') IS NOT NULL
    DROP TABLE #tempTbl4;
select * into #tempTbl4 from (
select
--ROW_NUMBER() OVER (PARTITION BY m.[Loan's Key],m.INVENTORY,m.[Alert Raised Date],m.[DAYS_SINCE_Alert raised]ORDER BY m.[Loan's Key]) num1,
m.*
,n.*
from 
#tempTbl2 m
--left outer join #tempTbl3 n on m.[Loan's Key]=n.loan_skey and convert(date,m.[Alert Raised Date])=convert(date,n.created_date)
outer apply(select top 1* from #tempTbl3 n where m.[Loan's Key]=n.loan_skey )n
)t
--where num1>1
--and convert(date,m.[Alert Raised Date])=convert(date,n.created_date)
--order by loan_skey asc;
--select * from #tempTbl4 where loan_skey=18977;

-----Skip Address
/*
select * from 
(select
p.[Report date],
p.[Loan's Key],
p.[Borrower's Name],
p.[PROPERTY STATE],
p.INVENTORY,
p.[EXCLUSION REASON],
p.[Loan #],
p.[Alert Status],
p.[Loan Status],
p.[Loan Sub_status],
p.[Alert Raised Date],
p.[Alert Raised BY],
p.[DAYS_SINCE_Alert raised],
p.note_type_description  as 'Last Skip Result',
p.created_date as 'Last Skip Date',
p.created_by as 'Last Agent Name',
p.Location,
ROW_NUMBER() OVER (PARTITION BY [Loan's Key]  ORDER BY [Loan's Key]) rn
from #tempTbl4 p
--#tempTbl2 p left join #tempTbl3 s on p.[Loan's Key]=s.loan_skey
where INVENTORY in('SKPADD') ) q
WHERE   rn = 1 
and [Loan's Key] in()
order by [Loan's Key]*/

--select * from #tempTbl4
------Skip Phone

select * from 
(select  
p.[Report date],
p.[Loan's Key],
p.[Borrower's Name],
p.[PROPERTY STATE],
p.INVENTORY,
p.[EXCLUSION REASON],
p.[Loan #],
p.[Alert Status],
p.[Loan Status],
p.[Loan Sub_status],
p.[Alert Raised Date],
p.[Alert Raised BY],
p.[DAYS_SINCE_Alert raised],
p.note_type_description  as 'Last Skip Result',
p.created_date as 'Last Skip Date',
p.created_by as 'Last Agent Name',
p.Location,
ROW_NUMBER() OVER (PARTITION BY [Loan's Key]  ORDER BY [Loan's Key]) rn
from #tempTbl4 p
--#tempTbl2 p left join #tempTbl3 s on p.[Loan's Key]=s.loan_skey
--where INVENTORY in ('SKPADD','SKPEXH','SKPTRC','SKPEML') 
) q
WHERE   rn = 1 
and [Loan's Key] in('200654',
'18349',
'101590',
'201205')
order by [Loan's Key]

/*----Other exclusion reason
select * from 
(select  
p.[Report date],
p.[Loan's Key],
p.[Borrower's Name],
p.[PROPERTY STATE],
p.INVENTORY,
p.[EXCLUSION REASON],
p.[Loan #],
p.[Alert Status],
p.[Loan Status],
p.[Loan Sub_status],
p.[Alert Raised Date],
p.[Alert Raised BY],
p.[DAYS_SINCE_Alert raised],
p.note_type_description  as 'Last Skip Result',
p.created_date as 'Last Skip Date',
p.created_by as 'Last Agent Name',
p.Location,
ROW_NUMBER() OVER (PARTITION BY [Loan's Key]  ORDER BY [Loan's Key]) rn
from #tempTbl4 p
--#tempTbl2 p left join #tempTbl3 s on p.[Loan's Key]=s.loan_skey
where [EXCLUSION REASON] in ('FRAUD SUSPICION',
'Litigation -  Proceed',
'LITIGATION - Lawsuit Pending',
'Bankruptcy Monitoring Started',
'Bankruptcy Monitoring Stopped',
'Cease and Desist',
'Pending Cease and Desist') ) q
WHERE   rn = 1 
order by [Loan's Key]
*/
