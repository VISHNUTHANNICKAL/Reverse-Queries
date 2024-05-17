SELECT 
a.[loan_skey]
,a.alert_type_description
        ,created_date as 'created_date'
        ,a.created_by as 'created_by'
	    ,a.modified_date as 'Changed date'
		,a.modified_by as  'Changed by'
		--,a.alert_status_description
		,DATEDIFF(DAY,a.created_date,a.modified_date) as 'TAT'
		--,ROW_NUMBER() OVER (PARTITION BY a.loan_skey ORDER BY a.loan_skey)  num
     FROM [ReverseQuest].[rms].[v_Alert] a
  where alert_type_description = 'Escalation'
  --and alert_status_description = 'Active'
  --and loan_skey=16893
  and created_date > =  DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
and created_date <   DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
  order by loan_skey
  --group by loan_skey,alert_type_description,alert_status_description