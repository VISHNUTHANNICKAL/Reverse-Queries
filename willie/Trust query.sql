IF OBJECT_ID('tempdb..#rtemp13') IS NOT NULL
    DROP TABLE #rtemp13;

SELECT  
      A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text]
      ,CONVERT(date, max( A.[created_date])) as 'TRUST_REVIEW_REQUEST_DATE'
      ,a.[created_by] as 'TRUST_REVIEW_REQUEST_BY',
	   b.TRUST_addinfo_DATE
	   ,b.TRUST_Add_info_by
	   ,c.Trust_received_borrower_CHANGE_DATE,
	   c.Trust_received_borrower_CHANGE_BY,
	   p.Trust_legal_response_DATE,
	   p.Trust_legal_response_BY,
	   d.Trust_review_Completed_Date,
	   d.trust_review_BY
	   into #rtemp13
  FROM [ReverseQuest].[rms].[v_Note] a
  left join
  (SELECT 
      A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text]
	  ,CONVERT(date, A.created_date) as 'TRUST_addinfo_DATE'
	  ,A.created_by as 'TRUST_Add_info_by'
  FROM [ReverseQuest].[rms].[v_Note] a
  where A. [note_type_description] = 'Trust Add Info Required'
 ) b
  on a.loan_skey=b.loan_skey and CONVERT(date,b.TRUST_addinfo_DATE)>= CONVERT(date,a.created_date)
  left join
  (SELECT 
      A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text]
	  ,CONVERT(date, A.created_date) as 'Trust_received_borrower_CHANGE_DATE'
	  ,a.created_by as 'Trust_received_borrower_CHANGE_BY'
  FROM [ReverseQuest].[rms].[v_Note] a
  where A. [note_type_description] = 'Trust Received from Borrower') c
  on a.loan_skey=c.loan_skey and CONVERT(date,c.Trust_received_borrower_CHANGE_DATE)>=CONVERT(date,a.created_date)
  left join
  (SELECT 
      A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text]
	  ,CONVERT(date, A.created_date) as 'Trust_legal_response_DATE'
	  ,a.created_by as 'Trust_legal_response_BY'
  FROM [ReverseQuest].[rms].[v_Note] a
  where A. [note_type_description] = 'Trust Legal Response') p
  on a.loan_skey=p.loan_skey and CONVERT(date,p.Trust_legal_response_DATE)>=CONVERT(date,a.created_date)
  left join
  (SELECT  
      A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text]
	   ,CONVERT(date, A.created_date) as 'Trust_review_Completed_Date'
	  ,a.created_by as 'trust_review_BY'
  FROM [ReverseQuest].[rms].[v_Note] a
  where A. [note_type_description] = 'Trust Review Completed') d
  on a.loan_skey=d.loan_skey and CONVERT(date,d.Trust_review_Completed_Date) > =CONVERT(date,a.created_date)
  where A. [note_type_description] in ('Trust Review Request')
  group by  A.[note_skey],A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text],a.[created_by]
     , b.TRUST_addinfo_DATE
	   ,b.TRUST_Add_info_by
	   ,c.Trust_received_borrower_CHANGE_DATE,
	   c.Trust_received_borrower_CHANGE_BY,
	   p.Trust_legal_response_DATE,
	   p.Trust_legal_response_BY,
	   d.Trust_review_Completed_Date,
	   d.trust_review_BY
  ;
  --select * from #rtemp13;



 select a.loan_skey,b.state_code as 'Property State',a.note_type_description,
 --a.note_text,
 a.TRUST_REVIEW_REQUEST_DATE,a.TRUST_REVIEW_REQUEST_BY
 ,a.TRUST_addinfo_DATE,a.TRUST_Add_info_by,a.Trust_received_borrower_CHANGE_DATE,a.Trust_received_borrower_CHANGE_BY
 ,a.Trust_legal_response_DATE,a.Trust_legal_response_BY
 ,a.Trust_review_Completed_Date,a.trust_review_BY
 ,case when a.Trust_legal_response_DATE is null and a.Trust_review_Completed_Date is null then
 (DATEDIFF(dd, a.TRUST_REVIEW_REQUEST_DATE, getdate()))-
 (DATEDIFF(WW, a.TRUST_REVIEW_REQUEST_DATE, getdate()) * 2)
		- CASE			
       WHEN DATEPART(WEEKDAY,A.TRUST_REVIEW_REQUEST_DATE) IN (1, 7) THEN 1 ELSE 0			
       END			
       - CASE			
       WHEN DATEPART(WEEKDAY,getdate()) IN (1, 7) THEN 1 ELSE 0	 end
	  else
				case when a.Trust_legal_response_DATE is not null then
				(DATEDIFF(dd, A.TRUST_REVIEW_REQUEST_DATE, A.Trust_legal_response_DATE) )
				-(DATEDIFF(WW, A.TRUST_REVIEW_REQUEST_DATE, A.Trust_legal_response_DATE) * 2)
				-CASE			
				WHEN DATEPART(WEEKDAY,A.TRUST_REVIEW_REQUEST_DATE) IN (1, 7) THEN 1 ELSE 0			
				END			
				- CASE			
				WHEN DATEPART(WEEKDAY,getdate()) IN (1, 7) THEN 1 ELSE 0	
				end	
	  else
				case when a.Trust_review_Completed_Date is not null then
				(DATEDIFF(dd, A.TRUST_REVIEW_REQUEST_DATE, A.Trust_review_Completed_Date) )
				-(DATEDIFF(WW, A.TRUST_REVIEW_REQUEST_DATE, A.Trust_review_Completed_Date) * 2)
				-CASE			
				WHEN DATEPART(WEEKDAY,A.TRUST_REVIEW_REQUEST_DATE) IN (1, 7) THEN 1 ELSE 0 	
				 END				
				- CASE	WHEN DATEPART(WEEKDAY,getdate()) IN (1, 7) THEN 1 ELSE 0	
				end 
	 end  end
		 END  AS 'AGING(Days)'
 from #rtemp13 a 
 join
[ReverseQuest].[rms].[v_PropertyMaster] b
on a.loan_skey=b.loan_skey;

