/*
select  
*
from [ReverseQuest].[rms].[v_LogColumnDataChange] 
where --loan_skey=82577 and
audit_type_description='Borrower Email'
and audit_description='Warren Meadows'
order by created_date desc

select  
distinct audit_type_description
from [ReverseQuest].[rms].[v_LogColumnDataChange] where audit_type_description like '%Su%' order by audit_type_description
where --loan_skey=82577 and
audit_type_description in ('Borrower Email','Co-Borrower Email','')
and audit_description='Warren Meadows'
order by created_date desc

select * from rms.v_ContactMaster where loan_skey=82577
*/
select  
a.loan_skey,
b.loan_status_description,
a.audit_type_description as 'Audit Type',
a.audit_description as 'Audit Description',
--a.column_name,
a.original_value as 'Original Value',
a.new_value as 'New Value',
a.created_by as 'Change By',
a.created_date as 'Change Date',
a.column_data_change_skey as 'Audit Skey'
from [ReverseQuest].[rms].[v_LogColumnDataChange] a
join [ReverseQuest].[rms].v_LoanMaster b on a.loan_skey=b.loan_skey
where 
--a.loan_skey=82577 and 
a.audit_type_description in ('Borrower Email','Co-Borrower Email','Supervisors')
and a.created_date >=     DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and a.created_date <     DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
order by a.loan_skey,a.created_date desc