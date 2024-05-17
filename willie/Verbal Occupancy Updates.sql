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
and a.created_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
--and a.created_date<=convert(date,'2024-03-28')
and a.created_date <  DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
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
and created_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
and created_date <  DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
and created_by not in ('System Load')
--and loan_skey in ('204964')

select reverse(substring(reverse ('abc, 123_@_gmail.com'), CHARINDEX('_', reverse ('abc, 123_@_gmail.com'))+3, len(reverse ('abc, 123_@_gmail.com'))));

select reverse ('abc, 123_@_gmail.com')

select distinct contact_type_description from rms.v_ContactMaster order by contact_type_description

select a.loan_skey,Agent_name,a.[RPC Note],a.[RPC Created by],a.[RPC created_date]
,b.note_type_category_description,b.note_type_description,b.verbal_created_by,b.verbal_created_date
from #Temp1 a
left join (
select loan_skey,note_type_category_description,note_type_description,note_text,created_by verbal_created_by,CONVERT(date,created_date) verbal_created_date
from rms.v_Note
where note_type_description='Verbal Occ Obtained'
and created_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
and created_date <  DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
)b on a.loan_skey=b.loan_skey and a.[RPC created_date]=b.verbal_created_date and replace(a.Agent_name,' ','')=replace(b.verbal_created_by,' ','')
order by a.[RPC created_date];