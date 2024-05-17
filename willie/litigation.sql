select top 10 * from [ReverseQuest].[rms].[v_Alert]
where alert_type_description  in ('FDCPA -  Call Restrictions','LITIGATION - Lawsuit Pending','Litigation -  Proceed')
and loan_skey =226

select loan_skey as 'Loan Skey'
,alert_status_description as 'Alert'
,alert_type_description as 'Alert Note',
max(alert_date)
from [ReverseQuest].[rms].[v_Alert]
where alert_type_description  in ('FDCPA -  Call Restrictions','LITIGATION - Lawsuit Pending','Litigation -  Proceed')
group by loan_skey,alert_status_description,alert_type_description
order by loan_skey
--and alert_status_description = 'Active')


select distinct alert_type_description from [ReverseQuest].[rms].[v_Alert] 
where alert_type_description like'%FDCPA%'