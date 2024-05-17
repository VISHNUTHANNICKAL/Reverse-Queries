
IF OBJECT_ID('tempdb..#rtemp') IS NOT NULL
    DROP TABLE #rtemp;
select  a.loan_skey,
--a.original_loan_number, 
a.loan_sub_status_description as loan_sub_status,a.investor_name
,c.contact_type_description as 'Contact Type'
,c.first_name as 'Contact First Name',c.last_name as 'Contact Last Name' 
,c.address1 as 'Property Address1',c.address2 as 'Property Address2' ,c.city as 'Property City' 
,c.state_code as 'Property State',c.zip_code as 'Property Zip'
,c.mail_address1 as 'Mailing Address 1' ,c.mail_address2 as 'Mailing Address 2',c.mail_city as 'Mailing City'
,c.mail_state_code as 'Mailing State' ,c.mail_zip_code as 'Mailing Zip',c.home_phone_number as 'Home Phone #',c.cell_phone_number as 'Cell Phone #'
,c.work_phone_number as 'Work Phone #'
,b.curtailment_reason_description,b.date_foreclosure_sale_held,b.date_foreclosure_sale_scheduled
,d.alert_type_description
,case when c.contact_type_description = 'Attorney' then '1'
	  when c.contact_type_description = 'Borrower' then '2'
	  when c.contact_type_description = 'Co-Borrower' then '3'
	  when c.contact_type_description = 'Legal Owner' then '5'
	  when c.contact_type_description = 'Entitled Non-Borrowing Spouse' then '6'
	  when c.contact_type_description = 'Alternate Contact' then '14'
	  when c.contact_type_description = 'Authorized Party' then '12'
	  when c.contact_type_description = 'Executor' then '7'
	  when c.contact_type_description = 'Power of Attorney' then '8'
	  when c.contact_type_description = 'Trustee' then '11'
	  when c.contact_type_description = 'Non-Borrowing Spouse' then '13'
	  when c.contact_type_description = 'Conservator' then '9'
	  when c.contact_type_description = 'Guardian' then '10'
	  when c.contact_type_description = 'Authorized Designee' then '4'
	 END as Priority
into #rtemp
from reversequest.rms.v_LoanMaster a
join
reversequest.rms.v_LoanCurtailSummary b
on a.loan_skey=b.loan_skey
join reversequest.rms.v_ContactMaster c
on a.loan_skey = c.loan_skey
join reversequest.rms.v_Alert d
on a.loan_skey=d.loan_skey
where 
--a.loan_sub_status_description not in ('Deleted','REO - Sale','Refinanced') and
 a.servicer_name not in ('PHH Mortgage Corporation')
and a.investor_name not in ('Advantis CU',
'American National Bank',
'BAML',
'Blue Plains Trust',
'BoA Merrill Lynch',
'Chetco FCU',
'Ent CU',
'FDIC',
'First National Bank of Pennsylvania',
'GTE FCU',
'Ivory Cove Trust',
'Low Valley Trust',
'Mid Hudson Valley FCU',
'Midland National Life',
'Moneyhouse',
'NexBank SSB',
'PHH Mortgage Services',
'Property Disposition, Inc.',
'Reverse Mortgage Loan Trust 2008-1',
'RML Trust 2013-1',
'RML Trust 2013-2',
'Seattle Bank Texas Insured',
'Seattle Bank Uninsured',
'Seattle Mortgage Company',
'SMS Financial NCU',
'Suncoast Credit Union',
'Teachers FCU',
'TRM, LLC',
'Visions FCU')
and a.loan_status_description in ('DEFAULT', 'FORECLOSURE')
and b.curtailment_reason_description is not null
and (b.date_foreclosure_sale_held is null )  

--and b.date_foreclosure_sale_scheduled < (SELECT CAST( GETDATE()+1 AS Date )) and 
and (b.date_foreclosure_sale_scheduled > (SELECT CAST( GETDATE()+60 AS Date )) or b.date_foreclosure_sale_scheduled is null)

and c.contact_type_description not in('Broker',
'  Counseling Agency',
'  Contractor',
'  Debt Counselor',
'  HOA',
'  Neighbor',
'  Other',
'  Payoff Requester',
'  Relative',
'  Skip Tracing',
'  Title Company')
and (len(c.home_phone_number)>=10 or len(c.cell_phone_number)>=10 or len(c.work_phone_number)>=10)
and d.alert_type_description not in ('Cease and Desist','Pending Cease and Desist','Litigation -  Proceed','LITIGATION - Lawsuit Pending','DVN Research Request Pend')
/*group by a.loan_skey,a.loan_sub_status_description,a.investor_name
--,c.contact_type_description,c.first_name,c.last_name,c.address1,c.address2,c.city,c.state_code,c.zip_code,c.mail_address1,c.mail_address2,c.mail_city,c.mail_state_code,c.mail_zip_code
,c.home_phone_number,c.cell_phone_number,c.work_phone_number
,b.curtailment_reason_description,b.date_foreclosure_sale_held,b.date_foreclosure_sale_scheduled
,d.alert_type_description*/
order by c.first_name;

/*select count(loan_skey) as cnt ,* from #rtemp
group by loan_skey,[loan_sub_status],investor_name
,[Contact Type],[Contact First Name],[Contact Last Name],[Property Address1],[Property Address2],[Property City],[Property State]
,[Property Zip],[Mailing Address 1],[Mailing Address 2],[Mailing City],[Mailing State],[Mailing Zip]
,[Home Phone #],[Cell Phone #],[Work Phone #]
,[curtailment_reason_description],date_foreclosure_sale_held,date_foreclosure_sale_scheduled
,alert_type_description;*/

/*;WITH cte AS
(
   SELECT 
         ROW_NUMBER() OVER (PARTITION BY [loan_skey] order by Priority) AS rn, *
   FROM #rtemp
)

SELECT *
FROM cte
WHERE 
--rn = 1 and 
priority is not null
order by loan_skey,rn,Priority;*/

/*select min(priority),* from #rtemp where priority is not null
group by priority,loan_skey,[loan_sub_status],investor_name
,[Contact Type],[Contact First Name],[Contact Last Name],[Property Address1],[Property Address2],[Property City],[Property State]
,[Property Zip],[Mailing Address 1],[Mailing Address 2],[Mailing City],[Mailing State],[Mailing Zip]
,[Home Phone #],[Cell Phone #],[Work Phone #]
,[curtailment_reason_description],date_foreclosure_sale_held,date_foreclosure_sale_scheduled
,alert_type_description*/

select * from 
(select ROW_NUMBER() OVER (PARTITION BY loan_skey ORDER BY priority) rn,* from #rtemp) q
WHERE   rn = 1
order by loan_skey