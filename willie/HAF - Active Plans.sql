select 
b.loan_skey,
c.loan_status_description,
d.note_type_description "Note Type",d.created_date "Note Created Date",d.created_by "Note Create by",
convert(varchar,a.original_schedule_date,23) as 'Create Date',
a.workflow_task_description as 'Task Description',
convert(varchar,a.complete_date,23) as 'Complete Date',
a.created_by as 'Created By',
--convert(varchar,a.created_date,23) as 'Create Date',
--convert(varchar,a.due_date,23) as 'End Date',
--a.responsible_party_id as 'Task Responsible Party',
--DateDiff(DAY,a.created_date,a.complete_date )  as 'Days Pending',
e.BRWR_NAME,e.COBRWR_NAME1,e.COBRWR_NAME2,e.COBRWR_NAME3,e.MAIL_ADD1,e.MAIL_ADD2,e.MAIL_CITY,e.MAIL_STATE,e.MAIL_ZIP,
e.PROP_ADD1,e.PROP_ADD2,e.PROP_CITY,e.PROP_STATE,e.PROP_ZIP,c.servicer_name SERVICER_NAME,c.investor_name INVESTOR_NAME

from [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
  join  [ReverseQuest].[rms].[v_WorkflowInstance] b on a.workflow_instance_skey=b.workflow_instance_skey
   join ReverseQuest.rms.v_LoanMaster c  on b.loan_skey=c.loan_skey
   join ReverseQuest.rms.v_Note d on b.loan_skey=d.loan_skey and d.note_type_description='Cash: Funds applied'
   left join (select * from(select a.loan_skey,a.Borrower_Name BRWR_NAME,
 b.Co_Borrower_Name as COBRWR_NAME1,
 c.Co_Borrower_Name as COBRWR_NAME2,
d.Co_Borrower_Name as COBRWR_NAME3,
a.mail_address1 MAIL_ADD1 ,a.mail_address2 MAIL_ADD2 ,a.mail_city MAIL_CITY,a.mail_state_code MAIL_STATE,a.Mail_zip MAIL_ZIP,
a.address1 PROP_ADD1,a.address2 PROP_ADD2,a.city PROP_CITY,a.state_code PROP_STATE, prop_zip PROP_ZIP
 from (
select 
a.loan_skey,contact_type_description,concat(first_name,concat(' ',middle_name,' ',last_name)) Borrower_Name,
mail_address1,mail_address2,mail_city,mail_state_code,left(mail_zip_code,5) Mail_zip,
b.address1,b.address2,b.city,b.state_code,LEFT(b.zip_code,5) prop_zip
from rms.v_ContactMaster a
join rms.v_PropertyMaster b on a.loan_skey=b.loan_skey
where contact_type_description='Borrower') a
left join (select * from (select a.loan_skey,contact_type_description,concat(first_name,concat(' ',middle_name,' ',last_name)) Co_Borrower_Name,
ROW_NUMBER() over (partition by a.loan_skey order by a.contact_skey ) sn
--,mail_address1,mail_address2,mail_city,mail_state_code,left(mail_zip_code,5) Mail_zip,
--b.address1,b.address2,b.city,b.state_code,LEFT(b.zip_code,5) prop_zip
from rms.v_ContactMaster a
join rms.v_PropertyMaster b on a.loan_skey=b.loan_skey
where contact_type_description='Co-Borrower') c where sn=1) b on a.loan_skey=b.loan_skey
left join (select * from (select a.loan_skey,contact_type_description,concat(first_name,concat(' ',middle_name,' ',last_name)) Co_Borrower_Name,
ROW_NUMBER() over (partition by a.loan_skey order by a.contact_skey ) sn
--,mail_address1,mail_address2,mail_city,mail_state_code,left(mail_zip_code,5) Mail_zip,
--b.address1,b.address2,b.city,b.state_code,LEFT(b.zip_code,5) prop_zip
from rms.v_ContactMaster a
join rms.v_PropertyMaster b on a.loan_skey=b.loan_skey
where contact_type_description='Co-Borrower') c where sn=2) c on a.loan_skey=c.loan_skey
left join (select * from (select a.loan_skey,contact_type_description,concat(first_name,concat(' ',middle_name,' ',last_name)) Co_Borrower_Name,
ROW_NUMBER() over (partition by a.loan_skey order by a.contact_skey ) sn
--,mail_address1,mail_address2,mail_city,mail_state_code,left(mail_zip_code,5) Mail_zip,
--b.address1,b.address2,b.city,b.state_code,LEFT(b.zip_code,5) prop_zip
from rms.v_ContactMaster a
join rms.v_PropertyMaster b on a.loan_skey=b.loan_skey
where contact_type_description='Co-Borrower') c where sn=3) d on a.loan_skey=d.loan_skey
)a
) e on b.loan_skey=e.loan_skey 
 where  a.workflow_task_description='Repayment Plan Satisfied'
and a.status_description='Active'
and a.complete_date is not null
and a.complete_date >'2023-06-30'
--and b.workflow_type_description='Cash Flow Analysis'
--and b.status_description='Active'
order by b.loan_skey

