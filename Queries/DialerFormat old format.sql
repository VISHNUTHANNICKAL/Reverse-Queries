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
a.loan_status_description in ('DEFAULT', 'FORECLOSURE','Active','Claim') and
 c.contact_type_description not in('Broker',
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
--and d.alert_status_description = 'Active'
and a.loan_skey in('223926',
'245532',
'209827',
'223366',
'223886',
'223979',
'224436',
'224257',
'313230',
'311843',
'323645',
'282596',
'279304',
'261968',
'264720',
'262531',
'246161',
'279832',
'246597',
'261687',
'263240',
'256168',
'228255',
'228581',
'237120',
'251642',
'224096',
'71477',
'220881',
'319017',
'283191',
'223129',
'222023',
'262533',
'261646',
'222273',
'322866',
'308948',
'284584',
'304131',
'266002',
'263355',
'245060',
'262188',
'264254',
'255813',
'222805',
'223455',
'224581',
'153507',
'224407',
'264470',
'279681',
'222589',
'271959',
'262617',
'322599',
'264075',
'252272',
'226433',
'233898',
'234848',
'251778',
'203905',
'225041',
'223192',
'221849',
'221932',
'221753',
'241000',
'223457',
'305917',
'223189',
'222200',
'277602',
'324337',
'306481',
'273412',
'271819',
'280814',
'270326',
'266903',
'284622',
'265376',
'261657',
'262414',
'263097',
'263564',
'267447',
'229193',
'230883',
'225221',
'222752',
'223395',
'224062',
'221933',
'72613',
'70723',
'141334',
'120086',
'95814',
'100756',
'217272',
'230733',
'223679',
'205287',
'223836',
'223957',
'265178',
'267335',
'323069',
'270920',
'267128',
'263847',
'261717',
'279830',
'258363',
'263109',
'262175',
'228587',
'229724',
'254379',
'254635',
'256137',
'224100',
'186226',
'187063',
'184215',
'68925',
'224710',
'224709',
'267287',
'264192',
'255752',
'315690',
'282658',
'264032',
'238787',
'280212',
'226617',
'205593',
'187880',
'165130',
'50231',
'247218',
'258935',
'223544',
'236489',
'261987',
'246868',
'262319',
'265181',
'251570',
'226754',
'232389',
'221654',
'69973',
'130020',
'42986',
'243645',
'304510',
'259454',
'260480',
'222885',
'323833',
'305783',
'75129',
'271052',
'245957',
'211443',
'250202',
'221668');

--select * from #rtemp where loan_skey = '323907' order by Priority;

delete from #rtemp where Priority is null;

IF OBJECT_ID('tempdb..#rtemp1') IS NOT NULL
    DROP TABLE #rtemp1;
select * into #rtemp1 from 
(select ROW_NUMBER() OVER (PARTITION BY loan_skey ORDER BY priority) rn,* from #rtemp) q
WHERE   rn = 1
order by loan_skey

--select * from #rtemp1 where loan_skey = '88061' order by Priority;

delete from #rtemp1 where loan_skey  in(
select loan_skey from [ReverseQuest].[rms].[v_Alert]
where alert_type_description  in ('FDCPA -  Call Restrictions','Cease and Desist',
'Pending Cease and Desist',
'Litigation -  Proceed','LITIGATION - Lawsuit Pending',
'DVN Research Request Pend')
and alert_status_description = 'Active')

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

  

IF OBJECT_ID('tempdb..#rtemp2') IS NOT NULL
    DROP TABLE #rtemp2;
select a.*
,e.default_reason as 'default reason'
,e.created_date 
into #rtemp2
from
#rtemp1 a
join reversequest.rms.v_MonthlyLoanDefaultSummary e
on a.loan_skey=e.loan_skey

--select * from #rtemp2 where loan_skey = '88061';

  
  delete from #rtemp2
where loan_skey in
(select a.loan_skey from reversequest.rms.v_note a
where a.created_date
>= DATEADD(d,-7,DATEDIFF(d,0,GETDATE())) and
a.created_date < DATEADD(d,0,DATEDIFF(d,0,GETDATE()))
and (a.note_type_description like '%Incom%' or note_type_description like 'Spoc Incom%'));

IF OBJECT_ID('tempdb..#rtemp3') IS NOT NULL
    DROP TABLE #rtemp3;
select loan_skey,loan_sub_status,investor_name
--,loan_status_description,
,[Contact Type],[Contact First Name],[Contact Last Name],[Property Address1]
,[Property Address2], [Property City],[Property State],[Property Zip],[Mailing Address 1],[Mailing Address 2],[Mailing City],[Mailing State],[Mailing Zip]
,[Home Phone #], [Cell Phone #], [Work Phone #] 
--,alert_type_description
,[default reason],loan_status_description
--,Priority 
into #rtemp3
from 
(select ROW_NUMBER() OVER (PARTITION BY loan_skey ORDER BY priority,created_date desc) rownum,* from #rtemp2) x
WHERE  
rownum = 1 and 
Priority is not null 
--and loan_skey = '89192'
order by loan_skey,alert_type_description;

update #rtemp3 set [Home Phone #]='',[Cell Phone #]=''
where [Contact Type] = 'Attorney';

select loan_skey as LOANSKEY,loan_sub_status as LOANSUBSTATUS, investor_name as INVESTORNAME,[Contact Type] as CONTACTTYPE
,[Contact First Name] as CONTACTFIRSTNAME,[Contact Last Name] as CONTACTLASTNAME,[Property Address1] as PROPERTYADDRESS1
,[Property Address2] as PROPERTYADDRESS2,[Property City] as PROPERTYCITY,[Property State] as PROPERTYSTATE,[Property Zip] as PROPERTYZIP
,[Mailing Address 1] as MAILINGADDRESS1,[Mailing Address 2] as MAILINGADDRESS2, [Mailing City] as MAILINGCITY,[Mailing State] as MAILINGSTATE
,[Mailing Zip] as MAILINGZIP,[Home Phone #] as HOMEPHONE, [Cell Phone #] as CELLPHONE,[default reason] as CALLREASON,loan_status_description
from #rtemp3;
