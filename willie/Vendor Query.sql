
 IF OBJECT_ID('tempdb..#rtemp14') IS NOT NULL
    DROP TABLE #rtemp14;

SELECT  
      A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text]
      ,CONVERT(date, max( A.[created_date])) as 'Vendor_Setup_request_DATE'
      ,a.[created_by] as 'Vendor_Setup_request_by' ,
	   b.Vendor_setup_decline_DATE
	   ,b.Vendor_setup_decline_by
	   ,c.Vendor_approved_DATE,
	   c.Vendor_approved_BY
	   into #rtemp14
  FROM [ReverseQuest].[rms].[v_Note] a
  left join
  (SELECT 
      A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text]
	  ,CONVERT(date, A.created_date) as 'Vendor_setup_decline_DATE'
	  ,A.created_by as 'Vendor_setup_decline_by'
  FROM [ReverseQuest].[rms].[v_Note] a
  where A. [note_type_description] = 'Vendor Setup Declined'
 ) b
  on a.loan_skey=b.loan_skey and CONVERT(date,b.Vendor_setup_decline_DATE)>= CONVERT(date,a.created_date)
  left join
  (SELECT 
      A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text]
	  ,CONVERT(date, A.created_date) as 'Vendor_approved_DATE'
	  ,a.created_by as 'Vendor_approved_BY'
  FROM [ReverseQuest].[rms].[v_Note] a
  where A. [note_type_description] = 'Vendor Setup Approved') c
  on a.loan_skey=c.loan_skey and CONVERT(date,c.Vendor_approved_DATE)>=CONVERT(date,a.created_date)
  where A. [note_type_description] = 'Vendor Setup Request  Received'
  group by  A.[note_skey],A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text],a.[created_by]
	 ,b.Vendor_setup_decline_DATE
	   ,b.Vendor_setup_decline_by
	   ,c.Vendor_approved_DATE,
	   c.Vendor_approved_BY
  ;

  --select * from #rtemp14;

  select a.loan_skey,b.state_code as 'Property State',a.note_type_description,
  --a.note_text,
  a.Vendor_Setup_request_DATE,a.Vendor_Setup_request_by,a.Vendor_setup_decline_DATE,a.Vendor_setup_decline_by,a.Vendor_approved_DATE,a.Vendor_approved_BY,
  case when a.Vendor_approved_DATE is null and a.Vendor_setup_decline_DATE is null	 then
 (DATEDIFF(dd, a.Vendor_Setup_request_DATE, getdate()) )
		-(DATEDIFF(WW, A.Vendor_Setup_request_DATE, getdate()) * 2)
		-CASE			
       WHEN DATEPART(WEEKDAY,A.Vendor_Setup_request_DATE) IN (1, 7) THEN 1 ELSE 0			
       END			
       - CASE			
       WHEN DATEPART(WEEKDAY,getdate()) IN (1, 7) THEN 1 ELSE 0		
	   end 
	   else
				case when a.Vendor_approved_DATE is not null then
				(DATEDIFF(dd, A.Vendor_Setup_request_DATE, A.Vendor_approved_DATE) )
				-(DATEDIFF(WW, A.Vendor_Setup_request_DATE, A.Vendor_approved_DATE) * 2)
				-CASE			
				WHEN DATEPART(WEEKDAY,A.Vendor_Setup_request_DATE) IN (1, 7) THEN 1 ELSE 0			
				END			
				- CASE			
				WHEN DATEPART(WEEKDAY,getdate()) IN (1, 7) THEN 1 ELSE 0	end	
	   
	else
				case when a.Vendor_setup_decline_DATE is not null then
				(DATEDIFF(dd, A.Vendor_Setup_request_DATE, A.Vendor_setup_decline_DATE) )
				-(DATEDIFF(WW, A.Vendor_Setup_request_DATE, A.Vendor_setup_decline_DATE) * 2)
				-CASE			
				WHEN DATEPART(WEEKDAY,A.Vendor_Setup_request_DATE) IN (1, 7) THEN 1 ELSE 0			
				END			
				- CASE			
				WHEN DATEPART(WEEKDAY,getdate()) IN (1, 7) THEN 1 ELSE 0	end	
       end
	   END end AS 'AGING(Days)'
 from #rtemp14 a
 join
[ReverseQuest].[rms].[v_PropertyMaster] b
on a.loan_skey=b.loan_skey;