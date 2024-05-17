IF OBJECT_ID('tempdb..#rtemp') IS NOT NULL
    DROP TABLE #rtemp;
select  a.loan_skey,
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
--select * from #rtemp where [Work Phone #] is not null and [Contact Type] <> 'Attorney';

IF OBJECT_ID('tempdb..#rtemp1') IS NOT NULL
    DROP TABLE #rtemp1;
select distinct a.loan_skey,
--a.original_loan_number, 
a.loan_sub_status_description as loan_sub_status,a.investor_name,a.loan_status_description,
c.contact_type_description as 'Contact Type'
,c.first_name as 'Contact First Name',c.last_name as 'Contact Last Name' 
,b.address1 as 'Property Address1',b.address2 as 'Property Address2' ,b.city as 'Property City' 
,b.state_code as 'Property State',b.zip_code as 'Property Zip'
,c.mail_address1 as 'Mailing Address 1' ,c.mail_address2 as 'Mailing Address 2',c.mail_city as 'Mailing City'
,c.mail_state_code as 'Mailing State' ,c.mail_zip_code as 'Mailing Zip',c.home_phone_number as 'Home Phone #',c.cell_phone_number as 'Cell Phone #'
,c.work_phone_number as 'Work Phone #' 
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
into #rtemp1
from  reversequest.rms.v_LoanMaster a
join
[ReverseQuest].[rms].[v_PropertyMaster] b
on a.loan_skey=b.loan_skey
join reversequest.rms.v_ContactMaster c
on a.loan_skey = c.loan_skey
where a.loan_status_description not in ('DELETED', 'INACTIVE') 
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
'  Title Company');


IF OBJECT_ID('tempdb..#rtemp2') IS NOT NULL
    DROP TABLE #rtemp2;
/*select a.*,x.loan_skey from #rtemp1 a 
left join #rtemp x on a.loan_skey=x.loan_skey
--where x.loan_skey is null
and a.loan_status_description not in ('DELETED', 'INACTIVE') 
order by a.loan_skey;*/
select a.* 
into #rtemp2
from  #rtemp1 a
where a.loan_skey not in (select distinct loan_skey from #rtemp)
and Priority is not null;



--select * from #rtemp2;


--select  distinct loan_skey from #rtemp2 order by loan_skey;



IF OBJECT_ID('tempdb..#tmpBadPhoneWorkable') IS NOT NULL
    DROP TABLE #tmpBadPhoneWorkable;

	select a.* from #rtemp2 a
	left join (select loan_skey,alert_type_description from  reversequest.rms.v_Alert  where alert_type_description 
	in ('FDCPA -	 Call Restrictions','Cease and Desist','Pending Cease and Desist','Litigation -  Proceed','LITIGATION - Lawsuit Pending','DVN Research Request Pend'
	,'Borrower Represented by Attorney')
	and alert_status_description = 'Active') b on a.loan_skey=b.loan_skey where b.loan_skey is null
	order by a.loan_skey;

-----------------------------------------------------------------------------Bad address----------------------------------------

IF OBJECT_ID('tempdb..#tmpBadAddress') IS NOT NULL
    DROP TABLE #tmpBadAddress;
select  a.loan_skey,
--a.original_loan_number, 
a.loan_sub_status_description as loan_sub_status,a.investor_name,a.loan_status_description
,b.address1 as 'Property Address1',b.address2 as 'Property Address2' ,b.city as 'Property City' 
,b.state_code as 'Property State',b.zip_code as 'Property Zip'
--,b.curtailment_reason_description,b.date_foreclosure_sale_held,b.date_foreclosure_sale_scheduled
,d.alert_date
,d.alert_type_description
,d.alert_status_description
into #tmpBadAddress
from reversequest.rms.v_LoanMaster a
join
[ReverseQuest].[rms].[v_PropertyMaster] b
on a.loan_skey=b.loan_skey
join reversequest.rms.v_Alert d
on a.loan_skey=d.loan_skey
where 
a.loan_status_description not in ('DELETED', 'INACTIVE') and
(d.alert_type_description = 'Returned Mail - Follow Up Required'  )
and alert_status_description = 'Active';

delete from #tmpBadAddress where loan_skey  in(
select loan_skey from [ReverseQuest].[rms].[v_Alert]
where alert_type_description  in ('FDCPA -  Call Restrictions','Cease and Desist','Pending Cease and Desist','LITIGATION - Lawsuit Pending','DVN Research Request Pend')
and alert_status_description = 'Active')

IF OBJECT_ID('tempdb..#tmpBadAddress1') IS NOT NULL
    DROP TABLE #tmpBadAddress1;
select x.loan_skey,max(x.alert_date) as alert_date, x.loan_sub_status, x.loan_status_description,x.investor_name,x.[Property Address1],x.[Property Address2]
	,x.[Property City],x.[Property State],x.[Property Zip],x.alert_type_description into #tmpBadAddress1
	from #tmpBadAddress x 
	group by x.loan_skey,x.loan_sub_status,x.loan_status_description,x.investor_name,x.[Property Address1],x.[Property Address2]
	,x.[Property City],x.[Property State],x.[Property Zip],x.alert_type_description;

	select * from #tmpBadAddress1 where alert_date >=   DATEADD(DAY, DATEDIFF(DAY, 60, GETDATE()), 0);
	--select distinct loan_skey from #tmpBadAddress1;

IF OBJECT_ID('tempdb..#tmpBadAddressWorkable') IS NOT NULL
    DROP TABLE #tmpBadAddressWorkable;
select x.loan_skey,max(alert_date) as alert_date, x.loan_sub_status, x.loan_status_description,x.investor_name,x.[Property Address1],x.[Property Address2]
	,x.[Property City],x.[Property State],x.[Property Zip],x.alert_type_description,case when x.[Property State] in('CT', 'NH', 'WA') then 'Onshore'
	when x.[Property State] in ('TN') then 'Bangalore' else 'All' end as 'Location',1 as 'Skip_Flag' into #tmpBadAddressWorkable
	from #tmpBadAddress1 x 
	/*join 
	(select loan_skey from reversequest.rms.v_Alert
	where alert_type_description in ('SKPTRC', 'SKPADD', 'SKPEXH', 'SKPEML')
	and alert_status_description = 'Active') y
	on x.loan_skey=y.loan_skey*/
	group by x.loan_skey,x.loan_sub_status,x.loan_status_description,x.investor_name,x.[Property Address1],x.[Property Address2]
	,x.[Property City],x.[Property State],x.[Property Zip],x.alert_type_description;
	
	IF OBJECT_ID('tempdb..#tmpBadAddressWorkable1') IS NOT NULL
    DROP TABLE #tmpBadAddressWorkable1;
	select x.loan_skey,max(x.alert_date) as alert_date, x.loan_sub_status, x.loan_status_description,x.investor_name,x.[Property Address1],x.[Property Address2]
	,x.[Property City],x.[Property State],x.[Property Zip],x.alert_type_description,x.Location into #tmpBadAddressWorkable1
	from #tmpBadAddressWorkable x
	left join (select loan_skey,alert_type_description from  reversequest.rms.v_Alert  where alert_type_description 
	in ('FDCPA -  Call Restrictions','Cease and Desist','Pending Cease and Desist','Litigation -  Proceed','LITIGATION - Lawsuit Pending','DVN Research Request Pend'
	,'Borrower Represented by Attorney')
	and alert_status_description = 'Active') y on x.loan_skey=y.loan_skey where y.loan_skey is null
	group by x.loan_skey,x.loan_sub_status,x.loan_status_description,x.investor_name,x.[Property Address1],x.[Property Address2]
	,x.[Property City],x.[Property State],x.[Property Zip],x.alert_type_description,x.Location;

	--select * from #tmpBadAddressWorkable1;
	/*delete from #tmpBadAddress
	where loan_skey in (select loan_skey from reversequest.rms.v_Alert
	where alert_type_description in ('SKPTRC', 'SKPADD', 'SKPEXH', 'SKPEML')
	and alert_status_description = 'Active');*/

	/*select x.loan_skey,max(x.alert_date) as alert_date, x.loan_sub_status, x.loan_status_description,x.investor_name,x.[Property Address1],x.[Property Address2]
	,x.[Property City],x.[Property State],x.[Property Zip],x.alert_type_description
	from #tmpBadAddress x 
	left join #tmpBadAddressWorkable1 y
	on x.loan_skey=y.loan_skey
	where y.loan_skey IS null
	group by x.loan_skey,x.loan_sub_status,x.loan_status_description,x.investor_name,x.[Property Address1],x.[Property Address2]
	,x.[Property City],x.[Property State],x.[Property Zip],x.alert_type_description ;*/


	