IF OBJECT_ID('tempdb..#tempLs') IS NOT NULL
    DROP TABLE #tempLs;

SELECT [loan_skey]
      ,[alert_type_description]
      --,[created_by]
	  ,alert_status_description,
	  max([created_date]) as 'created_date'
	  into #tempLs
  FROM [ReverseQuest].[rms].[v_Alert]
  where alert_type_description = 'Returned Mail - Follow Up Required'
  and alert_status_description = 'Active'
  group by [loan_skey]
      ,[alert_type_description]
      --,[created_by]
	  ,alert_status_description
	  order by loan_skey;


	  IF OBJECT_ID('tempdb..#tempLs1') IS NOT NULL
    DROP TABLE #tempLs1;
	  select loan_skey,audit_type_description,column_name,original_value as 'old_value',new_value,created_date as 'change_date',created_by as 'change_by'
	  into #tempLs1
	  from
    [ReverseQuest].[rms].[v_LogColumnDataChange]
	where loan_skey in (select loan_skey from #tempLs)
	and audit_type_description in (
	'Borrower Mailing Address Line1',
'Borrower Mailing Address Line2',
'Borrower Mailing City',
'Borrower Mailing First Name',
'Borrower Mailing Last Name',
'Borrower Mailing Middle Name',
'Borrower Mailing State Code',
'Borrower Mailing Zip Code',
'Co-Borrower Mailing Address Line1',
'Co-Borrower Mailing Address Line2',
'Co-Borrower Mailing City',
'Co-Borrower Mailing First Name',
'Co-Borrower Mailing Last Name',
'Co-Borrower Mailing Middle Name',
'Co-Borrower Mailing State Code',
'Co-Borrower Mailing Zip Code')
	--and created_date > = Convert(datetime, '2022-10-01' )
	order by loan_skey,audit_type_description;
	  
  
  IF OBJECT_ID('tempdb..#tempLs2') IS NOT NULL
    DROP TABLE #tempLs2;
  select y.loan_skey,x.audit_type_description,x.column_name,x.old_value,x.new_value,x.change_date,x.change_by,y.created_date as 'Alert Date',
  case when x.change_date>y.created_date then 1 else 0 end as 'Updated' 
  into #tempLs2
  from #tempLs1 x
  right join
  #tempLs y
  on x.loan_skey=y.loan_skey
  --where x.change_date>y.created_date
  order by x.loan_skey;

  IF OBJECT_ID('tempdb..#tempLs3') IS NOT NULL
    DROP TABLE #tempLs3;
  select distinct loan_skey,[Alert Date],Updated
  into #tempLs3
  from (select * from #tempLs2 where updated = 1) x
  ;

  alter table #tempLs3
add 
[Borrower Mailing Address Line1] NVARCHAR(100),
[Borrower Mailing Address Line2] NVARCHAR(200),
[Borrower Mailing City] NVARCHAR(200),
[Borrower Mailing First Name] NVARCHAR(100),
[Borrower Mailing Last Name] NVARCHAR(100),
[Borrower Mailing Middle Name] NVARCHAR(100),
[Borrower Mailing State Code] NVARCHAR(100),
[Borrower Mailing Zip Code] NVARCHAR(100),
[Co-Borrower Mailing Address Line1] NVARCHAR(100),
[Co-Borrower Mailing Address Line2] NVARCHAR(200),
[Co-Borrower Mailing City] NVARCHAR(200),
[Co-Borrower Mailing First Name] NVARCHAR(100),
[Co-Borrower Mailing Last Name] NVARCHAR(100),
[Co-Borrower Mailing Middle Name] NVARCHAR(100),
[Co-Borrower Mailing State Code] NVARCHAR(100),
[Co-Borrower Mailing Zip Code] NVARCHAR(100)
;
	

	update a set a.[Borrower Mailing Address Line1]=b.new_value
	from #tempLs3 a
	join
	(
	select * from #tempLs2 
	where updated = 1 and audit_type_description='Borrower Mailing Address Line1') b
	on a.loan_skey=b.loan_skey;

	update a set a.[Borrower Mailing Address Line2]=b.new_value
	from #tempLs3 a
	join
	(
	select * from #tempLs2 
	where updated = 1 and audit_type_description='Borrower Mailing Address Line2') b
	on a.loan_skey=b.loan_skey;

	update a set a.[Borrower Mailing City]=b.new_value
	from #tempLs3 a
	join
	(
	select * from #tempLs2 
	where updated = 1 and audit_type_description='Borrower Mailing City') b
	on a.loan_skey=b.loan_skey;

	update a set a.[Borrower Mailing First Name]=b.new_value
	from #tempLs3 a
	join
	(
	select * from #tempLs2 
	where updated = 1 and audit_type_description='Borrower Mailing First Name') b
	on a.loan_skey=b.loan_skey;
	
	update a set a.[Borrower Mailing Last Name]=b.new_value
	from #tempLs3 a
	join
	(
	select * from #tempLs2 
	where updated = 1 and audit_type_description='Borrower Mailing Last Name') b
	on a.loan_skey=b.loan_skey;
	
	update a set a.[Borrower Mailing Last Name]=b.new_value
	from #tempLs3 a
	join
	(
	select * from #tempLs2 
	where updated = 1 and audit_type_description='Borrower Mailing Last Name') b
	on a.loan_skey=b.loan_skey;

	update a set a.[Borrower Mailing Middle Name]=b.new_value
	from #tempLs3 a
	join
	(
	select * from #tempLs2 
	where updated = 1 and audit_type_description='Borrower Mailing Middle Name') b
	on a.loan_skey=b.loan_skey;

	update a set a.[Borrower Mailing State Code]=b.new_value
	from #tempLs3 a
	join
	(
	select * from #tempLs2 
	where updated = 1 and audit_type_description='Borrower Mailing State Code') b
	on a.loan_skey=b.loan_skey;

	update a set a.[Borrower Mailing Zip Code]=b.new_value
	from #tempLs3 a
	join
	(
	select * from #tempLs2 
	where updated = 1 and audit_type_description='Borrower Mailing Zip Code') b
	on a.loan_skey=b.loan_skey;

	---------------------------------------------


	update a set a.[Co-Borrower Mailing Address Line1]=b.new_value
	from #tempLs3 a
	join
	(
	select * from #tempLs2 
	where updated = 1 and audit_type_description='Co-Borrower Mailing Address Line1') b
	on a.loan_skey=b.loan_skey;

	update a set a.[Co-Borrower Mailing Address Line2]=b.new_value
	from #tempLs3 a
	join
	(
	select * from #tempLs2 
	where updated = 1 and audit_type_description='Co-Borrower Mailing Address Line2') b
	on a.loan_skey=b.loan_skey;

	update a set a.[Co-Borrower Mailing City]=b.new_value
	from #tempLs3 a
	join
	(
	select * from #tempLs2 
	where updated = 1 and audit_type_description='Co-Borrower Mailing City') b
	on a.loan_skey=b.loan_skey;

	update a set a.[Co-Borrower Mailing First Name]=b.new_value
	from #tempLs3 a
	join
	(
	select * from #tempLs2 
	where updated = 1 and audit_type_description='Co-Borrower Mailing First Name') b
	on a.loan_skey=b.loan_skey;
	
	update a set a.[Co-Borrower Mailing Last Name]=b.new_value
	from #tempLs3 a
	join
	(
	select * from #tempLs2 
	where updated = 1 and audit_type_description='Co-Borrower Mailing Last Name') b
	on a.loan_skey=b.loan_skey;
	
	update a set a.[Co-Borrower Mailing Last Name]=b.new_value
	from #tempLs3 a
	join
	(
	select * from #tempLs2 
	where updated = 1 and audit_type_description='Co-Borrower Mailing Last Name') b
	on a.loan_skey=b.loan_skey;

	update a set a.[Co-Borrower Mailing Middle Name]=b.new_value
	from #tempLs3 a
	join
	(
	select * from #tempLs2 
	where updated = 1 and audit_type_description='Co-Borrower Mailing Middle Name') b
	on a.loan_skey=b.loan_skey;

	update a set a.[Co-Borrower Mailing State Code]=b.new_value
	from #tempLs3 a
	join
	(
	select * from #tempLs2 
	where updated = 1 and audit_type_description='Co-Borrower Mailing State Code') b
	on a.loan_skey=b.loan_skey;

	update a set a.[Co-Borrower Mailing Zip Code]=b.new_value
	from #tempLs3 a
	join
	(
	select * from #tempLs2 
	where updated = 1 and audit_type_description='Co-Borrower Mailing Zip Code') b
	on a.loan_skey=b.loan_skey;
	-------------------------------------------

	IF OBJECT_ID('tempdb..#rtemp') IS NOT NULL
    DROP TABLE #rtemp;
select  a.loan_skey,a.original_loan_number,
--a.original_loan_number, 
a.loan_sub_status_description as loan_sub_status,a.investor_name,a.loan_status_description,
c.contact_type_description as 'Contact Type'
,c.first_name as 'Contact First Name',c.last_name as 'Contact Last Name' 
,b.address1 as 'Property Address1',b.address2 as 'Property Address2' ,b.city as 'Property City' 
,b.state_code as 'Property State',b.zip_code as 'Property Zip'
,c.mail_address1 as 'Mailing Address 1' ,c.mail_address2 as 'Mailing Address 2',c.mail_city as 'Mailing City'
,c.mail_state_code as 'Mailing State' ,c.mail_zip_code as 'Mailing Zip',c.home_phone_number as 'Home Phone #',c.cell_phone_number as 'Cell Phone #'
,c.work_phone_number as 'Work Phone #'
--,b.curtailment_reason_description,b.date_foreclosure_sale_held,b.date_foreclosure_sale_scheduled
--,d.alert_type_description
--,d.alert_status_description
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
a.loan_status_description not in ('DELETED', 'INACTIVE') 
and  ((len(c.home_phone_number)>=10 and c.home_phone_number <>'9999999999' and c.home_phone_number <> '4444444444')or (len(c.cell_phone_number)>=10 and c.cell_phone_number <> '9999999999' and c.cell_phone_number <> '4444444444') or
((len(c.work_phone_number)>=10) and c.work_phone_number <> '9999999999' and c.work_phone_number <> '4444444444') and c.contact_type_description = 'Attorney')
--and d.alert_status_description = 'Active'
;
-------------------------------------------------------

	select a.*, case when a.loan_skey in
		(select loan_skey from #rtemp where [Contact Type] in ('Attorney','Borrower','Co-Borrower','Legal Owner',
		'Entitled Non-Borrowing Spouse','Alternate Contact','Authorized Party','Executor','Power of Attorney','Trustee',
		'Non-Borrowing Spouse','Conservator','Guardian','Authorized Designee'))
		then 1 else 0 end as 'Has Valid Number'
	from #tempLs2 a
	order by a.loan_skey;

	