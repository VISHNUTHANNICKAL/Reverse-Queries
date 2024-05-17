/*Select  loan_skey, 
display_balance_flag,
do_not_aggregate_flag,
payee_includes_borrower_flag,
send_to_hud_flag,
estimated_flag,
reimbursable_flag


from rms.v_Disbursement where loan_skey=7254
and transaction_code in(2122,1856)
and process_date >=convert(date,'2023-07-01') and process_date <=convert(date,'2023-12-31')
select distinct long_transaction_description,transaction_code 
from [rms].[v_Transaction]-- order by long_transaction_description
where loan_skey=4289 
--and long_transaction_description in ('Corp Adv - S305 - Taxes','Disb - Prop Chrg Pre D&P - Taxes')


and transaction_code in(2122,1856)

Select transaction_code from rms.v_LoanMaster where loan_skey=4289

select * from rms.v_Disbursement where process_date >=convert(date,'2023-07-01') and process_date <=convert(date,'2023-12-31')

select top 10 * from rms.v_LoanRate where loan_skey=7254
select top 100 * from rms.v_MonthlyLoanSummary where loan_skey=4289
and period_description like 'December 2023'
*/

----------------------------------------=============

select 
a.loan_skey 'Loan Skey',
a.LESA_type_description 'LESA Type',
a.original_loan_number 'Loan #',
a.loan_status_description 'Loan Status',
a.payment_plan_description 'Payment Plan',
b.disbursement_type_description 'Disbursement Type',
b.pay_to 'Pay To',
b.check_number 'Check / ACH #',
b.created_by 'Created By',
b.created_date 'Create Date',
b.process_date 'Process Date',
b.disbursed_date 'Disburse Date',
b.check_amount 'Disbursed Amount',
case when b.do_not_aggregate_flag=1 then 'YES' else 'NO' end as 'Disbursed',
--case when b.do_not_aggregate_flag=1 then 'YES' else 'NO' end as 'Cleared',
--case when b.do_not_aggregate_flag=1 then 'YES' else 'NO' end as 'Voided',
case when b.reimbursable_flag=1 then 'YES' else 'NO' end as 'Reimbursable',
---case when b.reimbursable_flag=1 then 'YES' else 'NO' end as 'Payment Stopped',
concat(b.payor_first_name,' ',b.payor_middle_name,' ',b.payor_last_name) "Payor Name",
b.payor_aba_number 'Payor ABA #',b.payor_account_number 'Payor Account #',
b.disbursed_by 'Disbursed By',
b.invoice_date 'Invoice Date',b.invoice_number 'Invoice #',c.long_transaction_description 'Transaction Type',
a.fha_case_number 'FHA Case #',a.product_type_description 'Product Type',
d.arm_type_description 'ARM Type',d.rate_index_type_description 'Rate Index Type',
a.credit_type_description 'Credit Type',a.loan_sub_status_description 'Loan Sub-Status',
b.voided_date 'Voided Date',b.funds_requested_date 'Funds Requested Date',
e.state_code 'Property State',b.cleared_date 'Cleared Date',b.check_note 'Check Note'
,b.incurred_date 'Incurred Date',b.recoverable_percent '% Recoverable',
f.corporate_advance_recoverable_amount 'Recoverable Amount',b.recoverable_from 'Recoverable From'
,f.corporate_advance_non_recoverable_amount 'Non-Recoverable Amount',b.disbursement_skey 'Disbursement Skey'
from rms.v_LoanMaster a 
left join rms.v_Disbursement b on a.loan_skey=b.loan_skey and transaction_code in(2122,
1651,
1650,
2051,
2050,
1856,
1356)
left join rms.v_Transaction c on b.loan_skey=c.loan_skey and c.transaction_code in(2122,
1651,
1650,
2051,
2050,
1856,
1356)
left join rms.v_LoanRate d on a.loan_skey=d.loan_skey
left join rms.v_PropertyMaster e on a.loan_skey=e.loan_skey
left join rms.v_MonthlyLoanSummary f on a.loan_skey=f.loan_skey
and f.created_date >=   DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
and f.created_date <   DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
where 
b.process_date >= DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
and b.process_date <=DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
and a.LESA_type_description in ('Fully Funded')
order by a.loan_skey


