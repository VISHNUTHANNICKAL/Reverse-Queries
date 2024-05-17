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
	a.loan_status_description in ('DEFAULT', 'FORECLOSURE')   
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
	
	--select * from #tempTbl2;
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

	select * from #tempTbl5;
	select loan_skey,[Max RPP Duration] from #tempTbl5;

