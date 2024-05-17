select 
a.loan_skey,a.original_loan_number 'Loan #',
a.loan_status_description 'Loan Status',a.loan_sub_status_description 'Loan Sub-Status'
,b.audit_type_description 'Audit Type',b.audit_description 'Audit Description'
,b.column_name,b.original_value 'Original Value',b.new_value 'New Value',
b.created_by 'Changed By',b.created_date 'Change Date',d.state_code 'Property State'
,c.alert_type_description,c.alert_status_description
 from
rms.v_LoanMaster a 
left join rms.v_LogColumnDataChange b on a.loan_skey=b.loan_skey
join (select * from (
select loan_skey,alert_type_description,alert_status_description,created_by,created_date
,ROW_NUMBER() over (PARTITION by loan_skey order by  loan_skey ,created_date desc ) sn
from rms.v_Alert where alert_type_description 
in ('Returned Mail - Follow Up Required')
and alert_status_description='ACTIVE') a where sn=1 ) c on a.loan_skey=c.loan_skey
join rms.v_PropertyMaster d on a.loan_skey=d.loan_skey
where b.audit_type_description in ('Borrower Mailing Address Line1','Borrower Mailing Address Line2'
,'Borrower Mailing City','Borrower Mailing State Code','Borrower Zip Code'
,'Co-Borrower Mailing Address Line1','Co-Borrower Mailing Address Line2','Co-Borrower Mailing City',
'Co-Borrower Mailing State Code','Co-Borrower Mailing Zip Code','Alt. Contact Mailing Address Line1'
,'Alt. Contact Mailing Address Line2','Alt. Contact Mailing City','Alt. Contact Mailing State Code',
'Alt. Contact Zip Code')
and b.created_date >=DATEADD(d,-7,DATEDIFF(d,0,GETDATE()))
order by b.created_date

/*select * from (
select loan_skey,alert_type_description,alert_status_description,created_by,created_date
,ROW_NUMBER() over (PARTITION by loan_skey order by  loan_skey ,created_date desc ) sn
from rms.v_Alert where alert_type_description 
in ('Returned Mail - Follow Up Required')
and alert_status_description='ACTIVE') a */