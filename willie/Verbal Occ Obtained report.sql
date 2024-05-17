select
concat('VLT-REV-R0655-0000000000000',ROW_NUMBER() over (order by a.loan_skey)) as "REQUEST_ID",
--ROW_NUMBER() over (order by a.loan_skey ) sn,
'R0655' as "LETTER_ID",'Yes' as "INTERNAL",a.loan_skey as LOAN_SKEY,
coalesce(h.BRWR_NAME,'') as BRWR_NAME,
coalesce(h.COBRWR_NAME1,'') as COBRWR_NAME1,
coalesce(h.COBRWR_NAME2,'') as COBRWR_NAME2,'' COBRWR_NAME3,'' COBRWR_NAME4,
coalesce(h.MAIL_ADD1,'') MAIL_ADD1,
coalesce(h.MAIL_ADD2,'') MAIL_ADD2,
coalesce(h.MAIL_CITY,'') MAIL_CITY,
coalesce(h.MAIL_STATE,'') MAIL_STATE,
coalesce(h.MAIL_ZIP,'') MAIL_ZIP,
coalesce(h.PROP_ADD1,'') PROP_ADD1,
coalesce(h.PROP_ADD2,'') PROP_ADD2,
coalesce(h.PROP_CITY,'') PROP_CITY,
coalesce(h.PROP_STATE,'') PROP_STATE,
coalesce(h.PROP_ZIP,'') PROP_ZIP,
 case when h.Borrower_death_date is null then 'Borrower'
 else 'ENBS' end  as "OPTION",
 a.created_by as "CASE_ASGND_TO",
 case when coalesce(coalesce(h.[Borrower  Home Phone Number],h.[Borrower Cell Phone Number]),'')='' then'' else concat('(',substring(coalesce(coalesce(h.[Borrower  Home Phone Number],h.[Borrower Cell Phone Number]),''),1,3),') ',substring(coalesce(coalesce(h.[Borrower  Home Phone Number],h.[Borrower Cell Phone Number]),''),4,3),'-',substring(coalesce(coalesce(h.[Borrower  Home Phone Number],h.[Borrower Cell Phone Number]),''),7,4)) end  as "STRING1",
--coalesce(coalesce(h.[Borrower  Home Phone Number],h.[Borrower Cell Phone Number]),'') as "STRING1",
--concat('(',substring(coalesce(coalesce(h.[Co-Borrower1 Home Phone Number],h.[Co-Borrower1 Cell Phone Number]),''),1,3),') ',substring(coalesce(coalesce(h.[Co-Borrower1 Home Phone Number],h.[Co-Borrower1 Cell Phone Number]),''),4,3),'-',substring(coalesce(coalesce(h.[Co-Borrower1 Home Phone Number],h.[Co-Borrower1 Cell Phone Number]),''),7,4))  as "STRING12",
case when coalesce(coalesce(h.[Co-Borrower1 Home Phone Number],h.[Co-Borrower1 Cell Phone Number]),'')='' then '' else concat('(',substring(coalesce(coalesce(h.[Co-Borrower1 Home Phone Number],h.[Co-Borrower1 Cell Phone Number]),''),1,3),') ',substring(coalesce(coalesce(h.[Co-Borrower1 Home Phone Number],h.[Co-Borrower1 Cell Phone Number]),''),4,3),'-',substring(coalesce(coalesce(h.[Co-Borrower1 Home Phone Number],h.[Co-Borrower1 Cell Phone Number]),''),7,4)) end as "STRING2",
coalesce(h.[ENBS Name],'') as ENBS_NAME, convert(date,a.created_date) as "Date1",'Senior Specialist, Home Retention Reverse Servicing' as "STRING3",
i.servicer_name as "SERVICER_NAME",i.investor_name as "INVESTOR_NAME"
from rms.v_Note a
join rms.v_LoanMaster b on a.loan_skey=b.loan_skey
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
join rms.v_LoanMaster i on a.loan_skey=i.loan_skey 
where note_type_description='Verbal Occ Obtained'
--and a.created_date >= convert(date,getdate()-3) -- to fetch friday's data
and a.created_date >= convert(date,getdate()-1) -- to fetch one day prior data
and a.created_date <  DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
order by a.loan_skey;