
IF OBJECT_ID('tempdb..#rtemp') IS NOT NULL
    DROP TABLE #rtemp;
select  a.loan_skey,
--a.original_loan_number, 
a.loan_sub_status_description as loan_sub_status,a.investor_name,a.loan_status_description,
c.contact_type_description as 'CONTACTTYPE'
,c.first_name as 'CONTACTFIRSTNAME',c.last_name as 'CONTACTLASTNAME' 
,b.address1 as 'PROPERTYADDRESS1',b.address2 as 'PROPERTYADDRESS2' ,b.city as 'PROPERTYCITY' 
,b.state_code as 'PROPERTYSTATE',b.zip_code as 'PROPERTYZIP'
,c.mail_address1 as 'MAILINGADDRESS1' ,c.mail_address2 as 'MAILINGADDRESS2',c.mail_city as 'MAILINGCITY'
,c.mail_state_code as 'MAILINGSTATE' ,c.mail_zip_code as 'MAILINGZIP',c.home_phone_number as 'HOMEPHONE',c.cell_phone_number as 'CELLPHONE'
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
--select * from #rtemp where loan_skey = '25111';

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

delete from #tempAlldefault
where loan_skey in
(select a.loan_skey from reversequest.rms.v_note a
where a.created_date
>= DATEADD(d,-7,DATEDIFF(d,0,GETDATE())) and
a.created_date < DATEADD(d,0,DATEDIFF(d,0,GETDATE()))
and (a.note_type_description like '%Incom%' or note_type_description like 'Spoc Incom%'));

IF OBJECT_ID('tempdb..#finalDefault') IS NOT NULL
    DROP TABLE #finalDefault;
select loan_skey as [LOANSKEY],loan_sub_status as [LOANSUBSTATUS],investor_name as [INVESTORNAME]
--,loan_status_description,
,CONTACTTYPE,CONTACTFIRSTNAME,[CONTACTLASTNAME],[PROPERTYADDRESS1]
,[PROPERTYADDRESS2], [PROPERTYCITY],[PROPERTYSTATE],[PROPERTYZIP],[MAILINGADDRESS1],[MAILINGADDRESS2],[MAILINGCITY],[MAILINGSTATE],[MAILINGZIP]
,[HOMEPHONE], [CELLPHONE]
--, [Work Phone #] 
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

delete from #finalDefault where LOANSKEY in(
SELECT  [loan_skey]      
  FROM [ReverseQuest].[rms].[v_WorkflowInstance] a 
  join ReverseQuest.rms.v_WorkflowTaskActivity  b on a.workflow_instance_skey=b.workflow_instance_skey 
where workflow_type_description like 'Due & Payable w/ HUD Approval' and a.status_description='Active' and 
    b.workflow_task_description like 'Request to Rescind D&P' and b.status_description='Active');

delete from #finalDefault where LOANSKEY in(
SELECT  [loan_skey]      
  FROM [ReverseQuest].[rms].[v_WorkflowInstance] a 
  join ReverseQuest.rms.v_WorkflowTaskActivity  b on a.workflow_instance_skey=b.workflow_instance_skey 
  where workflow_type_description = 'Foreclosure - Judicial' and a.status_description='Active'
  and b.workflow_task_description = 'Send Rescission Request to HUD'and b.status_description='Active');
  
  delete from #finalDefault where LOANSKEY in(
  SELECT  [loan_skey]      
  FROM [ReverseQuest].[rms].[v_WorkflowInstance] a 
  join ReverseQuest.rms.v_WorkflowTaskActivity  b on a.workflow_instance_skey=b.workflow_instance_skey 
  where  workflow_type_description like 'Foreclosure - Non Judicial' and a.status_description='Active'
  and b.workflow_task_description = 'Send Rescission Request to HUD'and b.status_description='Active')

update #finalDefault set [HOMEPHONE]='',[CELLPHONE]=''
where [CONTACTTYPE] = 'Attorney';



-----------------------------MAMHRDLossMit----------------------------

IF OBJECT_ID('tempdb..#MAMHRDLossMit') IS NOT NULL
    DROP TABLE #MAMHRDLossMit;

select x.LOANSKEY,x.LOANSUBSTATUS,x.INVESTORNAME,x.CONTACTTYPE,x.CONTACTFIRSTNAME,x.CONTACTLASTNAME,x.PROPERTYADDRESS1
,x.PROPERTYADDRESS2,x.PROPERTYCITY,x.PROPERTYSTATE,x.PROPERTYZIP,x.MAILINGADDRESS1,x.MAILINGADDRESS2
,x.MAILINGCITY,x.MAILINGSTATE,x.MAILINGZIP,x.HOMEPHONE,x.CELLPHONE,'Loss Mitigation Pilot Program' as 'CALLREASON' into #MAMHRDLossMit
from #finalDefault x
join
[ReverseQuest].[rms].[v_Alert] y
on x.LOANSKEY = y.loan_skey
where y.alert_type_description  in ('LM Customer Incentive Offered')
and y.alert_status_description = 'Active'
;

select * from #MAMHRDLossMit;
----------------------------------HRD BAML----------------------------------------

IF OBJECT_ID('tempdb..#HRDBAML') IS NOT NULL
    DROP TABLE #HRDBAML;

select x.LOANSKEY,x.LOANSUBSTATUS,x.INVESTORNAME,x.CONTACTTYPE,x.CONTACTFIRSTNAME,x.CONTACTLASTNAME,x.PROPERTYADDRESS1
,x.PROPERTYADDRESS2,x.PROPERTYCITY,x.PROPERTYSTATE,x.PROPERTYZIP,x.MAILINGADDRESS1,x.MAILINGADDRESS2
,x.MAILINGCITY,x.MAILINGSTATE,x.MAILINGZIP,x.HOMEPHONE,x.CELLPHONE,'HRD Baml - Death Cert' as 'CALLREASON' into #HRDBAML
from #finalDefault x
join
[ReverseQuest].[rms].[v_Alert] y
on x.LOANSKEY = y.loan_skey
where y.alert_type_description  in ('BAML- Death Cert Needed')
and y.alert_status_description = 'Active';

select a.* from #HRDBAML a
where
a.LOANSKEY not in 
(select LOANSKEY from #MAMHRDLossMit
);
--------------------------------------------HRDPendingRQCallRequest---------------------
IF OBJECT_ID('tempdb..#HRDPendingRQCallRequest') IS NOT NULL
    DROP TABLE #HRDPendingRQCallRequest; 
select x.LOANSKEY,x.LOANSUBSTATUS,x.INVESTORNAME,x.CONTACTTYPE,x.CONTACTFIRSTNAME,x.CONTACTLASTNAME,x.PROPERTYADDRESS1
,x.PROPERTYADDRESS2,x.PROPERTYCITY,x.PROPERTYSTATE,x.PROPERTYZIP,x.MAILINGADDRESS1,x.MAILINGADDRESS2
,x.MAILINGCITY,x.MAILINGSTATE,x.MAILINGZIP,x.HOMEPHONE,x.CELLPHONE
--,b.created_date
,b.note_type_description as 'CALLREASON' into #HRDPendingRQCallRequest
from #finalDefault x
join
(select loan_skey,note_type_description,created_date from [ReverseQuest].[rms].[v_Note] 
where 
--created_date > Convert(date, getdate()-1) and  created_date < Convert(date, getdate())
created_date between  DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()-1), 0) + '14:01'AND   DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0) + '06:00' --Morning Call prior day 2pm to current day 6am 
--created_date between  DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0) + '06:01' AND   DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0) + '14:00' --Afternoon Call 6am	current day	to 2pm current day		
) b
on x.LOANSKEY=b.loan_skey
  where (b.note_type_description like 'Call Req%') and b.note_type_description not in ('Call Request - CA','Call Request - WA','Call Request - NV');

  select distinct a.* from #HRDPendingRQCallRequest a where
   a.LOANSKEY not in 
(select LOANSKEY from #MAMHRDLossMit
union
select LOANSKEY from #HRDBAML
)
  order by a.LOANSKEY;

-----------------------HRDHOBR------------------------
IF OBJECT_ID('tempdb..#HRDHOBR') IS NOT NULL
    DROP TABLE #HRDHOBR;

select x.LOANSKEY,x.LOANSUBSTATUS,x.INVESTORNAME,x.CONTACTTYPE,x.CONTACTFIRSTNAME,x.CONTACTLASTNAME,x.PROPERTYADDRESS1
,x.PROPERTYADDRESS2,x.PROPERTYCITY,x.PROPERTYSTATE,x.PROPERTYZIP,x.MAILINGADDRESS1,x.MAILINGADDRESS2
,x.MAILINGCITY,x.MAILINGSTATE,x.MAILINGZIP,x.HOMEPHONE,x.CELLPHONE
--,b.workflow_task_description
--,status_description,b.complete_date
,'HRDHOBR' as 'CALLREASON' into #HRDHOBR
from #finalDefault x
join
(select b.loan_skey,a.workflow_task_description
--,a.status_description,a.complete_date
  --,a.workflow_instance_skey,a.complete_date
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a join [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
  where a.workflow_task_description in ( '1st Call Attempt - HBOR Call Campaign'
,'2nd Call Attempt - HBOR Call Campaign'
,'3rd Call Attempt - HBOR Call Campaign'
)
and b.status_description ='Active' and a.status_description ='Active'
and a.complete_date is null) b
on x.LOANSKEY =b.loan_skey;


IF OBJECT_ID('tempdb..#HRDHOBR1') IS NOT NULL
    DROP TABLE #HRDHOBR1;
select distinct a.* 
into #HRDHOBR1
from #HRDHOBR a
union
(
select x.LOANSKEY,x.LOANSUBSTATUS,x.INVESTORNAME,x.CONTACTTYPE,x.CONTACTFIRSTNAME,x.CONTACTLASTNAME,x.PROPERTYADDRESS1
,x.PROPERTYADDRESS2,x.PROPERTYCITY,x.PROPERTYSTATE,x.PROPERTYZIP,x.MAILINGADDRESS1,x.MAILINGADDRESS2
,x.MAILINGCITY,x.MAILINGSTATE,x.MAILINGZIP,x.HOMEPHONE,x.CELLPHONE
,'HRDHOBR' as 'CALLREASON' from #finalDefault x where LOANSKEY in(
  select loan_skey from [ReverseQuest].[rms].[v_Note] 
  where note_type_description in ('Call Request - CA','Call Request - WA','Call Request - NV')
  and created_date > Convert(date, getdate()-1) and  created_date < Convert(date, getdate())
  )
 )


 select x.* from #HRDHOBR1 x where x.LOANSKEY not in
 (select LOANSKEY from #MAMHRDLossMit
union
select LOANSKEY from #HRDBAML
union
select LOANSKEY from #HRDPendingRQCallRequest
);

-----------------------------------HRD Pending Occ

IF OBJECT_ID('tempdb..#HRDPendingOcc') IS NOT NULL
    DROP TABLE #HRDPendingOcc;
select x.LOANSKEY,x.LOANSUBSTATUS,x.INVESTORNAME,x.CONTACTTYPE,x.CONTACTFIRSTNAME,x.CONTACTLASTNAME,x.PROPERTYADDRESS1
,x.PROPERTYADDRESS2,x.PROPERTYCITY,x.PROPERTYSTATE,x.PROPERTYZIP,x.MAILINGADDRESS1,x.MAILINGADDRESS2
,x.MAILINGCITY,x.MAILINGSTATE,x.MAILINGZIP,x.HOMEPHONE,x.CELLPHONE,'HRD Pending Occupancy' as 'CALLREASON' into #HRDPendingOcc
from #finalDefault x
join
(select b.loan_skey
  --,a.workflow_instance_skey,a.complete_date
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a join [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
  where a.workflow_task_description in ( 'Call Attempt - Borrower/CoBorrower'
,'2nd Call Attempt - Borrower/CoBorrower'
,'Final Call Attempt - Borrower/CoBorrower'
,'Call Attempt - Invalid Occupancy Certificate '
,'Task Call to CS to confirm borrower has returned.',
'Call Attempt - Eligible Non-Borrowing Spouse'
,'Call Attempt - Invalid eNBS Occupancy Certificate ')
and a.status_description = 'Active' and b.status_description = 'Active'
and a.complete_date is null) b
on x.LOANSKEY=b.loan_skey;

select a.* from #HRDPendingOcc a
where
   a.LOANSKEY not in 
(select LOANSKEY from #MAMHRDLossMit
union
select LOANSKEY from #HRDBAML
union 
select LOANSKEY from #HRDHOBR1
union
select LOANSKEY from #HRDPendingRQCallRequest
);


--------------------HRDPending RPP----------------------------
IF OBJECT_ID('tempdb..#HRDPendingRPP') IS NOT NULL
    DROP TABLE #HRDPendingRPP;
select x.LOANSKEY,x.LOANSUBSTATUS,x.INVESTORNAME,x.CONTACTTYPE,x.CONTACTFIRSTNAME,x.CONTACTLASTNAME,x.PROPERTYADDRESS1
,x.PROPERTYADDRESS2,x.PROPERTYCITY,x.PROPERTYSTATE,x.PROPERTYZIP,x.MAILINGADDRESS1,x.MAILINGADDRESS2
,x.MAILINGCITY,x.MAILINGSTATE,x.MAILINGZIP,x.HOMEPHONE,x.CELLPHONE,'HRD Pending RPP' as 'CALLREASON' into #HRDPendingRPP
from #finalDefault x
join
(select b.loan_skey
  --,a.workflow_instance_skey,a.complete_date
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a join [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
  where a.workflow_task_description in ( 'Notify Borrower of Approved Repayment Plan'
,'Missed Payment - 1st Call'
,'Missed Payment - 2nd Call'
,'Unreturned Signed Agreement - 1st Call'
,'Unreturned Signed Agreement - 2nd Call')
and a.status_description ='Active' and b.status_description = 'Active'
and a.complete_date is null) b
on x.LOANSKEY=b.loan_skey;

IF OBJECT_ID('tempdb..#HRDPendingRPP1') IS NOT NULL
    DROP TABLE #HRDPendingRPP1;
select distinct x.LOANSKEY,x.LOANSUBSTATUS,x.INVESTORNAME,x.CONTACTTYPE,x.CONTACTFIRSTNAME,x.CONTACTLASTNAME,x.PROPERTYADDRESS1
,x.PROPERTYADDRESS2,x.PROPERTYCITY,x.PROPERTYSTATE,x.PROPERTYZIP,x.MAILINGADDRESS1,x.MAILINGADDRESS2
,x.MAILINGCITY,x.MAILINGSTATE,x.MAILINGZIP,x.HOMEPHONE,x.CELLPHONE,x.CALLREASON into #HRDPendingRPP1
from #HRDPendingRPP x;

select x.* from #HRDPendingRPP1 x
where x.LOANSKEY not in 
(select LOANSKEY from #MAMHRDLossMit
union 
select LOANSKEY from #HRDHOBR1
union
select LOANSKEY from #HRDBAML
union
select LOANSKEY from #HRDPendingOcc
union
select LOANSKEY from #HRDPendingRQCallRequest
); 


------------------------HRDPendingCFW
IF OBJECT_ID('tempdb..#HRDPendingCFW') IS NOT NULL
    DROP TABLE #HRDPendingCFW; 
select x.LOANSKEY,x.LOANSUBSTATUS,x.INVESTORNAME,x.CONTACTTYPE,x.CONTACTFIRSTNAME,x.CONTACTLASTNAME,x.PROPERTYADDRESS1
,x.PROPERTYADDRESS2,x.PROPERTYCITY,x.PROPERTYSTATE,x.PROPERTYZIP,x.MAILINGADDRESS1,x.MAILINGADDRESS2
,x.MAILINGCITY,x.MAILINGSTATE,x.MAILINGZIP,x.HOMEPHONE,x.CELLPHONE
--,b.status_description
,'HRD Pending CFW' as 'CALLREASON' into #HRDPendingCFW
from #finalDefault x
join
(select b.loan_skey
  --,a.workflow_instance_skey,a.complete_date
  --,b.status_description
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a join [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
  where a.workflow_task_description in ( 'Notify Borrower of Denied Plan')
and a.status_description ='Active'
and a.complete_date is null
and b.status_description = 'Active') b
on x.LOANSKEY=b.loan_skey;

select x.* from #HRDPendingCFW x
where x.LOANSKEY not in 
(select LOANSKEY from #MAMHRDLossMit
union 
select LOANSKEY from #HRDHOBR1
union
select LOANSKEY from #HRDBAML
union
select LOANSKEY from #HRDPendingOcc
union
select LOANSKEY from #HRDPendingRPP1
union
select LOANSKEY from #HRDPendingRQCallRequest
);


-----------------------------------------HRD Repair
IF OBJECT_ID('tempdb..#HRDRepair') IS NOT NULL
    DROP TABLE #HRDRepair; 
select x.LOANSKEY,x.LOANSUBSTATUS,x.INVESTORNAME,x.CONTACTTYPE,x.CONTACTFIRSTNAME,x.CONTACTLASTNAME,x.PROPERTYADDRESS1
,x.PROPERTYADDRESS2,x.PROPERTYCITY,x.PROPERTYSTATE,x.PROPERTYZIP,x.MAILINGADDRESS1,x.MAILINGADDRESS2
,x.MAILINGCITY,x.MAILINGSTATE,x.MAILINGZIP,x.HOMEPHONE,x.CELLPHONE, 'HRD Repair' as 'CALLREASON' 
into #HRDRepair
from #finalDefault x
join(
SELECT A.LOAN_SKEY
/*, B.ORIGINAL_LOAN_NUMBER, B.INVESTOR_LOAN_NUMBER, B.SERVICER_NAME, B.INVESTOR_NAME, B.LOAN_POOL_LONG_DESCRIPTION,					
B.LOAN_STATUS_DESCRIPTION, B.LOAN_SUB_STATUS_DESCRIPTION, B.PRODUCT_TYPE_DESCRIPTION, B.PAYMENT_PLAN_DESCRIPTION,					
B.PAYMENT_STATUS_DESCRIPTION, FORMAT(B.CREATED_DATE,'d','us') AS BOARDED_DATE, FORMAT(B.FUNDED_DATE,'d','us') AS FUNDED_DATE,					
C.STATE_CODE, D.FIRST_NAME, D.MIDDLE_NAME, D.LAST_NAME, A.WORKFLOW_TYPE_DESCRIPTION, A.STATUS_DESCRIPTION,					
FORMAT(A.CREATED_DATE,'d','us') AS CREATEDDATE, A.WORKFLOW_MANAGER, AB.WORKFLOW_TASK_DESCRIPTION,					
FORMAT(AB.SCHEDULE_DATE,'d','us') AS SCHEDULE_DATE, FORMAT(AB.DUE_DATE,'d','us') AS DUE_DATE,					
FORMAT(AB.CREATED_DATE,'d','us') AS CREATED_DATE, E.REPAIR_SET_ASIDE_AMOUNT AS ORIGINAL_REPAIR_SET_ASIDE, A.REPAIR_SET_ASIDE_AMOUNT,					
FORMAT(A.REPAIR_COMPLETION_DUE_DATE,'d','us') AS REPAIR_COMPLETION_DUE_DATE, A.REPAIR_TYPE, A.COMMENTS AS REPAIR_DESC,					
FORMAT(A.HUD_COMPLETION_DUE_DATE,'d','us') AS HUD_COMPLETION_DUE_DATE, B.RSA_INCLUDES_ADMINISTRATION_FEE_FLAG,					
DATEDIFF(DAY,A.CREATED_DATE,GETDATE()) AS REPAIR_AGING,					
DATEDIFF(DAY,AB.CREATED_DATE,GETDATE()) AS REPAIR_TASK_AGING,					
CASE WHEN DATEDIFF(DAY,A.CREATED_DATE,GETDATE()) <= 60 THEN '0-60 DAYS'					
	 WHEN DATEDIFF(DAY,A.CREATED_DATE,GETDATE()) <= 120 THEN '61-120 DAYS'				
	 WHEN DATEDIFF(DAY,A.CREATED_DATE,GETDATE()) <= 180 THEN '121-180 DAYS'				
	 WHEN DATEDIFF(DAY,A.CREATED_DATE,GETDATE()) <= 240 THEN '181-240 DAYS'				
	 WHEN DATEDIFF(DAY,A.CREATED_DATE,GETDATE()) <= 365 THEN '241-365 DAYS'				
     ELSE 'GT 1 YEAR' END AS REPAIR_AGE_BUCKET,					
CASE WHEN DATEDIFF(DAY,AB.CREATED_DATE,GETDATE()) <= 5 THEN '0-5 DAYS'					
	 WHEN DATEDIFF(DAY,AB.CREATED_DATE,GETDATE()) <= 10 THEN '6-10 DAYS'				
	 WHEN DATEDIFF(DAY,AB.CREATED_DATE,GETDATE()) <= 15 THEN '11-15 DAYS'				
	 WHEN DATEDIFF(DAY,AB.CREATED_DATE,GETDATE()) <= 20 THEN '16-20 DAYS'				
	 ELSE 'GT 20 DAYS' END AS TASK_AGE_BUCKET*/
FROM REVERSEQUEST.RMS.V_WORKFLOWINSTANCE A	
LEFT JOIN					
(SELECT * FROM [ReverseQuest].RMS.V_WORKFLOWTASKACTIVITY A					
WHERE A.COMPLETE_DATE IS NULL AND A.STATUS_SKEY = '1'					
     AND A.WORKFLOW_TASK_ACTIVITY_SKEY = (SELECT MIN(X.WORKFLOW_TASK_ACTIVITY_SKEY) FROM [ReverseQuest].RMS.V_WORKFLOWTASKACTIVITY X					
					WHERE X.COMPLETE_DATE IS NULL AND X.STATUS_SKEY = '1' AND X.WORKFLOW_INSTANCE_SKEY = A.WORKFLOW_INSTANCE_SKEY)
) AB ON A.WORKFLOW_INSTANCE_SKEY = AB.WORKFLOW_INSTANCE_SKEY					
LEFT JOIN REVERSEQUEST.RMS.V_LOANMASTER B ON A.LOAN_SKEY=B.LOAN_SKEY					
LEFT JOIN REVERSEQUEST.RMS.V_PROPERTYMASTER C ON A.LOAN_SKEY=C.LOAN_SKEY					
LEFT JOIN REVERSEQUEST.RMS.V_CONTACTMASTER D ON A.LOAN_SKEY=D.LOAN_SKEY AND D.CONTACT_TYPE_DESCRIPTION='BORROWER'					
LEFT JOIN REVERSEQUEST.RMS.V_TRANSACTION E ON A.LOAN_SKEY=E.LOAN_SKEY AND E.SHORT_TRANSACTION_DESCRIPTION='RSA'					
WHERE A.WORKFLOW_TYPE_DESCRIPTION='REPAIRS'	and AB.workflow_task_description in ('Receipt of Contractor W-9','Receipt of Property Inspection Report for Repairs'
,'Receipt of Repairs Contract','Repair Rider - Repairs Completion Due')				
AND A.STATUS_SKEY='1') b
on x.LOANSKEY=b.loan_skey;

select * from #HRDRepair;


-----------------------finalDefault

select x.LOANSKEY,x.LOANSUBSTATUS,x.INVESTORNAME,x.CONTACTTYPE,x.CONTACTFIRSTNAME,x.CONTACTLASTNAME,x.PROPERTYADDRESS1
,x.PROPERTYADDRESS2,x.PROPERTYCITY,x.PROPERTYSTATE,x.PROPERTYZIP,x.MAILINGADDRESS1,x.MAILINGADDRESS2
,x.MAILINGCITY,x.MAILINGSTATE,x.MAILINGZIP,x.HOMEPHONE,x.CELLPHONE, x.[default reason] as 'CALLREASON'  from #finalDefault x
where x.LOANSKEY not in 
(select LOANSKEY from #MAMHRDLossMit
union 
select LOANSKEY from #HRDHOBR1
union
select LOANSKEY from #HRDBAML
union
select LOANSKEY from #HRDPendingOcc
union
select LOANSKEY from #HRDPendingRPP1
union
select LOANSKEY from #HRDPendingCFW
union
select LOANSKEY from #HRDPendingRQCallRequest
union
select LOANSKEY from #HRDRepair
);


