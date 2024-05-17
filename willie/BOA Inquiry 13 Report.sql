select a.loan_skey,b.loan_status_description,b.loan_sub_status_description,a.note_type_description
,a.note_text
,a.created_by
--,replace(upper(a.created_by),' ','') created_by1
,convert(date,a.created_date) created_date
,c.note_type_description as 'Inquiry 13 Note Type',c.note_text as 'Inquiry 13 Note_text'
,convert(date,c.created_date) as 'Inquiry 13 Created Date'
,c.created_by as 'Inquiry 13 Created By'
--,b.servicer_name
,b.investor_name
--,b.loan_pool_long_description
,b.product_type_description
,d.[Complaint-Verbal note_type]
,d.[Complaint-Verbal_note_text]
,d.[Complaint-Verbal created_date]
,d.[Complaint-Verbal created_by]
from rms.v_Note a
join rms.v_LoanMaster b on a.loan_skey=b.loan_skey
left join (
select loan_skey,note_type_description,note_text,created_by,created_date 
from rms.v_Note where note_type_description='Inquiry 13'
and created_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) --MTD
--and created_date >= convert(date,getdate()-3) -- to fetch friday's data
--and created_date >=  convert(date,getdate()-1) -- to fetch one day prior data
and created_date < DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
) c on a.loan_skey=c.loan_skey
and convert(date,a.created_date)=convert(date,c.created_date)
and REPLACE(UPPER(a.created_by),' ','')=REPLACE(UPPER(c.created_by),' ','')
left join (
select loan_skey,note_type_description 'Complaint-Verbal note_type',
reverse(replace(substring(substring (reverse(note_text),charindex('(',reverse(note_text))+1,charindex(' *',reverse(note_text))+1) 
,CHARINDEX(' ',substring (reverse(note_text),charindex('(',reverse(note_text))+1,charindex(' *',reverse(note_text))+1))
,CHARINDEX('*',substring (reverse(note_text),charindex('(',reverse(note_text))+1,charindex(' *',reverse(note_text))+1))),'*',''))
as 'Complaint-Verbal created_by',
convert(date,SUBSTRING(note_text,1,11)) 'Complaint-Verbal created_date' 
,note_text 'Complaint-Verbal_note_text'
,created_by created_by1,convert(date,created_date) created_date
from rms.v_Note where note_type_description='Complaint-Verbal'
and created_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) -- MTD
--and created_date >= convert(date,getdate()-3) -- to fetch friday's data
--and created_date >=  convert(date,getdate()-1) -- to fetch one day prior data
and created_date <=DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
and created_by='System Load'
) d on a.loan_skey=d.loan_skey 
and CONVERT(date,a.created_date)=CONVERT(date,d.[Complaint-Verbal created_date])
and REPLACE(UPPER(a.created_by),' ','')=REPLACE(UPPER(d.[Complaint-Verbal created_by]),' ','')
where /*a.note_type_description in ('Incoming - Other',
'SPOC Outgoing A3P Loss Mit',
'Incoming A3P - ACH',
'SPOC Outgoing No Contact Estab',
'SPOC Incoming A3P Death',
'SPOC Incoming A3P Other',
'SPOC Incoming Death',
'Incoming - ACH',
'SPOC Incoming Insurance',
'SPOC Incoming Foreclosure',
'Incoming - LOC Draw Req',
'SPOC Incoming Occupancy',
'SPOC Incoming LOC DrawReq',
'SPOC Incoming A3P Foreclosure',
'SPOC Incoming Taxes',
'Outgoing No Contact Establishd',
'SPOC Outgoing Taxes',
'SPOC Outgoing T & I',
'SPOC Outgoing A3P Foreclosure',
'Incoming A3P - Serv Trsfr Inq',
'SPOC Incoming A3P LOC DrawReq',
'SPOC Incoming UA3P',
'SPOC Outgoing Other',
'SPOC Incoming A3P Insurance',
'SPOC Outgoing UA3P',

'SPOC Incoming A3P DocsRequest',
'SPOC Incoming A3P HAF',
'SPOC Incoming A3P HOA',
'SPOC Incoming A3P Loss Mit',
'SPOC Incoming A3P Occupancy',
'SPOC Incoming A3P Payoff',
'SPOC Incoming A3P Repairs',
'SPOC Incoming DocsRequest',
'SPOC Incoming HAF',
'SPOC Incoming HOA',
'Spoc Incoming LATP - Occupancy',
'SPOC Incoming Other',
'SPOC Incoming Payoff',
'SPOC Incoming Repairs',
'SPOC Outgoing - Repairs',
'SPOC Outgoing A3P Death',
'SPOC Outgoing A3P DocsRequest',
'SPOC Outgoing A3P HAF',
'SPOC Outgoing A3P HOA',
'SPOC Outgoing A3P Occupancy',
'SPOC Outgoing A3P Other',
'SPOC Outgoing A3P Payoff',
'SPOC Outgoing A3P T & I',
'SPOC Outgoing A3P Taxes',
'SPOC Outgoing A3P-Repairs',
'SPOC Outgoing Death',
'SPOC Outgoing DocsRequest',
'SPOC Outgoing Foreclosure',
'SPOC Outgoing HAF',
'SPOC Outgoing HOA',
'SPOC Outgoing Insurance',
'SPOC Outgoing Loss Mit','Spoc Outgoing LATP - Occupancy'
)*/
( a.note_type_description like '%Outgoing%' 
  or a.note_type_description like 'Spoc Outgoing%'
  or  a.note_type_description like 'Spoc Incom%'
  or a.note_type_description like 'Incoming%'
  )
  and a.note_type_description not in ('Kana Outgoing Email Sent','Incoming','SPOC Outgoing Dialer')
and a.created_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) -- MTD
--and a.created_date >=  convert(date,getdate()-3) -- to fetch friday's data
--and a.created_date >= convert(date,getdate()-1) -- to fetch one day prior data
and a.created_date <  DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
and b.investor_name='BAML'
order by a.created_date;
--select distinct note_type_description from rms.v_Note order by note_type_description where note_type_description='Inquiry 13'


/*
select loan_skey,note_type_description 'Complaint-Verbal note_type',
reverse(replace(substring(substring (reverse(note_text),charindex('(',reverse(note_text))+1,charindex(' *',reverse(note_text))+1) 
,CHARINDEX(' ',substring (reverse(note_text),charindex('(',reverse(note_text))+1,charindex(' *',reverse(note_text))+1))
,CHARINDEX('*',substring (reverse(note_text),charindex('(',reverse(note_text))+1,charindex(' *',reverse(note_text))+1))),'*',''))
as 'Complaint-Verbal created_by',
convert(date,SUBSTRING(note_text,1,11)) 'Complaint-Verbal created_date' 
,note_text 'Complaint-Verbal_note_text'
,created_by created_by1,convert(date,created_date) created_date
from rms.v_Note where note_type_description='Complaint-Verbal'
and created_date >=  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) -- MTD
--and created_date >= convert(date,getdate()-3) -- to fetch friday's data
--and created_date >=  convert(date,getdate()-1) -- to fetch one day prior data
--and created_date <=DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
and created_by='System Load'
*/