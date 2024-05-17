select a.loan_skey,loan_status_description,investor_name,servicer_name,b.state_code 
,case when loan_status_description in ('Default','Foreclosure') and b.state_code in('AL','AK','AR','AZ','CA','CO','DE','DC','FL','GA','HI','ID','IL','IN','KS','KY','LA','MD','ME','MA','MI','MN','MO','NM','ND','OH','OK','PA','PR','RI','SD','TN','TX','UT','VT','VA','VI','WV') then 'RMS_HRD_ALL'
  when loan_status_description in ('Default','Foreclosure') and b.state_code in ('NJ') then 'RMS_HRD_WPB'
  when loan_status_description in ('Default','Foreclosure') and b.state_code in ('CT','IA','MT','NE','NH','OR','SC','WA','WI','NV','NC') then 'RMS_HRD_HOU'
  when loan_status_description in ('Default','Foreclosure') and b.state_code in ('NY','WY') then 'RMS_HRD_PMC' 
  when loan_status_description in ('Default','Foreclosure') and b.state_code in ('MS') then 'RMS_WFO_HRD_HOU'
  when loan_status_description in ('Active','Claim') and b.state_code in ('AL','AK','AR','AZ','CA','CO','DE','DC','FL','GA','HI','ID','IL','IN','KS','KY','LA','MD','ME','MA','MI','MN','MO','NM','ND','OH','OK','PA','PR','RI','SD','TN','TX','UT','VT','VA','VI','WV','NY','WY') then 'RMS_CS_PMC' 
  when loan_status_description in ('Active','Claim') and b.state_code in ('NJ') then 'RMS_CS_WPB' 
  when loan_status_description in ('Active','Claim') and b.state_code in ('CT','IA','NV','NH','MT','NE','OR','NC','SC','WA','WI') then 'RMS_CS_HOU'
  when loan_status_description in ('Active','Claim') and b.state_code in ('MS') then 'RMS_WFO_CS_HOU'
  else null end  as 'CALLLIST'

from rms.v_LoanMaster a
join rms.v_PropertyMaster b on a.loan_skey=b.loan_skey
where loan_status_description in('Active','Claim','Default','Foreclosure')
and investor_name='Bank of America'
