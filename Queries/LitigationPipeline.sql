select  
loan_skey, alert_type_description,alert_date,loan_manager
,alert_status_description,Prop_State
from (
select a.loan_skey, alert_type_description,alert_date,b.loan_manager
,a.alert_status_description,c.state_code as 'Prop_State',
ROW_NUMBER() OVER (PARTITION BY a.loan_skey ORDER BY a.loan_skey) rn
from 
[ReverseQuest].[rms].[v_Alert] a
left join
[ReverseQuest].[rms].[v_LoanMaster] b
on a.loan_skey=b.loan_skey
join
[ReverseQuest].[rms].[v_PropertyMaster] c
on a.loan_skey=c.loan_skey
where alert_type_description in ('Litigation -  Proceed','LITIGATION - Lawsuit Pending')
and a.alert_status_description = 'Active') c
where rn=1