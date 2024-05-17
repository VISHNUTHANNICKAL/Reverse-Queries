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
	  b.workflow_type_description in ('Pre Due & Payable w/HUD Approval','Due & Payable w/ HUD Approval','Due & Payable w/o HUD Approval')
	--and a.workflow_task_description='HUD Decision - Denied'
	and b.status_description='Active'
  group by b.loan_skey,b.default_reason_description
,b.default_date,b.workflow_type_description,b.status_description,b.created_by
) b 
) a
where --loan_skey =210068 and 
rn=1
-- select distinct workflow_type_description from [ReverseQuest].[rms].[v_WorkflowInstance]  where workflow_type_description
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
	  b.workflow_type_description in ('Pre Due & Payable w/HUD Approval','Due & Payable w/ HUD Approval','Due & Payable w/o HUD Approval')
	--and a.workflow_task_description='HUD Decision - Denied'
	and b.status_description='Workflow Completed'
  group by b.loan_skey,b.default_reason_description
,b.default_date,b.workflow_type_description,b.status_description,b.created_by
) b 
) a
where --loan_skey =210068 and 
rn=1





select 'PHH1' as 'SITE ID',
a.loan_skey,servicer_name,investor_name,SSN
,coalesce(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([Borrower First Name], '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),'') [Borrower First Name]
,coalesce(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([Borrower Last Name], '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),'') [Borrower Last Name]
,coalesce([Borrower’s email Address],'') [Borrower’s email Address]
,coalesce([Co-Borrower First Name],'') [Co-Borrower First Name]
,coalesce([Co-Borrower Last Name],'') [Co-Borrower Last Name]
,coalesce([Co-Borrower’s email address],'') [Co-Borrower’s email address]
,coalesce(address1,'') address1
,coalesce(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(city, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),'') city
,coalesce(state_code,'') state_code
,coalesce(prop_zip,'') prop_zip
,coalesce(loan_status_description,'') loan_status_description
,coalesce(loan_sub_status_description,'') loan_sub_status_description
,coalesce(loan_balance,'') loan_balance
,coalesce(tots_balance,'') tots_balance
,coalesce(convert(varchar,b.due_date,101),'') [Repayment Plan Due Date]
,coalesce([Repayment plan Installment],'') [Repayment plan Installment]
,coalesce(convert(varchar,[Due & Payable Date],101),'') [Due & Payable Date]
,coalesce([Product Type],'') [Product Type]

--,[HOA Balance],[HOA DUE AMOUNT],
,coalesce(convert(varchar,[Foreclosure Sale Date],101),'') [Foreclosure Sale Date]
,coalesce([Min Amount],'') [Min Amount]
,coalesce([Max Amount],'') [Max Amount]
,coalesce([Default Reason],'') [Default Reason]
,coalesce( case when loan_status_description in ('Foreclosure') and a.sn<= 20 and [Repayment plan Installment]<=0 then 'Reject'
when loan_status_description in ('Foreclosure')and [Repayment plan Installment]<=0 and [Default Reason] in  ('Death','Conveyed Title',NULL)
then 'Reject'
else Accept end,'') as Accept 
,coalesce(case when loan_status_description in ('Foreclosure') and a.sn<= 20 and [Repayment plan Installment]<=0
then 'less than 20 days with zero Repayment plan Installment'
when loan_status_description in ('Foreclosure')and [Repayment plan Installment]<=0 and [Default Reason] in  ('Death','Conveyed Title',NULL)
then 'Default Reason'
else [Reject Reason] end,'') as
[Reject Reason]
/*,case when [Reject Reason] not like '' then 'We cannot process your payment at this time. Please contact our Customer Service Department at 866 503 5559 for further assistance' 
when loan_status_description in ('Foreclosure') and a.sn<= 20 and [Repayment plan Installment]<=0
then 'We cannot process your payment at this time. Please contact our Customer Service Department at 866 503 5559 for further assistance'
when loan_status_description in ('Foreclosure')and [Repayment plan Installment]<=0 and [Default Reason] in  ('Death','Conveyed Title',NULL)
then 'We cannot process your payment at this time. Please contact our Customer Service Department at 866 503 5559 for further assistance'
else '' end as 'Reject Verbiage'*/
--,sn
from 
(
select 
a.loan_skey,
a.servicer_name,
a.investor_name,b.SSN,
b.first_name 'Borrower First Name',
b.last_name 'Borrower Last Name',b.email 'Borrower’s email Address',
c.first_name 'Co-Borrower First Name',
c.last_name 'Co-Borrower Last Name',c.email 'Co-Borrower’s email address',
concat (b.address1,' ',b.address2) as 'address1',
b.city,b.state_code,b.prop_zip,a.loan_status_description,a.loan_sub_status_description
,a.loan_balance
,coalesce( h.Tots,0) tots_balance
,coalesce( e.[Monthly Repayment Amt],0) as 'Repayment plan Installment'
,CONVERT(varchar,coalesce(f.due_and_payable_date,NULL),101) as  'Due & Payable Date'
,a.product_type_description as 'Product Type'

,case when a.loan_status_description in ('DEFAULT') and coalesce(f.due_and_payable_date,NULL) is  null and coalesce( e.[Monthly Repayment Amt],0)<=0 then 100
when a.loan_status_description in ('DEFAULT') and coalesce(f.due_and_payable_date,NULL) is not null and coalesce( e.[Monthly Repayment Amt],0) <=0 then coalesce( h.Tots,0)
when a.loan_status_description in ('FORECLOSURE')  and coalesce( e.[Monthly Repayment Amt],0) <=0 then coalesce( h.Tots,0)
when a.loan_status_description in ('DEFAULT','FORECLOSURE')  and coalesce( e.[Monthly Repayment Amt],0) >=1 then coalesce( e.[Monthly Repayment Amt],0)
when a.loan_status_description='ACTIVE'  then 100 
else 0 end 'Min Amount'

,cast(a.loan_balance*0.90 as decimal(20,2)) 'Max Amount'
,d.corporate_advance_S305_HOA_balance 'HOA Balance'
,case when d.corporate_advance_S305_HOA_balance>=1 and e.[Monthly Repayment Amt]<=0
then d.corporate_advance_S305_HOA_balance else cast(a.loan_balance*0.90 as decimal(20,2))
end as 'HOA DUE AMOUNT'
,convert(date,g.due_date) as 'Foreclosure Sale Date'
, case when a.loan_sub_status_description in ('Default Conveyed Title','Default Occupancy','Default Death','Default DIL','Default Short Sale','Active DIL','Active Short Sale','CT 22 Assignment - Filed'
,'Deferred Pending - eNBS','MIssing Critical Docs','Pending Documents','Pending QC','Review REquired') or a.loan_skey in (select loan_skey from rms.v_Alert where alert_type_description
like 'Litigation%' and alert_status_description='Active') or b.state_code='NM' or ( a.loan_status_description in ('DEFAULT','FORECLOSURE') and a.fha_case_number in ('',NULL) and coalesce( e.[Monthly Repayment Amt],0) <=0 )or
(a.loan_status_description in ('DEFAULT','FORECLOSURE') and a.product_type_description in('HECM - TX') and coalesce( e.[Monthly Repayment Amt],0) <= 0) or
(a.loan_status_description in ('DEFAULT','FORECLOSURE') and coalesce( h.Tots,0)<=0 and coalesce( e.[Monthly Repayment Amt],0) <= 0)
--or (a.loan_status_description='FORECLOSURE' and convert(int,datediff(day,convert(date,g.due_date),convert(date,GETDATE())))<= 20 and e.[Monthly Repayment Amt]<=0)
then 'Reject' 
else 'Post' end  as 'Accept'
, case when a.loan_sub_status_description in ('Default Conveyed Title','Default Occupancy','Default Death','Default DIL','Default Short Sale','Active DIL','Active Short Sale','CT 22 Assignment - Filed'
,'Deferred Pending - eNBS','MIssing Critical Docs','Pending Documents','Pending QC','Review REquired') then a.loan_sub_status_description
when a.loan_skey in (select loan_skey from rms.v_Alert where alert_type_description
like 'Litigation%' and alert_status_description='Active') then 'Litigation Alert is Active'
when b.state_code='NM' then 'State Code is NM ' 
when ( a.loan_status_description in ('DEFAULT','FORECLOSURE') and a.fha_case_number in ('',NULL) and coalesce( e.[Monthly Repayment Amt],0) <=0) then 'FHA Case is blank and Repayment Installment Due is less than zero'
when ( a.loan_status_description in ('DEFAULT','FORECLOSURE') and a.product_type_description in('HECM - TX') and coalesce( e.[Monthly Repayment Amt],0) <= 0) then 'HECM - TX with Repayment plan Installment is less than zero'
when (a.loan_status_description in ('DEFAULT','FORECLOSURE') and coalesce( h.Tots,0)<=0 and coalesce( e.[Monthly Repayment Amt],0) <= 0) then 'Loan Status with zero TOTS'
--when (a.loan_status_description='FORECLOSURE' and convert(int,datediff(day,convert(date,g.due_date),convert(date,GETDATE())))<= '20' and e.[Monthly Repayment Amt]<=0)
--then 'less than 20 days with zero Repayment plan Installment'
else '' end as 
'Reject Reason'
,case when a.loan_status_description='FORECLOSURE' then j.default_reason_description else  i.default_reason_description end  as 'Default Reason'
,datediff(day,convert(date,GETDATE()),convert(date,g.due_date)) sn 
--,e.due_date 'Repayment Plan Due Date'
from [rms].[v_LoanMaster] a
left join (
select 
a.loan_skey,contact_type_description,right(a.ssn,4) SSN
--,concat(upper(substring( first_name,1,1)),lower(substring( first_name,2,70)),' ',upper(substring( last_name,1,1)),lower(substring( last_name,2,70))) Borrower_Name
,a.first_name,a.last_name
,a.email,
mail_address1,mail_address2,mail_city,mail_state_code,left(mail_zip_code,5) Mail_zip,
b.address1,b.address2,b.city,b.state_code,LEFT(b.zip_code,5) prop_zip,a.home_phone_number as "Borrower  Home Phone Number",a.cell_phone_number as "Borrower Cell Phone Number",a.work_phone_number as"Borrower Work Phone Number",a.death_date as "Borrower_death_date"
from rms.v_ContactMaster a
join rms.v_PropertyMaster b on a.loan_skey=b.loan_skey
where a.contact_type_description='Borrower'
) b on a.loan_skey=b.loan_skey 
left join ( select * from (
select loan_skey,first_name,last_name,email,
ROW_NUMBER() over (partition by loan_skey order by loan_skey) sn 
from rms.v_ContactMaster where contact_type_description='Co-Borrower'
)a where sn=1
) c on a.loan_skey=c.loan_skey
left join rms.v_MonthlyLoanDefaultSummary d on a.loan_skey=d.loan_skey
and d.created_date  >=   DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
and d.created_date <  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
left join (
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
		--a.due_date,
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
  b.repayment_plan_term,b.status_description,b.created_by,b.surplus_income_amount--,a.due_date
  )e on a.loan_skey=e.loan_skey
left join rms.[v_LoanDefaultInformation] f on a.loan_skey=f.loan_skey
left join(
select 
b.loan_skey,a.due_date,a.complete_date,b.workflow_type_description,a.workflow_task_description
    FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join
  [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
   join ReverseQuest.rms.v_LoanMaster c  on b.loan_skey=c.loan_skey
   where --b.loan_skey=1930 and 
    b.workflow_type_description ='Foreclosure - Non Judicial'
   and a.workflow_task_description='Foreclosure Sale Scheduled'
   and b.status_description='Active'
   and a.status_description='Active'
   and a.complete_date is not null
)g on a.loan_skey=g.loan_skey
left join(
 select c.loan_skey,
  sum( e.principal_amount + e.interest_amount + e.mip_amount + e.service_fee_amount + e.corporate_advance_borrower_amount ) as 'Tots'
  from
  ReverseQuest.rms.v_LoanMaster c
  left join   ReverseQuest.rms.v_Transaction e
	on c.loan_skey=e.loan_skey and 
	((  e.effective_date <= GETDATE() ) OR (  e.transaction_date <= GETDATE() )) 
 AND e.include_in_cure_amount_flag    = 1 
 --where c.loan_skey=12515
 group by c.loan_skey
)h on a.loan_skey=h.loan_skey
left join #tempTbl5 i on a.loan_skey=i.loan_skey
left join #tempTbl6 j on a.loan_skey=j.loan_skey

where  a.loan_status_description in ('ACTIVE','DEFAULT','Foreclosure')
) a
left join ( select * from (
 select 
		b.loan_skey,
		b.workflow_instance_skey,
		b.workflow_type_description,convert(date,a.due_date) 'due_date'
		,a.workflow_task_description
		,ROW_NUMBER() over (PARTITION by b.loan_skey order by a.due_date asc,b.loan_skey) sn

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
		and a.complete_date is null
		--order by b.loan_skey,a.due_date
 ) a where sn=1
)b on a.loan_skey=b.loan_skey
order by a.loan_skey;


--select distinct alert_type_description from rms.v_Alert where alert_type_description like 'Litigation%'
