IF OBJECT_ID('tempdb..#tblTemp') IS NOT NULL
    DROP TABLE #tblTemp;
SELECT RLS.LOAN_SKEY as 'Loan Skey',
bnm.first_name as 'Borrower First Name',
bnm.email as 'Email Address'
,(apm.address1 ) as 'Property Address1',
apm.state_code as 'Property State',
RLS.[prior_servicer_name] as 'Prior_servicer'
,RLS.[investor_name]
,RLS.[boarding_type_description]
,CAST(RLS.created_date AS DATE) 'Boarded Date'
,rls.LESA_type_description as 'LESA Type'
,rls.LESA_payment_status_description as 'LESA Payment Status'
,rls.LESA_semiannual_amount as 'Semi-Annual Payment'
,x.pymt_method as 'Payment Method'
,rls.monthly_principal_amount 'Net Monthly Payment'
,rls.payment_plan_description as 'Payment Plan'
,rls.payments_remain as 'Payments Remaining'
,rls.loan_status_description as 'Loan status'
,rls.payment_status_description as 'Payment Status'
,APM.property_type_description,
case when rls.payment_plan_description in ('Modified Term','Modified Tenure','Line of Credit','Tenure','Term') then (Curr_bal.principal_limit_amount
-Curr_bal.Total_Loan_Balance
-Curr_bal.service_fee_set_aside_amount
-Curr_bal.first_year_set_aside_amount
-Curr_bal.repair_set_aside_amount
-curr_bal.LESA_amount
-(Curr_bal.credit_line_amount
- Curr_bal.unscheduled_credit_disbursement_balance))
else 0 end 'Total Funds Available'
,Curr_bal.LESA_amount
,Curr_bal.credit_line_amount as 'Current Net Credit Line '
into #tblTemp
FROM [ReverseQuest].RMS.v_LoanMaster RLS
LEFT JOIN [ReverseQuest].RMS.v_LoanRate RT
ON RLS.loan_skey = RT.loan_skey
LEFT JOIN [ReverseQuest].rms.v_PropertyMaster apm
on apm.loan_skey = RLS.loan_skey
left join [ReverseQuest].rms.v_ContactMaster bnm
on bnm.loan_skey = rls.loan_skey
and bnm.contact_type_description = 'Borrower'
LEFT JOIN [ReverseQuest].RMS.v_LoanDefaultInformation LDI
ON RLS.LOAN_SKEY = LDI.loan_skey
left join
RQER.dbo.stg_hermit_pae x
on RLS.loan_skey =x.loan_skey
left join (Select loan_skey
, Sum(principal_amount) as principal_amount
,Sum(interest_amount) as interest_amount
,Sum(case when long_Transaction_description = 'Initial MIP - Paid by Borrower' then 0 else mip_amount end) as mip_amount
,Sum(service_fee_amount) as service_fee_amount
,Sum(principal_amount) + Sum(interest_amount) + Sum(case when long_Transaction_description = 'Initial MIP - Paid by Borrower' then 0 else mip_amount end) + Sum(service_fee_amount) as Total_Loan_Balance
,Sum(principal_limit_amount) as principal_limit_amount
,sum(case when long_transaction_description in ('Disb - Scheduled','Disb - Scheduled Void','Disb - Unscheduled from LOC Void','Disb - Unscheduled from LOC') then principal_amount else 0 end) Draws
,sum(service_fee_set_aside_amount) service_fee_set_aside_amount
,sum(first_year_set_aside_amount) first_year_set_aside_amount
,sum(repair_set_aside_amount) repair_set_aside_amount
,sum(credit_line_amount) credit_line_amount
, sum(LESA_amount) LESA_amount
,sum(case when --long_transaction_description in ('UnSch LOC Disb - Int & MIP/PMI Accrual','Disb - Unscheduled from LOC','Disb - Unscheduled from LOC Inspections','Disb - Unscheduled from LOC Attorney Fee','Disb - Unscheduled from LOC Taxes')
long_transaction_description like '%unsch%'
then (principal_amount+unscheduled_disbursement_accrual_amount) else 0 end) unscheduled_credit_disbursement_balance
From [ReverseQuest].rms.v_Transaction
--Where transaction_date = CAST( GETDATE()-1 AS Date )
group by loan_skey) Curr_bal
on Curr_bal.loan_skey = rls.loan_skey
where 
-- rls.created_date > Convert(datetime, '2022-02-28' )
 rls.created_date >= Convert(datetime, '2022-08-01' )
 and
	rls.created_date < Convert(datetime, '2022-08-20' )
 and 
 rls.loan_status_description = 'ACTIVE';

IF OBJECT_ID('tempdb..#tblTemp1') IS NOT NULL
    DROP TABLE #tblTemp1;
select [Loan Skey],[Borrower First Name],[Email Address], [Property Address1],[Property State],[boarding_type_description],[investor_name]
,Prior_servicer as 'Prior Servicer Original'
 ,case when boarding_type_description = 'Flow Loan' then 
	case when [investor_name] = 'PHH Mortgage Services' then 'Liberty Reverse Mortgage'
		 when [investor_name] = 'Moneyhouse' then 'Moneyhouse' 
	end
 else null
end as 'Prior_servicer'
,format([Boarded Date],'MM/dd/yyyy') as 'Servicing Transfer date'
,FORMAT(DATEPART(month,[Boarded Date]),'00') + '_' + FORMAT(DATEPART(day,[Boarded Date]),'00')as 'Servicing Transfer date 2',[Payment Method]
,[LESA Type]
,case when [LESA Type] = 'Not Required' then 'N' else 'Y' end as 'LESA'
,'PHH' as 'Logo 1','' as 'Logo 2',
case when [Payment Plan] = 'Line of Credit' and [Total Funds Available]>100  then 'Unscheduled'
	 when ([Payment Plan] = 'Term' and [Payments Remaining] >0) or  [Payment Plan] = 'Tenure' then 'Scheduled'
	 when  ([Payment Plan] = 'Modified Term' and [Total Funds Available]>100) and [Current Net Credit Line ] > 100 then 'Both'
	 when ([Payment Plan] = 'Modified Tenure' and [Total Funds Available]>100 ) and [Current Net Credit Line ] > 100 then 'Both'
	 else null end as 'Plan_TYPE'
,case when boarding_type_description = 'Flow Loan' and investor_name = 'PHH Mortgage Services' then 'Retail'
	  when boarding_type_description = 'Flow Loan' and investor_name <> 'PHH Mortgage Services' then 'Flow'
end as 'Loan_Type'
,[LESA Payment Status],LESA_amount,[Semi-Annual Payment],[Payment Plan],[Payments Remaining],[Net Monthly Payment],[Current Net Credit Line ]
,[Total Funds Available],[Loan Status], [Payment Status] into #tblTemp1
from #tblTemp where
 [Email Address] is not null and len([Email Address])>0 and
 [investor_name] not like '%HUD Reconveyance'
;

/*select * from #tblTemp1;
select pymt_method, a.*
from rqer.dbo.stg_hermit_pae a
where loan_skey in ('325914','325922','325971')

select distinct * from  #tblTemp2 where [loan skey] = '326134';

select * from #tblTemp2 order by [servicing transfer date]
where 
--[Payment Plan] = 'Term'
Plan_TYPE is null
;*/

IF OBJECT_ID('tempdb..#tblTemp2') IS NOT NULL
    DROP TABLE #tblTemp2;
select a.[Loan Skey],a.[Property Address1],a.[Property State],a.[Borrower First Name],a.[Email Address],a.Prior_servicer, a.[Servicing Transfer date],a.[Servicing Transfer date 2]
,case when a.[Payment Method] is null and b.loan_skey is not null then 'Check' else a.[Payment Method] end as 'Payment Method',
 --,a.[Payment Method],
[LESA Type],LESA,[Logo 1],[Logo 2],case when Plan_TYPE is null then 'Y' else ' '  end as 'Fixed'
,case when (Plan_TYPE = 'Scheduled' or Plan_TYPE = 'Both') then  FORMAT( dateadd(m,datediff(m,0, dateadd(month,1,[Servicing Transfer date] )),0 ),'MM/dd/yyyy')
else '' end as 'First_payment_date',Plan_TYPE,Loan_Type
,b.loan_skey
into #tblTemp2
from #tblTemp1 a
left join
(select loan_skey from [ReverseQuest].[rms].[v_Note]
where note_text in('Level 2 QC completed & QC checklist printed in RQ','Level 1 QC completed & QC checklist printed in RQ')
)b on a.[Loan Skey]=b.loan_skey;


/*select distinct * from #tblTemp2 
where 
[payment method] is not null
order by [servicing transfer date];*/

IF OBJECT_ID('tempdb..#tblFinal') IS NOT NULL
    DROP TABLE #tblFinal;
select [Loan Skey],Right([Loan Skey],4) as 'Last 4 Loan Skey',[Property State],[Email Address]
,[Borrower First Name],[Property Address1] as PropertyAddress1
--,IsNull([Email Address],'') as 'Email Address'
,IsNull(Prior_servicer,'') as 'Prior_servicer', [Servicing Transfer date],[Servicing Transfer date 2],
isnull([Payment Method],'') as [Payment Method],
[LESA Type],LESA,[Logo 1],[Logo 2],Fixed,First_payment_date, case when First_payment_date <> '' then
FORMAT(DATEPART(month,[First_payment_date]),'00') + '_' + FORMAT(DATEPART(day,[First_payment_date]),'00') 
else ' '  end
as 'First_payment_MM_DD' 
,IsNull(Plan_TYPE,'') as 'Plan_TYPE',IsNull(Loan_Type,'Bulk') as 'Loan_Type' 
into #tblFinal
from #tblTemp2
where [Email Address] is not null and len([Email Address])>0
--and [Payment Method] = 'ACH' order by [Servicing Transfer date];



select distinct [Loan Skey],[Last 4 Loan Skey],[Property State],[Email Address],[Borrower First Name],PropertyAddress1,Prior_servicer,[Servicing Transfer date],
[Servicing Transfer date 2],
case when Fixed = 'Y' then '' else [Payment Method] end as 'Payment Method'
,[LESA Type],LESA,[Logo 1],[Logo 2],Fixed,First_payment_date,First_payment_MM_DD
,Plan_TYPE,Loan_Type
from #tblfinal;


