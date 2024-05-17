IF OBJECT_ID('tempdb..#rtemp12') IS NOT NULL
    DROP TABLE #rtemp12;
select  a.loan_skey,
--a.original_loan_number, 
a.loan_sub_status_description as loan_sub_status,a.investor_name,a.loan_status_description,
c.contact_type_description as 'CONTACTTYPE1'
,c.first_name as 'CONTACTFIRSTNAME1',c.last_name as 'CONTACTLASTNAME1' 
,b.address1 as 'Property Address1',b.address2 as 'Property Address2' ,b.city as 'Property City' 
,b.state_code as 'Property State',left(b.zip_code,5) as 'Property Zip'
,c.mail_address1 as 'Mailing Address 1' ,c.mail_address2 as 'Mailing Address 2',c.mail_city as 'Mailing City'
,c.mail_state_code as 'Mailing State' ,left(c.mail_zip_code,5) as 'Mailing Zip'
,case when c.contact_type_description = 'Attorney' 
--and c.home_phone_number in(NULL,'')
then COALESCE(case when convert (varchar,work_phone_number)='' then NULL else convert (varchar,work_phone_number)  end ,case when convert (varchar,home_phone_number)='' then NULL else  convert (varchar,home_phone_number) end ) else c.home_phone_number end  as 'HOMEPHONE1'
,c.cell_phone_number as 'CELLPHONE1'
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
into  #rtemp12
from reversequest.rms.v_LoanMaster a
join
[ReverseQuest].[rms].[v_PropertyMaster] b
on a.loan_skey=b.loan_skey
join reversequest.rms.v_ContactMaster c
on a.loan_skey = c.loan_skey
join ( select * from (
select loan_skey,alert_status_description,alert_type_description,created_date,created_by,
ROW_NUMBER() over (partition by loan_skey order by created_date desc,loan_skey) sn
from 
reversequest.rms.v_Alert
where alert_status_description='Active') a where sn=1) d
on a.loan_skey=d.loan_skey
where --a.investor_name not in ('MECA 2011','FNMA') and 
a.loan_status_description in ('DEFAULT', 'FORECLOSURE','Active','Claim')  and
c.contact_type_description not in('Broker',
'Counseling Agency',
'Contractor',
'Debt Counselor',
'HOA',
'Neighbor',
'Other',
'Payoff Requester',
'Relative',
'Skip Tracing',
'Title Company')
and ((len(c.home_phone_number)>=10 and c.home_phone_number <>'9999999999' and c.home_phone_number <> '4444444444')or (len(c.cell_phone_number)>=10 and c.cell_phone_number <> '9999999999' and c.cell_phone_number <> '4444444444') or
(len(c.work_phone_number)>=10) and c.work_phone_number <> '9999999999' and c.work_phone_number <> '4444444444')
--and d.alert_status_description = 'Active'
and a.loan_skey in('214408'
)

IF OBJECT_ID('tempdb..#limitedattemptstaterules1') IS NOT NULL
    DROP TABLE #limitedattemptstaterules1;
	select loan_skey,note_text,sn  
	into #limitedattemptstaterules1
	from 
	(
SELECT loan_skey,note_text
,case when note_text like '%(Hung Up)_%' then 
(CONVERT(varchar, CONVERT(varchar, rtrim(ltrim(substring(note_text,CHARINDEX(')_', note_text)+2,10)))),11))
when note_text like '%Wrong Number_%' then 
(CONVERT(varchar, CONVERT(varchar, rtrim(ltrim(substring(note_text,CHARINDEX('r_', note_text)+2,10)))),11))
when note_text like '%Left Message Machine%' then 
(CONVERT(varchar, CONVERT(varchar, rtrim(ltrim(substring(note_text,CHARINDEX('ine_', note_text)+4,10)))),11))
when note_text like '%No Message Left%' then 
(CONVERT(varchar, CONVERT(varchar, rtrim(ltrim(substring(note_text,CHARINDEX('t_', note_text)+2,10)))),11))
when note_text like '%Operator Transfer (Agent Terminated Call)%' then 
(CONVERT(varchar, CONVERT(varchar, rtrim(ltrim(substring(note_text,CHARINDEX(')_', note_text)+2,10)))),11))
when note_text like '%AGENT - PTP by Mail%' then 
(CONVERT(varchar, CONVERT(varchar, rtrim(ltrim(substring(note_text,CHARINDEX('il_', note_text)+3,10)))),11))
when note_text like '%Invalid Phone Number%' then 
(CONVERT(varchar, CONVERT(varchar, rtrim(ltrim(substring(note_text,CHARINDEX('r_', note_text)+2,10)))),11))
when note_text like '%Customer Hung Up%' then 
(CONVERT(varchar, CONVERT(varchar, rtrim(ltrim(substring(note_text,CHARINDEX('Up_', note_text)+3,10)))),11))
when note_text like '%No Answer%' then 
(CONVERT(varchar, CONVERT(varchar, rtrim(ltrim(substring(note_text,CHARINDEX('r_', note_text)+2,10)))),11))
when note_text like '%Busy%' then 
(CONVERT(varchar, CONVERT(varchar, rtrim(ltrim(substring(note_text,CHARINDEX('y_', note_text)+2,10)))),11))
when note_text like '%Operator Transfer (Caller Abandoned)%' then 
(CONVERT(varchar, CONVERT(varchar, rtrim(ltrim(substring(note_text,CHARINDEX('ed)_', note_text)+4,10)))),11))
when note_text like '%Operator Transfer%' then 
(CONVERT(varchar, CONVERT(varchar, rtrim(ltrim(substring(note_text,CHARINDEX('fer_', note_text)+4,10)))),11))
when note_text like '%Hung Up in Opening%' then 
(CONVERT(varchar, CONVERT(varchar, rtrim(ltrim(substring(note_text,CHARINDEX('ing_', note_text)+4,10)))),11))
else '' end as
sn
  FROM [ReverseQuest].[rms].[v_Note]
  where 
  created_date > DATEADD(DAY, DATEDIFF(DAY, 13, GETDATE()), 0) and  created_date <   DATEADD(DAY, DATEDIFF(DAY, -1, GETDATE()), 0)
  and
  note_type_description in ('Outgoing Call -T&I Mitigation','SPOC Outgoing Loss Mit','SPOC Outgoing Dialer','Outgoing Call -Death','SPOC Outgoing Call Insurance',
'SPOC Outgoing No Contact Estab','Outgoing A3P - Other','SPOC Outgoing Foreclosure','SPOC Outgoing Call Occupancy','SPOC OutgoingCall No Atmp Need',
'SPOC Outgoing DocsRequest','SPOC Outgoing Call Foreclosure','SPOC Outgoing A3P DocsRequest','SPOC Outgoing Other','SPOC Outgoing Insurance','SPOC Outgoing HAF',
'Outgoing HAF','SPOC Outgoing Call Taxes','Outgoing','SPOC Outgoing A3P Taxes','SPOC Outgoing A3P Other','SPOC Outgoing A3P Foreclosure','Outgoing A3P HAF',
'SPOC Outgoing Payoff','SPOC Outgoing A3P Loss Mit','SPOC Outgoing UA3P','SPOC Outgoing A3P Insurance','SPOC Outgoing Death','Outgoing No Contact Establishd',
'SPOC Outgoing Call Death','SPOC Outgoing Call Other','SPOC Outgoing Call DocsRequest','SPOC Outgoing No Attempt Need','Outgoing - Occupancy','SPOC Outgoing Occupancy',
'Outgoing UA3P','SPOC Outgoing T & I','SPOC Outgoing Taxes','SPOC Outgoing A3P Payoff','Outgoing A3P - Foreclosure','SPOC Outgoing A3P Occupancy','Outgoing - Default',
'Outgoing Call -Insurance','SPOC Outgoing Call COVID 19','Outgoing Call -Occupancy','Outgoing - Death','SPOC Outgoing Call Loss Mit','Outgoing - Other','SPOC Outgoing A3P T & I',
'Outgoing - Foreclosure','SPOC Outgoing Call No Good Num','Outgoing - Plan Change','Outgoing - Payoff','Outgoing Call -Other','Outgoing - Docs Request','SPOC Outgoing No Good Num',
'SPOC Outgoing A3P Death','SPOCIncomingCall IncentiveOffr','Outgoing - Taxes','Outgoing Call -LOC Draw Req','Outgoing - Refi Inquiry','SPOC Outgoing A3P HAF','Outgoing Call -Loss Draft',
'Outgoing Call -Foreclosure','Outgoing - ACH','SPOC Outgoing Call CA Notifica','Outgoing - Repairs','SPOC Outgoing A3P WA Notifica','SPOC Outgoing A3P Title&Claim','Outgoing A3P - Payoff',
'Outgoing A3P - Default','SPOC Outgoing WA Notifica','SPOC Outgoing Title&Claim','SPOC Outgoing Call Equity Loan','Outgoing - Loss Draft','Outgoing Call -Taxes','SPOC Outgoing A3P COVID 19',
'Outgoing Call -Docs Request','Outgoing Call -ACH','SPOC Outgoing A3P CA Notifica','Outgoing - LOC Draw Req','Outgoing - Insurance','SPOC Outgoing CA Notifica','SPOC Outgoing Call WA Notifica','SPOC Outgoing COVID 19',
'SPOC Outgoing Call T & I','SPOC Outgoing A3P No Good Num','SPOC Outgoing Call-Loss Draft','Outgoing A3P - Occupancy','Outgoing - Payment Status','SPOC outgoing call - NY Occ','Outgoing Call -Payoff',
'SPOC Outgoing Call Payoff','Outgoing A3P - Payment Status','Outgoing A3P - Taxes','SPOC Outgoing Incentive Let','Outgoing - FEMA','Outgoing Call -Refi Inquiry','Outgoing - Address Change','Outgoing A3P - Refi Inquiry',
'Outgoing Call -Address Change','Outgoing Call -Payment Status','Outgoing Call -Mthly Statement','Outgoing Call -1098 IRS Form','Outgoing A3P - Death','Outgoing - Balance Inquiry','Outgoing - Returned Mail',
'Outgoing A3P - COVID 19','Outgoing Call -Default','Outgoing A3P - ACH','SPOC Outgoing BK','Outgoing - Serv Trsfr Inq','SPOC Outgoing A3P FEMA','SPOC Outgoing Call HOA','SPOC Outgoing - Repairs',
'SPOC Outgoing Call Title&Claim','Outgoing Call -Serv Trsfr Inq','Outgoing Call -Plan Change','SPOC Outgoing FEMA','SPOC Outgoing A3P-Loss Draft','SPOC Outgoing HOA','Outgoing - COVID 19',
'Outgoing A3P - Insurance','SPOC Out Call - Trans to SWBC','SPOCOutgoingCall IncentiveOffr','SPOC Outgoing Call ServiceTrsf','Outgoing Call- Hurricane IDA','Outgoing A3P - LOC Draw Req',
'SPOC Outgoing Call-Repairs','Outgoing - Mthly Statement','SPOC Outgoing A3P - NY Occ','SPOC Outgoing Call BK','SPOC Outgoing - NY Occ','Outgoing Call -Title Claim','Outgoing A3P - Plan Change',
'SPOC Outgoing A3P-Repairs','Outgoing Call -Balance Inquiry','Outgoing - Welcome Call','Outgoing Call -Repairs','Outgoing A3P - Docs Request','Outgoing - Release Req','Outgoing A3P - Release Req',
'Outgoing A3P - Serv Trsfr Inq','Outgoing - 1098 IRS Form','Outgoing A3P - Repairs','SPOC Outgoing ServiceTrsf','SPOC Outgoing A3P Incntive Let','SPOC Outgoing - Loss Draft','SPOC Outgoing A3P BK',
'Outgoing A3P - Address Change','Outgoing A3P - FEMA','SPOC Outgoing A3P NV Notifica','Outgoing - Bankruptcy','SPOC Outgoing NV Notifica','SPOC Outgoing Hurricane Isais','Outgoing Call -Bankruptcy',
'SPOC Outgoing A3P ServiceTrsf','Outgoing - Title Claim','SPOC Out Call- Hurricane IDA','Outgoing A3P - Mthly Statement','Outgoing Call -Returned Mail','SPOC Outgoing Trans to ASG','Outgoing - T&I Mitigation',
'SPOC Outgoing Call Earthquake','Outgoing Call -Welcome Call','SPOC Outgoing A3P HOA','SPOC Outgoing Equity Loan','Outgoing A3P - T&I Mitigation')
--and loan_skey not in (select loan_skey from #rtempDISBURSEMENTS)
) a where loan_skey in (
select loan_skey from rms.v_PropertyMaster
where state_code in('WA','MA')
union
select loan_skey from rms.v_ContactMaster
where contact_type_description in ('Borrower','Co-Borrower')
and mail_state_code in('WA','MA')
)

--select * from #limitedattemptstaterules1;


IF OBJECT_ID('tempdb..#temp_home_phone') IS NOT NULL
    DROP TABLE #temp_home_phone;
select * 
into #temp_home_phone
from(
select * 
from (
select a.loan_skey,a.sn--,b.contact_type_description 'contact type1'
,b.home_phone_number 'Home phone 1'--,b.cell_phone_number 'Cell Phone 1'
,c.contact_type_description,
c.home_phone_number--,c.cell_phone_number 
,ROW_NUMBER() over (PARTITION by a.loan_skey,b.home_phone_number order by a.loan_skey,b.home_phone_number) rn
from ( select * from (
select *,
ROW_NUMBER() over(PARTITION by sn order by sn ) tn
from #limitedattemptstaterules1
where sn not like ''
)a where tn=1
) a 
 left join(
select loan_skey,contact_type_description,home_phone_number,cell_phone_number from rms.v_ContactMaster
where contact_type_description in ('Borrower','Co-Borrower')
and loan_skey in (
select loan_skey from rms.v_PropertyMaster
where state_code in('WA','MA')
union
select loan_skey from rms.v_ContactMaster
where contact_type_description in ('Borrower','Co-Borrower')
and mail_state_code in('WA','MA')
)
) b on a.loan_skey=b.loan_skey and a.sn=b.home_phone_number
left join(
select loan_skey,contact_type_description,home_phone_number,cell_phone_number 
from rms.v_ContactMaster
where contact_type_description in ('Borrower','Co-Borrower')
and loan_skey in (
select loan_skey from rms.v_PropertyMaster
where state_code in('WA','MA')
union
select loan_skey from rms.v_ContactMaster
where contact_type_description in ('Borrower','Co-Borrower')
and mail_state_code in('WA','MA')
)
) c on a.loan_skey=c.loan_skey and a.sn!=c.home_phone_number
where a.sn not like '' 
)a where [Home phone 1] is not null
)b where rn=1

--select * from #temp_home_phone order by loan_skey

IF OBJECT_ID('tempdb..#temp_cell_phone') IS NOT NULL
    DROP TABLE #temp_cell_phone;
select * 
into #temp_cell_phone
from(
select * 
from (
select a.loan_skey,a.sn--,b.contact_type_description 'contact type1'
--,b.home_phone_number 'Home phone 1'
,b.cell_phone_number 'Cell Phone 1'
,c.contact_type_description,
--c.home_phone_number--,
c.cell_phone_number 
,ROW_NUMBER() over (PARTITION by a.loan_skey,b.cell_phone_number order by a.loan_skey,b.cell_phone_number) rn
from ( select * from (
select *,
ROW_NUMBER() over(PARTITION by sn order by sn ) tn
from #limitedattemptstaterules1
where sn not like ''
)a where tn=1
) a 
 left join(
select loan_skey,contact_type_description,home_phone_number,cell_phone_number from rms.v_ContactMaster
where contact_type_description in ('Borrower','Co-Borrower')
and loan_skey in (
select loan_skey from rms.v_PropertyMaster
where state_code in('WA','MA')
union
select loan_skey from rms.v_ContactMaster
where contact_type_description in ('Borrower','Co-Borrower')
and mail_state_code in('WA','MA')
)
) b on a.loan_skey=b.loan_skey and a.sn=b.cell_phone_number
left join(
select loan_skey,contact_type_description,home_phone_number,cell_phone_number 
from rms.v_ContactMaster
where contact_type_description in ('Borrower','Co-Borrower')
and loan_skey in (
select loan_skey from rms.v_PropertyMaster
where state_code in('WA','MA')
union
select loan_skey from rms.v_ContactMaster
where contact_type_description in ('Borrower','Co-Borrower')
and mail_state_code in('WA','MA')
)
) c on a.loan_skey=c.loan_skey and a.sn!=c.cell_phone_number
where a.sn not like '' 
)a where [Cell Phone 1] is not null
)b where rn=1;

IF OBJECT_ID('tempdb..#rtemp') IS NOT NULL
    DROP TABLE #rtemp;
select 
a.[loan_skey],a.[loan_sub_status],a.[investor_name],a.[loan_status_description],a.CONTACTTYPE1,
a.CONTACTFIRSTNAME1,a.CONTACTLASTNAME1,a.[Property Address1],a.[Property Address2],
a.[Property City],a.[Property State],a.[Property Zip],a.[Mailing Address 1],a.[Mailing Address 2]
,a.[Mailing City],a.[Mailing State],a.[Mailing Zip]
,a.HOMEPHONE1,
case 
when (a.[Property State] in('WA','MA') or a.[Mailing State] in ('WA','MA'))
and a.loan_skey=b.loan_skey
and a.CONTACTTYPE1 in('Borrower','Co-Borrower')
and a.CELLPHONE1=b.[Cell Phone 1] and a.HOMEPHONE1='' then b.[Cell Phone 1]
else a.CELLPHONE1
end as CELLPHONE1,
a.[Work Phone #],a.[alert_type_description],
a.[alert_status_description],
a.[Priority]
into #rtemp
from (
select
a.[loan_skey],a.[loan_sub_status],a.[investor_name],a.[loan_status_description],a.CONTACTTYPE1,
a.CONTACTFIRSTNAME1,a.CONTACTLASTNAME1,a.[Property Address1],a.[Property Address2],
a.[Property City],a.[Property State],a.[Property Zip],a.[Mailing Address 1],a.[Mailing Address 2]
,a.[Mailing City],a.[Mailing State],a.[Mailing Zip],
case when (a.[Property State] in('WA','MA') or a.[Mailing State] in ('WA','MA'))
and a.loan_skey=b.loan_skey
and a.CONTACTTYPE1 in('Borrower','Co-Borrower')
and a.[HOMEPHONE1] =b.[Home phone 1] and a.[CELLPHONE1] ='' then a.[HOMEPHONE1]
when (a.[Property State] in('WA','MA') or a.[Mailing State] in ('WA','MA')
)
and a.loan_skey=b.loan_skey
and a.CONTACTTYPE1 in('Borrower','Co-Borrower')
and a.[HOMEPHONE1] =b.[Home phone 1] and a.[CELLPHONE1] IS not null  then ''
else  
a.[HOMEPHONE1] end as HOMEPHONE1,
a.[CELLPHONE1],
a.[Work Phone #],
a.[alert_type_description],
a.[alert_status_description],
a.[Priority]
 from #rtemp12 a
 left  join #temp_home_phone b on a.loan_skey=b.loan_skey and a.[HOMEPHONE1] =b.[Home phone 1]
 --where (a.[Property State] in ('WA','MA') or a.[Mailing State] in ('WA','MA')) 
 )a 
 left join #temp_cell_phone b on a.loan_skey=b.loan_skey and a.CELLPHONE1 =b.[Cell Phone 1]
-- where (a.[Property State] in ('WA','MA') or a.[Mailing State] in ('WA','MA'))
/*)a
 left join #temp_home_phone b on a.loan_skey=b.loan_skey and a.[HOMEPHONE1] =b.[Home phone 1]
 
 and 
 */








--select distinct loan_skey,loan_status_description  from #rtemp  order by loan_status_description where loan_skey = '43270' order by Priority;

delete from #rtemp where Priority is null;
/*
delete  from #rtemp where loan_skey  in(
select loan_skey from [ReverseQuest].[rms].[v_Alert]
where alert_type_description  in ('Borrower Represented by Attorney'
)
and alert_status_description = 'Active')
and CONTACTTYPE1 in ('Borrower','Co-Borrower','Attorney')
*/

 delete from #rtemp where loan_skey  in(
select loan_skey from [ReverseQuest].[rms].v_ContactMaster
where contact_type_description  in ('Attorney')
)

delete from #rtemp where loan_skey  in(
select loan_skey--,loan_sub_status_description
from rms.v_LoanMaster 
where loan_sub_status_description in('FCL Sale - 3rd Party','FCL- 3rd Party Sale- Funds Pending')
)

  delete from #rtemp where loan_skey  in(
  select loan_skey from(
select distinct x.loan_skey,workflow_task_description,x.status_description,loan_status_description,complete_date
 from (
SELECT b.loan_skey, a.workflow_instance_skey,a.complete_date,
a.workflow_task_description,b.status_description
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
	join [ReverseQuest].[rms].[v_WorkflowInstance] b
on a.workflow_instance_skey=b.workflow_instance_skey
  where (a.workflow_task_description = 'Receipt of Short Sale Closing Proceeds' 
  or a.workflow_task_description = 'Receipt of Family Sale Proceeds' or 
	a.workflow_task_description = 'Receipt of Executed Deed -Instruct Attorney to record')
  and b.status_description = 'Active' and a.complete_date is not null
  ) x
  join
	(
	select loan_skey,loan_status_description from
	reversequest.rms.v_LoanMaster 
	where loan_status_description not in ('Inactive','Deleted')
	)y
on x.loan_skey=y.loan_skey
) m
);


IF OBJECT_ID('tempdb..#rtemp1') IS NOT NULL
    DROP TABLE #rtemp1;
select * into #rtemp1 from 
(select ROW_NUMBER() OVER (PARTITION BY loan_skey ORDER BY priority) rn,* from #rtemp) q
WHERE   rn = 1
order by loan_skey

--select * from #rtemp1 where loan_skey = '43623' order by Priority;

delete from #rtemp1 where loan_skey  in(
select loan_skey from [ReverseQuest].[rms].[v_Alert]
where alert_type_description  in ('FDCPA -  Call Restrictions','Cease and Desist',
'Pending Cease and Desist','Cease and Desist-Calls',
'Litigation -  Proceed','LITIGATION - Lawsuit Pending',
'DVN Research Request Pend'
,'SKPADD','SKPEML','SKPEXH','SKPTRC','Identity Theft','Fraud Suspicion','DVN Research Request Pend','North Carolina emergency declaration'
)
and alert_status_description = 'Active')

delete  from #rtemp1 
where loan_skey in
(select a.loan_skey from reversequest.rms.v_note a
where a.created_date
>= DATEADD(d,-6,DATEDIFF(d,0,GETDATE())) and
a.created_date < DATEADD(d,1,DATEDIFF(d,0,GETDATE()))
and a.note_type_description like 'Contact - RPC' and a.created_by in ('Vishnu V Thannickal','Mohit Gandhi')
);

delete from #rtemp1 
where loan_skey in
(select a.loan_skey from reversequest.rms.v_note a
where a.created_date
>= DATEADD(d,-7,DATEDIFF(d,0,GETDATE())) and
a.created_date < DATEADD(d,0,DATEDIFF(d,0,GETDATE()))
and a.note_type_description like 'Contact - RPC' and a.created_by not in ('Vishnu V Thannickal','Mohit Gandhi')
);

delete from #rtemp1 where loan_skey  in
(select b.loan_skey
  --,a.workflow_instance_skey,a.complete_date
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a join [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
  where a.workflow_task_description ='3rd Party Sale'
  and a.complete_date is not null);

  --select * from #rtemp where loan_skey = '88061' order by Priority;
  --select * from #rtemp1 where Priority is null;
  --delete from #rtemp where Priority is null;

  delete  from #rtemp1 where loan_skey in(
SELECT  [loan_skey]      
  FROM [ReverseQuest].[rms].[v_WorkflowInstance] a 
  join ReverseQuest.rms.v_WorkflowTaskActivity  b on a.workflow_instance_skey=b.workflow_instance_skey 
where workflow_type_description like 'Due & Payable w/ HUD Approval' and a.status_description='Active' and 
    b.workflow_task_description like 'Request to Rescind D&P'  and b.status_description='Active');

delete from #rtemp1  where loan_skey in(
SELECT  [loan_skey]      
  FROM [ReverseQuest].[rms].[v_WorkflowInstance] a 
  join ReverseQuest.rms.v_WorkflowTaskActivity  b on a.workflow_instance_skey=b.workflow_instance_skey 
  where workflow_type_description = 'Foreclosure - Judicial' and a.status_description='Active'
  and b.workflow_task_description = 'Send Rescission Request to HUD' and b.status_description='Active');
  
  delete from #rtemp1 where loan_skey in(
  SELECT  [loan_skey]      
  FROM [ReverseQuest].[rms].[v_WorkflowInstance] a 
  join ReverseQuest.rms.v_WorkflowTaskActivity  b on a.workflow_instance_skey=b.workflow_instance_skey 
  where  workflow_type_description like 'Foreclosure - Non Judicial' and a.status_description='Active'
  and b.workflow_task_description = 'Send Rescission Request to HUD' and b.status_description='Active')
  

delete from #rtemp1 where loan_skey in(select loan_skey from(
select distinct x.loan_skey,workflow_task_description,x.status_description,loan_status_description,complete_date
 from (
SELECT b.loan_skey, a.workflow_instance_skey,a.complete_date,
a.workflow_task_description,b.status_description
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
	join [ReverseQuest].[rms].[v_WorkflowInstance] b
on a.workflow_instance_skey=b.workflow_instance_skey
  where (a.workflow_task_description = 'Receipt of Short Sale Closing Proceeds' 
  or a.workflow_task_description = 'Receipt of Family Sale Proceeds' or 
	a.workflow_task_description = 'Receipt of Executed Deed -Instruct Attorney to record')
  and a.status_description = 'Active' and a.complete_date is not null
  ) x
  join
	(
	select loan_skey,loan_status_description from
	reversequest.rms.v_LoanMaster 
	where loan_status_description not in ('Inactive','Deleted')
	)y
on x.loan_skey=y.loan_skey
) m
);







IF OBJECT_ID('tempdb..#rtemp2') IS NOT NULL
    DROP TABLE #rtemp2;
select a.*
,e.default_reason as 'default reason'
,e.created_date 
into #rtemp2
from
#rtemp1 a
left join reversequest.rms.v_MonthlyLoanDefaultSummary e
on a.loan_skey=e.loan_skey;

--select  * from #rtemp3 where loan_skey = '46836';

  
 /* delete from #rtemp2
where loan_skey in
(select a.loan_skey from reversequest.rms.v_note a
where a.created_date
>= DATEADD(d,-7,DATEDIFF(d,0,GETDATE())) and
a.created_date < DATEADD(d,0,DATEDIFF(d,0,GETDATE()))
and (a.note_type_description like '%Incom%' or note_type_description like 'Spoc Incom%'));*/

IF OBJECT_ID('tempdb..#rtemp3') IS NOT NULL
    DROP TABLE #rtemp3;
select 
a.loan_skey,a.loan_sub_status,a.investor_name,
b.CONTACTTYPE1,b.CONTACTFIRSTNAME1,b.CONTACTLASTNAME1,a.[Property Address1]
,a.[Property Address2], a.[Property City],a.[Property State],a.[Property Zip],b.[Mailing Address 1]
,b.[Mailing Address 2],b.[Mailing City],b.[Mailing State],b.[Mailing Zip]
,b.HOMEPHONE1,b.CELLPHONE1, b.[Work Phone #],a.[default reason],a.loan_status_description 
into #rtemp3
from (
select loan_skey,loan_sub_status,investor_name
--,loan_status_description,
,CONTACTTYPE1,CONTACTFIRSTNAME1,CONTACTLASTNAME1,[Property Address1]
,[Property Address2], [Property City],[Property State],[Property Zip],[Mailing Address 1],[Mailing Address 2],[Mailing City],[Mailing State],[Mailing Zip]
,HOMEPHONE1,CELLPHONE1, [Work Phone #] 
--,alert_type_description
,[default reason],loan_status_description
--,Priority 
from 
(select ROW_NUMBER() OVER (PARTITION BY loan_skey ORDER BY priority,created_date desc) rownum,* from #rtemp2) x
WHERE  
rownum = 1 and 
Priority is not null 
--and loan_skey = '89192'
) a 
left join (
select loan_skey,loan_sub_status,investor_name
--,loan_status_description,
,CONTACTTYPE1,CONTACTFIRSTNAME1,CONTACTLASTNAME1,[Property Address1]
,[Property Address2], [Property City],[Property State],[Property Zip],[Mailing Address 1],[Mailing Address 2],[Mailing City],[Mailing State],[Mailing Zip]
,HOMEPHONE1,CELLPHONE1, [Work Phone #] 
--,alert_type_description
,[default reason],loan_status_description
--,Priority 
from 
(select ROW_NUMBER() OVER (PARTITION BY loan_skey ORDER BY priority,created_date desc) rownum,* from #rtemp2) x
WHERE  
rownum = 1 and 
Priority is not null 
and CONTACTTYPE1 in ('Borrower','Co-Borrower','Authorized Party','Legal Owner')
--and loan_skey = '89192'

)b on a.loan_skey=b.loan_skey
--order by loan_skey,alert_type_description;

--update #rtemp3 set HOMEPHONE1='',CELLPHONE1=''where CONTACTTYPE1 = 'Attorney';

alter table  #rtemp3
add 
CONTACTTYPE2 NVARCHAR(100),
CONTACTFIRSTNAME2 NVARCHAR(200),
CONTACTLASTNAME2 NVARCHAR(200),
HOMEPHONE2 NVARCHAR(20),
CELLPHONE2 NVARCHAR(20),
CONTACTTYPE3 NVARCHAR(100),
CONTACTFIRSTNAME3 NVARCHAR(200),
CONTACTLASTNAME3 NVARCHAR(200),
HOMEPHONE3 NVARCHAR(20),
CELLPHONE3 NVARCHAR(20),
CONTACTTYPE4 NVARCHAR(100),
CONTACTFIRSTNAME4 NVARCHAR(200),
CONTACTLASTNAME4 NVARCHAR(200),
HOMEPHONE4 NVARCHAR(20),
CELLPHONE4 NVARCHAR(20),
MAILINGSTATE2 NVARCHAR(20),
MAILINGZIP2 NVARCHAR(20),
MAILINGSTATE3 NVARCHAR(20),
MAILINGZIP3 NVARCHAR(20),
MAILINGSTATE4 NVARCHAR(20),
MAILINGZIP4 NVARCHAR(20)
;

IF OBJECT_ID('tempdb..#tmpContacts') IS NOT NULL
    DROP TABLE #tmpContacts;
select distinct loan_skey,loan_sub_status,investor_name,CONTACTTYPE1,CONTACTFIRSTNAME1,CONTACTLASTNAME1,HOMEPHONE1,CELLPHONE1,[Mailing State],[Mailing Zip],Priority
into #tmpContacts
from #rtemp;

delete a from #tmpContacts a
join  #rtemp3 b on a.loan_skey=b.loan_skey and a.CONTACTFIRSTNAME1=b.CONTACTFIRSTNAME1 and a.CONTACTLASTNAME1=b.CONTACTLASTNAME1;

update a set a.CONTACTTYPE2 = b.CONTACTTYPE1,
a.CONTACTFIRSTNAME2=b.CONTACTFIRSTNAME1,
a.CONTACTLASTNAME2=b.CONTACTLASTNAME1,
a.HOMEPHONE2 = b.HOMEPHONE1,
a.CELLPHONE2=b.CELLPHONE1,
a.MAILINGSTATE2=b.[Mailing State],
a.MAILINGZIP2=b.[Mailing Zip]
from #rtemp3 a
join
(select loan_skey,CONTACTTYPE1,CONTACTFIRSTNAME1,CONTACTLASTNAME1,HOMEPHONE1,CELLPHONE1,[Mailing State],[Mailing Zip],priority
from (select loan_skey,CONTACTTYPE1,CONTACTFIRSTNAME1,CONTACTLASTNAME1,HOMEPHONE1,CELLPHONE1,[Mailing State],[Mailing Zip],priority,
row_number() over(partition by loan_skey order by priority) as crn
from #tmpContacts) T where crn=1 and CONTACTTYPE1 in ('Borrower','Co-Borrower','Authorized Party','Legal Owner')
) b
on a.loan_skey=b.loan_skey;


delete a from #tmpContacts a
join #rtemp3 b on a.loan_skey=b.loan_skey and a.CONTACTFIRSTNAME1=b.CONTACTFIRSTNAME2 and a.CONTACTLASTNAME1=b.CONTACTLASTNAME2;

update a set a.CONTACTTYPE3 = b.CONTACTTYPE1,
a.CONTACTFIRSTNAME3=b.CONTACTFIRSTNAME1,
a.CONTACTLASTNAME3=b.CONTACTLASTNAME1,
a.HOMEPHONE3 = b.HOMEPHONE1,
a.CELLPHONE3=b.CELLPHONE1,
a.MAILINGSTATE3=b.[Mailing State],
a.MAILINGZIP3=b.[Mailing Zip]
from #rtemp3 a
join
(select loan_skey,CONTACTTYPE1,CONTACTFIRSTNAME1,CONTACTLASTNAME1,HOMEPHONE1,CELLPHONE1,[Mailing State],[Mailing Zip],priority
from (select loan_skey,CONTACTTYPE1,CONTACTFIRSTNAME1,CONTACTLASTNAME1,HOMEPHONE1,CELLPHONE1,[Mailing State],[Mailing Zip],priority,
row_number() over(partition by loan_skey order by priority) as crn
from #tmpContacts) T where crn=1 and CONTACTTYPE1 in ('Borrower','Co-Borrower','Authorized Party','Legal Owner')
) b
on a.loan_skey=b.loan_skey;

delete a from #tmpContacts a
join #rtemp3 b on a.loan_skey=b.loan_skey and a.CONTACTFIRSTNAME1=b.CONTACTFIRSTNAME3 and a.CONTACTLASTNAME1=b.CONTACTLASTNAME3;

update a set a.CONTACTTYPE4 = b.CONTACTTYPE1,
a.CONTACTFIRSTNAME4=b.CONTACTFIRSTNAME1,
a.CONTACTLASTNAME4=b.CONTACTLASTNAME1,
a.HOMEPHONE4 = b.HOMEPHONE1,
a.CELLPHONE4=b.CELLPHONE1,
a.MAILINGSTATE4=b.[Mailing State],
a.MAILINGZIP4=b.[Mailing Zip]
from #rtemp3 a
join
(select loan_skey,CONTACTTYPE1,CONTACTFIRSTNAME1,CONTACTLASTNAME1,HOMEPHONE1,CELLPHONE1,[Mailing State],[Mailing Zip],priority
from (select loan_skey,CONTACTTYPE1,CONTACTFIRSTNAME1,CONTACTLASTNAME1,HOMEPHONE1,CELLPHONE1,[Mailing State],[Mailing Zip],priority,
row_number() over(partition by loan_skey order by priority) as crn
from #tmpContacts) T where crn=1 and CONTACTTYPE1 not in ('Borrower','Co-Borrower','Authorized Party','Legal Owner')
) b
on a.loan_skey=b.loan_skey;

update #rtemp3 
set 
investor_name=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(investor_name, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
loan_sub_status= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(loan_sub_status, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTTYPE1= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTTYPE1, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTFIRSTNAME1=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTFIRSTNAME1, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTLASTNAME1= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTLASTNAME1, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
[Property Address1]= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([Property Address1], '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
[Property Address2] = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([Property Address2], '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
[Mailing Address 1]= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([Mailing Address 1], '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
[Mailing Address 2] = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([Mailing Address 2], '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTTYPE2= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTTYPE2, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTFIRSTNAME2= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTFIRSTNAME2, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTLASTNAME2 =REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTLASTNAME2, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTTYPE3= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTTYPE3, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTFIRSTNAME3=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTFIRSTNAME3, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTLASTNAME3=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTLASTNAME3, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTTYPE4=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTTYPE4, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTFIRSTNAME4=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTFIRSTNAME4, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTLASTNAME4=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTLASTNAME4, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿','')

/*
IF OBJECT_ID('tempdb..#tmpLoankey_1_10_23') IS NOT NULL
    DROP TABLE #tmpLoankey_1_10_23;
select * 
into #tmpLoankey_1_10_23
from
(

select 254334 as Loan_skey union all

)X */

--------------------------------IBOB Priority------------------------------------------



IF OBJECT_ID('tempdb..#rtemp11') IS NOT NULL
    DROP TABLE #rtemp11;
select a1.*,
case when CAST (a1.[TOTAL Calls] as int)=0 then 1 
  when CAST (a1.[TOTAL Calls] as int)=1 then 2
   when CAST (a1.[TOTAL Calls] as int)=2 then 3
    when CAST (a1.[TOTAL Calls] as int)>=3 then 4 end as 'PRIORITY'
	into #rtemp11
from
(select a.loan_skey,
/*CAST ((select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.loan_skey and( note_type_description like '%Incom%'  or  note_type_description like 'Spoc Incom%')
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 25, GETDATE()), 0)) AS INT) as 'Inbound Calls in 25 days',
CAST((select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.loan_skey and( note_type_description like 'Spoc Incom%'  or  note_type_description like 'Spoc Incom%')
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 25, GETDATE()), 0)) AS INT) as 'Spoc Inbound Calls in 25 days',*/
CAST((select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.loan_skey and( note_type_description like '%Outgoing%'  
-- or  note_type_description like 'Spoc Incom%'
  )
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 25, GETDATE()), 0))AS INT) as 'Outbound Calls in 25 days',
CAST((select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.loan_skey and( note_type_description like 'Spoc Outgoing%'  
-- or  note_type_description like 'Spoc Incom%'
  )
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 25, GETDATE()), 0))AS INT) as 'Spoc Outbound Calls in 25 days',
Convert(int,/*(select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.loan_skey and( note_type_description like '%Incom%'  or  note_type_description like 'Spoc Incom%')
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 25, GETDATE()), 0)) +
(select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.loan_skey and( note_type_description like 'Spoc Incom%'  or  note_type_description like 'Spoc Incom%')
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 25, GETDATE()), 0))+*/
(select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.loan_skey and( note_type_description like '%Outgoing%'  
-- or  note_type_description like 'Spoc Incom%'
  )
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 25, GETDATE()), 0)) +
(select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.loan_skey and( note_type_description like 'Spoc Outgoing%'  
-- or  note_type_description like 'Spoc Incom%'
  )
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 25, GETDATE()), 0)) ) 'TOTAL Calls'
  from #rtemp3 a) a1
  order by [TOTAL Calls]


 --LM

  IF OBJECT_ID('tempdb..#rtemp121') IS NOT NULL
    DROP TABLE #rtemp121;
select loan_skey,count(loan_skey) as LMCount,
case when count(loan_skey) <=1 then '1'
 when count(loan_skey) =2 then '2'
 when count(loan_skey) >=3 then '3' else '1' end
as "LMPRIORITY" 
into #rtemp121
from (
/*select  loan_skey,note_type_description,
note_text
,(CONVERT(varchar, CONVERT(datetime, replace(replace(rtrim(ltrim(substring(note_text,CHARINDEX('I_', note_text)+2,28))),'.',':'),'000000','00')),21))  as created_date
--,created_date
,created_by
from rms.v_Note where --loan_skey=245751 and 
note_text like '%Left Message Machine%'
and note_type_description='SPOC Outgoing Dialer'
and created_date >=    GETDATE()-25
and note_text  like 'OB_REV_%'
and note_text not like '%HCI__Invalid Phone Number%'
and note_text not like '%MANUAL_%'
union all
*/
select  loan_skey,note_type_description,
note_text
--,(CONVERT(varchar, CONVERT(datetime, replace(replace(rtrim(ltrim(substring(note_text,CHARINDEX('I_', note_text)+2,28))),'.',':'),'000000','00')),21))  as notetext_date
,created_date,created_by
from rms.v_Note where --loan_skey=245751 and 
(note_text like '%Left voicemail%' or note_text like '%Left VM%' or note_text like '%Left vm%' 
or note_text like '%Message Left%' or note_text like '%message Left%' or note_text like '%Left message%'
or note_text like '%VM left%' or note_text like '%Voicemail Left%'
)
--and note_type_description='SPOC Outgoing No Contact Estab'
and created_date >=    GETDATE()-25
) a
--where loan_skey=245751
group by loan_skey--,note_type_description,note_text,created_date,created_by
--order by created_date

--select * from #rtemp12 order by loan_skey


IF OBJECT_ID('tempdb..#finalDefault1') IS NOT NULL
    DROP TABLE #finalDefault1;
select loan_skey,loan_sub_status,investor_name,CONTACTTYPE1,CONTACTFIRSTNAME1,CONTACTLASTNAME1,
[Property Address1],[Property Address2],[Property City],[Property State],[Property Zip],[Mailing Address 1],
[Mailing Address 2],[Mailing City],[Mailing State],[Mailing Zip],
RTRIM(LTRIM(HOMEPHONE1)) HOMEPHONE1,
case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end as CELLPHONE1,
[Work Phone #],[default reason],
--CALLLIST,
CONTACTTYPE2,CONTACTFIRSTNAME2,CONTACTLASTNAME2,
case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end as HOMEPHONE2 ,

case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end as  CELLPHONE2,
CONTACTTYPE3,CONTACTFIRSTNAME3,CONTACTLASTNAME3,

case when rtrim(ltrim(HOMEPHONE3))=RTRIM(LTRIM(HOMEPHONE1))  or 
rtrim(ltrim(HOMEPHONE3))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end)
then '' else RTRIM(LTRIM(HOMEPHONE3)) end as HOMEPHONE3,

case when rtrim(ltrim(CELLPHONE3))=(RTRIM(LTRIM(HOMEPHONE1))) or 
rtrim(ltrim(CELLPHONE3))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end) or
rtrim(ltrim(CELLPHONE3))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) or
rtrim(ltrim(CELLPHONE3))=(case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end) or
RTRIM(LTRIM(CELLPHONE3))=(case when rtrim(ltrim(HOMEPHONE3))=RTRIM(LTRIM(HOMEPHONE1))  or 
rtrim(ltrim(HOMEPHONE3))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end)
then '' else RTRIM(LTRIM(HOMEPHONE3)) end)
then '' else RTRIM(LTRIM(CELLPHONE3)) end as CELLPHONE3,

CONTACTTYPE4,CONTACTFIRSTNAME4,CONTACTLASTNAME4,

case when rtrim(ltrim(HOMEPHONE4)) =(RTRIM(LTRIM(HOMEPHONE1))) or 
rtrim(ltrim(HOMEPHONE4)) =(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end) or 
rtrim(ltrim(HOMEPHONE4)) =(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) or 
rtrim(ltrim(HOMEPHONE4)) =(case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end) or 
rtrim(ltrim(HOMEPHONE4)) =(case when rtrim(ltrim(HOMEPHONE3))=RTRIM(LTRIM(HOMEPHONE1))  or 
rtrim(ltrim(HOMEPHONE3))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end)
then '' else RTRIM(LTRIM(HOMEPHONE3)) end) or 
rtrim(ltrim(HOMEPHONE4))=(case when rtrim(ltrim(CELLPHONE3))=(RTRIM(LTRIM(HOMEPHONE1))) or 
rtrim(ltrim(CELLPHONE3))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end) or
rtrim(ltrim(CELLPHONE3))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) or
rtrim(ltrim(CELLPHONE3))=(case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end) or
RTRIM(LTRIM(CELLPHONE3))=(case when rtrim(ltrim(HOMEPHONE3))=RTRIM(LTRIM(HOMEPHONE1))  or 
rtrim(ltrim(HOMEPHONE3))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end)
then '' else RTRIM(LTRIM(HOMEPHONE3)) end)
then '' else RTRIM(LTRIM(CELLPHONE3)) end)
then '' else rtrim(ltrim(HOMEPHONE4)) end as  HOMEPHONE4,

case when rtrim(ltrim(CELLPHONE4))= (RTRIM(LTRIM(HOMEPHONE1))) or 
rtrim(ltrim(CELLPHONE4))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end) or 
rtrim(ltrim(CELLPHONE4))= (case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) or 
rtrim(ltrim(CELLPHONE4))= (case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end) or
rtrim(ltrim(CELLPHONE4))= (case when rtrim(ltrim(HOMEPHONE3))=RTRIM(LTRIM(HOMEPHONE1))  or 
rtrim(ltrim(HOMEPHONE3))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end)
then '' else RTRIM(LTRIM(HOMEPHONE3)) end) or 
rtrim(ltrim(CELLPHONE4))= (case when rtrim(ltrim(CELLPHONE3))=(RTRIM(LTRIM(HOMEPHONE1))) or 
rtrim(ltrim(CELLPHONE3))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end) or
rtrim(ltrim(CELLPHONE3))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) or
rtrim(ltrim(CELLPHONE3))=(case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end) or
RTRIM(LTRIM(CELLPHONE3))=(case when rtrim(ltrim(HOMEPHONE3))=RTRIM(LTRIM(HOMEPHONE1))  or 
rtrim(ltrim(HOMEPHONE3))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end)
then '' else RTRIM(LTRIM(HOMEPHONE3)) end)
then '' else RTRIM(LTRIM(CELLPHONE3)) end) or 
rtrim(ltrim(CELLPHONE4))= (case when rtrim(ltrim(HOMEPHONE4)) =(RTRIM(LTRIM(HOMEPHONE1))) or 
rtrim(ltrim(HOMEPHONE4)) =(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end) or 
rtrim(ltrim(HOMEPHONE4)) =(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) or 
rtrim(ltrim(HOMEPHONE4)) =(case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end) or 
rtrim(ltrim(HOMEPHONE4)) =(case when rtrim(ltrim(HOMEPHONE3))=RTRIM(LTRIM(HOMEPHONE1))  or 
rtrim(ltrim(HOMEPHONE3))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end)
then '' else RTRIM(LTRIM(HOMEPHONE3)) end) or 
rtrim(ltrim(HOMEPHONE4))=(case when rtrim(ltrim(CELLPHONE3))=(RTRIM(LTRIM(HOMEPHONE1))) or 
rtrim(ltrim(CELLPHONE3))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end) or
rtrim(ltrim(CELLPHONE3))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) or
rtrim(ltrim(CELLPHONE3))=(case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end) or
RTRIM(LTRIM(CELLPHONE3))=(case when rtrim(ltrim(HOMEPHONE3))=RTRIM(LTRIM(HOMEPHONE1))  or 
rtrim(ltrim(HOMEPHONE3))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end)
then '' else RTRIM(LTRIM(HOMEPHONE3)) end)
then '' else RTRIM(LTRIM(CELLPHONE3)) end)
then '' else rtrim(ltrim(HOMEPHONE4)) end) 
then '' else rtrim(ltrim(CELLPHONE4)) end as CELLPHONE4,
MAILINGSTATE2,
MAILINGZIP2,
MAILINGSTATE3,
MAILINGZIP3,
MAILINGSTATE4,
MAILINGZIP4,loan_status_description
into #finalDefault1
 from #rtemp3

 --select * from #rtemp3;
 --
 --select loan_status_description from #finalDefault1


 ------update for HOMEPHONE 2

update #finalDefault1 set HOMEPHONE2='' ,[CELLPHONE2] = '' where [Property State] in ('WA','MA')
and [CONTACTTYPE2] like 'CoBorrower' and [HOMEPHONE1] not in('') and [CELLPHONE1] not in('');

update #finalDefault1 set HOMEPHONE2='' ,[CELLPHONE2] = '' where [MAILINGSTATE2] in ('WA','MA')
and [CONTACTTYPE2] like 'CoBorrower' and [HOMEPHONE1] not in('') and [CELLPHONE1] not in('');

------update for CELLPHONE 2

update #finalDefault1 set [CELLPHONE2] = '' where [Property State] in ('WA','MA')
and [CONTACTTYPE2] like 'CoBorrower' and [HOMEPHONE1]  in('') and [CELLPHONE1] not in('') and HOMEPHONE2 not in('') ;

update #finalDefault1 set [CELLPHONE2] = '' where [MAILINGSTATE2] in ('WA','MA')
and [CONTACTTYPE2] like 'CoBorrower' and [HOMEPHONE1]  in('') and [CELLPHONE1] not in('') and HOMEPHONE2 not in('') ;

update #finalDefault1 set [CELLPHONE2] = '' where [Property State] in ('WA','MA')
and [CONTACTTYPE2] like 'CoBorrower' and [HOMEPHONE1] not in('')  and [CELLPHONE1] in('') and HOMEPHONE2 not in('') ;

update #finalDefault1 set [CELLPHONE2] = '' where [MAILINGSTATE2] in ('WA','MA')
and [CONTACTTYPE2] like 'CoBorrower' and [HOMEPHONE1] not in('')  and [CELLPHONE1] in('') and HOMEPHONE2 not in('') ;

update #finalDefault1 set [CELLPHONE2] = '' where [Property State] in ('WA','MA')
and [CONTACTTYPE2] like 'CoBorrower' and [HOMEPHONE1] not in('')  and [CELLPHONE1] in(NULL) and HOMEPHONE2 not in('') ;

update #finalDefault1 set [CELLPHONE2] = '' where [MAILINGSTATE2] in ('WA','MA')
and [CONTACTTYPE2] like 'CoBorrower' and [HOMEPHONE1] not in('')  and [CELLPHONE1] in(NULL) and HOMEPHONE2 not in('') ;


-------update for HOMEPHONE3---------
update #finalDefault1 set HOMEPHONE3 = '' where [Property State] in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1] not in('') and [CELLPHONE1] not in('') and HOMEPHONE2 in('') and [CELLPHONE2] in('') ;

update #finalDefault1 set HOMEPHONE3 = '' where [Property State] in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1] not in('') and [CELLPHONE1]  in('') and HOMEPHONE2  not in('') and [CELLPHONE2] in('') ;

update #finalDefault1 set HOMEPHONE3 = '' where [Property State] in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1] not in('') and [CELLPHONE1] in('') and HOMEPHONE2 in('') and [CELLPHONE2] not in('') ;

update #finalDefault1 set HOMEPHONE3 = '' where [Property State] in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1] not in('') and [CELLPHONE1] in('') and HOMEPHONE2 not in('') and [CELLPHONE2] not in('') ;
--
update #finalDefault1 set HOMEPHONE3 = '' where [MAILINGSTATE3] in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1] not in('') and [CELLPHONE1] not in('') and HOMEPHONE2 in('') and [CELLPHONE2] in('') ;

update #finalDefault1 set HOMEPHONE3 = '' where [MAILINGSTATE3] in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1] not in('') and [CELLPHONE1]  in('') and HOMEPHONE2  not in('') and [CELLPHONE2] in('') ;

update #finalDefault1 set HOMEPHONE3 = '' where [MAILINGSTATE3] in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1] not in('') and [CELLPHONE1] in('') and HOMEPHONE2 in('') and [CELLPHONE2] not in('') ;

update #finalDefault1 set HOMEPHONE3 = '' where [MAILINGSTATE3] in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1] not in('') and [CELLPHONE1] in('') and HOMEPHONE2 not in('') and [CELLPHONE2] not in('') ;


--------update for CELLPHONE3--
update #finalDefault1 set CELLPHONE3 = '' where [Property State] in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1] not in('') and [CELLPHONE1] not in('') and HOMEPHONE2 in('') and [CELLPHONE2] in('') and HOMEPHONE3 in ('');

update #finalDefault1 set CELLPHONE3 = '' where [Property State] in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1]  in('') and [CELLPHONE1] not in('') and HOMEPHONE2 not in('') and [CELLPHONE2] in('') and HOMEPHONE3 in ('');

update #finalDefault1 set CELLPHONE3 = '' where [Property State] in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1]  in('') and [CELLPHONE1]  in('') and HOMEPHONE2 not in('') and [CELLPHONE2] not in('') and HOMEPHONE3 in ('');

update #finalDefault1 set CELLPHONE3 = '' where [Property State] in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1]  in('') and [CELLPHONE1]  in('') and HOMEPHONE2  in('') and [CELLPHONE2] not in('') and HOMEPHONE3 not in ('');

update #finalDefault1 set CELLPHONE3 = '' where [Property State] in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1]  not in('') and [CELLPHONE1]  in('') and HOMEPHONE2 not in('') and [CELLPHONE2] in('') and HOMEPHONE3 in ('');

update #finalDefault1 set CELLPHONE3 = '' where [Property State] in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1]  in('') and [CELLPHONE1]  in('') and HOMEPHONE2 not in('') and [CELLPHONE2] not in('') and HOMEPHONE3 in ('');

----
update #finalDefault1 set CELLPHONE3 = '' where MAILINGSTATE3 in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1] not in('') and [CELLPHONE1] not in('') and HOMEPHONE2 in('') and [CELLPHONE2] in('') and HOMEPHONE3 in ('');

update #finalDefault1 set CELLPHONE3 = '' where MAILINGSTATE3 in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1]  in('') and [CELLPHONE1] not in('') and HOMEPHONE2 not in('') and [CELLPHONE2] in('') and HOMEPHONE3 in ('');

update #finalDefault1 set CELLPHONE3 = '' where MAILINGSTATE3 in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1]  in('') and [CELLPHONE1]  in('') and HOMEPHONE2 not in('') and [CELLPHONE2] not in('') and HOMEPHONE3 in ('');

update #finalDefault1 set CELLPHONE3 = '' where MAILINGSTATE3 in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1]  in('') and [CELLPHONE1]  in('') and HOMEPHONE2  in('') and [CELLPHONE2] not in('') and HOMEPHONE3 not in ('');

update #finalDefault1 set CELLPHONE3 = '' where MAILINGSTATE3 in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1]  not in('') and [CELLPHONE1]  in('') and HOMEPHONE2 not in('') and [CELLPHONE2] in('') and HOMEPHONE3 in ('');

update #finalDefault1 set CELLPHONE3 = '' where MAILINGSTATE3 in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1]  in('') and [CELLPHONE1]  in('') and HOMEPHONE2 not in('') and [CELLPHONE2] not in('') and HOMEPHONE3 in ('');




 --delete from #finalDefault1 where investor_name in('FNMA','MECA 2011')



----CS Format------
select a.loan_skey as LOANSKEY,loan_sub_status as LOANSUBSTATUS, investor_name as INVESTORNAME,CONTACTTYPE1 as CONTACTTYPE1
,coalesce(CONTACTFIRSTNAME1,'No Data') as CONTACTFIRSTNAME1,coalesce(CONTACTLASTNAME1,'No Data') as CONTACTLASTNAME1,[Property Address1] as PROPERTYADDRESS1
,[Property Address2] as PROPERTYADDRESS2,[Property City] as PROPERTYCITY,[Property State] as PROPERTYSTATE,[Property Zip] as PROPERTYZIP
,[Mailing Address 1] as MAILINGADDRESS1,[Mailing Address 2] as MAILINGADDRESS2, [Mailing City] as MAILINGCITY,[Mailing State] as MAILINGSTATE
,[Mailing Zip] as MAILINGZIP,HOMEPHONE1 as HOMEPHONE1, CELLPHONE1 as CELLPHONE1,
CONTACTTYPE2,CONTACTFIRSTNAME2,CONTACTLASTNAME2,HOMEPHONE2,CELLPHONE2
,CONTACTTYPE3,CONTACTFIRSTNAME3,CONTACTLASTNAME3,HOMEPHONE3,CELLPHONE3
,CONTACTTYPE4,CONTACTFIRSTNAME4,CONTACTLASTNAME4,HOMEPHONE4,CELLPHONE4
,[default reason] as CALLREASON,
case when [Property State] in ('AL','AK','AR','AZ','CA','CO','DE','DC','FL','GA','HI','ID','IL','IN','KS','KY','LA','MD','ME','MA','MI','MN','MO','NM','ND','OH','OK','PA','PR','RI','SD','TN','TX','UT','VT','VA','VI','WV','NY','CT','IA','NV','NH','MT','NE','OR','NC','SC','WA','WI','MS') 
  and investor_name='BAML' then 'RMS_CS_BAML_HOU'
 when [Property State] in ('NJ','WY') and  investor_name='BAML' then 'RMS_CS_BAML_WPB'
  when [Property State]  in ('AL','AK','AR','AZ','CA','CO','DE','DC','FL','GA','HI','ID','IL','IN','KS','KY','LA','MD','ME','MA','MI','MN','MO','NM','ND','OH','OK','PA','PR','RI','SD','TN','TX','UT','VT','VA','VI','WV','NY','WY') then 'RMS_CS_PMC'
 when [Property State] in ('NJ') then 'RMS_CS_WPB' 
  when [Property State] in ('CT','IA','NV','NH','MT','NE','OR','NC','SC','WA','WI','MS') then 'RMS_CS_HOU'
  else NULL end as 'CALLLIST'
 /* case when [Property State] in('AL','AK','AR','AZ','CA','CO','DE','DC','FL','GA','HI','ID','IL','IN','KS','KY','LA','MD','ME','MA','MI','MN','MO','NM','NC','ND','OH','OK','PA','PR','RI','SD','TN','TX','UT','VT','VA','VI','WV') then 'RMS_HRD_ALL'
  when [Property State] in ('NV','NJ','WY') then 'RMS_HRD_WPB'
  when [Property State] in ('CT','IA','MT','NE','NH','OR','SC','WA','WI') then 'RMS_HRD_HOU'
  when [Property State] in ('NY') then 'RMS_HRD_PMC' 
  when [Property State] in ('MS') then 'WFO_RMS_HRD_ONS'
  else null end  as 'CALLLIST'*/
--,loan_status_description
,MAILINGSTATE2,MAILINGZIP2,MAILINGSTATE3,MAILINGZIP3,MAILINGSTATE4,MAILINGZIP4,
case when f.PRIORITY is null then 1 else f.PRIORITY end as 'PRIORITYIBOB',
case when e.LMPRIORITY is null then 1 else e.LMPRIORITY end as 'LMPRIORITY' 
from #finalDefault1 a
   left join #rtemp121 e on a.loan_skey=e.loan_skey
   left join #rtemp11 f on a.loan_skey=f.loan_skey
where a.loan_status_description in ('ACTIVE','Claim')
--and loan_skey not in (select Loan_skey from #tmpLoankey_1_10_23);

----HRD Format------
select a.loan_skey as LOANSKEY,loan_sub_status as LOANSUBSTATUS, investor_name as INVESTORNAME,CONTACTTYPE1 as CONTACTTYPE1
,coalesce(CONTACTFIRSTNAME1,'No Data') as CONTACTFIRSTNAME1,coalesce(CONTACTLASTNAME1,'No Data') as CONTACTLASTNAME1,[Property Address1] as PROPERTYADDRESS1
,[Property Address2] as PROPERTYADDRESS2,[Property City] as PROPERTYCITY,[Property State] as PROPERTYSTATE,[Property Zip] as PROPERTYZIP
,[Mailing Address 1] as MAILINGADDRESS1,[Mailing Address 2] as MAILINGADDRESS2, [Mailing City] as MAILINGCITY,[Mailing State] as MAILINGSTATE
,[Mailing Zip] as MAILINGZIP,HOMEPHONE1 as HOMEPHONE1, CELLPHONE1 as CELLPHONE1,
CONTACTTYPE2,CONTACTFIRSTNAME2,CONTACTLASTNAME2,HOMEPHONE2,CELLPHONE2
,CONTACTTYPE3,CONTACTFIRSTNAME3,CONTACTLASTNAME3,HOMEPHONE3,CELLPHONE3
,CONTACTTYPE4,CONTACTFIRSTNAME4,CONTACTLASTNAME4,HOMEPHONE4,CELLPHONE4
,[default reason] as CALLREASON,
case when [Property State] in ('NY','AL','AK','AR','AZ','CA','CO','DE','DC','FL','GA','HI','ID','IL','IN','KS','KY','LA','MD','ME','MA','MI','MN','MO','NM','ND','OH','OK','PA','PR','RI','SD','TN','TX','UT','VT','VA','VI','WV','CT','IA','MT','NE','NH','OR','SC','WA','WI','NV','NC','MS') 
  and investor_name='BAML' then 'RMS_HRD_BAML_HOU'
 when [Property State] in ('NJ','WY') and investor_name='BAML' then 'RMS_HRD_BAML_WPB'
  when [Property State] in('NY','AL','AK','AR','AZ','CA','CO','DE','DC','FL','GA','HI','ID','IL','IN','KS','KY','LA','MD','ME','MA','MI','MN','MO','NM','ND','OH','OK','PA','PR','RI','SD','TN','TX','UT','VT','VA','VI','WV') then 'RMS_HRD_ALL'
  when [Property State] in ('NJ') then 'RMS_HRD_WPB'
  when [Property State] in ('CT','IA','MT','NE','NH','OR','SC','WA','WI','NV','NC','MS') then 'RMS_HRD_HOU'
  when [Property State] in ('WY') then 'RMS_HRD_PMC' 
  else null end  as 'CALLLIST'
--,loan_status_description
,MAILINGSTATE2,MAILINGZIP2,MAILINGSTATE3,MAILINGZIP3,MAILINGSTATE4,MAILINGZIP4,
case when f.PRIORITY is null then 1 else f.PRIORITY end as 'PRIORITYIBOB',
case when e.LMPRIORITY is null then 1 else e.LMPRIORITY end as 'LMPRIORITY' 
from #finalDefault1 a
   left join #rtemp121 e on a.loan_skey=e.loan_skey
   left join #rtemp11 f on a.loan_skey=f.loan_skey
where loan_status_description in ('FORECLOSURE','DEFAULT')
--and loan_skey not in (select Loan_skey from #tmpLoankey_1_10_23);



