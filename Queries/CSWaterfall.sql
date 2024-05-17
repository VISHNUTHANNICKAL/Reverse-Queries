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
,d.alert_type_description
,d.alert_status_description
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
join
[ReverseQuest].[rms].[v_PropertyMaster] b
on a.loan_skey=b.loan_skey
join reversequest.rms.v_ContactMaster c
on a.loan_skey = c.loan_skey
join reversequest.rms.v_Alert d
on a.loan_skey=d.loan_skey
where 
a.loan_status_description in ('Active', 'Claim')
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
and ((len(c.home_phone_number)>=10 and c.home_phone_number <>'9999999999' and c.home_phone_number <> '4444444444')or (len(c.cell_phone_number)>=10 and c.cell_phone_number <> '9999999999' and c.cell_phone_number <> '4444444444') or
(len(c.work_phone_number)>=10) and c.work_phone_number <> '9999999999' and c.work_phone_number <> '4444444444')
and d.alert_status_description = 'Active';

delete from #rtemp where loan_skey  in(
select loan_skey from [ReverseQuest].[rms].[v_Alert]
where alert_type_description  in ('FDCPA -  Call Restrictions','Cease and Desist','Pending Cease and Desist','LITIGATION - Lawsuit Pending','DVN Research Request Pend')
and alert_status_description = 'Active')

delete from #rtemp where loan_skey  in
(select b.loan_skey
  --,a.workflow_instance_skey,a.complete_date
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a join [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
  where a.workflow_task_description ='3rd Party Sale'
  and a.status_description = 'Active' and b.status_description = 'Active'
  and a.complete_date is not null);
  
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
,e.created_date 
into #tempAlldefault
from
#rtemp1 a
join reversequest.rms.v_MonthlyLoanDefaultSummary e
on a.loan_skey=e.loan_skey

/*delete from #tempAlldefault
where loan_skey in
(select a.loan_skey from reversequest.rms.v_note a
where a.created_date
>= DATEADD(d,-7,DATEDIFF(d,0,GETDATE())) and
a.created_date < DATEADD(d,0,DATEDIFF(d,0,GETDATE()))
and (a.note_type_description like '%Incom%' or note_type_description like 'Spoc Incom%'));
*/
IF OBJECT_ID('tempdb..#finalDefault') IS NOT NULL
    DROP TABLE #finalDefault;
select loan_skey,loan_sub_status,investor_name
--,loan_status_description,
,[Contact Type],[Contact First Name],[Contact Last Name],[Property Address1]
,[Property Address2], [Property City],[Property State],[Property Zip],[Mailing Address 1],[Mailing Address 2],[Mailing City],[Mailing State],[Mailing Zip]
,[Home Phone #], [Cell Phone #], [Work Phone #] 
--,alert_type_description
,[default reason]
--,Priority 
into #finalDefault
from 
(select ROW_NUMBER() OVER (PARTITION BY loan_skey ORDER BY priority,created_date desc) rownum,* from #tempAlldefault) x
WHERE  
rownum = 1 and 
Priority is not null 
--and loan_skey = '89192'
order by loan_skey,alert_type_description;

--select * from #finalDefault


delete from #finalDefault where loan_skey in(
SELECT  [loan_skey]      
  FROM [ReverseQuest].[rms].[v_WorkflowInstance] a 
  join ReverseQuest.rms.v_WorkflowTaskActivity  b on a.workflow_instance_skey=b.workflow_instance_skey 
where workflow_type_description like 'Due & Payable w/ HUD Approval' and a.status_description='Active' and 
    b.workflow_task_description like 'Request to Rescind D&P' and b.status_description='Active');

delete from #finalDefault where loan_skey in(
SELECT  [loan_skey]      
  FROM [ReverseQuest].[rms].[v_WorkflowInstance] a 
  join ReverseQuest.rms.v_WorkflowTaskActivity  b on a.workflow_instance_skey=b.workflow_instance_skey 
  where workflow_type_description = 'Foreclosure - Judicial' and a.status_description='Active'
  and b.workflow_task_description = 'Send Rescission Request to HUD'and b.status_description='Active');
  
  delete from #finalDefault where loan_skey in(
  SELECT  [loan_skey]      
  FROM [ReverseQuest].[rms].[v_WorkflowInstance] a 
  join ReverseQuest.rms.v_WorkflowTaskActivity  b on a.workflow_instance_skey=b.workflow_instance_skey 
  where  workflow_type_description like 'Foreclosure - Non Judicial' and a.status_description='Active'
  and b.workflow_task_description = 'Send Rescission Request to HUD'and b.status_description='Active')



update #finalDefault set [Home Phone #]='',[Cell Phone #]=''
where [Contact Type] = 'Attorney';

-------------------------------------------------------



--------------------------------------------

IF OBJECT_ID('tempdb..#CSPendingRQCallRequest') IS NOT NULL
    DROP TABLE #CSPendingRQCallRequest; 
select x. loan_skey as LOANSKEY,x.loan_sub_status as LOANSUBSTATUS,x.investor_name as  INVESTORNAME
,x.[Contact Type] as CONTACTTYPE,x.[Contact First Name] as CONTACTFIRSTNAME,x.[Contact Last Name] as CONTACTLASTNAME
,x.[Property Address1]  as PROPERTYADDRESS1,x. [Property Address2] as PROPERTYADDRESS2, x.[Property City] as PROPERTYCITY,
x. [Property State] as PROPERTYSTATE,x.[Property Zip] as PROPERTYZIP,x.[Mailing Address 1] as MAILINGADDRESS1
,x.[Mailing Address 2] as MAILINGADDRESS2,x.[Mailing City] as MAILINGCITY,x.[Mailing State] as MAILINGSTATE,
x.[Mailing Zip] as MAILINGZIP,x.[Home Phone #] As HOMEPHONE,x.[Cell Phone #] as CELLPHONE
--,b.created_date,
,b.note_type_description as 'CALLREASON' into #CSPendingRQCallRequest
from #finalDefault x
join
(select loan_skey,note_type_description,created_date from [ReverseQuest].[rms].[v_Note] 
where 
--created_date >    DATEADD(HOUR, -13, getdate()) and  created_date <   DATEADD(HOUR, -1, getdate())
created_date between  DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()-1), 0) + '14:01'AND   DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0) + '06:00' --Morning Call prior day 2pm to current day 6am 
--created_date between  DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0) + '06:01' AND   DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0) + '14:00' --Afternoon Call 6am	current day	to 2pm current day		
				) b
on x.loan_skey=b.loan_skey
  where (b.note_type_description like 'Call Req%') and b.note_type_description not in ('Call Request - CA','Call Request - WA','Call Request - NV')
  ;
  select distinct * from #CSPendingRQCallRequest order by LOANSKEY;
  ---------------------------------------------------------CS CallOccupancy----------------------------------
  select x. loan_skey as LOANSKEY,x.loan_sub_status as LOANSUBSTATUS,x.investor_name as  INVESTORNAME
,x.[Contact Type] as CONTACTTYPE,x.[Contact First Name] as CONTACTFIRSTNAME,x.[Contact Last Name] as CONTACTLASTNAME
,x.[Property Address1]  as PROPERTYADDRESS1,x. [Property Address2] as PROPERTYADDRESS2, x.[Property City] as PROPERTYCITY,
x. [Property State] as PROPERTYSTATE,x.[Property Zip] as PROPERTYZIP,x.[Mailing Address 1] as MAILINGADDRESS1
,x.[Mailing Address 2] as MAILINGADDRESS2,x.[Mailing City] as MAILINGCITY,x.[Mailing State] as MAILINGSTATE,
x.[Mailing Zip] as MAILINGZIP,x.[Home Phone #] As HOMEPHONE,x.[Cell Phone #] as CELLPHONE, 'CSPendingOC' as 'CALLREASON'
from #finalDefault x
join
(select b.loan_skey
  --,a.workflow_instance_skey,a.complete_date
  ,b.status_description
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a join [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
  where a.workflow_task_description in ( 'Call Attempt - Borrower/CoBorrower'
,'2nd Call Attempt - Borrower/CoBorrower'
,'Final Call Attempt - Borrower/CoBorrower'
,'Call Attempt - Invalid Occupancy Certificate '
,'Task Call to CS to confirm borrower has returned.',
'Call Attempt - Eligible Non-Borrowing Spouse'
,'Call Attempt - Invalid eNBS Occupancy Certificate ')
and a.status_description = ('Active')
and a.complete_date is null
and b.status_description in ('Active')
) b
on x.loan_skey=b.loan_skey
and x.loan_skey not in
(select LOANSKEY from #CSPendingRQCallRequest);