

select 
a.loan_skey,
a.loan_status_description,contact_skey,
concat(concat(concat(concat(b.first_name,' '),b.middle_name),' '),b.last_name) as "Contact Person",
b.contact_type_skey,
b.contact_type_description,
b.other_contact_type_description,
b.work_phone_number,b.cell_phone_number,b.home_phone_number,
b.created_date "Create Date",b.created_by "Create By",b.modified_date "Change Date",b.modified_by "Change By"
from 
rms.v_LoanMaster   a 
left join rms.v_ContactMaster b on a.loan_skey=b.loan_skey
where --b.contact_type_description not in('Borrower','Co-borrower') and 
a.loan_status_description not in ('Deleted','Inactive')