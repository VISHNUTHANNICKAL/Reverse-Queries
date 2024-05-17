
 IF OBJECT_ID('tempdb..#rtemp12') IS NOT NULL
    DROP TABLE #rtemp12;

SELECT  
      A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text]
      ,CONVERT(date, max( A.[created_date])) as 'POA_REQUEST_RECEIVED_DATE'
      ,a.[created_by] as 'POA_REQUEST_RECEIVED_BY'
	  , b.POA_Add_Info_Required_DATE
	   ,b.POA_Add_Info_Required_BY
	   ,c.POA_Request_Denied_Date,
	   c.POA_Request_Denied_BY,
	   d.POA_Request_Approved_Date,
	   d.POA_Request_Approved_BY
	   into #rtemp12
  FROM [ReverseQuest].[rms].[v_Note] a
  left join
  (SELECT 
      A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text]
	  ,CONVERT(date, A.created_date) as 'POA_Add_Info_Required_DATE'
	  ,A.created_by as 'POA_Add_Info_Required_BY'
  FROM [ReverseQuest].[rms].[v_Note] a
  where A. [note_type_description] = 'POA Add Info Required'
 ) b
  on a.loan_skey=b.loan_skey and CONVERT(date,b.POA_Add_Info_Required_DATE)>= CONVERT(date,a.created_date)
  left join
  (SELECT 
      A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text]
	  ,CONVERT(date, A.created_date) as 'POA_Request_Denied_Date'
	  ,a.created_by as 'POA_Request_Denied_BY'
	   FROM [ReverseQuest].[rms].[v_Note] a
  where A. [note_type_description] = 'POA Request Denied') c
  on a.loan_skey=c.loan_skey and CONVERT(date,c.POA_Request_Denied_Date)>=CONVERT(date,a.created_date)
  left join
  (SELECT  
      A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text]
	  ,CONVERT(date, A.created_date) as 'POA_Request_Approved_Date'
	  ,a.created_by as 'POA_Request_Approved_BY'
	  FROM [ReverseQuest].[rms].[v_Note] a
  where A. [note_type_description] = 'POA Request Approved') d
  on a.loan_skey=d.loan_skey and CONVERT(date,d.POA_Request_Approved_Date) > =CONVERT(date,a.created_date)
  where A. [note_type_description] = 'POA Request Received'
  group by  A.[note_skey],A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text],a.[created_by]
	  ,b.POA_Add_Info_Required_DATE
	   ,b.POA_Add_Info_Required_BY
	   ,c.POA_Request_Denied_Date,
	   c.POA_Request_Denied_BY,
	   d.POA_Request_Approved_Date,
	   d.POA_Request_Approved_BY
  ;

  --select * from #rtemp12 order by loan_skey =272143 ;

  select a.loan_skey,b.state_code as 'Property State',a.note_type_description,
  --a.note_text,
  a.POA_REQUEST_RECEIVED_DATE,a.POA_REQUEST_RECEIVED_BY,a.POA_Add_Info_Required_DATE,a.POA_Add_Info_Required_BY,a.POA_Request_Denied_Date,a.POA_Request_Denied_BY,a.POA_Request_Approved_Date,a.POA_Request_Approved_BY,
  case when a.POA_Request_Approved_Date is null and a.POA_Request_Denied_Date is null	 then
 (DATEDIFF(dd, a.POA_REQUEST_RECEIVED_DATE, getdate()) )
		-(DATEDIFF(WW, A.POA_REQUEST_RECEIVED_DATE, getdate()) * 2)
		-CASE			
       WHEN DATEPART(WEEKDAY,A.POA_REQUEST_RECEIVED_DATE) IN (1, 7) THEN 1 ELSE 0			
       END			
       - CASE			
       WHEN DATEPART(WEEKDAY,getdate()) IN (1, 7) THEN 1 ELSE 0		
	   end
	  else
				case when a.POA_Request_Approved_Date is not null then
				(DATEDIFF(dd, A.POA_REQUEST_RECEIVED_DATE, A.POA_Request_Approved_Date) )
				-(DATEDIFF(WW, A.POA_REQUEST_RECEIVED_DATE, A.POA_Request_Approved_Date) * 2)
				-CASE			
				WHEN DATEPART(WEEKDAY,A.POA_REQUEST_RECEIVED_DATE) IN (1, 7) THEN 1 ELSE 0			
				END			
				- CASE			
				WHEN DATEPART(WEEKDAY,getdate()) IN (1, 7) THEN 1 ELSE 0	end	
	   else
		case when a.POA_Request_Denied_Date is not null then
				(DATEDIFF(dd, A.POA_REQUEST_RECEIVED_DATE, A.POA_Request_Denied_Date) )
				-(DATEDIFF(WW, A.POA_REQUEST_RECEIVED_DATE, A.POA_Request_Denied_Date) * 2)
				-CASE			
				WHEN DATEPART(WEEKDAY,A.POA_REQUEST_RECEIVED_DATE) IN (1, 7) THEN 1 ELSE 0		end	
			END			
				- CASE			
				WHEN DATEPART(WEEKDAY,getdate()) IN (1, 7) THEN 1 ELSE 0	end	
   
   end 
          END AS 'AGING(Days)'
 from #rtemp12 a
 join
[ReverseQuest].[rms].[v_PropertyMaster] b
on a.loan_skey=b.loan_skey
--where a.loan_skey=278325
order by a.loan_skey
;


--select * from [ReverseQuest].[rms].[v_PropertyMaster] where loan_skey =272143

/*select * from [ReverseQuest].[rms].[v_Note] where 
note_type_description like 'POA Request Denied%'  
and loan_skey =278325
order by created_date*/