
IF OBJECT_ID('tempdb..#rtemp') IS NOT NULL
    DROP TABLE #rtemp;
	select  a.loan_skey,
--a.original_loan_number, 
a.loan_status_description as loan_status,
c.contact_type_description as 'Contact Type'
,concat(concat(concat(concat(c.first_name,' '),c.middle_name),' '),c.last_name) as 'Borrower  Name'
,b.address1 as 'Property Address1',b.address2 as 'Property Address2' ,b.city as 'Property City' 
,b.state_code as 'Property State',b.zip_code as 'Property Zip'
,c.mail_address2 as 'Mailing Address 2',c.mail_city as 'Mailing City'
,c.mail_state_code as 'Mailing State' ,c.mail_zip_code as 'Mailing Zip',c.email
,c.created_date,c.created_by,c.modified_date as 'change_date'
,c.modified_by as 'changed_by'
, case when (c.created_date>=c.modified_date or c.modified_date is null) then c.created_date else c.modified_date end as 'createddate'
,c.home_phone_number as 'Home Phone #',c.cell_phone_number as 'Cell Phone #'
,c.work_phone_number as 'Work Phone #'
into #rtemp
from reversequest.rms.v_LoanMaster a
join
[ReverseQuest].[rms].[v_PropertyMaster] b
on a.loan_skey=b.loan_skey
join reversequest.rms.v_ContactMaster c
on a.loan_skey = c.loan_skey
--join reversequest.rms.v_Alert d
--on a.loan_skey=d.loan_skey
where 
 c.contact_type_description = 'Power of Attorney' and
 b.state_code = 'VA' and
 a.loan_status_description <> 'INACTIVE';

 select * from #rtemp;

 /*
 select a.loan_skey,a.loan_status,[Property State],null as 'created_by', null as 'created_date',null as 'changed_by',null as 'change_date'
 ,d.created_by as 'deleted by',d.created_date as 'deleted date',[Home Phone #],[Cell Phone #],[Work Phone #]
 from #rtemp a
join
[ReverseQuest]. [rms].[v_LogColumnDataChange] d
on a.loan_skey=d.loan_skey and a.[Borrower  Name]=d.audit_description
--where 
 --d.audit_type_description = 'Deleted Contact'and
 --d.original_value = 'Power of Attorney' and
--and a.loan_skey = '255654' and
 --d.created_date
-->=   DATEADD(DAY, DATEDIFF(DAY, 90, GETDATE()), 0);

 select loan_skey,loan_status,[Property State],created_by,created_date,changed_by,change_date,null as 'deleted by',null as 'deleted date'
 --,createddate as 'changedate'
 ,[Home Phone #],[Cell Phone #],[Work Phone #]
 from #rtemp where 
  (createddate
>=   DATEADD(DAY, DATEDIFF(DAY, 30, GETDATE()), 0) 
)

union

select a.loan_skey,a.loan_status,[Property State],null as 'created_by', null as 'created_date',null as 'changed_by',null as 'change_date'
 ,d.created_by as 'deleted by',d.created_date as 'deleted date',[Home Phone #],[Cell Phone #],[Work Phone #]
 from #rtemp a
join
[ReverseQuest]. [rms].[v_LogColumnDataChange] d
on a.loan_skey=d.loan_skey and a.[Borrower  Name]=d.audit_description
where 
 d.audit_type_description = 'Deleted Contact'
and d.original_value = 'Power of Attorney'
and d.created_date
>=   DATEADD(DAY, DATEDIFF(DAY, 30, GETDATE()), 0);
;

 
 --select distinct loan_status from #rtemp;
 select * from #rtemp
 */

