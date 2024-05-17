
SELECT RLS.LOAN_SKEY,
rls.SERVICER_NAME,
RLS.INVESTOR_NAME,
LOAN_SUB_STATUS_CODE,
rls.loan_sub_status_description,
rls.payment_plan_description,
DEFAULT_REASON_DESCRIPTION,
(bnm.first_name + ' ' + bnm.last_name) Borrower_name,
bnm.mail_address1 -- Mail Information Address 1
, bnm.mail_address2 -- Mail Information Address 2
, bnm.mail_city -- Mail Information City
, bnm.mail_state_code -- Mail Information State
, bnm.mail_zip_code ,
(apm.address1 + ' ' + apm.address2) as property_address,
apm.state_code,
product_type_description,
CAST(RLS.created_date AS DATE) BOARDING_DATE,
APM.property_type_description,
--zz.credit_line_amount,
--zz.principal_limit_amount
case when rls.payment_plan_description in ('Modified Term','Modified Tenure','Line of Credit','Tenure','Term') then (Curr_bal.principal_limit_amount
-Curr_bal.Total_Loan_Balance
-Curr_bal.service_fee_set_aside_amount
-Curr_bal.first_year_set_aside_amount
-Curr_bal.repair_set_aside_amount
-curr_bal.LESA_amount
-(Curr_bal.credit_line_amount
- Curr_bal.unscheduled_credit_disbursement_balance))
else 0 end net_principal_limit
,Curr_bal.LESA_amount
FROM RMS.v_LoanMaster RLS
LEFT JOIN RMS.v_LoanRate RT
ON RLS.loan_skey = RT.loan_skey
LEFT JOIN rms.v_PropertyMaster apm
on apm.loan_skey = RLS.loan_skey
left join rms.v_ContactMaster bnm
on bnm.loan_skey = rls.loan_skey
and bnm.contact_type_description = 'Borrower'
LEFT JOIN RMS.v_LoanDefaultInformation LDI
ON RLS.LOAN_SKEY = LDI.loan_skey
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
From rms.v_Transaction
--Where transaction_date = CAST( GETDATE()-1 AS Date )
group by loan_skey) Curr_bal
on Curr_bal.loan_skey = rls.loan_skey
where rls.loan_skey = '270717'
--where rls.loan_skey = '270448'

