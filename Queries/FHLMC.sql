IF OBJECT_ID('tempdb..#rtemp') IS NOT NULL
    DROP TABLE #rtemp;
select   Convert(date, getdate()) as 'CREATE_DATE',b.loan_skey,b.investor_name,b.fha_case_number as 'FHA CASE NO',b.servicer_name,b.loan_pool_short_description as 'INVESTOR POOL'
,b.loan_status_description,b.loan_sub_status_description as 'SUB STATUS',c.default_date,
DATEDIFF(day, c.default_date,getdate()) as 'DAYS DELQ', b.loan_manager as 'RM NAME'
into #rtemp
from
--[RQER].[dbo].[rep_monthly_portfolio_analysis_extract] a
--join
[ReverseQuest].rms.v_LoanMaster b
--on b.loan_skey=b.loan_skey
 left join [ReverseQuest].[rms].[v_LoanDefaultInformation] c
on b.loan_skey=c.loan_skey
where b.loan_status_description not  in ('DELETED', 'INACTIVE');

select * from #rtemp;

IF OBJECT_ID('tempdb..#rtemp1') IS NOT NULL
    DROP TABLE #rtemp1;

select x.*,y.UPB 
into #rtemp1
from #rtemp x
join
(Select loan_skey
, Sum(principal_amount) as UPB
,Sum(interest_amount) as interest_amount
,Sum(case when long_Transaction_description = 'Initial MIP - Paid by Borrower' then 0 else mip_amount end) as mip_amount
,Sum(service_fee_amount) as service_fee_amount
,Sum(principal_amount) + Sum(interest_amount) + Sum(case when long_Transaction_description = 'Initial MIP - Paid by Borrower' then 0 else mip_amount end) + Sum(service_fee_amount) as Total_Loan_Balance
,Sum(principal_limit_amount) as principal_limit_amount
,sum(case when long_transaction_description in ('Disb - Scheduled','Disb - Scheduled Void','Disb - Unscheduled from LOC Void','Disb - Unscheduled from LOC') then principal_amount else 0 end) Draws
From [ReverseQuest].rms.v_Transaction 
--where loan_skey = '2621'
group by loan_skey
) y
on x.loan_skey=y.loan_skey;

select top 1 * from #rtemp1;


IF OBJECT_ID('tempdb..#rtemp2') IS NOT NULL
    DROP TABLE #rtemp2;
select a.CREATE_DATE, a.loan_skey,a.investor_name,a.[FHA CASE NO]
,a.servicer_name,a.loan_status_description,a.[SUB STATUS],a.default_date
,a.[DAYS DELQ],a.[RM NAME],a.UPB,max(b.[due date]) 'Repay plan Due Date' 
,case when b.[due date] is null then 'No' else 'Yes' end as 'Active Repay Plan' 
into #rtemp2
from #rtemp1 a
 left join
(SELECT[loan_skey],y.workflow_task_description
	  ,min(y.due_date) as 'due date'
	  ,y.complete_date
  FROM [ReverseQuest].[rms].[v_WorkflowInstance] x
   join
   [ReverseQuest].[rms].[v_WorkflowTaskActivity] y on x.workflow_instance_skey=y.workflow_instance_skey
  where y.workflow_task_description = 'Repayment Plan Installment Due'
  and x.status_description = 'Active'
  and y.complete_date is null
  group by loan_skey,y.workflow_task_description,y.complete_date
   ) b
  on a.loan_skey =b.loan_skey
  group by a.CREATE_DATE, a.loan_skey,a.investor_name,a.[FHA CASE NO]
,a.servicer_name,a.investor_name,a.loan_status_description,a.[SUB STATUS],a.default_date
,a.[DAYS DELQ],a.[RM NAME],a.UPB,b.[due date];


IF OBJECT_ID('tempdb..#rtemp3') IS NOT NULL
    DROP TABLE #rtemp3;
  select a.*,
  (select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.loan_skey and( note_type_description like '%Incom%'  or  note_type_description like 'Spoc Incom%')
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 30, GETDATE()), 0)) as 'Inbound Calls in 30 days',
  (select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.loan_skey and( note_type_description like '%Incom%'  or  note_type_description like 'Spoc Incom%')
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 60, GETDATE()), 0)) as 'Inbound Calls in 60 days',
  (select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.loan_skey and( note_type_description like '%Incom%'  or  note_type_description like 'Spoc Incom%')
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 90, GETDATE()), 0)) as 'Inbound Calls in 90 days',
  (select max(created_date)  from reversequest.rms.v_note 
  where loan_skey = a.loan_skey and( note_type_description like '%Incom%'  or  note_type_description like 'Spoc Incom%'))
  as 'Last Inbound ',
  (select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.loan_skey and( (note_type_description like '%Outgoing%'  or  note_type_description like 'Spoc Outgoing%') and note_type_description <> 'Outgoing Letter')
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 30, GETDATE()), 0)) as 'Outbound Calls in 30 days',
  (select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.loan_skey and( (note_type_description like '%Outgoing%'  or  note_type_description like 'Spoc Outgoing%') and note_type_description <> 'Outgoing Letter')
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 60, GETDATE()), 0)) as 'Outbound Calls in 60 days',
  (select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.loan_skey and( (note_type_description like '%Outgoing%'  or  note_type_description like 'Spoc Outgoing%') and note_type_description <> 'Outgoing Letter')
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 90, GETDATE()), 0)) as 'Outbound Calls in 90 days',
  (select max(created_date)  from reversequest.rms.v_note 
  where loan_skey = a.loan_skey and( (note_type_description like '%Outgoing%'  or  note_type_description like 'Spoc Outgoing%') and note_type_description <> 'Outgoing Letter')
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 90, GETDATE()), 0)) as 'Last Outbound',
  (select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.loan_skey and( note_type_description like 'Email Out%')
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 30, GETDATE()), 0)) as 'Email sent in 30 days',
  (select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.loan_skey and( note_type_description like 'Email Out%')
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 60, GETDATE()), 0)) as 'Email sent in 60 days',
  (select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.loan_skey and( note_type_description like 'Email Out%')
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 90, GETDATE()), 0)) as 'Email sent in 90 days',
  (select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.loan_skey and( note_type_description like 'Fax Out%')
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 30, GETDATE()), 0)) as 'Fax sent in 30 days',
  (select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.loan_skey and( note_type_description like 'Fax Out%')
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 60, GETDATE()), 0)) as 'Fax sent in 60 days',
  (select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.loan_skey and( note_type_description like 'Fax Out%')
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 90, GETDATE()), 0)) as 'Fax sent in 90 days',
  (select count(loan_skey)  from [RQER].[dbo].[app_document] 
  where loan_skey = a.loan_skey and document_description in ('Loss Mit Correspondence','Loss Mit Letter(s)','Loss Mit-Family Sale Pending','Loss Mit-Refer to Atty for DIL','Loss Mit-Short Sale'
  ,'DIL Agreement','DIL Cancellation','DIL Change ownership','DIL-Appraisal','DIL Appraisal ','DIL Extension','DIL-Investor Approval','DIL-Invoices','DIL-Legal','DIL-Referral','DIL-Title','DIL Other')
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 30, GETDATE()), 0)) as 'Loss Mit Correspondence in 30 days'
  into #rtemp3
  from #rtemp2 a;
  

  IF OBJECT_ID('tempdb..#rtemp4') IS NOT NULL
    DROP TABLE #rtemp4;
  select a.*,b.workflow_type_description
  --,c.alert_type_description
  ,case when(b.workflow_type_description) is null then 'N' else 'Y' end as 'Active Workflow' into #rtemp4
  from #rtemp3 a
  left join
  [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.loan_skey=b.loan_skey
  and b.status_description = 'Active' and workflow_type_description in
  ('Repayment Plan','Loss Mit-Short Sale','Loss Mit-Family Sale Pending'
  ,'Extension - At Risk','Extension - COVID-19 Request to Delay Claims Submission','Extension - COVID-19 Request to Delay Due & Payable',
  'Extension - COVID-19 Request to Delay Foreclosure','Extension - Deed-in-Lieu','Extension - Hardest Hit Fund (HHF)','Extension - Property Charge Loss Mitigation'
  ,'Loss Mitigation - Deed in Lieu','Loss Mitigation - Family Sale Pending','Loss Mitigation - Short Sale');
  
  select  distinct workflow_type_description from #rtemp4 order by workflow_type_description;

  IF OBJECT_ID('tempdb..#final') IS NOT NULL
    DROP TABLE #final;

  select ROW_NUMBER() OVER (PARTITION BY a.loan_skey ORDER BY case 
	when workflow_type_description is null then 0
	when workflow_type_description = 'Repayment Plan' then 1 else 2 end
  ) rownum,
  a.*, c.alert_type_description as 'Non-Workable Reason', case when c.alert_type_description is null then 'Y' else 'N' end as 'Workable' into #final
  from #rtemp4 a
   left join (select * from [ReverseQuest].[rms].[v_Alert]  where loan_skey in 
   (select loan_skey from #rtemp4) and alert_type_description 
   in ('FDCPA -  Call Restrictions','Cease and Desist','Pending Cease and Desist','LITIGATION - Lawsuit Pending','DVN Research Request Pend') and alert_status_description = 'Active' )c
  on a.loan_skey=c.loan_skey
 -- where a. loan_skey = '44686'
  ; 

  select a.CREATE_DATE,a.loan_skey,a.investor_name,a.[FHA CASE NO],a.servicer_name,a.loan_status_description,a.[SUB STATUS],a.default_date,a.[DAYS DELQ],a.[RM NAME],a.UPB
  ,a.[Inbound Calls in 30 days],a.[Inbound Calls in 60 days],a.[Inbound Calls in 90 days],a.[Last Inbound ]
  ,a.[Outbound Calls in 30 days],a.[Outbound Calls in 60 days],a.[Outbound Calls in 90 days],a.[Last Outbound],a.[Email sent in 30 days],a.[Email sent in 60 days],a.[Email sent in 90 days]
  ,a.[Fax sent in 30 days],a.[Fax sent in 60 days],a.[Fax sent in 90 days],a.[Loss Mit Correspondence in 30 days],a.[Active Repay Plan],a.[Repay plan Due Date]
  ,a.[Active Workflow],a.workflow_type_description as 'Active Loss Mitigation workflow',a.Workable,a.[Non-Workable Reason]
  from #final a
  where a.rownum=1;
  