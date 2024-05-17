IF OBJECT_ID('tempdb..#tempTbl') IS NOT NULL
    DROP TABLE #tempTbl;
select a.loan_skey,a.loan_status_description,c.state_code,
d.alert_type_description,a.loan_status_description 'EXCLUSION REASON'
,b.contact_type_description
,concat(b.first_name,concat(' ',b.last_name)) as 'Contact Person'
,b.home_phone_number,b.cell_phone_number
into #tempTbl
from rms.v_LoanMaster a join
rms.v_ContactMaster b on a.loan_skey=b.loan_skey and b.home_phone_number=b.cell_phone_number
left join rms.v_PropertyMaster c on a.loan_skey= c.loan_skey
left join (
select loan_skey,alert_type_description,alert_status_description
,convert(date,created_date) 'Task Raised date',created_by 'Task Raised by'
,convert(date,modified_date) 'Task Closed date',modified_by 'Task closed by'
from rms.v_Alert
where alert_type_description in ('SKPTRC','SKPEXH')
and alert_status_description='Active'
) d on a.loan_skey=d.loan_skey
where b.home_phone_number  not in('')
and b.cell_phone_number not in('')
order by b.loan_skey;


update #tempTbl set [EXCLUSION REASON]='Borrower Represented by Attorney'
where loan_skey in (select  loan_skey from 
rms.v_ContactMaster
where contact_type_description='Attorney'
);

update #tempTbl set [EXCLUSION REASON]=''
where [EXCLUSION REASON] in('ACTIVE','DEFAULT','FORECLOSURE','CLAIM');


IF OBJECT_ID('tempdb..#tempTbl5') IS NOT NULL
    DROP TABLE #tempTbl5;
select * 
into #tempTbl5
from (
select e.loan_skey,e.alert_type_description,e.alert_status_description,CONVERT(date,e.alert_date) as alert_date,
ROW_NUMBER() OVER (PARTITION BY e.alert_date,e.loan_skey ORDER BY e.loan_skey) rn
from ReverseQuest.rms.v_Alert e
 join (select max(alert_date) as alert_date,alert_type_description,loan_skey from ReverseQuest.rms.v_Alert 
where 
alert_type_description in('FRAUD SUSPICION',
'LITIGATION - Lawsuit Pending',
'Cease and Desist','Pending Cease and Desist','Borrower Represented by Attorney')
and alert_status_description ='Active'
--and loan_skey='266744'
group by loan_skey,alert_type_description) f on e.loan_skey=f.loan_skey and e.alert_date=f.alert_date
where 
--e.loan_skey='266744' and 
e.alert_type_description in('FRAUD SUSPICION',
'LITIGATION - Lawsuit Pending',
'Cease and Desist','Pending Cease and Desist','Borrower Represented by Attorney')
and e.alert_status_description ='Active'
--order by e.loan_skey
) t where t.rn=1
order by t.loan_skey;




--select * from #tempTbl5



select 
a.loan_skey,a.loan_status_description,a.state_code 'property_state_code',
a.alert_type_description,
case when b.alert_status_description IN ('FRAUD SUSPICION',
'LITIGATION - Lawsuit Pending',
'Cease and Desist','Pending Cease and Desist','Borrower Represented by Attorney')
then b.alert_type_description
else
a.[EXCLUSION REASON] end as [EXCLUSION REASON]
,a.contact_type_description,a.[Contact Person]
,a.home_phone_number,a.cell_phone_number
from #tempTbl a
left join #tempTbl5 b on a.loan_skey=b.loan_skey
/*where
a.loan_skey in (select  loan_skey from 
rms.v_ContactMaster
where contact_type_description='Attorney'
)*/
order by a.loan_skey
;

--select * from rms.v_ContactMaster where loan_skey='2745'
