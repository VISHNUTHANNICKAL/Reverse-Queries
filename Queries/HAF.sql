
IF OBJECT_ID('tempdb..#rtemp') IS NOT NULL
    DROP TABLE #rtemp;
select  a.loan_skey,
--a.original_loan_number, 
a.loan_sub_status_description as loan_sub_status,a.investor_name,a.loan_status_description,
c.contact_type_description as 'Contact Type'
,c.first_name as 'Contact First Name',c.last_name as 'Contact Last Name' 
,c.address1 as 'Property Address1',c.address2 as 'Property Address2' ,c.city as 'Property City' 
,c.state_code as 'Property State',c.zip_code as 'Property Zip'
,c.mail_address1 as 'Mailing Address 1' ,c.mail_address2 as 'Mailing Address 2',c.mail_city as 'Mailing City'
,c.mail_state_code as 'Mailing State' ,c.mail_zip_code as 'Mailing Zip',c.home_phone_number as 'Home Phone #',c.cell_phone_number as 'Cell Phone #'
,c.work_phone_number as 'Work Phone #'
--,b.curtailment_reason_description,b.date_foreclosure_sale_held,b.date_foreclosure_sale_scheduled
,d.alert_type_description
,case when c.contact_type_description = 'Attorney' then 1
	  when c.contact_type_description = 'Borrower' then 2
	  when c.contact_type_description = 'Co-Borrower' then 3
	  when c.contact_type_description = 'Legal Owner' then 5
	  when c.contact_type_description = 'Entitled Non-Borrowing Spouse' then 6
	  when c.contact_type_description = 'Alternate Contact' then 14
	  when c.contact_type_description = 'Authorized Party' then 12
	  when c.contact_type_description = 'Executor' then 7
	  when c.contact_type_description = 'Power of Attorney' then 8
	  when c.contact_type_description = 'Trustee' then 11
	  when c.contact_type_description = 'Non-Borrowing Spouse' then 13
	  when c.contact_type_description = 'Conservator' then 9
	  when c.contact_type_description = 'Guardian' then 10
	  when c.contact_type_description = 'Authorized Designee' then 4
	 END as Priority
into #rtemp
from reversequest.rms.v_LoanMaster a
--join
--reversequest.rms.v_LoanCurtailSummary b
--on a.loan_skey=b.loan_skey
join reversequest.rms.v_ContactMaster c
on a.loan_skey = c.loan_skey
join reversequest.rms.v_Alert d
on a.loan_skey=d.loan_skey
where 
a.loan_status_description in ('DEFAULT', 'FORECLOSURE')
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
and d.alert_status_description = 'Active';


delete from #rtemp where loan_skey  in(
select loan_skey from [ReverseQuest].[rms].[v_Alert]
where alert_type_description  in ('FDCPA -  Call Restrictions','Cease and Desist','Pending Cease and Desist','Litigation -  Proceed','LITIGATION - Lawsuit Pending','DVN Research Request Pend')
and alert_status_description = 'Active')

delete from #rtemp where Priority is null;

IF OBJECT_ID('tempdb..#rtemp1') IS NOT NULL
    DROP TABLE #rtemp1;
select * into #rtemp1 from 
(select ROW_NUMBER() OVER (PARTITION BY loan_skey ORDER BY priority) rn,* from #rtemp) q
WHERE   rn = 1
order by loan_skey

IF OBJECT_ID('tempdb..#tempAlldefault') IS NOT NULL
    DROP TABLE #tempAlldefault;
select a.*
,e.default_reason as 'default reason'
, e.period_description,e.tots_balance
,e.created_date 
into #tempAlldefault
from
#rtemp1 a
join reversequest.rms.v_MonthlyLoanDefaultSummary e
on a.loan_skey=e.loan_skey
where
(e.default_reason  in ('Unpaid Taxes','Unpaid Insurance','Unpaid HOA Fees')
and e.period_description = FORMAT(DATEADD(MM, -1, GETDATE()),'MMMM yyyy')
and e.tots_balance >0);



/*select loan_skey,loan_sub_status,investor_name,loan_status_description,[Contact Type],[Contact First Name],[Contact Last Name],[Property Address1]
[Property Address2], [Property City],[Property State],[Property Zip],[Mailing Address 1],[Mailing Address 2],[Mailing City],[Mailing State],[Mailing Zip]
[Home Phone #], [Cell Phone #], [Work Phone #],  alert_type_description
[default reason],Priority from 
(select ROW_NUMBER() OVER (PARTITION BY loan_skey ORDER BY priority,created_date desc) rownum,* from #tempAlldefault) x
WHERE  
rownum = 1 and 
Priority is not null 
and loan_skey = '2805'
order by loan_skey*/

IF OBJECT_ID('tempdb..#tempHaf') IS NOT NULL
    DROP TABLE #tempHaf;
select * into #tempHaf
from 
(select ROW_NUMBER() OVER (PARTITION BY loan_skey ORDER BY priority,created_date desc) rownum,* from #tempAlldefault) x
WHERE  
rownum = 1 and 
Priority is not null 
--and loan_skey = '221986'
order by loan_skey
/*select *  from 
(select ROW_NUMBER() OVER (PARTITION BY loan_skey ORDER BY priority) rn,* from #rtemp) q
WHERE   rn = 1 
and loan_skey = '1930'
order by loan_skey*/


delete from #tempHaf where loan_skey  in(
select loan_skey from [ReverseQuest].[rms].[v_PropertyMaster] where vacancy_date is not null);

--select * from #tempHaf where loan_skey  in(select loan_skey from [ReverseQuest].[rms].[v_MonthlyLoanDefaultSummary] 
--where period_description = FORMAT(DATEADD(MM, -1, GETDATE()),'MMMM yyyy') and tots_balance <=0);

select * from #tempHaf
--where loan_skey = '267085'


--select loan_skey,period_description,tots_balance  from [ReverseQuest].[rms].[v_MonthlyLoanDefaultSummary]
--where loan_skey = '185977' and period_description = FORMAT(DATEADD(MM, -1, GETDATE()),'MMMM yyyy')