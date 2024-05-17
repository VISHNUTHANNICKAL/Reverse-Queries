IF OBJECT_ID('tempdb..#rtemp') IS NOT NULL
    DROP TABLE #rtemp;

SELECT  
      A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text]
      ,CONVERT(date, max( A.[created_date])) as 'ACH REQUEST_DATE'
      ,a.[created_by],
	   b.ACH_SETUP_DATE
	   ,b.ACH_SETUP_BY
	   ,c.ACH_DECLINED_DATE,
	   c.ACH_DECLINED_BY,
	   p.ACH_CHANGE_DATE,
	   p.ACH_CHANGE_BY,
	   d.ACH_QC_Completed_Date,
	   d.QC_BY
	   into #rtemp
  FROM [ReverseQuest].[rms].[v_Note] a
  left join
  (SELECT 
      A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text]
	  ,CONVERT(date, A.created_date) as 'ACH_SETUP_DATE'
	  ,A.created_by as 'ACH_SETUP_BY'
  FROM [ReverseQuest].[rms].[v_Note] a
  where A. [note_type_description] = 'ACH Processing and Setup'
 ) b
  on a.loan_skey=b.loan_skey and CONVERT(date,b.ACH_SETUP_DATE)>= CONVERT(date,a.created_date)
  left join
  (SELECT 
      A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text]
	  ,a.created_by as 'ACH_DECLINED_BY'
	  ,CONVERT(date, A.created_date) as 'ACH_DECLINED_DATE'
  FROM [ReverseQuest].[rms].[v_Note] a
  where A. [note_type_description] = 'DECLINED ACH') c
  on a.loan_skey=c.loan_skey and CONVERT(date,c.ACH_DECLINED_DATE)>=CONVERT(date,a.created_date)
  left join
  (SELECT 
      A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text]
	  ,a.created_by as 'ACH_CHANGE_BY'
	  ,CONVERT(date, A.created_date) as 'ACH_CHANGE_DATE'
  FROM [ReverseQuest].[rms].[v_Note] a
  where A. [note_type_description] = 'ACH Change Information') p
  on a.loan_skey=p.loan_skey and CONVERT(date,p.ACH_CHANGE_DATE)>=CONVERT(date,a.created_date)
  left join
  (SELECT  
      A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text]
	  ,a.created_by as 'QC_BY'
	  ,CONVERT(date, A.created_date) as 'ACH_QC_Completed_Date'
  FROM [ReverseQuest].[rms].[v_Note] a
  where A. [note_type_description] = 'ACH QC Completed') d
  on a.loan_skey=d.loan_skey and CONVERT(date,d.ACH_QC_Completed_Date) > =CONVERT(date,a.created_date)
  where A. [note_type_description] in ('ACH Setup Request')
  group by  A.[note_skey],A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text],a.[created_by]
	  ,b.ACH_SETUP_DATE
	   ,b.ACH_SETUP_BY
	   ,c.ACH_DECLINED_DATE,
	   c.ACH_DECLINED_BY,
	   p.ACH_CHANGE_DATE,
	   p.ACH_CHANGE_BY,
	   d.ACH_QC_Completed_Date,
	  d.QC_BY
  ;

 delete from  #rtemp where [ACH REQUEST_DATE] <  DATEADD(m,-2,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 31))  
  
 -- DATEADD(DAY, DATEDIFF(DAY, 60, GETDATE()), 0)
  -->=  select DATEADD(m,-2,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 31))
--and a.created_date < DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 25))
  
  ;



  -----------ACH
  --select * from #rtemp;
 select a.loan_skey,b.state_code as 'Property State',a.note_type_description,a.note_text,a.[ACH REQUEST_DATE]
 ,a.created_by,a.ACH_SETUP_DATE,a.ACH_SETUP_BY
--,ACH_DECLINED_DATE
 ,a.ACH_QC_Completed_Date
 ,case when a.ACH_SETUP_DATE is null and a.ACH_DECLINED_DATE is null	 then
 (DATEDIFF(dd, a.[ACH REQUEST_DATE], getdate()) )
		-(DATEDIFF(WW, A.[ACH REQUEST_DATE], getdate()) * 2)
		-CASE			
       WHEN DATEPART(WEEKDAY,A.[ACH REQUEST_DATE]) IN (1, 7) THEN 1 ELSE 0			
       END			
       - CASE			
       WHEN DATEPART(WEEKDAY,getdate()) IN (1, 7) THEN 1 ELSE 0		
	   end
	  else
				case when a.ACH_SETUP_DATE is not null then
				(DATEDIFF(dd, A.[ACH REQUEST_DATE], A.ACH_SETUP_DATE) )
				-(DATEDIFF(WW, A.[ACH REQUEST_DATE], A.ACH_SETUP_DATE) * 2)
				-CASE			
				WHEN DATEPART(WEEKDAY,A.[ACH REQUEST_DATE]) IN (1, 7) THEN 1 ELSE 0			
				END			
				- CASE			
				WHEN DATEPART(WEEKDAY,getdate()) IN (1, 7) THEN 1 ELSE 0	end	
	  else
		case when a.ACH_DECLINED_DATE is not null then
				(DATEDIFF(dd, A.[ACH REQUEST_DATE], A.ACH_DECLINED_DATE) )
				-(DATEDIFF(WW, A.[ACH REQUEST_DATE], A.ACH_DECLINED_DATE) * 2)
				-CASE			
				WHEN DATEPART(WEEKDAY,A.[ACH REQUEST_DATE]) IN (1, 7) THEN 1 ELSE 0		end	
			END			
				- CASE			
				WHEN DATEPART(WEEKDAY,getdate()) IN (1, 7) THEN 1 ELSE 0	end	
	   end
       END AS 'AGING(Days)'
 from #rtemp a 
 join
[ReverseQuest].[rms].[v_PropertyMaster] b
on a.loan_skey=b.loan_skey
 where a.QC_BY is null 
 and a.ACH_DECLINED_DATE is null
 and a.ACH_CHANGE_DATE is null
 ;

 ---ACH Declined
 select a.loan_skey,b.state_code,a.note_type_description,a.note_text,a.[ACH REQUEST_DATE]
 ,a.created_by,a.ACH_SETUP_DATE,a.ACH_SETUP_BY,a.ACH_DECLINED_DATE
 ,a.ACH_DECLINED_BY,a.ACH_CHANGE_DATE,ACH_CHANGE_BY,a.ACH_QC_Completed_Date,a.QC_BY
 ,case when a.ACH_SETUP_DATE is null and a.ACH_DECLINED_DATE is null	 then
 (DATEDIFF(dd, a.[ACH REQUEST_DATE], getdate()) )
		-(DATEDIFF(WW, A.[ACH REQUEST_DATE], getdate()) * 2)
		-CASE			
       WHEN DATEPART(WEEKDAY,A.[ACH REQUEST_DATE]) IN (1, 7) THEN 1 ELSE 0			
       END			
       - CASE			
       WHEN DATEPART(WEEKDAY,getdate()) IN (1, 7) THEN 1 ELSE 0		
	   end
	  else
				case when a.ACH_SETUP_DATE is not null then
				(DATEDIFF(dd, A.[ACH REQUEST_DATE], A.ACH_SETUP_DATE) )
				-(DATEDIFF(WW, A.[ACH REQUEST_DATE], A.ACH_SETUP_DATE) * 2)
				-CASE			
				WHEN DATEPART(WEEKDAY,A.[ACH REQUEST_DATE]) IN (1, 7) THEN 1 ELSE 0			
				END			
				- CASE			
				WHEN DATEPART(WEEKDAY,getdate()) IN (1, 7) THEN 1 ELSE 0	end	
	  else
		case when a.ACH_DECLINED_DATE is not null then
				(DATEDIFF(dd, A.[ACH REQUEST_DATE], A.ACH_DECLINED_DATE) )
				-(DATEDIFF(WW, A.[ACH REQUEST_DATE], A.ACH_DECLINED_DATE) * 2)
				-CASE			
				WHEN DATEPART(WEEKDAY,A.[ACH REQUEST_DATE]) IN (1, 7) THEN 1 ELSE 0		end	
			END			
				- CASE			
				WHEN DATEPART(WEEKDAY,getdate()) IN (1, 7) THEN 1 ELSE 0	end	
	   end
       END AS 'AGING(Days)'
 from #rtemp a 
 join
[ReverseQuest].[rms].[v_PropertyMaster] b
on a.loan_skey=b.loan_skey
 where a.QC_BY is not null 
or a.ACH_DECLINED_DATE is not null
or a.ACH_CHANGE_DATE is not null
 and a.[ACH REQUEST_DATE]
 >=     convert(date, DATEADD(DAY, DATEDIFF(DAY, 60, GETDATE()), 0))
 -->=     convert(date, DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)))
 --and a.ACH_SETUP_DATE<  select convert(date, DATEADD(m,1,DATEADD(mm, DATEDIFF(m,0,GETDATE()),0)))
 ;
 
 ----------------------------------------------
 
 IF OBJECT_ID('tempdb..#rtemp1') IS NOT NULL
    DROP TABLE #rtemp1;

SELECT  
      A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text]
      ,CONVERT(date, max( A.[created_date])) as 'COP REQUEST_DATE'
      ,a.[created_by] as 'COP REQUEST_BY',
	  x.CLAR_REQUEST_DATE,
	  x.CLAR_REQUEST_BY,
	   b.COP_PROCESSED_DATE
	   ,b.COP_PROCESSED_BY
	   ,c.[COP Request Cancelled By],
	   c.[COP_Request_Cancelled_ Date],
	   d.[COP Approved Date],
	   d.[COP Approved By]
	   ,y.[COP Declined Date]
	   ,y.[COP Declined By]
	   into #rtemp1
  FROM [ReverseQuest].[rms].[v_Note] a
  left join
  (SELECT 
      A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text]
	  ,CONVERT(date, A.created_date) as 'CLAR_REQUEST_DATE'
	  ,A.created_by as 'CLAR_REQUEST_BY'
  FROM [ReverseQuest].[rms].[v_Note] a
  where A. [note_type_description] = 'COP Request Clar. Needed'
 ) x
  on a.loan_skey=x.loan_skey and CONVERT(date,x.CLAR_REQUEST_DATE)>= CONVERT(date,a.created_date)
  left join
  (SELECT 
      A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text]
	  ,CONVERT(date, A.created_date) as 'COP_PROCESSED_DATE'
	  ,A.created_by as 'COP_PROCESSED_BY'
  FROM [ReverseQuest].[rms].[v_Note] a
  where A. [note_type_description] = 'COP Request Processed'
 ) b
  on a.loan_skey=b.loan_skey and CONVERT(date,b.COP_PROCESSED_DATE)>= CONVERT(date,a.created_date)
  left join
  (SELECT 
      A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text]
	  ,a.created_by as 'COP Request Cancelled By'
	  ,CONVERT(date, A.created_date) as 'COP_Request_Cancelled_ Date'
  FROM [ReverseQuest].[rms].[v_Note] a
  where A. [note_type_description] = 'COP Request Cancelled') c
  on a.loan_skey=c.loan_skey and CONVERT(date,c.[COP_Request_Cancelled_ Date])>=CONVERT(date,a.created_date)
  left join
  (SELECT  
      A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text]
	  ,a.created_by as 'COP Approved By'
	  ,CONVERT(date, A.created_date) as 'COP Approved Date'
  FROM [ReverseQuest].[rms].[v_Note] a
  where A. [note_type_description] = 'Approved COP') d
  on a.loan_skey=d.loan_skey and CONVERT(date,d.[COP Approved Date]) > =CONVERT(date,a.created_date)
  left join
  (SELECT  
      A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text]
	  ,a.created_by as 'COP Declined By'
	  ,CONVERT(date, A.created_date) as 'COP Declined Date'
  FROM [ReverseQuest].[rms].[v_Note] a
  where A. [note_type_description] = 'Declined COP') y
  on a.loan_skey=y.loan_skey and CONVERT(date,y.[COP Declined Date]) > =CONVERT(date,a.created_date)
  where A. [note_type_description] = 'COP Borrower Request'
  group by  A.[note_skey],A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text],a.[created_by]
	  ,b.COP_PROCESSED_DATE
	   ,b.COP_PROCESSED_BY
	   ,c.[COP_Request_Cancelled_ Date],
	   c.[COP Request Cancelled By],
	   d.[COP Approved By],
	  d.[COP Approved By],
	  d.[COP Approved Date]
	  ,x.CLAR_REQUEST_BY
	  ,x.CLAR_REQUEST_DATE
	  ,y.[COP Declined By]
	  ,y.[COP Declined Date];
	  --select * from #rtemp1;
	  delete from #rtemp1 where [COP REQUEST_DATE] <   DATEADD(m,-2,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 31)) ;

  select a.loan_skey,b.state_code as 'Property State',a.note_type_description,a.note_text,a.[COP REQUEST_DATE]
  ,a.[COP REQUEST_BY],a.CLAR_REQUEST_DATE,a.CLAR_REQUEST_BY,a.COP_PROCESSED_DATE,a.COP_PROCESSED_BY,a.[COP_Request_Cancelled_ Date]
  ,[COP Request Cancelled By]
  ,a.[COP Approved Date],a.[COP Declined Date],a.[COP Declined By]
 ,case when a.COP_PROCESSED_DATE is null and a.[COP_Request_Cancelled_ Date] is null	 then
 (DATEDIFF(dd, a.[COP REQUEST_DATE], getdate()) )
		-(DATEDIFF(WW, A.[COP REQUEST_DATE], getdate()) * 2)
		-CASE			
       WHEN DATEPART(WEEKDAY,A.[COP REQUEST_DATE]) IN (1, 7) THEN 1 ELSE 0			
       END			
       - CASE			
       WHEN DATEPART(WEEKDAY,getdate()) IN (1, 7) THEN 1 ELSE 0		
	   end
	  else
				case when a.COP_PROCESSED_DATE is not null then
				(DATEDIFF(dd, A.[COP REQUEST_DATE], A.COP_PROCESSED_DATE) )
				-(DATEDIFF(WW, A.[COP REQUEST_DATE], A.COP_PROCESSED_DATE) * 2)
				-CASE			
				WHEN DATEPART(WEEKDAY,A.[COP REQUEST_DATE]) IN (1, 7) THEN 1 ELSE 0			
				END			
				- CASE			
				WHEN DATEPART(WEEKDAY,getdate()) IN (1, 7) THEN 1 ELSE 0	end	
	  else
		case when a.[COP_Request_Cancelled_ Date] is not null then
				(DATEDIFF(dd, A.[COP REQUEST_DATE], A.[COP_Request_Cancelled_ Date]) )
				-(DATEDIFF(WW, A.[COP REQUEST_DATE], A.[COP_Request_Cancelled_ Date]) * 2)
				-CASE			
				WHEN DATEPART(WEEKDAY,A.[COP REQUEST_DATE]) IN (1, 7) THEN 1 ELSE 0		end	
			END			
				- CASE			
				WHEN DATEPART(WEEKDAY,getdate()) IN (1, 7) THEN 1 ELSE 0	end	
	   end
       END AS 'AGING(Days)'
 from #rtemp1 a
 join
[ReverseQuest].[rms].[v_PropertyMaster] b
on a.loan_skey=b.loan_skey
 ;
 ------------------------------------------------------------------FCOP------

 IF OBJECT_ID('tempdb..#rtemp2') IS NOT NULL
    DROP TABLE #rtemp2;

SELECT  
      A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text]
      ,CONVERT(date, max( A.[created_date])) as 'FCOP REQUEST_DATE'
      ,a.[created_by],
	   b.CLAR_REQUEST_DATE
	   ,b.CLAR_REQUEST_BY
	   ,c.FCOP_REQUEST_PROCESSED_DATE,
	   c.FCOP_REQUEST_PROCESSED_BY,
	   d.FCOP_Request_Cancelled_Date,
	   d.FCOP_Request_Cancelled_BY
	   into #rtemp2
  FROM [ReverseQuest].[rms].[v_Note] a
  left join
  (SELECT 
      A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text]
	  ,CONVERT(date, A.created_date) as 'CLAR_REQUEST_DATE'
	  ,A.created_by as 'CLAR_REQUEST_BY'
  FROM [ReverseQuest].[rms].[v_Note] a
  where A. [note_type_description] = 'FCOP Request Clar. Needed'
 ) b
  on a.loan_skey=b.loan_skey and CONVERT(date,b.CLAR_REQUEST_DATE)>= CONVERT(date,a.created_date)
  left join
  (SELECT 
      A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text]
	  ,a.created_by as 'FCOP_REQUEST_PROCESSED_BY'
	  ,CONVERT(date, A.created_date) as 'FCOP_REQUEST_PROCESSED_DATE'
  FROM [ReverseQuest].[rms].[v_Note] a
  where A. [note_type_description] = 'FCOP Request Processed') c
  on a.loan_skey=c.loan_skey and CONVERT(date,c.FCOP_REQUEST_PROCESSED_DATE)>=CONVERT(date,a.created_date)
  left join
  (SELECT  
      A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text]
	  ,a.created_by as 'FCOP_Request_Cancelled_BY'
	  ,CONVERT(date, A.created_date) as 'FCOP_Request_Cancelled_Date'
  FROM [ReverseQuest].[rms].[v_Note] a
  where A. [note_type_description] = 'FCOP Request Cancelled') d
  on a.loan_skey=d.loan_skey and CONVERT(date,d.[FCOP_Request_Cancelled_Date]) > =CONVERT(date,a.created_date)
  where A. [note_type_description] = 'FCOP Request'
  group by  A.[note_skey],A.[loan_skey]
      ,A.[note_type_description]
      ,A.[note_text],a.[created_by]
	  ,b.CLAR_REQUEST_DATE
	   ,b.CLAR_REQUEST_BY
	   ,c.FCOP_REQUEST_PROCESSED_DATE,
	   c.FCOP_REQUEST_PROCESSED_BY,
	   d.FCOP_Request_Cancelled_Date,
	  d.FCOP_Request_Cancelled_BY
  ;

delete from #rtemp2 where  [FCOP REQUEST_DATE] < DATEADD(m,-2,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 31)) ;

  select a.loan_skey,b.state_code as 'Property State',a.note_type_description,a.note_text,a.[FCOP REQUEST_DATE],a.created_by,a.CLAR_REQUEST_DATE,a.CLAR_REQUEST_BY
  ,a.FCOP_REQUEST_PROCESSED_DATE,a.FCOP_REQUEST_PROCESSED_BY,a.FCOP_Request_Cancelled_Date,a.FCOP_Request_Cancelled_BY
 ,case when a.FCOP_REQUEST_PROCESSED_DATE is null and a.FCOP_Request_Cancelled_Date is null	 then
 (DATEDIFF(dd, a.[FCOP REQUEST_DATE], getdate()) )
		-(DATEDIFF(WW, A.[FCOP REQUEST_DATE], getdate()) * 2)
		-CASE			
       WHEN DATEPART(WEEKDAY,A.[FCOP REQUEST_DATE]) IN (1, 7) THEN 1 ELSE 0			
       END			
       - CASE			
       WHEN DATEPART(WEEKDAY,getdate()) IN (1, 7) THEN 1 ELSE 0		
	   end
	  else
				case when a.FCOP_REQUEST_PROCESSED_DATE is not null then
				(DATEDIFF(dd, A.[FCOP REQUEST_DATE], A.FCOP_REQUEST_PROCESSED_DATE) )
				-(DATEDIFF(WW, A.[FCOP REQUEST_DATE], A.FCOP_REQUEST_PROCESSED_DATE) * 2)
				-CASE			
				WHEN DATEPART(WEEKDAY,A.[FCOP REQUEST_DATE]) IN (1, 7) THEN 1 ELSE 0			
				END			
				- CASE			
				WHEN DATEPART(WEEKDAY,getdate()) IN (1, 7) THEN 1 ELSE 0	end	
	  else
		case when a.FCOP_Request_Cancelled_Date is not null then
				(DATEDIFF(dd, A.[FCOP REQUEST_DATE], A.FCOP_Request_Cancelled_Date) )
				-(DATEDIFF(WW, A.[FCOP REQUEST_DATE], A.FCOP_Request_Cancelled_Date) * 2)
				-CASE			
				WHEN DATEPART(WEEKDAY,A.[FCOP REQUEST_DATE]) IN (1, 7) THEN 1 ELSE 0		end	
			END			
				- CASE			
				WHEN DATEPART(WEEKDAY,getdate()) IN (1, 7) THEN 1 ELSE 0	end	
	   end
       END AS 'AGING(Days)'
 from #rtemp2 a
 join
[ReverseQuest].[rms].[v_PropertyMaster] b
on a.loan_skey=b.loan_skey;