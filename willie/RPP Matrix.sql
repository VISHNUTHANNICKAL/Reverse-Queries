IF OBJECT_ID('tempdb..#tempTbl') IS NOT NULL
    DROP TABLE #tempTbl;
	select a.loan_skey,a.loan_status_description,b.default_reason_description,b.due_and_payable_date,b.date_foreclosure_sale_scheduled
	,sum( c.principal_amount + c.interest_amount + c.mip_amount + c.service_fee_amount + c.corporate_advance_borrower_amount ) as 'Tots',
	case when d.[due date] is null then 'No' else 'Yes' end as 'Active Repay Plan',d.workflow_instance_skey,d.created_by into #tempTbl
	from rms.v_LoanMaster a
	left join [ReverseQuest].[rms].[v_LoanDefaultInformation] b
	on a.loan_skey=b.loan_skey
	left join ReverseQuest.rms.v_Transaction c
	on a.loan_skey=c.loan_skey and 
	((  c.effective_date <= GETDATE() ) OR (  c.transaction_date <= GETDATE() )) 
 AND c.include_in_cure_amount_flag    = 1 
	left join
	(SELECT[loan_skey],y.workflow_task_description
	  ,min(y.due_date) as 'due date'
	  ,y.complete_date,x.workflow_instance_skey,x.created_by
  FROM [ReverseQuest].[rms].[v_WorkflowInstance] x
   join
   [ReverseQuest].[rms].[v_WorkflowTaskActivity] y on x.workflow_instance_skey=y.workflow_instance_skey
  where y.workflow_task_description = 'Repayment Plan Installment Due'
  and x.status_description = 'Active'
  --and y.complete_date is null
  group by loan_skey,y.workflow_task_description,y.complete_date,x.workflow_instance_skey,x.created_by
   ) d
   on a.loan_skey=d.loan_skey
	where 
	a.loan_status_description not in ('DELETED','INACTIVE')
 GROUP BY a.loan_skey,a.loan_status_description,b.default_reason_description,
 b.due_and_payable_date,b.date_foreclosure_sale_scheduled,d.[due date],d.workflow_instance_skey,d.created_by;

 IF OBJECT_ID('tempdb..#tempTbl1') IS NOT NULL
    DROP TABLE #tempTbl1;
	select distinct * into #tempTbl1
	from #tempTbl ;

	IF OBJECT_ID('tempdb..#tempTbl2') IS NOT NULL
    DROP TABLE #tempTbl2;
	select a.loan_skey,a.loan_status_description,a.default_reason_description,a.due_and_payable_date,a.date_foreclosure_sale_scheduled
	,a.Tots,a.[Active Repay Plan]
	,b.workflow_task_description,a.created_by
	--,b.complete_date
	--,count(*)  as term 
	,sum(case when b.complete_date is null then 1 else 0 end) as 'pymts pending',
	sum(case when b.complete_date is not null then 1 else 0 end) as 'pymts made'
	into #tempTbl2
	from #tempTbl1 a
	left join
	[ReverseQuest].[rms].[v_WorkflowTaskActivity] b
	on a.workflow_instance_skey=b.workflow_instance_skey and b.workflow_task_description = 'Repayment Plan Installment Due'
	group by a.loan_skey,a.loan_skey,a.loan_status_description,a.default_reason_description,a.due_and_payable_date,a.date_foreclosure_sale_scheduled
	,a.[Active Repay Plan],a.Tots,b.workflow_task_description,a.created_by
	--,b.complete_date
	--having a.loan_skey = '1492'
	;
	
	--select * from #tempTbl2 where  loan_skey=17614;
	IF OBJECT_ID('tempdb..#tempTbl3') IS NOT NULL
    DROP TABLE #tempTbl3;
	SELECT 
      a.loan_skey, a.[total_remittance_amount],a.created_date,b.check_date,b.remit_type_description
	  into #tempTbl3
	  FROM [ReverseQuest].[rms].[v_LoanRemitHeader] a
  join
  [ReverseQuest].[rms].[v_LoanRemit] b
  on a.loan_remit_header_skey=b.loan_remit_header_skey
  where 
  a.loan_skey in (select distinct loan_skey from  #tempTbl )
  and
   a.long_transaction_description = 'Part Repay - Reduce Loan Balance' and a.status_description = 'Active';

   
   --select * from #tempTbl1 where [Active Repay Plan] = 'No';

   IF OBJECT_ID('tempdb..#tempTbl4') IS NOT NULL
    DROP TABLE #tempTbl4;
   select a.*,a.[pymts made]+a.[pymts pending] as 'RPP Term'
   ,count(b.created_date) as 'Pymts since due&payable'
   ,60-count(b.created_date) as 'Max RPP Duration' into #tempTbl4
   from #tempTbl2 a
   left join
   #tempTbl3 b
   on a.loan_skey=b.loan_skey and b.created_date>a.due_and_payable_date
   group by
   a.loan_skey,a.loan_skey,a.loan_status_description,a.default_reason_description,a.due_and_payable_date,a.date_foreclosure_sale_scheduled
	,a.[Active Repay Plan],a.Tots,a.workflow_task_description,a.[pymts made],a.[pymts pending],a.created_by;

	--select * from #tempTbl4 where loan_skey=17614;

	IF OBJECT_ID('tempdb..#tempTbl5') IS NOT NULL
    DROP TABLE #tempTbl5;
	select a.loan_skey,a.loan_status_description,a.default_reason_description,
	format(a.due_and_payable_date,'MM-dd-yyyy') as due_and_payable_date
	,a.[Pymts since due&payable],
	format(a.date_foreclosure_sale_scheduled,'MM-dd-yyyy') as date_foreclosure_sale_scheduled
	,a.Tots,a.[Active Repay Plan],a.[RPP Term],a.[pymts made],a.[pymts pending]
	,a.[Max RPP Duration]
	,case when a.[Pymts since due&payable] >=60 then 'Yes' else 'No' end as 'Non-Compliance'
	,case when a.[pymts pending] > a.[Max RPP Duration] then 'Yes' else 'No' end as 'Setup Error',
	case when a.[pymts pending] > a.[Max RPP Duration] then a.[pymts pending] - a.[Max RPP Duration] else 0 end as 'Months NonCompliance',a.created_by
	,b.servicer_name,b.investor_name into #tempTbl5
	from #tempTbl4 a
	join
	ReverseQuest.rms.v_LoanMaster b
	on a.loan_skey=b.loan_skey;





/*
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
	and b.status_description='Active'
  group by b.loan_skey,b.default_reason_description
,b.default_date,b.workflow_type_description,b.status_description,b.created_by
) b 
) a
where --loan_skey =210068 and 
rn=1
*/
-- select * from  #tempTbl6 where loan_skey=1300

IF OBJECT_ID('tempdb..#tempTbl7') IS NOT NULL
    DROP TABLE #tempTbl7;
select * 
into #tempTbl7
from (
select 
b.loan_skey
,b.workflow_type_description,b.status_description,b.complete_date,
b.created_date
,b.created_by
,ROW_NUMBER() OVER (PARTITION BY b.loan_skey ORDER BY b.complete_date desc) rn
from(select
b.loan_skey--,b.default_reason_description,b.default_date
,b.workflow_type_description,b.status_description,convert(date,a.complete_date) complete_date,b.created_date as created_date,b.created_by
	from   [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
	 join [ReverseQuest].[rms].[v_WorkflowInstance] b
	 on a.workflow_instance_skey=b.workflow_instance_skey
	 where --b.loan_skey=1930 and
	  b.workflow_type_description in ('Pre Due & Payable w/HUD Approval','Due & Payable w/ HUD Approval','Due & Payable w/o HUD Approval')
	and a.workflow_task_description='Default Event Occurred'
	and a.status_description in('Active')
	and b.status_description in('Workflow Completed','Active')
	and a.complete_date is not null
 -- group by b.loan_skey,b.default_reason_description
--,b.default_date,b.workflow_type_description,b.status_description,b.created_by
) b 
) a
where --loan_skey =210068 and 
rn=1



IF OBJECT_ID('tempdb..#tempTbl10') IS NOT NULL
    DROP TABLE #tempTbl10;
select 
b.loan_skey,loan_status_description
,[Repayment Plan Broken Reason]
,sum(Count1)+1  '# of RPP being set up'
,state_code 'property_state'
,case when 
DATEDIFF(MONTH,convert(date,[Default Event Occurred]),convert(date,getdate())) >12 then 'Greater than 12 months'
when 
DATEDIFF(MONTH,convert(date,[Default Event Occurred]),convert(date,getdate())) <=12 then 'Less than 12 months'
else 'NO' end
'Default'
, case when 
DATEDIFF(day,convert(date,[Foreclosure Sale Scheduled]),convert(date,getdate())) >=45 then 'Greater than 45'
when 
DATEDIFF(day,convert(date,[Foreclosure Sale Scheduled]),convert(date,getdate())) <45 then 'Less than 45'
else 'NO' end 
'FC_ sale_date'
,[Months of Eligiblity remaining ]
,[Repayment Plan Broken Complete Date]
,[Foreclosure Sale Scheduled]
,[Default Event Occurred]
--,DATEDIFF(MONTH,convert(date,[Default Event Occurred]),convert(date,getdate()))
--,sum(Count1) '# of RPP Since Default'
,[Default plus 12 mths]
into #tempTbl10
from (
select 
a.loan_skey,loan_status_description,state_code,[Foreclosure Sale Scheduled],[Default Event Occurred]
,[Months of Eligiblity remaining ],[Repayment Plan created date]
,case when [Default Event Occurred]<=[Repayment Plan created date] then 1 else 0 end Count1
,[Repayment Plan Broken Complete Date]
, [Repayment Plan Broken Reason],[Default plus 12 mths]

from (
select a.loan_skey ,a.loan_status_description,j.state_code
--,b.date_foreclosure_sale_scheduled
,i.due_date 'Foreclosure Sale Scheduled',
--CONVERT(date,case when a.loan_status_description='FORECLOSURE' then e.default_date else d.default_date end) 
e.complete_date as 'Default Event Occurred'
,f.[Max RPP Duration] 'Months of Eligiblity remaining '
,convert(date,g.created_date) 'Repayment Plan created date' 
,h.complete_date 'Repayment Plan Broken Complete Date'
,h.task_note 'Repayment Plan Broken Reason'
,dateadd(year,1,e.complete_date) 'Default plus 12 mths'
--,case when dateadd(year,1,e.complete_date) > k.created_date then 1 else 0 end Count2
from rms.v_LoanMaster a
left join [ReverseQuest].[rms].[v_LoanDefaultInformation] b
	on a.loan_skey=b.loan_skey
--left join #tempTbl6 d on a.loan_skey=d.loan_skey
left join #tempTbl7 e on a.loan_skey=e.loan_skey
left join #tempTbl5 f on a.loan_skey=f.loan_skey
left join
(
 select * from (
  select 
b.loan_skey,convert(date,a.complete_date) complete_date ,b.workflow_type_description,a.workflow_task_description
,a.task_note,
ROW_NUMBER() over (partition by b.loan_skey order by a.complete_date desc,b.loan_skey) sn
    FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join
  [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
   join ReverseQuest.rms.v_LoanMaster c  on b.loan_skey=c.loan_skey
   where --b.loan_skey=1930 and 
    b.workflow_type_description ='Repayment Plan'
   and a.workflow_task_description='Repayment Plan Broken'
   and b.status_description in ('Active','Workflow Completed')
   and a.status_description in ('Active','Workflow Completed')
    and a.complete_date is not null
   ) a where sn=1
)h on a.loan_skey=h.loan_skey
left join (
select 
b.loan_skey
,b.workflow_type_description
,b.created_date,b.created_by,b.status_description
    FROM 
  [ReverseQuest].[rms].[v_WorkflowInstance] b
    join ReverseQuest.rms.v_LoanMaster c  on b.loan_skey=c.loan_skey
   where --b.loan_skey=2549 and 
    b.workflow_type_description ='Repayment Plan'   
   and b.status_description in ('Active','Workflow Completed')
) g on a.loan_skey=g.loan_skey --and a.[Default Event Occurred]>=g.created_date
left join
(
 select * from (
  select 
b.loan_skey,convert(date,a.complete_date) complete_date 
,convert(date,a.due_date) due_date
,b.workflow_type_description,a.workflow_task_description
,a.task_note,
ROW_NUMBER() over (partition by b.loan_skey order by convert(date,a.due_date) desc,b.loan_skey) sn
    FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join
  [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
   join ReverseQuest.rms.v_LoanMaster c  on b.loan_skey=c.loan_skey
   where-- b.loan_skey=221558 and 
    b.workflow_type_description  in ('Foreclosure - Non Judicial','Foreclosure - Judicial')
   and a.workflow_task_description='Foreclosure Sale Scheduled'
   and b.status_description in ('Active')
   and a.status_description in ('Active')
    and a.complete_date is not null
   ) a where sn=1
)i on a.loan_skey=i.loan_skey
join rms.v_PropertyMaster j on a.loan_skey=j.loan_skey
where a.loan_status_description not in ('DELETED','INACTIVE')

)a
)b
--where loan_skey=221558
group by b.loan_skey,loan_status_description,b.state_code,[Foreclosure Sale Scheduled],[Default Event Occurred],
[Months of Eligiblity remaining ],[Repayment Plan Broken Complete Date]
,[Repayment Plan Broken Reason],[Default plus 12 mths]
order by loan_skey;


--select top 100 * from rms.v_PropertyMaster
select a.loan_skey,a.loan_status_description,a.[Repayment Plan Broken Reason],a.[# of RPP being set up]
,a.property_state,a.[Default],a.[FC_ sale_date],a.[Months of Eligiblity remaining ],a.[Repayment Plan Broken Complete Date],
a.[Foreclosure Sale Scheduled],a.[Default Event Occurred],a.[Default plus 12 mths],
sum(Count1) as 'Count of RPP past 12 months'
,case when sum(Count1) <=0 then 'YES' else 'NO' end as '1st  Plan > than 12 months'
from (
select a.loan_skey,a.loan_status_description,a.[Repayment Plan Broken Reason],a.[# of RPP being set up]
,a.property_state,a.[Default],a.[FC_ sale_date],a.[Months of Eligiblity remaining ],a.[Repayment Plan Broken Complete Date],
a.[Foreclosure Sale Scheduled],a.[Default Event Occurred],a.[Default plus 12 mths]
,case when k.created_date>=convert(date,a.[Default plus 12 mths]) then 1 else 0 end as Count1
from #tempTbl10 a
left join (
select 
b.loan_skey,convert(date,a.created_date) created_date 
--,convert(date,a.due_date) due_date
,b.workflow_type_description,a.workflow_task_description
--,a.task_note,
--ROW_NUMBER() over (partition by b.loan_skey order by convert(date,a.due_date) desc,b.loan_skey) sn
    FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join
  [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
   join ReverseQuest.rms.v_LoanMaster c  on b.loan_skey=c.loan_skey
   where-- b.loan_skey=221558 and 
    b.workflow_type_description  in ('Repayment Plan')
   and a.workflow_task_description in ('Notify Borrower of Approved Repayment Plan')
   and b.status_description in  ('Active','Workflow Completed')
   and a.status_description in ('Active','Workflow Completed')
  --  and a.complete_date is not null
)k on a.loan_skey=k.loan_skey and k.created_date>=convert(date,a.[Default plus 12 mths])
) a 
group by a.loan_skey,a.loan_status_description,a.[Repayment Plan Broken Reason],a.[# of RPP being set up]
,a.property_state,a.[Default],a.[FC_ sale_date],a.[Months of Eligiblity remaining ],a.[Repayment Plan Broken Complete Date],
a.[Foreclosure Sale Scheduled],a.[Default Event Occurred],a.[Default plus 12 mths]
order by a.loan_skey;

/*

left join (
select 
b.loan_skey,convert(date,a.created_date) created_date 
,convert(date,a.due_date) due_date
,b.workflow_type_description,a.workflow_task_description
,a.task_note,
ROW_NUMBER() over (partition by b.loan_skey order by convert(date,a.due_date) desc,b.loan_skey) sn
    FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join
  [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
   join ReverseQuest.rms.v_LoanMaster c  on b.loan_skey=c.loan_skey
   where-- b.loan_skey=221558 and 
    b.workflow_type_description  in ('Repayment Plan')
   and a.workflow_task_description in ('Notify Borrower of Approved Repayment Plan')
   and b.status_description in  ('Active','Workflow Completed')
   and a.status_description in ('Active','Workflow Completed')
  --  and a.complete_date is not null
)k on b.loan_skey=k.loan_skey
*/