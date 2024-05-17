
IF OBJECT_ID('tempdb..#tempTbl') IS NOT NULL
    DROP TABLE #tempTbl;
    SELECT b.loan_skey,c.loan_status_description,c.fha_case_number as 'FHA Case #',c.investor_name,c.servicer_name,
	d.due_and_payable_date as  'Due & Payable Date' ,
	 a.schedule_date as 'Notify Borrower of Approved Repayment Plan Start Date',
	-- d.tots_balance,
	 sum( e.principal_amount + e.interest_amount + e.mip_amount + e.service_fee_amount + e.corporate_advance_borrower_amount ) as 'Tots'
	 ,d.default_reason_description,d.default_date
into #tempTbl
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join  [ReverseQuest].[rms].[v_WorkflowInstance] b on a.workflow_instance_skey=b.workflow_instance_skey
   join ReverseQuest.rms.v_LoanMaster c  on b.loan_skey=c.loan_skey
   left join [ReverseQuest].[rms].[v_LoanDefaultInformation] d on b.loan_skey=d.loan_skey
   left join ReverseQuest.rms.v_Transaction e
	on c.loan_skey=e.loan_skey and 
	((  e.effective_date <= GETDATE() ) OR (  e.transaction_date <= GETDATE() )) 
 AND e.include_in_cure_amount_flag    = 1 
where 
    a.workflow_task_description in ('Notify Borrower of Approved Repayment Plan')
  and a.status_description in('Active')
  and b.workflow_type_description in ('Repayment Plan')
  and b.status_description='Active'
  --and a.created_date >= DATEADD(DAY, DATEDIFF(DAY, 30, GETDATE()), 0)
 --and   b.loan_skey = '1300'
 group by  b.loan_skey,c.loan_status_description,c.fha_case_number,c.investor_name,c.servicer_name,
	d.due_and_payable_date ,
	 a.schedule_date ,
	 d.tots_balance, d.default_reason_description,d.default_date
  order by b.loan_skey;

--  select * from #tempTbl1 where loan_skey=1930
/*select e.loan_skey,
sum( e.principal_amount + e.interest_amount + e.mip_amount + e.service_fee_amount + e.corporate_advance_borrower_amount ) as 'Tots'
from #tempTbl a
   left join ReverseQuest.rms.v_Transaction e
	on a.loan_skey=e.loan_skey and 
	((  e.effective_date <= GETDATE() ) OR (  e.transaction_date <= GETDATE() )) 
 AND e.include_in_cure_amount_flag    = 1 
 group by e.loan_skey
 a.loan_skey,a.loan_status_description,a.default_date,a.[FHA Case #],a.[Due & Payable Date],a.[Notify Borrower of Approved Repayment Plan Start Date]
 ,a.tots_balance,a.default_reason_description,


 */




IF OBJECT_ID('tempdb..#tempTbl1') IS NOT NULL
    DROP TABLE #tempTbl1;
  select a.*,
  z.complete_date as 'Receipt of Signed Repayment Plan Complete Date' 
  into #tempTbl1
  from #tempTbl a
  left join
   (
  SELECT max(x.complete_date) as complete_date,y.loan_skey,x.workflow_task_description
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] x
  join
  [ReverseQuest].[rms].[v_WorkflowInstance] y
  on x.workflow_instance_skey=y.workflow_instance_skey
  where x.workflow_task_description = 'Receipt of Signed Repayment Plan'
  and x.status_description='Active'
  and y.workflow_type_description in ('Repayment Plan')
  and y.status_description='Active'
 -- and x.created_date >= DATEADD(DAY, DATEDIFF(DAY, 30, GETDATE()), 0)
  and x.complete_date is not null
  group by y.loan_skey,x.workflow_task_description
  ) z
  on a.loan_skey=z.loan_skey;



IF OBJECT_ID('tempdb..#tempTbl2') IS NOT NULL
    DROP TABLE #tempTbl2;
select a.*, b.[Submit Property Charge Loss Mitigation Extension] 
into #tempTbl2
from #tempTbl1 a 
left join 
  ( SELECT b.loan_skey,
    max(a.complete_date) as 'Submit Property Charge Loss Mitigation Extension',
	a.workflow_task_description,
	b.workflow_type_description
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join
  [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
   join ReverseQuest.rms.v_LoanMaster c  on b.loan_skey=c.loan_skey
  where a.workflow_task_description in ('Submit Property Charge Loss Mitigation Extension')
  and a.status_description='Active'
  and b.workflow_type_description='Repayment Plan'
   and b.status_description='Active'
  --and a.created_date >= DATEADD(DAY, DATEDIFF(DAY, 30, GETDATE()), 0)
 --and   b.loan_skey = '2621'
 group by b.loan_skey,a.workflow_task_description,b.workflow_type_description
  --order by b.loan_skey
  ) b on a.loan_skey=b.loan_skey


 -- select * from #tempTbl2
 -------------------------


IF OBJECT_ID('tempdb..#tempTbl3') IS NOT NULL
    DROP TABLE #tempTbl3;
  select a.*
  ,a.[Monthly Repayment Amt]*(a.[Repayment Plan Term]-b.[Complete date]) as 'Remaining Amount'
  --,a.[Orig. Repayment Amt]-(a.[Monthly Repayment Amt]*(a.[Repayment Plan Term]-b.[Complete date])) as 'Tots balance'
  ,b.[Complete date]
  ,(a.[Repayment Plan Term]-b.[Complete date]) as '# Repayments Remaining' 
   ,c.[First Repayment Due Date]
   ,d.[Last Repayment Received Date]
   ,e.[Next Repayment Due Date]
   ,f.[Down Payment Due Date]
   into #tempTbl3
	from(  
	 select 
		b.loan_skey,
		b.workflow_instance_skey,
		b.workflow_type_description,
  --b.default_date,
 -- b.due_and_payable_date,
		round(b.repayment_plan_amount/ b.repayment_plan_term, 2) as 'Monthly Repayment Amt',
		b.repayment_plan_amount as 'Orig. Repayment Amt',
		b.repayment_plan_term as 'Repayment Plan Term',
		b.status_description,
		b.surplus_income_amount,
		b.down_payment_amount,
		max(b.created_date) as 'created_date',
		b.created_by
		FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
		join  [ReverseQuest].[rms].[v_WorkflowInstance] b
		on a.workflow_instance_skey=b.workflow_instance_skey
		join ReverseQuest.rms.v_LoanMaster c  on b.loan_skey=c.loan_skey
		where 
		--b.loan_skey=1930 and
		b.workflow_type_description ='Repayment Plan'
		and b.status_description='Active'
		and a.workflow_task_description='Repayment Plan Installment Due'
		and a.status_description='Active'
		group by   b.loan_skey, b.workflow_instance_skey,
  b.workflow_type_description,b.down_payment_amount,
  --b.default_date,
 -- b.due_and_payable_date,
  b.repayment_plan_amount,
  b.repayment_plan_term,b.status_description,b.created_by,b.surplus_income_amount) a 
  left join (select 
b.loan_skey,count(a.complete_date) as 'Complete date'
    FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join
  [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
   join ReverseQuest.rms.v_LoanMaster c  on b.loan_skey=c.loan_skey
   where --b.loan_skey=1930 and 
    b.workflow_type_description ='Repayment Plan'
   and a.workflow_task_description='Repayment Plan Installment Due'
   and b.status_description='Active'
   and a.status_description='Active'
   and a.complete_date is not  null
   group by b.loan_skey) b on a.loan_skey=b.loan_skey
left join (select 
b.loan_skey,min(a.due_date) as 'First Repayment Due Date'  
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join  [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
   join ReverseQuest.rms.v_LoanMaster c  on b.loan_skey=c.loan_skey
   where --b.loan_skey=1930 and 
   b.workflow_type_description ='Repayment Plan'
   and a.workflow_task_description='Repayment Plan Installment Due'
   and b.status_description='Active'
   and a.status_description='Active'
   group by b.loan_skey ) c on a.loan_skey=c.loan_skey
   left join (select 
		b.loan_skey,max(a.complete_date) as 'Last Repayment Received Date'
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join
  [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
   join ReverseQuest.rms.v_LoanMaster c  on b.loan_skey=c.loan_skey
   where --b.loan_skey=1930 and 
   b.workflow_type_description ='Repayment Plan'
   and a.workflow_task_description='Repayment Plan Installment Due'
   and a.complete_date is not null
   and b.status_description='Active'
   and a.status_description='Active'
   group by b.loan_skey) d on a.loan_skey=d.loan_skey
   left join (select 
	b.loan_skey,min(a.due_date) as 'Next Repayment Due Date'
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join
  [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
   join ReverseQuest.rms.v_LoanMaster c  on b.loan_skey=c.loan_skey
   where --b.loan_skey=1930 and 
   b.workflow_type_description ='Repayment Plan'
   and a.workflow_task_description='Repayment Plan Installment Due'
   and a.complete_date is null
   and b.status_description='Active'
   and a.status_description='Active' --and b.loan_skey=1300
   group by b.loan_skey) e on a.loan_skey=e.loan_skey
   left join (select 
		b.loan_skey,max(a.complete_date) as 'Down Payment Due Date'
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join
  [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
   join ReverseQuest.rms.v_LoanMaster c  on b.loan_skey=c.loan_skey
   where --b.loan_skey=1930 and 
   b.workflow_type_description ='Repayment Plan'
   and a.workflow_task_description='Down Payment Installment Due'
   and a.complete_date is not null
   and b.status_description='Active'
   and a.status_description='Active'
   group by b.loan_skey) f on a.loan_skey=f.loan_skey

  --  select * from #tempTbl3 where loan_skey=7148
-----------------------------

IF OBJECT_ID('tempdb..#tempTbl4') IS NOT NULL
    DROP TABLE #tempTbl4;
 select a.*,b.[Submit Extension Request for Time Complete Date],c.[Upload Extension Package Complete Date]
 ,d.[HUD Decision - Approved Complete Date],e.[HUD Decision - Denied Complete Date]
 into #tempTbl4 
 from 
 (
 select b.loan_skey
	,b.workflow_instance_skey
	,b.workflow_type_description
	,a.workflow_task_description
	,a.complete_date as 'Initiate Extension Complete Date'	
	from   [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
	 join [ReverseQuest].[rms].[v_WorkflowInstance] b
	 on a.workflow_instance_skey=b.workflow_instance_skey
	 where --b.loan_skey=2549 and
	  b.workflow_type_description ='Extension - Property Charge Loss Mitigation'
	and a.workflow_task_description='Initiate Extension'
	and b.status_description='Active'
   and a.status_description='Active'
	and a.complete_date is not null) a 
	left join (select b.loan_skey
	,b.workflow_instance_skey
	,b.workflow_type_description
	,a.workflow_task_description
	,a.complete_date as 'Submit Extension Request for Time Complete Date'
	from   [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
	 join [ReverseQuest].[rms].[v_WorkflowInstance] b
	 on a.workflow_instance_skey=b.workflow_instance_skey
	 where --b.loan_skey=1930 and
	  b.workflow_type_description ='Extension - Property Charge Loss Mitigation'
	and a.workflow_task_description='Submit Extension Request for Time'
	and b.status_description='Active'
		and a.complete_date is not null
		and a.status_description='Active') b on a.loan_skey=b.loan_skey
left join (
select b.loan_skey
	,b.workflow_instance_skey
	,b.workflow_type_description
	,a.workflow_task_description
	,a.complete_date as 'Upload Extension Package Complete Date'
	from   [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
	 join [ReverseQuest].[rms].[v_WorkflowInstance] b
	 on a.workflow_instance_skey=b.workflow_instance_skey
	 where --b.loan_skey=1930 and
	  b.workflow_type_description ='Extension - Property Charge Loss Mitigation'
	and a.workflow_task_description='Upload Extension Package'
	and b.status_description='Active'
   and a.status_description='Active'
		and a.complete_date is not null)  c on a.loan_skey=c.loan_skey
left join(
select b.loan_skey
	,b.workflow_instance_skey
	,b.workflow_type_description
	,a.workflow_task_description
	,a.complete_date as 'HUD Decision - Approved Complete Date'
	from   [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
	 join [ReverseQuest].[rms].[v_WorkflowInstance] b
	 on a.workflow_instance_skey=b.workflow_instance_skey
	 where --b.loan_skey=1930 and
	  b.workflow_type_description ='Extension - Property Charge Loss Mitigation'
	and a.workflow_task_description='HUD Decision - Approved'
	and b.status_description='Active'
   and a.status_description='Active'
		and a.complete_date is not null) d on a.loan_skey=d.loan_skey
left join(
select b.loan_skey
	,b.workflow_instance_skey
	,b.workflow_type_description
	,a.workflow_task_description
	,a.complete_date as 'HUD Decision - Denied Complete Date'
	from   [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
	 join [ReverseQuest].[rms].[v_WorkflowInstance] b
	 on a.workflow_instance_skey=b.workflow_instance_skey
	 where --b.loan_skey=1930 and
	  b.workflow_type_description ='Extension - Property Charge Loss Mitigation'
	and a.workflow_task_description='HUD Decision - Denied'
	and b.status_description='Active'
   and a.status_description='Active'
	and a.complete_date is not null) e on a.loan_skey=e.loan_skey


----------------------------------
IF OBJECT_ID('tempdb..#tempTbl5') IS NOT NULL
    DROP TABLE #tempTbl5;
select * 
into #tempTbl5
from (
select 
b.loan_skey,b.default_reason_description
,b.default_date,b.workflow_type_description,b.status_description,
b.created_date
,b.created_by
,ROW_NUMBER() OVER (PARTITION BY b.loan_skey ORDER BY b.created_date desc) rn
from(select
b.loan_skey,b.default_reason_description
,b.default_date,b.workflow_type_description,b.status_description,max(b.created_date) as created_date,b.created_by
	from   [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
	 join [ReverseQuest].[rms].[v_WorkflowInstance] b
	 on a.workflow_instance_skey=b.workflow_instance_skey
	 where --b.loan_skey=1930 and
	  b.workflow_type_description in ('Pre Due & Payable w/HUD Approval','Due & Payable w/ HUD Approval')
	--and a.workflow_task_description='HUD Decision - Denied'
	and b.status_description='Active'
  group by b.loan_skey,b.default_reason_description
,b.default_date,b.workflow_type_description,b.status_description,b.created_by
) b 
) a
where --loan_skey =210068 and 
rn=1

-- select * from  #tempTbl6 where loan_skey=1300

IF OBJECT_ID('tempdb..#tempTbl6') IS NOT NULL
    DROP TABLE #tempTbl6;
select * 
into #tempTbl6
from (
select 
b.loan_skey,b.default_reason_description
,b.default_date,b.workflow_type_description,b.status_description,
b.created_date
,b.created_by
,ROW_NUMBER() OVER (PARTITION BY b.loan_skey ORDER BY b.created_date desc) rn
from(select
b.loan_skey,b.default_reason_description
,b.default_date,b.workflow_type_description,b.status_description,max(b.created_date) as created_date,b.created_by
	from   [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
	 join [ReverseQuest].[rms].[v_WorkflowInstance] b
	 on a.workflow_instance_skey=b.workflow_instance_skey
	 where --b.loan_skey=1930 and
	  b.workflow_type_description in ('Pre Due & Payable w/HUD Approval','Due & Payable w/ HUD Approval')
	--and a.workflow_task_description='HUD Decision - Denied'
	and b.status_description='Workflow Completed'
  group by b.loan_skey,b.default_reason_description
,b.default_date,b.workflow_type_description,b.status_description,b.created_by
) b 
) a
where --loan_skey =210068 and 
rn=1




-----------------------------------------------------
/*
select a.loan_skey as 'Loan key',a.loan_status_description as 'Loan Status',a.[FHA Case #]
,CONVERT(varchar,a.[Notify Borrower of Approved Repayment Plan Start Date],101) as 'Notify Borrower of Approved Repayment Plan Start Date'
,CONVERT(varchar,a.[Receipt of Signed Repayment Plan Complete Date],101) as 'Receipt of Signed Repayment Plan Complete Date'
,CONVERT(varchar,a.[Submit Property Charge Loss Mitigation Extension],101) as 'Submit Property Charge Loss Mitigation Extension'
,b.[Repayment Plan Term],b.[Monthly Repayment Amt],b.surplus_income_amount as 'Surplus Income Amount'
, case when b.down_payment_amount=0 then NULL else b.down_payment_amount end  as 'Down Payment Amount'
,CONVERT(varchar,b.[First Repayment Due Date],101) as 'First Repayment Due Date'
,CONVERT(varchar,b.[Last Repayment Received Date],101) as 'Last Repayment Received Date'
,CONVERT(varchar,b.[Next Repayment Due Date],101) as 'Next Repayment Due Date'
,case when b.[Last Repayment Received Date] is NULL then b.[Repayment Plan Term] else coalesce( b.[# Repayments Remaining],0) end as '# Repayments Remaining'
,coalesce(b.[Orig. Repayment Amt],0) as 'Orig. Repayment Amt'
,case when  b.[Last Repayment Received Date] is NULL then b.[Orig. Repayment Amt] else coalesce(b.[Remaining Amount],0) end as 'Remaining Amount'
,round(a.Tots,2) as 'TOTS Balance'
,case when a.loan_status_description='FORECLOSURE' then e.default_reason_description else  d.default_reason_description end  as 'Default Reason',
CONVERT(varchar,case when a.loan_status_description='FORECLOSURE' then e.default_date else d.default_date end,101) as 'Default Date'
,CONVERT(varchar,a.[Due & Payable Date],101) as 'Due & Payable Date'
,CONVERT(varchar,c.[Initiate Extension Complete Date],101) as 'Initiate Extension Complete Date'
,CONVERT(varchar,c.[Submit Extension Request for Time Complete Date],101) as 'Submit Extension Request for Time Complete Date'
,CONVERT(varchar,c.[Upload Extension Package Complete Date],101) as 'Upload Extension Package Complete Date'
,CONVERT(varchar,c.[HUD Decision - Approved Complete Date],101) as'HUD Decision - Approved Complete Date'
,CONVERT(varchar,c.[HUD Decision - Denied Complete Date],101) as 'HUD Decision - Denied Complete Date'
from #tempTbl2 a
left join #tempTbl3 b on a.loan_skey=b.loan_skey
left join #tempTbl4 c on a.loan_skey=c.loan_skey
left join #tempTbl5 d on a.loan_skey=d.loan_skey
left join #tempTbl6 e on a.loan_skey=e.loan_skey
/*left join #tempTbl7 f on a.loan_skey=f.loan_skey
left join #tempTbl8 g on a.loan_skey=g.loan_skey*/
order by a.loan_skey
*/

--select * from #tempTbl2
select * from(
select 
a.[Loan key],
a.[Loan Status],
a.[FHA Case #],
a.[Notify Borrower of Approved Repayment Plan Start Date],
a.[Receipt of Signed Repayment Plan Complete Date],
a.[Submit Property Charge Loss Mitigation Extension],
a.[Repayment Plan Term],
a.[Monthly Repayment Amt],
a.[Surplus Income Amount],
a.[Down Payment Amount],
a.[Down Payment Due Date],
a.[First Repayment Due Date],
a.[Last Repayment Received Date],
a.[Next Repayment Due Date],
a.[Days Delq],
concat( '$',case when a.[Days Delq]>=30 then a.[Monthly Repayment Amt]*2+a.[Down Payment Amount]
when a.[Days Delq] between 1 and 29 then a.[Monthly Repayment Amt]*1+a.[Down Payment Amount]
when a.[Days Delq]<=0 then 0
else 0 end) as 'Amount_Due',
a.[Cancellation Date],
a.[# Repayments Remaining],
a.[Orig. Repayment Amt],
a.[Remaining Amount],
a.[TOTS Balance],
a.[Default Reason],
a.[Default Date],
a.[Due & Payable Date],
a.[Initiate Extension Complete Date],
a.[Submit Extension Request for Time Complete Date],
a.[Upload Extension Package Complete Date],
a.[HUD Decision - Approved Complete Date],
a.[HUD Decision - Denied Complete Date],
a.[BRWR_NAME],a.BRWR_MAILID,
a.[COBRWR_NAME1],a.COBRWR1_MAILID,
a.[COBRWR_NAME2],a.COBRWR2_MAILID,
a.[COBRWR_NAME3],a.COBRWR3_MAILID,
a.[MAIL_ADD1],
a.[MAIL_ADD2],
a.[MAIL_CITY],
a.[MAIL_STATE],
a.[MAIL_ZIP],
a.[PROP_ADD1],
a.[PROP_ADD2],
a.[PROP_CITY],
a.[PROP_STATE],
a.[PROP_ZIP],
a.[Phone Number],
a.[BUSINESS_HOURS_WL],a.investor_name,a.servicer_name
from (
select a.loan_skey as 'Loan key',a.loan_status_description as 'Loan Status',a.[FHA Case #]
,CONVERT(varchar,a.[Notify Borrower of Approved Repayment Plan Start Date],23) as 'Notify Borrower of Approved Repayment Plan Start Date'
,CONVERT(varchar,a.[Receipt of Signed Repayment Plan Complete Date],23) as 'Receipt of Signed Repayment Plan Complete Date'
,CONVERT(varchar,a.[Submit Property Charge Loss Mitigation Extension],23) as 'Submit Property Charge Loss Mitigation Extension'
,b.[Repayment Plan Term],b.[Monthly Repayment Amt],b.surplus_income_amount as 'Surplus Income Amount'
,coalesce( case when b.down_payment_amount in (0,NULL,'') then 0 else b.down_payment_amount end,0)  as 'Down Payment Amount'
,CONVERT(varchar,b.[First Repayment Due Date],23) as 'First Repayment Due Date'
,CONVERT(varchar,b.[Last Repayment Received Date],23) as 'Last Repayment Received Date'
,CONVERT(varchar,b.[Next Repayment Due Date],23) as 'Next Repayment Due Date'
,DATEDIFF( DD, CONVERT(varchar,b.[Next Repayment Due Date],23),DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 1)) ) as 'Days Delq'
,CONVERT(varchar,(b.[Next Repayment Due Date]+60),23)  as 'Cancellation Date'
,case when b.[Last Repayment Received Date] is NULL then b.[Repayment Plan Term] else coalesce( b.[# Repayments Remaining],0) end as '# Repayments Remaining'
,coalesce(b.[Orig. Repayment Amt],0) as 'Orig. Repayment Amt'
,case when  b.[Last Repayment Received Date] is NULL then b.[Orig. Repayment Amt] else coalesce(b.[Remaining Amount],0) end as 'Remaining Amount'
,round(a.Tots,2) as 'TOTS Balance'
,case when a.loan_status_description='FORECLOSURE' then e.default_reason_description else  d.default_reason_description end  as 'Default Reason',
CONVERT(varchar,case when a.loan_status_description='FORECLOSURE' then e.default_date else d.default_date end,23) as 'Default Date'
,CONVERT(varchar,a.[Due & Payable Date],23) as 'Due & Payable Date'
,CONVERT(varchar,c.[Initiate Extension Complete Date],23) as 'Initiate Extension Complete Date'
,CONVERT(varchar,c.[Submit Extension Request for Time Complete Date],23) as 'Submit Extension Request for Time Complete Date'
,CONVERT(varchar,c.[Upload Extension Package Complete Date],23) as 'Upload Extension Package Complete Date'
,CONVERT(varchar,c.[HUD Decision - Approved Complete Date],23) as'HUD Decision - Approved Complete Date'
,CONVERT(varchar,c.[HUD Decision - Denied Complete Date],23) as 'HUD Decision - Denied Complete Date'
,CONVERT(varchar,b.[Down Payment Due Date],23) as 'Down Payment Due Date'
,h.BRWR_NAME,h.BRWR_MAILID,h.COBRWR_NAME1,h.COBRWR1_MAILID,h.COBRWR_NAME2,h.COBRWR2_MAILID
,h.COBRWR_NAME3,h.COBRWR3_MAILID,h.MAIL_ADD1,h.MAIL_ADD2,h.MAIL_CITY,h.MAIL_STATE,h.MAIL_ZIP,
h.PROP_ADD1,h.PROP_ADD2,h.PROP_CITY,h.PROP_STATE,h.PROP_ZIP,'1-866-799-7744' as 'Phone Number',
'Monday - Friday 8:00 a.m. - 7:00 p.m. ET.' as 'BUSINESS_HOURS_WL',
a.investor_name,a.servicer_name
from #tempTbl2 a
left join #tempTbl3 b on a.loan_skey=b.loan_skey
left join #tempTbl4 c on a.loan_skey=c.loan_skey
left join #tempTbl5 d on a.loan_skey=d.loan_skey
left join #tempTbl6 e on a.loan_skey=e.loan_skey
/*left join #tempTbl7 f on a.loan_skey=f.loan_skey
left join #tempTbl8 g on a.loan_skey=g.loan_skey*/
left join (select * from(select a.loan_skey,a.Borrower_Name BRWR_NAME,a.email as 'BRWR_MAILID',
 b.Co_Borrower_Name as COBRWR_NAME1,b.email as 'COBRWR1_MAILID',
 c.Co_Borrower_Name as COBRWR_NAME2,c.email as 'COBRWR2_MAILID',
d.Co_Borrower_Name as COBRWR_NAME3,d.email as 'COBRWR3_MAILID',
a.mail_address1 MAIL_ADD1 ,a.mail_address2 MAIL_ADD2 ,a.mail_city MAIL_CITY,a.mail_state_code MAIL_STATE,a.Mail_zip MAIL_ZIP,
a.address1 PROP_ADD1,a.address2 PROP_ADD2,a.city PROP_CITY,a.state_code PROP_STATE, prop_zip PROP_ZIP
 from (
select 
a.loan_skey,contact_type_description,
concat(upper(substring( first_name,1,1)),lower(substring( first_name,2,70)),' ',upper(substring( middle_name,1,1)),lower(substring( middle_name,2,70)),' ',upper(substring( last_name,1,1)),lower(substring( last_name,2,70)))
Borrower_Name,a.email,
mail_address1,mail_address2,mail_city,mail_state_code,left(mail_zip_code,5) Mail_zip,
b.address1,b.address2,b.city,b.state_code,LEFT(b.zip_code,5) prop_zip
from rms.v_ContactMaster a
join rms.v_PropertyMaster b on a.loan_skey=b.loan_skey
where contact_type_description='Borrower') a
left join (select * from (select a.loan_skey,contact_type_description,
concat(upper(substring( first_name,1,1)),lower(substring( first_name,2,70)),' ',upper(substring( middle_name,1,1)),lower(substring( middle_name,2,70)),' ',upper(substring( last_name,1,1)),lower(substring( last_name,2,70)))
 Co_Borrower_Name,email,
ROW_NUMBER() over (partition by a.loan_skey order by a.contact_skey ) sn
--,mail_address1,mail_address2,mail_city,mail_state_code,left(mail_zip_code,5) Mail_zip,
--b.address1,b.address2,b.city,b.state_code,LEFT(b.zip_code,5) prop_zip
from rms.v_ContactMaster a
join rms.v_PropertyMaster b on a.loan_skey=b.loan_skey
where contact_type_description='Co-Borrower') c where sn=1) b on a.loan_skey=b.loan_skey
left join (select * from (select a.loan_skey,contact_type_description,
concat(upper(substring( first_name,1,1)),lower(substring( first_name,2,70)),' ',upper(substring( middle_name,1,1)),lower(substring( middle_name,2,70)),' ',upper(substring( last_name,1,1)),lower(substring( last_name,2,70)))
 Co_Borrower_Name,email,
ROW_NUMBER() over (partition by a.loan_skey order by a.contact_skey ) sn
--,mail_address1,mail_address2,mail_city,mail_state_code,left(mail_zip_code,5) Mail_zip,
--b.address1,b.address2,b.city,b.state_code,LEFT(b.zip_code,5) prop_zip
from rms.v_ContactMaster a
join rms.v_PropertyMaster b on a.loan_skey=b.loan_skey
where contact_type_description='Co-Borrower') c where sn=2) c on a.loan_skey=c.loan_skey
left join (select * from (select a.loan_skey,contact_type_description,
concat(upper(substring( first_name,1,1)),lower(substring( first_name,2,70)),' ',upper(substring( middle_name,1,1)),lower(substring( middle_name,2,70)),' ',upper(substring( last_name,1,1)),lower(substring( last_name,2,70)))
 Co_Borrower_Name,email,
ROW_NUMBER() over (partition by a.loan_skey order by a.contact_skey ) sn
--,mail_address1,mail_address2,mail_city,mail_state_code,left(mail_zip_code,5) Mail_zip,
--b.address1,b.address2,b.city,b.state_code,LEFT(b.zip_code,5) prop_zip
from rms.v_ContactMaster a
join rms.v_PropertyMaster b on a.loan_skey=b.loan_skey
where contact_type_description='Co-Borrower') c where sn=3) d on a.loan_skey=d.loan_skey
)a
) h on a.loan_skey=h.loan_skey 
)a
)b
--where b.[Days Delq] between 1 and 61
order by b.[Loan key];


----For Tyree

select [Loan key],
[BRWR_NAME],BRWR_MAILID,
[COBRWR_NAME1],COBRWR1_MAILID,
[COBRWR_NAME2],COBRWR2_MAILID,
[COBRWR_NAME3],COBRWR3_MAILID,
Amount_Due,
[Next Repayment Due Date] as 'Due Date',
'Y' as 'Days Delq',
PROP_STATE,
[Phone Number],
BUSINESS_HOURS_WL
from(
select 
a.[Loan key],
a.[Loan Status],
a.[FHA Case #],
a.[Notify Borrower of Approved Repayment Plan Start Date],
a.[Receipt of Signed Repayment Plan Complete Date],
a.[Submit Property Charge Loss Mitigation Extension],
a.[Repayment Plan Term],
a.[Monthly Repayment Amt],
a.[Surplus Income Amount],
a.[Down Payment Amount],
a.[Down Payment Due Date],
a.[First Repayment Due Date],
a.[Last Repayment Received Date],
a.[Next Repayment Due Date],
a.[Days Delq],
concat( '$',case when a.[Days Delq]>=30 then a.[Monthly Repayment Amt]*2+a.[Down Payment Amount]
when a.[Days Delq] between 1 and 29 then a.[Monthly Repayment Amt]*1+a.[Down Payment Amount]
when a.[Days Delq]<=0 then 0
else 0 end) as 'Amount_Due',
a.[Cancellation Date],
a.[# Repayments Remaining],
a.[Orig. Repayment Amt],
a.[Remaining Amount],
a.[TOTS Balance],
a.[Default Reason],
a.[Default Date],
a.[Due & Payable Date],
a.[Initiate Extension Complete Date],
a.[Submit Extension Request for Time Complete Date],
a.[Upload Extension Package Complete Date],
a.[HUD Decision - Approved Complete Date],
a.[HUD Decision - Denied Complete Date],
a.[BRWR_NAME],a.BRWR_MAILID,
a.[COBRWR_NAME1],a.COBRWR1_MAILID,
a.[COBRWR_NAME2],a.COBRWR2_MAILID,
a.[COBRWR_NAME3],a.COBRWR3_MAILID,
a.[MAIL_ADD1],
a.[MAIL_ADD2],
a.[MAIL_CITY],
a.[MAIL_STATE],
a.[MAIL_ZIP],
a.[PROP_ADD1],
a.[PROP_ADD2],
a.[PROP_CITY],
a.[PROP_STATE],
a.[PROP_ZIP],
a.[Phone Number],
a.[BUSINESS_HOURS_WL]
from (
select a.loan_skey as 'Loan key',a.loan_status_description as 'Loan Status',a.[FHA Case #]
,CONVERT(varchar,a.[Notify Borrower of Approved Repayment Plan Start Date],23) as 'Notify Borrower of Approved Repayment Plan Start Date'
,CONVERT(varchar,a.[Receipt of Signed Repayment Plan Complete Date],23) as 'Receipt of Signed Repayment Plan Complete Date'
,CONVERT(varchar,a.[Submit Property Charge Loss Mitigation Extension],23) as 'Submit Property Charge Loss Mitigation Extension'
,b.[Repayment Plan Term],b.[Monthly Repayment Amt],b.surplus_income_amount as 'Surplus Income Amount'
,coalesce( case when b.down_payment_amount in (0,NULL,'') then 0 else b.down_payment_amount end,0)  as 'Down Payment Amount'
,CONVERT(varchar,b.[First Repayment Due Date],23) as 'First Repayment Due Date'
,CONVERT(varchar,b.[Last Repayment Received Date],23) as 'Last Repayment Received Date'
,CONVERT(varchar,b.[Next Repayment Due Date],23) as 'Next Repayment Due Date'
,DATEDIFF( DD, CONVERT(varchar,b.[Next Repayment Due Date],23),DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 1)) ) as 'Days Delq'
,CONVERT(varchar,(b.[Next Repayment Due Date]+60),23)  as 'Cancellation Date'
,case when b.[Last Repayment Received Date] is NULL then b.[Repayment Plan Term] else coalesce( b.[# Repayments Remaining],0) end as '# Repayments Remaining'
,coalesce(b.[Orig. Repayment Amt],0) as 'Orig. Repayment Amt'
,case when  b.[Last Repayment Received Date] is NULL then b.[Orig. Repayment Amt] else coalesce(b.[Remaining Amount],0) end as 'Remaining Amount'
,round(a.Tots,2) as 'TOTS Balance'
,case when a.loan_status_description='FORECLOSURE' then e.default_reason_description else  d.default_reason_description end  as 'Default Reason',
CONVERT(varchar,case when a.loan_status_description='FORECLOSURE' then e.default_date else d.default_date end,23) as 'Default Date'
,CONVERT(varchar,a.[Due & Payable Date],23) as 'Due & Payable Date'
,CONVERT(varchar,c.[Initiate Extension Complete Date],23) as 'Initiate Extension Complete Date'
,CONVERT(varchar,c.[Submit Extension Request for Time Complete Date],23) as 'Submit Extension Request for Time Complete Date'
,CONVERT(varchar,c.[Upload Extension Package Complete Date],23) as 'Upload Extension Package Complete Date'
,CONVERT(varchar,c.[HUD Decision - Approved Complete Date],23) as'HUD Decision - Approved Complete Date'
,CONVERT(varchar,c.[HUD Decision - Denied Complete Date],23) as 'HUD Decision - Denied Complete Date'
,CONVERT(varchar,b.[Down Payment Due Date],23) as 'Down Payment Due Date'
,h.BRWR_NAME,h.BRWR_MAILID,h.COBRWR_NAME1,h.COBRWR1_MAILID,h.COBRWR_NAME2,h.COBRWR2_MAILID
,h.COBRWR_NAME3,h.COBRWR3_MAILID,h.MAIL_ADD1,h.MAIL_ADD2,h.MAIL_CITY,h.MAIL_STATE,h.MAIL_ZIP,
h.PROP_ADD1,h.PROP_ADD2,h.PROP_CITY,h.PROP_STATE,h.PROP_ZIP,'1-866-799-7744' as 'Phone Number',
'Monday - Friday 8:00 a.m. - 7:00 p.m. ET.' as 'BUSINESS_HOURS_WL'
from #tempTbl2 a
left join #tempTbl3 b on a.loan_skey=b.loan_skey
left join #tempTbl4 c on a.loan_skey=c.loan_skey
left join #tempTbl5 d on a.loan_skey=d.loan_skey
left join #tempTbl6 e on a.loan_skey=e.loan_skey
/*left join #tempTbl7 f on a.loan_skey=f.loan_skey
left join #tempTbl8 g on a.loan_skey=g.loan_skey*/
left join (select * from(select a.loan_skey,a.Borrower_Name BRWR_NAME,a.email as 'BRWR_MAILID',
 b.Co_Borrower_Name as COBRWR_NAME1,b.email as 'COBRWR1_MAILID',
 c.Co_Borrower_Name as COBRWR_NAME2,c.email as 'COBRWR2_MAILID',
d.Co_Borrower_Name as COBRWR_NAME3,d.email as 'COBRWR3_MAILID',
a.mail_address1 MAIL_ADD1 ,a.mail_address2 MAIL_ADD2 ,a.mail_city MAIL_CITY,a.mail_state_code MAIL_STATE,a.Mail_zip MAIL_ZIP,
a.address1 PROP_ADD1,a.address2 PROP_ADD2,a.city PROP_CITY,a.state_code PROP_STATE, prop_zip PROP_ZIP
 from (
select 
a.loan_skey,contact_type_description,concat(upper(substring( first_name,1,1)),lower(substring( first_name,2,70))) Borrower_Name,a.email,
mail_address1,mail_address2,mail_city,mail_state_code,left(mail_zip_code,5) Mail_zip,
b.address1,b.address2,b.city,b.state_code,LEFT(b.zip_code,5) prop_zip
from rms.v_ContactMaster a
join rms.v_PropertyMaster b on a.loan_skey=b.loan_skey
where contact_type_description='Borrower') a
left join (select * from (select a.loan_skey,contact_type_description,concat(upper(substring( first_name,1,1)),lower(substring( first_name,2,70))) Co_Borrower_Name,email,
ROW_NUMBER() over (partition by a.loan_skey order by a.contact_skey ) sn
--,mail_address1,mail_address2,mail_city,mail_state_code,left(mail_zip_code,5) Mail_zip,
--b.address1,b.address2,b.city,b.state_code,LEFT(b.zip_code,5) prop_zip
from rms.v_ContactMaster a
join rms.v_PropertyMaster b on a.loan_skey=b.loan_skey
where contact_type_description='Co-Borrower') c where sn=1) b on a.loan_skey=b.loan_skey
left join (select * from (select a.loan_skey,contact_type_description,concat(upper(substring( first_name,1,1)),lower(substring( first_name,2,70))) Co_Borrower_Name,email,
ROW_NUMBER() over (partition by a.loan_skey order by a.contact_skey ) sn
--,mail_address1,mail_address2,mail_city,mail_state_code,left(mail_zip_code,5) Mail_zip,
--b.address1,b.address2,b.city,b.state_code,LEFT(b.zip_code,5) prop_zip
from rms.v_ContactMaster a
join rms.v_PropertyMaster b on a.loan_skey=b.loan_skey
where contact_type_description='Co-Borrower') c where sn=2) c on a.loan_skey=c.loan_skey
left join (select * from (select a.loan_skey,contact_type_description,concat(upper(substring( first_name,1,1)),lower(substring( first_name,2,70))) Co_Borrower_Name,email,
ROW_NUMBER() over (partition by a.loan_skey order by a.contact_skey ) sn
--,mail_address1,mail_address2,mail_city,mail_state_code,left(mail_zip_code,5) Mail_zip,
--b.address1,b.address2,b.city,b.state_code,LEFT(b.zip_code,5) prop_zip
from rms.v_ContactMaster a
join rms.v_PropertyMaster b on a.loan_skey=b.loan_skey
where contact_type_description='Co-Borrower') c where sn=3) d on a.loan_skey=d.loan_skey
)a
) h on a.loan_skey=h.loan_skey 
)a
)b where b.[Days Delq] between 1 and 61
order by b.[Loan key];



----For Rayan

select 
'VLT-REV-R0645-00000000000001' as 'REQUEST_ID',
'R0645' as 'LETTER_ID',
[Loan key] as 'LOAN_SKEY',
coalesce( BRWR_NAME,'') as BRWR_NAME,
coalesce( COBRWR_NAME1,'') as COBRWR_NAME1,
coalesce( COBRWR_NAME2,'') as COBRWR_NAME2,
coalesce( COBRWR_NAME3,'') as COBRWR_NAME3,
coalesce( MAIL_ADD1,'') as MAIL_ADD1,
coalesce( MAIL_ADD2,'') as MAIL_ADD2,
coalesce( MAIL_CITY,'') as MAIL_CITY,
coalesce( MAIL_STATE,'') as MAIL_STATE,
coalesce( MAIL_ZIP,'') as MAIL_ZIP,
coalesce( PROP_ADD1,'') as PROP_ADD1,
coalesce( PROP_ADD2,'') as PROP_ADD2,
coalesce( PROP_CITY,'') as PROP_CITY,
coalesce( PROP_STATE,'') as PROP_STATE,
coalesce( PROP_ZIP,'') as PROP_ZIP,
coalesce( Amount_Due,'') as Amount_Due,
coalesce( [Next Repayment Due Date] ,'') as 'NEXT_DUEDT',
coalesce( servicer_name,'')  as 'SERVICER_NAME',
coalesce( investor_name,'')  as 'INVESTOR_NAME'
from(
select 
a.[Loan key],
a.[Loan Status],
a.[FHA Case #],
a.[Notify Borrower of Approved Repayment Plan Start Date],
a.[Receipt of Signed Repayment Plan Complete Date],
a.[Submit Property Charge Loss Mitigation Extension],
a.[Repayment Plan Term],
a.[Monthly Repayment Amt],
a.[Surplus Income Amount],
a.[Down Payment Amount],
a.[Down Payment Due Date],
a.[First Repayment Due Date],
a.[Last Repayment Received Date],
a.[Next Repayment Due Date],
a.[Days Delq],
case when a.[Days Delq]>=30 then a.[Monthly Repayment Amt]*2+a.[Down Payment Amount]
when a.[Days Delq] between 1 and 29 then a.[Monthly Repayment Amt]*1+a.[Down Payment Amount]
when a.[Days Delq]<=0 then 0
else 0 end as 'Amount_Due',
a.[Cancellation Date],
a.[# Repayments Remaining],
a.[Orig. Repayment Amt],
a.[Remaining Amount],
a.[TOTS Balance],
a.[Default Reason],
a.[Default Date],
a.[Due & Payable Date],
a.[Initiate Extension Complete Date],
a.[Submit Extension Request for Time Complete Date],
a.[Upload Extension Package Complete Date],
a.[HUD Decision - Approved Complete Date],
a.[HUD Decision - Denied Complete Date],
a.[BRWR_NAME],a.BRWR_MAILID,
a.[COBRWR_NAME1],a.COBRWR1_MAILID,
a.[COBRWR_NAME2],a.COBRWR2_MAILID,
a.[COBRWR_NAME3],a.COBRWR3_MAILID,
a.[MAIL_ADD1],
a.[MAIL_ADD2],
a.[MAIL_CITY],
a.[MAIL_STATE],
a.[MAIL_ZIP],
a.[PROP_ADD1],
a.[PROP_ADD2],
a.[PROP_CITY],
a.[PROP_STATE],
a.[PROP_ZIP],
a.[Phone Number],
a.[BUSINESS_HOURS_WL],a.investor_name,a.servicer_name
from (
select a.loan_skey as 'Loan key',a.loan_status_description as 'Loan Status',a.[FHA Case #]
,CONVERT(varchar,a.[Notify Borrower of Approved Repayment Plan Start Date],23) as 'Notify Borrower of Approved Repayment Plan Start Date'
,CONVERT(varchar,a.[Receipt of Signed Repayment Plan Complete Date],23) as 'Receipt of Signed Repayment Plan Complete Date'
,CONVERT(varchar,a.[Submit Property Charge Loss Mitigation Extension],23) as 'Submit Property Charge Loss Mitigation Extension'
,b.[Repayment Plan Term],b.[Monthly Repayment Amt],b.surplus_income_amount as 'Surplus Income Amount'
,coalesce( case when b.down_payment_amount in (0,NULL,'') then 0 else b.down_payment_amount end,0)  as 'Down Payment Amount'
,CONVERT(varchar,b.[First Repayment Due Date],23) as 'First Repayment Due Date'
,CONVERT(varchar,b.[Last Repayment Received Date],23) as 'Last Repayment Received Date'
,CONVERT(varchar,b.[Next Repayment Due Date],23) as 'Next Repayment Due Date'
,DATEDIFF( DD, CONVERT(varchar,b.[Next Repayment Due Date],23),DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 1)) ) as 'Days Delq'
,CONVERT(varchar,(b.[Next Repayment Due Date]+60),23)  as 'Cancellation Date'
,case when b.[Last Repayment Received Date] is NULL then b.[Repayment Plan Term] else coalesce( b.[# Repayments Remaining],0) end as '# Repayments Remaining'
,coalesce(b.[Orig. Repayment Amt],0) as 'Orig. Repayment Amt'
,case when  b.[Last Repayment Received Date] is NULL then b.[Orig. Repayment Amt] else coalesce(b.[Remaining Amount],0) end as 'Remaining Amount'
,round(a.Tots,2) as 'TOTS Balance'
,case when a.loan_status_description='FORECLOSURE' then e.default_reason_description else  d.default_reason_description end  as 'Default Reason',
CONVERT(varchar,case when a.loan_status_description='FORECLOSURE' then e.default_date else d.default_date end,23) as 'Default Date'
,CONVERT(varchar,a.[Due & Payable Date],23) as 'Due & Payable Date'
,CONVERT(varchar,c.[Initiate Extension Complete Date],23) as 'Initiate Extension Complete Date'
,CONVERT(varchar,c.[Submit Extension Request for Time Complete Date],23) as 'Submit Extension Request for Time Complete Date'
,CONVERT(varchar,c.[Upload Extension Package Complete Date],23) as 'Upload Extension Package Complete Date'
,CONVERT(varchar,c.[HUD Decision - Approved Complete Date],23) as'HUD Decision - Approved Complete Date'
,CONVERT(varchar,c.[HUD Decision - Denied Complete Date],23) as 'HUD Decision - Denied Complete Date'
,CONVERT(varchar,b.[Down Payment Due Date],23) as 'Down Payment Due Date'
,h.BRWR_NAME,h.BRWR_MAILID,h.COBRWR_NAME1,h.COBRWR1_MAILID,h.COBRWR_NAME2,h.COBRWR2_MAILID
,h.COBRWR_NAME3,h.COBRWR3_MAILID,h.MAIL_ADD1,h.MAIL_ADD2,h.MAIL_CITY,h.MAIL_STATE,h.MAIL_ZIP,
h.PROP_ADD1,h.PROP_ADD2,h.PROP_CITY,h.PROP_STATE,h.PROP_ZIP,'1-866-799-7744' as 'Phone Number',
'Monday - Friday 8:00 a.m. - 7:00 p.m. ET.' as 'BUSINESS_HOURS_WL',
a.investor_name,a.servicer_name
from #tempTbl2 a
left join #tempTbl3 b on a.loan_skey=b.loan_skey
left join #tempTbl4 c on a.loan_skey=c.loan_skey
left join #tempTbl5 d on a.loan_skey=d.loan_skey
left join #tempTbl6 e on a.loan_skey=e.loan_skey
/*left join #tempTbl7 f on a.loan_skey=f.loan_skey
left join #tempTbl8 g on a.loan_skey=g.loan_skey*/
left join (select * from(select a.loan_skey,a.Borrower_Name BRWR_NAME,a.email as 'BRWR_MAILID',
 b.Co_Borrower_Name as COBRWR_NAME1,b.email as 'COBRWR1_MAILID',
 c.Co_Borrower_Name as COBRWR_NAME2,c.email as 'COBRWR2_MAILID',
d.Co_Borrower_Name as COBRWR_NAME3,d.email as 'COBRWR3_MAILID',
a.mail_address1 MAIL_ADD1 ,a.mail_address2 MAIL_ADD2 ,a.mail_city MAIL_CITY,a.mail_state_code MAIL_STATE,a.Mail_zip MAIL_ZIP,
a.address1 PROP_ADD1,a.address2 PROP_ADD2,a.city PROP_CITY,a.state_code PROP_STATE, prop_zip PROP_ZIP
 from (
select 
a.loan_skey,contact_type_description,
concat(upper(substring( first_name,1,1)),lower(substring( first_name,2,70)),' ',upper(substring( middle_name,1,1)),lower(substring( middle_name,2,70)),' ',upper(substring( last_name,1,1)),lower(substring( last_name,2,70)))
 Borrower_Name,a.email,
mail_address1,mail_address2,mail_city,mail_state_code,left(mail_zip_code,5) Mail_zip,
b.address1,b.address2,b.city,b.state_code,LEFT(b.zip_code,5) prop_zip
from rms.v_ContactMaster a
join rms.v_PropertyMaster b on a.loan_skey=b.loan_skey
where contact_type_description='Borrower') a
left join (select * from (select a.loan_skey,contact_type_description,
concat(upper(substring( first_name,1,1)),lower(substring( first_name,2,70)),' ',upper(substring( middle_name,1,1)),lower(substring( middle_name,2,70)),' ',upper(substring( last_name,1,1)),lower(substring( last_name,2,70)))
 Co_Borrower_Name,email,
ROW_NUMBER() over (partition by a.loan_skey order by a.contact_skey ) sn
--,mail_address1,mail_address2,mail_city,mail_state_code,left(mail_zip_code,5) Mail_zip,
--b.address1,b.address2,b.city,b.state_code,LEFT(b.zip_code,5) prop_zip
from rms.v_ContactMaster a
join rms.v_PropertyMaster b on a.loan_skey=b.loan_skey
where contact_type_description='Co-Borrower') c where sn=1) b on a.loan_skey=b.loan_skey
left join (select * from (select a.loan_skey,contact_type_description,
concat(upper(substring( first_name,1,1)),lower(substring( first_name,2,70)),' ',upper(substring( middle_name,1,1)),lower(substring( middle_name,2,70)),' ',upper(substring( last_name,1,1)),lower(substring( last_name,2,70)))
 Co_Borrower_Name,email,
ROW_NUMBER() over (partition by a.loan_skey order by a.contact_skey ) sn
--,mail_address1,mail_address2,mail_city,mail_state_code,left(mail_zip_code,5) Mail_zip,
--b.address1,b.address2,b.city,b.state_code,LEFT(b.zip_code,5) prop_zip
from rms.v_ContactMaster a
join rms.v_PropertyMaster b on a.loan_skey=b.loan_skey
where contact_type_description='Co-Borrower') c where sn=2) c on a.loan_skey=c.loan_skey
left join (select * from (select a.loan_skey,contact_type_description,
concat(upper(substring( first_name,1,1)),lower(substring( first_name,2,70)),' ',upper(substring( middle_name,1,1)),lower(substring( middle_name,2,70)),' ',upper(substring( last_name,1,1)),lower(substring( last_name,2,70)))
 Co_Borrower_Name,email,
ROW_NUMBER() over (partition by a.loan_skey order by a.contact_skey ) sn
--,mail_address1,mail_address2,mail_city,mail_state_code,left(mail_zip_code,5) Mail_zip,
--b.address1,b.address2,b.city,b.state_code,LEFT(b.zip_code,5) prop_zip
from rms.v_ContactMaster a
join rms.v_PropertyMaster b on a.loan_skey=b.loan_skey
where contact_type_description='Co-Borrower') c where sn=3) d on a.loan_skey=d.loan_skey
)a
) h on a.loan_skey=h.loan_skey 
)a
)b where b.[Days Delq] between 1 and 61
order by b.[Loan key];
