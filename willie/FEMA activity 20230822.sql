select 
a.loan_skey "Loan Skey",
a.loan_status_description "Loan Status",
a.loan_sub_status_description "Loan Sub-status",
concat(b.first_name,' ',b.middle_name,' ',b.last_name) as Borrower_Name,
b.contact_type_description "Contact Type",
c.state_code "Property State",
b.email  "Email Address",
a.payment_method "Payment Method"
from rms.v_LoanMaster a
join rms.v_ContactMaster b on a.loan_skey=b.loan_skey and b.contact_type_description='Borrower'
join rms.v_PropertyMaster c on a.loan_skey=c.loan_skey
--left join rms.v_Alert d on a.loan_skey=d.loan_skey and d.alert_type_description=
where 

order by a.loan_skey;

--select distinct alert_type_description from rms.v_Alert order by alert_type_description




