IF OBJECT_ID('tempdb..#Contactrpc') IS NOT NULL
    DROP TABLE #Contactrpc;
select  loan_skey,note_type_description,created_date,created_by 
into #Contactrpc
from(
select loan_skey,note_type_description,convert(date,created_date) created_date,created_by,
ROW_NUMBER() over (partition by loan_skey order by created_date desc) sn
from rms.v_Note where note_type_description='Contact - RPC') a
where sn=1;



select 
a.loan_skey,a.loan_status_description,a.investor_name,a.loan_balance,a.created_date,a.created_by,a.modified_date,a.modified_by,
h.BRWR_NAME,h.COBRWR_NAME1,
b.original_value,b.new_value,b.created_date,b.created_by
,i.created_date 'last inbound/outbound right party contact'
from rms.v_LoanMaster a
left join (
select loan_skey,audit_type_description,original_value,new_value,created_date,created_by
from rms.v_LogColumnDataChange
where audit_type_description like 'Loan Status'
and original_value='ACTIVE'
) b on a.loan_skey=b.loan_skey
left join (select * from(
select a.loan_skey,a.Borrower_Name BRWR_NAME,a.email as 'BRWR_MAILID',a.[Borrower  Home Phone Number],a.[Borrower Cell Phone Number],a.[Borrower Work Phone Number],a.Borrower_death_date,
 b.Co_Borrower1_Name as COBRWR_NAME1,b.email as 'COBRWR1_MAILID',b.[Co-Borrower1 Home Phone Number],b.[Co-Borrower1 Cell Phone Number],b.[Co-Borrower1 Work Phone Number],b.[Co-Borrower1_death_date],
 d.Co_Borrower2_Name as COBRWR_NAME2,d.email as 'COBRWR2_MAILID',d.[Co-Borrower2 Home Phone Number],d.[Co-Borrower2 Cell Phone Number],d.[Co-Borrower2 Work Phone Number],d.[Co-Borrower2_death_date],
 c.[ENBS Name],c.email as 'ENBS_MAILID',c.[ENBS Home Phone Number],c.[ENBS Cell Phone Number],c.[ENBS Work Phone Number],c.eNBS_death_date
--d.Co_Borrower_Name as COBRWR_NAME3,d.email as 'COBRWR3_MAILID'
,a.mail_address1 MAIL_ADD1 ,a.mail_address2 MAIL_ADD2 ,a.mail_city MAIL_CITY,a.mail_state_code MAIL_STATE,a.Mail_zip MAIL_ZIP
,a.address1 PROP_ADD1,a.address2 PROP_ADD2,a.city PROP_CITY,a.state_code PROP_STATE, prop_zip PROP_ZIP
 from (
select 
a.loan_skey,contact_type_description,concat(upper(substring( first_name,1,1)),lower(substring( first_name,2,70)),' ',upper(substring( last_name,1,1)),lower(substring( last_name,2,70))) Borrower_Name,a.email,
mail_address1,mail_address2,mail_city,mail_state_code,left(mail_zip_code,5) Mail_zip,
b.address1,b.address2,b.city,b.state_code,LEFT(b.zip_code,5) prop_zip,a.home_phone_number as "Borrower  Home Phone Number",a.cell_phone_number as "Borrower Cell Phone Number",a.work_phone_number as"Borrower Work Phone Number",a.death_date as "Borrower_death_date"
from rms.v_ContactMaster a
join rms.v_PropertyMaster b on a.loan_skey=b.loan_skey
where contact_type_description='Borrower') a
left join (select * from (select a.loan_skey,contact_type_description,concat(upper(substring( first_name,1,1)),lower(substring( first_name,2,70)),' ',upper(substring( last_name,1,1)),lower(substring( last_name,2,70))) Co_Borrower1_Name,email,a.home_phone_number as "Co-Borrower1 Home Phone Number",a.cell_phone_number as "Co-Borrower1 Cell Phone Number",a.work_phone_number as"Co-Borrower1 Work Phone Number",
ROW_NUMBER() over (partition by a.loan_skey order by a.contact_skey ) sn,a.death_date as "Co-Borrower1_death_date"
--,mail_address1,mail_address2,mail_city,mail_state_code,left(mail_zip_code,5) Mail_zip,
--b.address1,b.address2,b.city,b.state_code,LEFT(b.zip_code,5) prop_zip
from rms.v_ContactMaster a
join rms.v_PropertyMaster b on a.loan_skey=b.loan_skey
where contact_type_description='Co-Borrower') c where sn=1) b on a.loan_skey=b.loan_skey
left join (select * from (select a.loan_skey,contact_type_description,concat(upper(substring( first_name,1,1)),lower(substring( first_name,2,70)),' ',upper(substring( last_name,1,1)),lower(substring( last_name,2,70))) Co_Borrower2_Name,email,a.home_phone_number as "Co-Borrower2 Home Phone Number",a.cell_phone_number as "Co-Borrower2 Cell Phone Number",a.work_phone_number as"Co-Borrower2 Work Phone Number",
ROW_NUMBER() over (partition by a.loan_skey order by a.contact_skey ) sn,a.death_date as "Co-Borrower2_death_date"
--,mail_address1,mail_address2,mail_city,mail_state_code,left(mail_zip_code,5) Mail_zip,
--b.address1,b.address2,b.city,b.state_code,LEFT(b.zip_code,5) prop_zip
from rms.v_ContactMaster a
join rms.v_PropertyMaster b on a.loan_skey=b.loan_skey
where contact_type_description='Co-Borrower') c where sn=2) d on a.loan_skey=d.loan_skey

left join (select * from (select a.loan_skey,contact_type_description,concat(upper(substring( first_name,1,1)),lower(substring( first_name,2,70)),' ',upper(substring( last_name,1,1)),lower(substring( last_name,2,70))) as "ENBS Name",email,a.home_phone_number as "ENBS Home Phone Number",a.cell_phone_number as "ENBS Cell Phone Number",a.work_phone_number as"ENBS Work Phone Number",
ROW_NUMBER() over (partition by a.loan_skey order by a.contact_skey ) sn,a.death_date as "eNBS_death_date"
--,mail_address1,mail_address2,mail_city,mail_state_code,left(mail_zip_code,5) Mail_zip,
--b.address1,b.address2,b.city,b.state_code,LEFT(b.zip_code,5) prop_zip
from rms.v_ContactMaster a
join rms.v_PropertyMaster b on a.loan_skey=b.loan_skey
where contact_type_description='Entitled Non-Borrowing Spouse') c where sn=1) c on a.loan_skey=c.loan_skey
/*
left join (select * from (select a.loan_skey,contact_type_description,concat(upper(substring( first_name,1,1)),lower(substring( first_name,2,70))) Co_Borrower_Name,email,
ROW_NUMBER() over (partition by a.loan_skey order by a.contact_skey ) sn
--,mail_address1,mail_address2,mail_city,mail_state_code,left(mail_zip_code,5) Mail_zip,
--b.address1,b.address2,b.city,b.state_code,LEFT(b.zip_code,5) prop_zip
from rms.v_ContactMaster a
join rms.v_PropertyMaster b on a.loan_skey=b.loan_skey
where contact_type_description='Co-Borrower') c where sn=3) d on a.loan_skey=d.loan_skey*/

)a
) h on a.loan_skey=h.loan_skey 
left join #Contactrpc i on a.loan_skey=i.loan_skey 
where loan_status_description = 'ACTIVE'
--and created_date>= convert(date,'2023-01-01')
--and loan_skey in('3813')
and a.created_date<= CONVERT(date,'2024-02-01')
and loan_balance > 0

/*
select loan_skey,audit_type_description,original_value,new_value,created_date,created_by
from rms.v_LogColumnDataChange
where audit_type_description like 'Loan Status'
and original_value='ACTIVE'
and loan_skey in ('3813')
--and new_value='ACTIVE'
and created_date<= CONVERT(date,'2024-02-01')*/