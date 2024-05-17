
IF OBJECT_ID('tempdb..#rtemp') IS NOT NULL
    DROP TABLE #rtemp;select  a.loan_skey,
--a.original_loan_number, 
a.loan_status_description as loan_status,
c.contact_type_description as 'Contact Type'
,concat(concat(c.first_name,' '),c.last_name) as 'Borrower  Name'
,c.address1 as 'Property Address1',c.address2 as 'Property Address2' ,c.city as 'Property City' 
,c.state_code as 'Property State',c.zip_code as 'Property Zip'
,c.mail_address2 as 'Mailing Address 2',c.mail_city as 'Mailing City'
,c.mail_state_code as 'Mailing State' ,c.mail_zip_code as 'Mailing Zip',c.email
,c.created_date,c.created_by,c.modified_date as 'change_date',c.modified_by as 'changed_by'
,c.home_phone_number as 'Home Phone #',c.cell_phone_number as 'Cell Phone #'
,c.work_phone_number as 'Work Phone #'
into #rtemp
from reversequest.rms.v_LoanMaster a
join reversequest.rms.v_ContactMaster c
on a.loan_skey = c.loan_skey
--join reversequest.rms.v_Alert d
--on a.loan_skey=d.loan_skey
where 
 c.contact_type_description = 'Attorney' and
 --and d.alert_type_description = 'Active'
 a.loan_status_description <> 'INACTIVE';


 select * from #rtemp;

 select  a.loan_skey,
--a.original_loan_number, 
a.loan_status_description as loan_status,
c.contact_type_description as 'Contact Type'
,concat(concat(c.first_name,' '),c.last_name) as 'Borrower  Name'
,c.home_phone_number as 'Home Phone #',c.cell_phone_number as 'Cell Phone #'
,c.work_phone_number as 'Work Phone #'
 from reversequest.rms.v_LoanMaster a
join reversequest.rms.v_ContactMaster c
on a.loan_skey = c.loan_skey
where a.loan_skey in (select loan_skey from #rtemp);
 ;
 select distinct loan_status from #rtemp;
 

