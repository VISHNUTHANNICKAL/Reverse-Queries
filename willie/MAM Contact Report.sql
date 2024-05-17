 IF OBJECT_ID('tempdb..#temp1') IS NOT NULL
    DROP TABLE #temp1;
select 
a.[loan_skey],
a.[loan_status_description],
a.[servicer_name],
a.[investor_name],
a.[contact_type_description],
a.[Contact Person],
a.[cell_phone_number],
a.[home_phone_number],
a.[work_phone_number],
a.[email],
case when a.cell_phone_number in ('') and a.home_phone_number in ('')
and a.work_phone_number in ('') then 1 else 0 
end as 'Count of loans with no numbers', 
case when a.email in ('') then 1 else 0 end  as 'Count of loans with no Email',
ROW_NUMBER() over (partition by a.loan_skey order by a.loan_skey) sn
into #temp1
from(
select 
a.loan_skey,
a.loan_status_description,
a.servicer_name,
a.investor_name,
b.contact_type_description,
CONCAT(b.first_name,'',b.middle_name,'',b.last_name) 'Contact Person',
 case when b.cell_phone_number is NULL then '' else b.cell_phone_number end as cell_phone_number
,case when b.home_phone_number IS NULL then '' else b.home_phone_number end as home_phone_number
,case when b.work_phone_number is NULL then '' else b.work_phone_number end as work_phone_number
,case when b.email IS NULL then '' else  b.email end as email/*,
case when coalesce(b.cell_phone_number,NULL) is null and coalesce(b.home_phone_number,NULL) is null and 
coalesce(b.work_phone_number,NULL) is null then 1 else 0 end 'Count of loans with no numbers'
,case when coalesce(b.email,NULL) is null then 1 else 0 end 'Count of loans with no Email'*/
from rms.v_LoanMaster a
left join rms.v_ContactMaster b on a.loan_skey=b.loan_skey 
where 
 a.loan_status_description not in('DELETED','INACTIVE')
--a.loan_status_description  in('DEFAULT','FORECLOSURE')
and
a.investor_name in('Bank of America',
'Black Reef Trust',
'Cascade Funding Alternative Holdings, LLC',
'Cascade Funding Mortgage Trust - AB1',
'Cascade Funding Mortgage Trust - AB2',
'Cascade Funding Mortgage Trust - HB10',
'Cascade Funding Mortgage Trust - HB11',
'Cascade Funding Mortgage Trust - HB4',
'Cascade Funding Mortgage Trust - HB7',
'Cascade Funding Mortgage Trust - HB8',
'Cascade Funding Mortgage Trust - HB9',
'Cascade Funding Mortgage Trust 2018-RM2',
'Cascade Funding Mortgage Trust 2019 - RM3',
'Cascade Funding RM1 Acquisitions Grantor Tr',
'Cascade Funding RM1 Alternative Holdings, LLC',
'Cascade Funding RM4 Acquisitions Grantor Tr',
'Everbank 2008 AKA TIAA',
'Everbank 2015 AKA TIAA',
'Guggenheim Life and Annuity Company (GLAC)',
'HB0 Alternative Holdings, LLC',
'HB1 Alternative Holdings, LLC',
'HB2 Alternative Holdings, LLC',
'Ivory Cove Trust',
'MECA 2007-FF1',
'MECA 2007-FF2',
'MECA 2007-FF3',
'MECA Trust 2010-1',
'Mortgage Equity Conversion Asset Trust 2010-1',
'Mr Cooper HUD Reconveyance',
'NARRE Titling Trust',
'RBS Financial Products fka Greenwich',
'Reverse Mortgage Solutions, Inc.',
'Reverse Mortgage Solutions, Inc. 2018-09',
'Riverview HECM Trust 2007-1',
'SASCO 1999-RM1',
'SHAP Acquisition Trust HB0',
'SHAP Acquisitions Trust HB1 Barclays',
'SHAP Acquisitions Trust HB2 Nomura',
'VF1-NA Trust',
'WF BOA Repurchase',
'Wilmington Savings Fund Society FSB',
'SMS Financial NCU',
'Reverse Mortgage Loan Trust Series REV 2007-2') 
)a 

 IF OBJECT_ID('tempdb..#temp2') IS NOT NULL
    DROP TABLE #temp2;
 select loan_skey,min ([Count of loans with no numbers]) 'No Number' 
 , min ([Count of loans with no Email] ) 'No Email'
 into #temp2 
from #temp1 
group by loan_skey
order by loan_skey
 
 select 
loan_skey, 
case when [No Email]=1 and [No Number]=1 then 'No Number / No Email'
when [No Number]=1 then 'No Number'
when [No Email]=1 then 'No Email'
else NULL end as 'Status'
from #temp2
order by loan_skey
;

  IF OBJECT_ID('tempdb..#temp3') IS NOT NULL
    DROP TABLE #temp3;
select 
a.loan_skey,
a.loan_status_description,
a.servicer_name,
a.investor_name,
a.contact_type_description,
a.[Contact Person],
a.cell_phone_number,
a.home_phone_number,
a.work_phone_number,
a.email,
b.[No Number] [Count of loans with no numbers],
b.[No Email] [Count of loans with no Email]
into  #temp3
from #temp1 a  
left join #temp2 b on a.loan_skey=b.loan_skey
order by a.loan_skey;


select * from #temp3
order by loan_skey
;



