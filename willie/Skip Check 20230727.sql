

select b.loan_skey,a.loan_status_description,b.contact_type_description,
concat(b.first_name,concat(' ',b.last_name)) as 'Contact Person',
c.state_code,left(c.zip_code,5) as zipcode,b.home_phone_number,b.cell_phone_number,d.alert_type_description,
case when b.contact_type_description like 'Attorney' then UPPER('Borrower Represented by Attorney') else e.alert_type_description end as 'EXCLUSION REASON'
from rms.v_LoanMaster a join
rms.v_ContactMaster b on a.loan_skey=b.loan_skey and b.home_phone_number=b.cell_phone_number
join rms.v_PropertyMaster c on a.loan_skey=c.loan_skey
left join (
select * from (
select loan_skey,alert_type_description,created_date,created_by,
ROW_NUMBER() over (partition by loan_skey order by created_date desc ) sn
from rms.v_Alert where alert_type_description in('SKPADD','SKPEML','SKPEXH','SKPTRC')
and alert_status_description ='Active'
) a where sn=1
) d on a.loan_skey=d.loan_skey
left join (
select * 
from (
select e.loan_skey,e.alert_type_description,e.alert_status_description,CONVERT(date,e.alert_date) as alert_date,
ROW_NUMBER() OVER (PARTITION BY e.alert_date ORDER BY e.loan_skey) rn
from ReverseQuest.rms.v_Alert e
 join (select max(alert_date) as alert_date,loan_skey from ReverseQuest.rms.v_Alert 
where 
alert_type_description in('FRAUD SUSPICION',
'LITIGATION - Lawsuit Pending',
'Cease and Desist','Pending Cease and Desist')
and alert_status_description ='Active'
group by loan_skey) f on e.loan_skey=f.loan_skey and e.alert_date=f.alert_date
where 
--e.loan_skey=56 and 
e.alert_type_description in('FRAUD SUSPICION',
'LITIGATION - Lawsuit Pending',
'Cease and Desist','Pending Cease and Desist')
and e.alert_status_description ='Active'
) t where t.rn=1
) e on a.loan_skey=e.loan_skey
where b.home_phone_number  not in('')
and b.cell_phone_number not in('')
and b.loan_skey in('133932',
'149768',
'224619',
'224619',
'259599',
'262157',
'265570',
'272046',
'279208',
'279208',
'283038')
order by b.loan_skey;

/*
select loan_skey,state_code,zip_code from rms.v_PropertyMaster where loan_skey in('133932',
'149768',
'224619',
'224619',
'259599',
'262157',
'265570',
'272046',
'279208',
'279208',
'283038'
)
*/