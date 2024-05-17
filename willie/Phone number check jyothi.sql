--select distinct home_phone_number,loan_skey,loan_status_description,state_code,home_phone_number,call_type,alert_type_description from (
select a.loan_skey,c.loan_status_description,a.state_code
,a.home_phone_number
,case when a.home_phone_number is not null then 'HOME'
when a.work_phone_number is not null then 'WORK'
when a.cell_phone_number is not null then 'CELL' else null end as call_type
,b.alert_type_description
from rms.v_ContactMaster a
join rms.v_LoanMaster c on a.loan_skey=c.loan_skey
left join  rms.v_Alert b on a.loan_skey=b.loan_skey
where alert_type_description in('SKPADD','SKPEML','SKPEXH','SKPTRC')
and alert_status_description ='Active'
and a.home_phone_number in('2532724777',
'5094810403',
'2532953553',
'3608308991',
'5415370204',
'3609302992',
'5099529643',
'5098339664',
'3604640611',
'3609038644',
'6179650778',
'7815287348',
'6024050812',
'2183492998',
'6038996459',
'6038996459',
'6038996459',
'6038996459',
'6038996459',
'2096786342',
'2096786342',
'9169191234')
union all
select a.loan_skey,c.loan_status_description,a.state_code
,a.cell_phone_number
,case when a.home_phone_number is not null then 'HOME'
when a.work_phone_number is not null then 'WORK'
when a.cell_phone_number is not null then 'CELL' else null end as call_type
,b.alert_type_description
from rms.v_ContactMaster a
join rms.v_LoanMaster c on a.loan_skey=c.loan_skey
left join  rms.v_Alert b on a.loan_skey=b.loan_skey
where alert_type_description in('SKPADD','SKPEML','SKPEXH','SKPTRC')
and alert_status_description ='Active'
and a.cell_phone_number in('2532724777',
'5094810403',
'2532953553',
'3608308991',
'5415370204',
'3609302992',
'5099529643',
'5098339664',
'3604640611',
'3609038644',
'6179650778',
'7815287348',
'6024050812',
'2183492998',
'6038996459',
'6038996459',
'6038996459',
'6038996459',
'6038996459',
'2096786342',
'2096786342',
'9169191234')

union all
select a.loan_skey,c.loan_status_description,a.state_code
,a.work_phone_number
,case when a.home_phone_number is not null then 'HOME'
when a.work_phone_number is not null then 'WORK'
when a.cell_phone_number is not null then 'CELL' else null end as call_type
,b.alert_type_description
from rms.v_ContactMaster a
join rms.v_LoanMaster c on a.loan_skey=c.loan_skey
left join  rms.v_Alert b on a.loan_skey=b.loan_skey
where alert_type_description in('SKPADD','SKPEML','SKPEXH','SKPTRC')
and alert_status_description ='Active'
and a.work_phone_number in('2532724777',
'5094810403',
'2532953553',
'3608308991',
'5415370204',
'3609302992',
'5099529643',
'5098339664',
'3604640611',
'3609038644',
'6179650778',
'7815287348',
'6024050812',
'2183492998',
'6038996459',
'6038996459',
'6038996459',
'6038996459',
'6038996459',
'2096786342',
'2096786342',
'9169191234')
--) a group by loan_skey,loan_status_description,state_code,home_phone_number,call_type,alert_type_description

