/*select 
a.loan_skey,
b.loan_status_description,
b.loan_sub_status_description,
a.note_type_description,
convert(date,a.created_date) created_date,
a.created_by
from rms.v_Note a
join rms.v_LoanMaster b on a.loan_skey=b.loan_skey
where note_type_description in (
'Refi Opportunity','Trans to Liberty','Refi - Interested','Refi - Not Interested'
)
order by a.created_date;
*/

--select distinct note_type_description from rms.v_Note order by note_type_description
/*
IF OBJECT_ID('tempdb..#Temp1') IS NOT NULL
    DROP TABLE #Temp1;
select 
loan_skey,upper(replace(Agent_name,', ',',')) Agent_name1,
--replace(LEFT(upper(replace(Agent_name,', ',',')), CHARINDEX(',', upper(replace(Agent_name,', ',',')))),',','') last_name,
--REPLACE(SUBSTRING(upper(replace(Agent_name,', ',',')), CHARINDEX(',', upper(replace(Agent_name,', ',','))), LEN(upper(replace(Agent_name,', ',',')))), ',', '') first_name,
CONCAT(REPLACE(SUBSTRING(upper(replace(Agent_name,', ',',')), CHARINDEX(',', upper(replace(Agent_name,', ',','))), LEN(upper(replace(Agent_name,', ',',')))), ',', ''),' ', replace(LEFT(upper(replace(Agent_name,', ',',')), CHARINDEX(',', upper(replace(Agent_name,', ',',')))),',','')) Agent_name
,[RPC Note category],[RPC Note],[RPC NoteText],[RPC Created by],[RPC created_date]
into #Temp1
from (
select a.loan_skey,
case when substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30) like '%(%' then 
reverse(substring(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30) 
), CHARINDEX('(', reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))+1, len(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))))
when substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30) like '%_%' then
reverse(substring(reverse (

reverse(substring(reverse (
reverse(substring(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30) 
), CHARINDEX('_', reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))+1, len(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))))
), CHARINDEX('_', reverse (
reverse(substring(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30) 
), CHARINDEX('_', reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))+1, len(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))))
))+1, len(reverse (
reverse(substring(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30) 
), CHARINDEX('_', reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))+1, len(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))))
))))
), CHARINDEX('_', reverse (
reverse(substring(reverse (
reverse(substring(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30) 
), CHARINDEX('_', reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))+1, len(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))))
), CHARINDEX('_', reverse (
reverse(substring(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30) 
), CHARINDEX('_', reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))+1, len(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))))
))+1, len(reverse (
reverse(substring(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30) 
), CHARINDEX('_', reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))+1, len(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))))
))))
))+1, len(reverse (
reverse(substring(reverse (
reverse(substring(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30) 
), CHARINDEX('_', reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))+1, len(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))))
), CHARINDEX('_', reverse (
reverse(substring(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30) 
), CHARINDEX('_', reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))+1, len(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))))
))+1, len(reverse (
reverse(substring(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30) 
), CHARINDEX('_', reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))+1, len(reverse (substring(a.note_text,CHARINDEX('Contact_RPC_', a.note_text)+22,30)
))))
))))
))))
else 
''
end 
as Agent_name
--,substring(note_text,CHARINDEX('Contact_RPC_', note_text)+22,30) as notetext_date
,a.note_type_category_description 'RPC Note category'
,a.note_type_description 'RPC Note',a.note_text 'RPC NoteText',a.created_by 'RPC Created by',convert(date,a.created_date) 'RPC created_date'
/*,b.note_type_category_description 'Loss Note category',
b.note_type_description 'Loss Note type',
b.note_text 'Loss Note text',
b.created_by 'Loss Created by',
b.created_date 'Loss Created Date'*/
from rms.v_Note a
/*join (
select loan_skey,note_type_category_description,
note_type_description,note_text,upper(created_by) created_by,convert(date,created_date) created_date from rms.v_Note
where note_type_description in ('Loss Mit Referral – DIL','Loss Mit Referral – SS','Loss Mit Referral–At-Risk Ext.'
,'Loss Mit Referral–Mktg. Ext.','Promise Occupancy ','Promise Payoff ','Promise Reinstatement Funds',
'Promise Tax & Ins Doc')
and created_date >= convert(date,'2024-03-18')
) b on a.loan_skey=b.loan_skey and convert(date,a.created_date)=b.created_date*/
where a.note_type_description='Contact - RPC'
and a.created_by ='System Load'
--and a.created_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
and a.created_date>=convert(date,'2024-03-18')
--and a.created_date <  DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
/*and loan_skey in(select loan_skey
--,note_type_description,note_text,created_by,convert(date,created_date) created_date 
from rms.v_Note
where note_type_description in ('Loss Mit Referral – DIL','Loss Mit Referral – SS','Loss Mit Referral–At-Risk Ext.'
,'Loss Mit Referral–Mktg. Ext.','Promise Occupancy ','Promise Payoff ','Promise Reinstatement Funds',
'Promise Tax & Ins Doc')
and created_date >= convert(date,'2024-03-18') -- to fetch one day prior data
and created_date <=DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
--order by loan_skey,note_type_description;
)*/
) b
/*where loan_skey in (
select loan_skey from rms.v_LoanMaster
where investor_name in ('Bank of America',
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
)*/
order by b.loan_skey;


--select * from #Temp1;

IF OBJECT_ID('tempdb..#Temp2') IS NOT NULL
    DROP TABLE #Temp2;	
select loan_skey,note_type_description,
case
when ( SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,3)like 'a3p'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,3)like 'A3p'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,3)like 'A3P'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,3)like 'HOA'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,3)like 'hoa'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,3)like 'POA'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,3)like 'poa'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,3)like 'ATP'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,3)like 'atp'
)
then SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,3)

when ( SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,4)like 'UA3p')
then SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,4)

when ( SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,5)like 'Other')
then SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,5)

when ( SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,6)like 'Broker')
then SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,6)

when ( SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,7)like 'Trustee'
OR  SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,7)like 'trustee'
)then SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,7)


when (SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,8) like 'Borrower'
or SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,8) like 'borrower'
or SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,8) like 'executor'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,8) like 'Executor'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,8) like 'attorney'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,8) like 'Attorney'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,8) like 'Guardian'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,8) like 'guardian'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,8) like 'Neighbor'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,8) like 'neighbor'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,8) like 'Relative'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,8) like 'relative'
)
then SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,8)

when ( SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,10)like 'Contractor'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,10)like 'contractor')
then SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,10)

when ( SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,11)like 'Co-Borrower'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,11)like 'co-borrower'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,11)like 'co borrower'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,11)like 'Conservator'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,11)like 'conservator'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,11)like 'Legal Owner'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,11)like 'legal owner'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,11)like 'Legal owner'
)
then SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,11)

when ( SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,12)like 'skip tracing'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,12)like 'Skip tracing'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,12)like 'Skip Tracing'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,12)like 'co- borrower'
)
then SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,12)

when ( SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,13)like 'Title Company'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,13)like 'title company'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,13)like 'Title company' )
then SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,13)

when ( SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,14)like 'Debt Counselor'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,14)like 'debt counselor' )
then SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,14)


when ( SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,16)like 'authorized party'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,16)like 'Authorized party' 
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,16)like 'Payoff Requester' 
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,16)like 'payoff requester' 
) then SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,16)

when (SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,17) like 'power of attorney'
or SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,17) like 'Power of attorney'
or SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,17) like 'Power of Attorney'
Or SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,17) like 'alternate contact'
Or SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,17) like 'Alternate contact'
Or SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,17) like 'counseling agency'
Or SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,17) like 'Counseling Agency'
) then SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,17)

when (SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,18) like 'Bankruptcy Trustee'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,18) like 'bankruptcy trustee'
or SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,18) like 'Legally Authorized'
or SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,18) like 'legally authorized'
)
then SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,18)



when (SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,19) like 'Authorized Designee'
or SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,19) like 'authorized designee')
then SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,19)


when (SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,29) like 'Entitled Non-Borrowing Spouse'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,29) like 'entitled non-borrowing Spouse' ) 
then SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,29)

when (SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,20) like 'non-borrowing spouse'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,20) like 'Non-Borrowing Spouse' ) 
then SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,20)

when (SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,22) like 'Non legally authorized'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,22) like 'Non Legally Authorized'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,22) like 'Authorized Third Party'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,22) like 'authorized third party'
) 
then SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,22)

when (SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,26) like 'Non Authorized Third Party'
or SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,26) like 'non-authorized third party' )
then SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,26)

when SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,30) like 'legally authorized third party'
then SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,30)



when (SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,31) like 'Ineligible Non-Borrowing Spouse'
or SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,31) like 'ineligible non-borrowing spouse' )
then SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,31)


when (SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,34) like 'non-legally authorized third party'
OR SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,34) like 'Non Legally Authorized Third Party' )
then SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,34)


--spoke to

when ( SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,3)like 'a3p'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,3)like 'A3p'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,3)like 'A3P'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,3)like 'HOA'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,3)like 'hoa'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,3)like 'POA'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,3)like 'poa'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,3)like 'ATP'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,3)like 'atp'
)
then SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,3)

when ( SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,4)like 'UA3p')
then SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,4)


when ( SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,5)like 'Other')
then SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,5)

when ( SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,6)like 'Broker')
then SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,6)

when ( SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,7)like 'Trustee'
OR  SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,7)like 'trustee'
)then SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,7)


when (SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,8) like 'Borrower'
or SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,8) like 'borrower'
or SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,8) like 'executor'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,8) like 'Executor'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,8) like 'attorney'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,8) like 'Attorney'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,8) like 'Guardian'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,8) like 'guardian'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,8) like 'Neighbor'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,8) like 'neighbor'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,8) like 'Relative'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,8) like 'relative'
)
then SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,8)

when ( SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,10)like 'Contractor'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,10)like 'contractor')
then SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,10)

when ( SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,11)like 'Co-Borrower'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,11)like 'co-borrower'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,11)like 'co borrower'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,11)like 'Conservator'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,11)like 'conservator'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,11)like 'Legal Owner'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,11)like 'legal owner'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,11)like 'Legal owner'
)
then SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,11)

when ( SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,12)like 'skip tracing'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,12)like 'Skip tracing'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,12)like 'Skip Tracing' )
then SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,12)

when ( SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,13)like 'Title Company'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,13)like 'title company'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,13)like 'Title company' )
then SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,13)

when ( SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,14)like 'Debt Counselor'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,14)like 'debt counselor' )
then SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,14)


when ( SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,16)like 'authorized party'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,16)like 'Authorized party' 
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,16)like 'Payoff Requester' 
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,16)like 'payoff requester' 
) then SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,16)

when (SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,17) like 'power of attorney'
or SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,17) like 'Power of attorney'
or SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,17) like 'Power of Attorney'
Or SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,17) like 'alternate contact'
Or SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,17) like 'Alternate contact'
Or SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,17) like 'counseling agency'
Or SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,17) like 'Counseling Agency'
) then SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,17)

when (SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,18) like 'Bankruptcy Trustee'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,18) like 'bankruptcy trustee'
or SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,18) like 'Legally Authorized'
or SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,18) like 'legally authorized'
)
then SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,18)



when (SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,19) like 'Authorized Designee'
or SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,19) like 'authorized designee')
then SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,19)


when (SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,29) like 'Entitled Non-Borrowing Spouse'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,29) like 'entitled non-borrowing Spouse' ) 
then SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,29)

when (SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,20) like 'non-borrowing spouse'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,20) like 'Non-Borrowing Spouse' ) 
then SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,20)

when (SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,22) like 'Non legally authorized'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,22) like 'Non Legally Authorized'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,22) like 'Authorized Third Party'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,22) like 'authorized third party') 
then SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,22)

when (SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,26) like 'Non Authorized Third Party'
or SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,26) like 'non-authorized third party' )
then SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,26)

when SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,30) like 'legally authorized third party'
then SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,30)



when (SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,31) like 'Ineligible Non-Borrowing Spouse'
or SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,31) like 'ineligible non-borrowing spouse' )
then SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,31)


when (SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,34) like 'non-legally authorized third party'
OR SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,34) like 'Non Legally Authorized Third Party' )
then SUBSTRING(note_text,CHARINDEX('Verification: Spoke to ',note_text)+23,34)


else ''
--SUBSTRING(note_text,CHARINDEX('Verification:',note_text)+14,40)
end as 'Contact Type',note_text,
case when ( note_type_description like '%Outgoing%' 
  or note_type_description like 'Spoc Outgoing%') then 'Outbound'
when ( note_type_description like 'Spoc Incom%'
  or  note_type_description like 'Incom%') then 'Inbound'
end as 'Call Type',
created_by ibob_created_by,convert(date,created_date) ibob_created_date
into #Temp2
from rms.v_Note
where 
( note_type_description like '%Outgoing%' 
  or note_type_description like 'Spoc Outgoing%'
  or    note_type_description like 'Spoc Incom%'
  or  note_type_description like 'Incom%'
)
 and note_type_description  not like 'Kana Outgoing Email Sent'
 and created_date>= CONVERT(date,'2024-02-01')
--and created_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
--and created_date <  DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
and created_by not in ('System Load');
--and loan_skey in ('204964')

--select * from #Temp1;
--select * from #Temp2;

IF OBJECT_ID('tempdb..#Temp3') IS NOT NULL
    DROP TABLE #Temp3;
select 
a.loan_skey,
a.loan_status_description,
a.loan_sub_status_description,
a.servicer_name,
a.investor_name,
b.[Refi Opportunity Note Type],
b.[Refi Opportunity created_date],
c.[Refi - Not Interested created_date],
c.[Refi - Not Interested created_by],
d.[Refi - Interested created_date],
d.[Refi - Interested created_by],
e.[Trans to Liberty created_date],
e.[Trans to Liberty created_by],
f.[Refi Update created_date],
f.[Refi Update created_by]
into #Temp3
from rms.v_LoanMaster a
 join (
select * from (
select loan_skey,note_type_category_description,note_type_description 'Refi Opportunity Note Type',
CONVERT(date,created_date) 'Refi Opportunity created_date',created_by 'Refi Opportunity created_by',
ROW_NUMBER() over (PARTITION by loan_skey order by CONVERT(date,created_date) desc,loan_skey ) sn 
from rms.v_Note
where note_type_description='Refi Opportunity'
--order by loan_skey
) a where sn=1
) b on a.loan_skey=b.loan_skey 
left join (
select * from (
select loan_skey,note_type_category_description,note_type_description,
CONVERT(date,created_date) 'Refi - Not Interested created_date',created_by 'Refi - Not Interested created_by',
ROW_NUMBER() over (PARTITION by loan_skey order by CONVERT(date,created_date) desc,loan_skey ) sn 
from rms.v_Note
where note_type_description='Refi - Not Interested'
--order by loan_skey
) a where sn=1
) c on a.loan_skey=c.loan_skey
left join (
select * from (
select loan_skey,note_type_category_description,note_type_description,
CONVERT(date,created_date) 'Refi - Interested created_date',created_by 'Refi - Interested created_by',
ROW_NUMBER() over (PARTITION by loan_skey order by CONVERT(date,created_date) desc,loan_skey ) sn 
from rms.v_Note
where note_type_description='Refi - Interested'
--and loan_skey=2598
--order by loan_skey
) a where sn=1
) d on a.loan_skey=d.loan_skey
left join (
select * from (
select loan_skey,note_type_category_description,note_type_description,
CONVERT(date,created_date) 'Trans to Liberty created_date',created_by 'Trans to Liberty created_by',
ROW_NUMBER() over (PARTITION by loan_skey order by CONVERT(date,created_date) desc,loan_skey ) sn 
from rms.v_Note
where note_type_description='Trans to Liberty'
--and loan_skey=2598
--order by loan_skey
) a where sn=1
) e on a.loan_skey=e.loan_skey
left join (
select * from (
select loan_skey,note_type_category_description,note_type_description,
CONVERT(date,created_date) 'Refi Update created_date',created_by 'Refi Update created_by',
ROW_NUMBER() over (PARTITION by loan_skey order by CONVERT(date,created_date) desc,loan_skey ) sn 
from rms.v_Note
where note_type_description='Refi Update'
--and loan_skey=2598
--order by loan_skey
) a where sn=1
) f on a.loan_skey=f.loan_skey

--select * from #Temp1;
--select * from #Temp2;
--select * from #Temp3;

IF OBJECT_ID('tempdb..#Temp4') IS NOT NULL
    DROP TABLE #Temp4;
select 
a.[loan_skey],
a.[loan_status_description],
a.[loan_sub_status_description],
a.[servicer_name],
a.[investor_name],
a.[Refi Opportunity Note Type],
a.[Refi Opportunity created_date],
b.note_type_description,
b.ibob_created_date ibob_created_date,
b.[Call Type],
b.[Contact Type],
c.[RPC Note],
c.[RPC created_date],
a.[Refi - Not Interested created_date],
a.[Refi - Not Interested created_by],
a.[Refi - Interested created_date],
a.[Refi - Interested created_by],
a.[Trans to Liberty created_date],
a.[Trans to Liberty created_by],
a.[Refi Update created_date],
a.[Refi Update created_by]
into  #Temp4
from #Temp3 a
 join #Temp2 b on a.loan_skey=b.loan_skey
and convert(date,a.[Refi Opportunity created_date]) < CONVERT(date,b.ibob_created_date)
left join #Temp1 c on a.loan_skey=c.loan_skey
and convert(date,a.[Refi Opportunity created_date]) < CONVERT(date,c.[RPC created_date])
order by a.[Refi Opportunity created_date]
;


/*
update a  set a.note_type_description='',a.ibob_created_date=''
,a.[Call Type]='' from #Temp4 a 
join #Temp4 b on (a.loan_skey=b.loan_skey and a.[Refi Opportunity created_date]>b.ibob_created_date);





select 
a.[loan_skey],
a.[loan_status_description],
a.[loan_sub_status_description],
a.[servicer_name],
a.[investor_name],
a.[Refi Opportunity Note Type],
a.[Refi Opportunity created_date],
a.[note_type_description],
a.[ibob_created_date],
a.[Call Type],
a.[Contact Type],
'Contact - RPC' [RPC Note],
a.[RPC created_date],
a.[Refi - Not Interested created_date],
a.[Refi - Not Interested created_by],
a.[Refi - Interested created_date],
a.[Refi - Interested created_by],
a.[Trans to Liberty created_date],
a.[Trans to Liberty created_by],
a.[Refi Update created_date],
a.[Refi Update created_by]
from #Temp4 a
where
a.[Refi - Not Interested created_date] is not null or
a.[Refi - Interested created_date] is not null or 
a.[Trans to Liberty created_date] is not null or
a.[Refi Update created_date] is not null
order by a.[Refi Opportunity created_date]*/

/*
select 
a.[loan_skey],
a.[loan_status_description],
a.[loan_sub_status_description],
a.[servicer_name],
a.[investor_name],
a.[Refi Opportunity Note Type],
a.[Refi Opportunity created_date],
b.note_type_description,
b.ibob_created_date ibob_created_date,
b.[Call Type],
b.[Contact Type],
c.[RPC Note],
c.[RPC created_date],
a.[Refi - Not Interested created_date],
a.[Refi - Not Interested created_by],
a.[Refi - Interested created_date],
a.[Refi - Interested created_by],
a.[Trans to Liberty created_date],
a.[Trans to Liberty created_by],
a.[Refi Update created_date],
a.[Refi Update created_by]
from (
select a.loan_skey,b.loan_status_description
,b.loan_sub_status_description,b.servicer_name,b.investor_name
,a.note_type_category_description,a.note_type_description 'Refi Opportunity Note Type',
CONVERT(date,a.created_date) 'Refi Opportunity created_date',a.created_by 'Refi Opportunity created_by',
ROW_NUMBER() over (PARTITION by a.loan_skey order by CONVERT(date,a.created_date) desc,a.loan_skey ) sn 
from rms.v_Note a
left join rms.v_LoanMaster b on a.loan_skey=b.loan_skey
where a.note_type_description='Refi Opportunity') a
 join #Temp2 b on a.loan_skey=b.loan_skey
and convert(date,a.[Refi Opportunity created_date]) < CONVERT(date,b.ibob_created_date)
left join #Temp1 c on a.loan_skey=c.loan_skey
and convert(date,a.[Refi Opportunity created_date]) < CONVERT(date,c.[RPC created_date])
order by a.[Refi Opportunity created_date]
;
*/
*/


-----------------------OLD Logic -------------------------------------

IF OBJECT_ID('tempdb..#Temp4') IS NOT NULL
    DROP TABLE #Temp4;
select * 
into #Temp4
from (
select
a.[loan_skey],
a.[loan_status_description],
a.[loan_sub_status_description],
a.[servicer_name],
a.[investor_name],
a.[Contact-RPC note type],
a.[Contact-RPC created_date],
a.[Refi Opportunity Note Type],
a.[Refi Opportunity created_date],
a.[Refi - Not Interested created_date],
a.[Refi - Not Interested created_by],
a.[Refi - Interested created_date],
a.[Refi - Interested created_by],
a.[Trans to Liberty created_date],
a.[Trans to Liberty created_by],
f.[Refi Update created_date],
f.[Refi Update created_by]
from(
select 
a.loan_skey,
a.loan_status_description,
a.loan_sub_status_description,
a.servicer_name,
a.investor_name,
case when c.[Refi - Not Interested created_date] is not null or
d.[Refi - Interested created_date] is not null or
e.[Trans to Liberty created_date] is not null 
--or f.[Refi Update created_date] is not null
then 'Contact - RPC' else 
g.[Contact-RPC note type] end as [Contact-RPC note type],
case when g.[Contact-RPC created_date] is not null then g.[Contact-RPC created_date] else 
coalesce(c.[Refi - Not Interested created_date],coalesce(d.[Refi - Interested created_date],e.[Trans to Liberty created_date]))
end as [Contact-RPC created_date],
b.[Refi Opportunity Note Type],
b.[Refi Opportunity created_date],
c.[Refi - Not Interested created_date],
c.[Refi - Not Interested created_by],
d.[Refi - Interested created_date],
d.[Refi - Interested created_by],
e.[Trans to Liberty created_date],
e.[Trans to Liberty created_by]
--f.[Refi Update created_date],
--f.[Refi Update created_by]
from rms.v_LoanMaster a
 join (
select * from (
select loan_skey,note_type_category_description,note_type_description 'Refi Opportunity Note Type',
CONVERT(date,created_date) 'Refi Opportunity created_date',created_by 'Refi Opportunity created_by',
ROW_NUMBER() over (PARTITION by loan_skey order by CONVERT(date,created_date) desc,loan_skey ) sn 
from rms.v_Note
where note_type_description='Refi Opportunity'
--and created_by not in ('System Load')
--order by loan_skey
) a where sn=1
) b on a.loan_skey=b.loan_skey
left join (
select * from (
select loan_skey,note_type_category_description,note_type_description,
CONVERT(date,created_date) 'Refi - Not Interested created_date',created_by 'Refi - Not Interested created_by',
ROW_NUMBER() over (PARTITION by loan_skey order by CONVERT(date,created_date) desc,loan_skey ) sn 
from rms.v_Note
where note_type_description='Refi - Not Interested'
and created_by not in ('System Load')
--order by loan_skey
) a where sn=1
) c on a.loan_skey=c.loan_skey
left join (
select * from (
select loan_skey,note_type_category_description,note_type_description,
CONVERT(date,created_date) 'Refi - Interested created_date',created_by 'Refi - Interested created_by',
ROW_NUMBER() over (PARTITION by loan_skey order by CONVERT(date,created_date) desc,loan_skey ) sn 
from rms.v_Note
where note_type_description='Refi - Interested'
and created_by not in ('System Load')
--and loan_skey=2598
--order by loan_skey
) a where sn=1
) d on a.loan_skey=d.loan_skey
left join (
select * from (
select loan_skey,note_type_category_description,note_type_description,
CONVERT(date,created_date) 'Trans to Liberty created_date',created_by 'Trans to Liberty created_by',
ROW_NUMBER() over (PARTITION by loan_skey order by CONVERT(date,created_date) desc,loan_skey ) sn 
from rms.v_Note
where note_type_description='Trans to Liberty'
and created_by not in ('System Load')
--and loan_skey=2598
--order by loan_skey
) a where sn=1
) e on a.loan_skey=e.loan_skey
left join (
select * from (
select loan_skey,note_type_category_description,note_type_description 'Contact-RPC note type',
CONVERT(date,created_date) 'Contact-RPC created_date',created_by 'Contact-RPC created_by',
ROW_NUMBER() over (PARTITION by loan_skey order by CONVERT(date,created_date) desc,loan_skey ) sn 
from rms.v_Note
where note_type_description='Contact - RPC'
--and loan_skey=2598
--order by loan_skey
) a where sn=1
)g on b.loan_skey=g.loan_skey and convert(date,b.[Refi Opportunity created_date]) <CONVERT(date,g.[Contact-RPC created_date])
) a
left join (
select * from (
select loan_skey,note_type_category_description,note_type_description,
CONVERT(date,created_date) 'Refi Update created_date',created_by 'Refi Update created_by',
ROW_NUMBER() over (PARTITION by loan_skey order by CONVERT(date,created_date) desc,loan_skey ) sn 
from rms.v_Note
where note_type_description='Refi Update'
--and created_by not in ('System Load')
--and loan_skey=2598
--order by loan_skey
) a where sn=1
) f on a.loan_skey=f.loan_skey and  f.[Refi Update created_date] > convert(date,a.[Refi Opportunity created_date])
--where convert(date,a.[Refi Opportunity created_date]) <=CONVERT(date,a.[Contact-RPC created_date])
/*
union 

select
a.[loan_skey],
a.[loan_status_description],
a.[loan_sub_status_description],
a.[servicer_name],
a.[investor_name],
a.[Contact-RPC note type],
a.[Contact-RPC created_date],
a.[Refi Opportunity Note Type],
a.[Refi Opportunity created_date],
a.[Refi - Not Interested created_date],
a.[Refi - Not Interested created_by],
a.[Refi - Interested created_date],
a.[Refi - Interested created_by],
a.[Trans to Liberty created_date],
a.[Trans to Liberty created_by],
f.[Refi Update created_date],
f.[Refi Update created_by]
from(
select 
a.loan_skey,
a.loan_status_description,
a.loan_sub_status_description,
a.servicer_name,
a.investor_name,
case when c.[Refi - Not Interested created_date] is not null or
d.[Refi - Interested created_date] is not null or
e.[Trans to Liberty created_date] is not null 
--or f.[Refi Update created_date] is not null
then 'Contact - RPC' else 
g.[Contact-RPC note type] end as [Contact-RPC note type],
case when g.[Contact-RPC created_date] is not null then g.[Contact-RPC created_date] else 
coalesce(c.[Refi - Not Interested created_date],coalesce(d.[Refi - Interested created_date],e.[Trans to Liberty created_date]))
end as [Contact-RPC created_date],
b.[Refi Opportunity Note Type],
b.[Refi Opportunity created_date],
c.[Refi - Not Interested created_date],
c.[Refi - Not Interested created_by],
d.[Refi - Interested created_date],
d.[Refi - Interested created_by],
e.[Trans to Liberty created_date],
e.[Trans to Liberty created_by]
--f.[Refi Update created_date],
--f.[Refi Update created_by]
from rms.v_LoanMaster a
 join (
select * from (
select loan_skey,note_type_category_description,note_type_description 'Refi Opportunity Note Type',
CONVERT(date,created_date) 'Refi Opportunity created_date',created_by 'Refi Opportunity created_by',
ROW_NUMBER() over (PARTITION by loan_skey order by CONVERT(date,created_date) desc,loan_skey ) sn 
from rms.v_Note
where note_type_description='Refi Opportunity'
--and created_by not in ('System Load')
--order by loan_skey
) a where sn=1
) b on a.loan_skey=b.loan_skey
left join (
select * from (
select loan_skey,note_type_category_description,note_type_description,
CONVERT(date,created_date) 'Refi - Not Interested created_date',created_by 'Refi - Not Interested created_by',
ROW_NUMBER() over (PARTITION by loan_skey order by CONVERT(date,created_date) desc,loan_skey ) sn 
from rms.v_Note
where note_type_description='Refi - Not Interested'
and created_by not in ('System Load')
--order by loan_skey
) a where sn=1
) c on a.loan_skey=c.loan_skey
left join (
select * from (
select loan_skey,note_type_category_description,note_type_description,
CONVERT(date,created_date) 'Refi - Interested created_date',created_by 'Refi - Interested created_by',
ROW_NUMBER() over (PARTITION by loan_skey order by CONVERT(date,created_date) desc,loan_skey ) sn 
from rms.v_Note
where note_type_description='Refi - Interested'
and created_by not in ('System Load')
--and loan_skey=2598
--order by loan_skey
) a where sn=1
) d on a.loan_skey=d.loan_skey
left join (
select * from (
select loan_skey,note_type_category_description,note_type_description,
CONVERT(date,created_date) 'Trans to Liberty created_date',created_by 'Trans to Liberty created_by',
ROW_NUMBER() over (PARTITION by loan_skey order by CONVERT(date,created_date) desc,loan_skey ) sn 
from rms.v_Note
where note_type_description='Trans to Liberty'
and created_by not in ('System Load')
--and loan_skey=2598
--order by loan_skey
) a where sn=1
) e on a.loan_skey=e.loan_skey
left join (
select * from (
select loan_skey,note_type_category_description,note_type_description 'Contact-RPC note type',
CONVERT(date,created_date) 'Contact-RPC created_date',created_by 'Contact-RPC created_by',
ROW_NUMBER() over (PARTITION by loan_skey order by CONVERT(date,created_date) desc,loan_skey ) sn 
from rms.v_Note
where note_type_description='Contact - RPC'
--and loan_skey=2598
--order by loan_skey
) a where sn=1
)g on b.loan_skey=g.loan_skey and convert(date,b.[Refi Opportunity created_date]) <CONVERT(date,g.[Contact-RPC created_date])
) a
left join (
select * from (
select loan_skey,note_type_category_description,note_type_description,
CONVERT(date,created_date) 'Refi Update created_date',created_by 'Refi Update created_by',
ROW_NUMBER() over (PARTITION by loan_skey order by CONVERT(date,created_date) desc,loan_skey ) sn 
from rms.v_Note
where note_type_description='Refi Update'
--and created_by not in ('System Load')
--and loan_skey=2598
--order by loan_skey
) a where sn=1
) f on a.loan_skey=f.loan_skey and  f.[Refi Update created_date] > convert(date,a.[Refi Opportunity created_date])
where [Contact-RPC note type] is null
--convert(date,a.[Refi Opportunity created_date]) <=CONVERT(date,a.[Contact-RPC created_date])
*/
)a 
--where  [Refi Update created_date] >=[Refi Opportunity created_date]
order by a.loan_skey;


delete from #Temp4 where loan_skey in (
select loan_skey from (
select * from #Temp4 
where 
--[Contact-RPC created_date] is not null and
[Refi Update created_date] is not null
) a where 
 [Refi - Interested created_date] is  null
and   [Refi - Not Interested created_date] is  null 
and  [Trans to Liberty created_date] is  null
)

select * from #Temp4;