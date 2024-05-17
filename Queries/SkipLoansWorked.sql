/****** Script for SelectTopNRows command from SSMS  ******/
SELECT a.[loan_skey]
	  ,b.loan_status_description
      ,[note_type_description]
      ,[note_type_category_description]
      ,[note_text]
      ,format(a.[created_date],'MM/dd/yyyy') as 'created_date'
      ,a.[created_by]
	  ,b.investor_name,
	  b.product_type_description
  FROM [ReverseQuest].[rms].[v_Note] a
  join
  reversequest.rms.v_LoanMaster b
  on a.loan_skey=b.loan_skey
  where note_type_category_description = 'Skip Tracing'
  and a.created_date >=  DATEADD(month, DATEDIFF(month, 0, getdate()), -31);
