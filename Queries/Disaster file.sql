IF OBJECT_ID('tempdb..#tblTemp') IS NOT NULL
    DROP TABLE #tblTemp;
select a.loan_skey,
a.loan_status_description as 'Loan status',a.loan_sub_status_description as 'Loan Sub-Status'
,concat(concat(c.first_name,' '),c.last_name) as 'Borrower  Name',c.contact_type_description as 'Contact Type'
,b.state_code as 'Property State',c.email,a.payment_method
into #tblTemp
from reversequest.rms.v_LoanMaster a
join
[ReverseQuest].[rms].[v_PropertyMaster] b
on a.loan_skey=b.loan_skey
join reversequest.rms.v_ContactMaster c
on a.loan_skey = c.loan_skey
where
--a.loan_status_description <> 'INACTIVE'
a.loan_status_description in ('DEFAULT', 'FORECLOSURE','ACTIVE','CLAIM')
--a.loan_status_description in ('ACTIVE','CLAIM')
--and c.contact_type_description not in ('Payoff Requester')
and b.state_code in ('FL')
and a.payment_method not like ('ACH')
;
select * from #tblTemp order by loan_skey;

--select distinct state_code from ReverseQuest.rms.v_PropertyMaster
