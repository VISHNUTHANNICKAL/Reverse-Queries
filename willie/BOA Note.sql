select a.loan_skey,b.loan_status_description,b.loan_sub_status_description,a.note_type_description,a.note_text
,a.created_by,a.created_date,c.note_type_description as 'Inquiry 13 Note Type',c.note_text as 'Inquiry 13 Note_text',c.created_date as "Inquiry 13 Created Date"
,c.created_by as "Inquiry 13 Created By"
,b.servicer_name,b.investor_name,b.loan_pool_long_description,b.product_type_description
from rms.v_Note a
join rms.v_LoanMaster b on a.loan_skey=b.loan_skey
left join (
select loan_skey,note_type_description,note_text,created_by,created_date 
from rms.v_Note where note_type_description='Inquiry 13'
--and a.created_date >= convert(date,getdate()-4) -- to fetch friday's data
and created_date >= convert(date,getdate()-1) -- to fetch one day prior data
and created_date <=DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
) c on a.loan_skey=c.loan_skey
where a.note_type_description in ('Incoming - Other',
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
'SPOC Outgoing UA3P')
--and a.created_date >= convert(date,getdate()-4) -- to fetch friday's data
and a.created_date >= convert(date,getdate()-1) -- to fetch one day prior data
and a.created_date <=DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
and b.investor_name='BAML'

--select loan_skey,note_type_description,note_text,created_by,created_date from rms.v_Note where note_type_description='Inquiry 13'
