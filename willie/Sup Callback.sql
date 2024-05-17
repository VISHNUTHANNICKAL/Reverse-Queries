
IF OBJECT_ID('tempdb..#tempTbl') IS NOT NULL
    DROP TABLE #tempTbl;
select loan_skey,note_type_description as 'Call Req Note Type'
,created_by,format(created_date,'MM/dd/yyyy') as 'Call Req Date'
into #tempTbl
from
[ReverseQuest].[rms].[v_Note] 
where note_type_description in 
('Call Request - SUPV HRD','Call Request - SUPV CS')
--and created_date  >=  Convert(datetime, '2023-01-24' )
and created_date  >=  Convert(datetime, '2023-03-01' )
order by note_type_description,created_date;

--select * from #tempTbl;

IF OBJECT_ID('tempdb..#obtemp') IS NOT NULL
    DROP TABLE #obtemp;
SELECT x.loan_skey,x.note_type_description as 'OB Note',y.[Call Req Note Type], x.created_date as 'OB Time'
,x.created_by as 'OB by'
into #obtemp
  FROM [ReverseQuest].[rms].[v_Note] x
  join
  #tempTbl y
  on x.loan_skey=y.loan_skey
  where 
  x.created_date > y.[Call Req Date]
  and
  x.note_type_description in ('Outgoing Call -T&I Mitigation','SPOC Outgoing Loss Mit','SPOC Outgoing Dialer','Outgoing Call -Death','SPOC Outgoing Call Insurance',
'SPOC Outgoing No Contact Estab','Outgoing A3P - Other','SPOC Outgoing Foreclosure','SPOC Outgoing Call Occupancy','SPOC OutgoingCall No Atmp Need',
'SPOC Outgoing DocsRequest','SPOC Outgoing Call Foreclosure','SPOC Outgoing A3P DocsRequest','SPOC Outgoing Other','SPOC Outgoing Insurance','SPOC Outgoing HAF',
'Outgoing HAF','SPOC Outgoing Call Taxes','Outgoing','SPOC Outgoing A3P Taxes','SPOC Outgoing A3P Other','SPOC Outgoing A3P Foreclosure','Outgoing A3P HAF',
'SPOC Outgoing Payoff','SPOC Outgoing A3P Loss Mit','SPOC Outgoing UA3P','SPOC Outgoing A3P Insurance','SPOC Outgoing Death','Outgoing No Contact Establishd',
'SPOC Outgoing Call Death','SPOC Outgoing Call Other','SPOC Outgoing Call DocsRequest','SPOC Outgoing No Attempt Need','Outgoing - Occupancy','SPOC Outgoing Occupancy',
'Outgoing UA3P','SPOC Outgoing T & I','SPOC Outgoing Taxes','SPOC Outgoing A3P Payoff','Outgoing A3P - Foreclosure','SPOC Outgoing A3P Occupancy','Outgoing - Default',
'Outgoing Call -Insurance','SPOC Outgoing Call COVID 19','Outgoing Call -Occupancy','Outgoing - Death','SPOC Outgoing Call Loss Mit','Outgoing - Other','SPOC Outgoing A3P T & I',
'Outgoing - Foreclosure','SPOC Outgoing Call No Good Num','Outgoing - Plan Change','Outgoing - Payoff','Outgoing Call -Other','Outgoing - Docs Request','SPOC Outgoing No Good Num',
'SPOC Outgoing A3P Death','SPOCIncomingCall IncentiveOffr','Outgoing - Taxes','Outgoing Call -LOC Draw Req','Outgoing - Refi Inquiry','SPOC Outgoing A3P HAF','Outgoing Call -Loss Draft',
'Outgoing Call -Foreclosure','Outgoing - ACH','SPOC Outgoing Call CA Notifica','Outgoing - Repairs','SPOC Outgoing A3P WA Notifica','SPOC Outgoing A3P Title&Claim','Outgoing A3P - Payoff',
'Outgoing A3P - Default','SPOC Outgoing WA Notifica','SPOC Outgoing Title&Claim','SPOC Outgoing Call Equity Loan','Outgoing - Loss Draft','Outgoing Call -Taxes','SPOC Outgoing A3P COVID 19',
'Outgoing Call -Docs Request','Outgoing Call -ACH','SPOC Outgoing A3P CA Notifica','Outgoing - LOC Draw Req','Outgoing - Insurance','SPOC Outgoing CA Notifica','SPOC Outgoing Call WA Notifica','SPOC Outgoing COVID 19',
'SPOC Outgoing Call T & I','SPOC Outgoing A3P No Good Num','SPOC Outgoing Call-Loss Draft','Outgoing A3P - Occupancy','Outgoing - Payment Status','SPOC outgoing call - NY Occ','Outgoing Call -Payoff',
'SPOC Outgoing Call Payoff','Outgoing A3P - Payment Status','Outgoing A3P - Taxes','SPOC Outgoing Incentive Let','Outgoing - FEMA','Outgoing Call -Refi Inquiry','Outgoing - Address Change','Outgoing A3P - Refi Inquiry',
'Outgoing Call -Address Change','Outgoing Call -Payment Status','Outgoing Call -Mthly Statement','Outgoing Call -1098 IRS Form','Outgoing A3P - Death','Outgoing - Balance Inquiry','Outgoing - Returned Mail',
'Outgoing A3P - COVID 19','Outgoing Call -Default','Outgoing A3P - ACH','SPOC Outgoing BK','Outgoing - Serv Trsfr Inq','SPOC Outgoing A3P FEMA','SPOC Outgoing Call HOA','SPOC Outgoing - Repairs',
'SPOC Outgoing Call Title&Claim','Outgoing Call -Serv Trsfr Inq','Outgoing Call -Plan Change','SPOC Outgoing FEMA','SPOC Outgoing A3P-Loss Draft','SPOC Outgoing HOA','Outgoing - COVID 19',
'Outgoing A3P - Insurance','SPOC Out Call - Trans to SWBC','SPOCOutgoingCall IncentiveOffr','SPOC Outgoing Call ServiceTrsf','Outgoing Call- Hurricane IDA','Outgoing A3P - LOC Draw Req',
'SPOC Outgoing Call-Repairs','Outgoing - Mthly Statement','SPOC Outgoing A3P - NY Occ','SPOC Outgoing Call BK','SPOC Outgoing - NY Occ','Outgoing Call -Title Claim','Outgoing A3P - Plan Change',
'SPOC Outgoing A3P-Repairs','Outgoing Call -Balance Inquiry','Outgoing - Welcome Call','Outgoing Call -Repairs','Outgoing A3P - Docs Request','Outgoing - Release Req','Outgoing A3P - Release Req',
'Outgoing A3P - Serv Trsfr Inq','Outgoing - 1098 IRS Form','Outgoing A3P - Repairs','SPOC Outgoing ServiceTrsf','SPOC Outgoing A3P Incntive Let','SPOC Outgoing - Loss Draft','SPOC Outgoing A3P BK',
'Outgoing A3P - Address Change','Outgoing A3P - FEMA','SPOC Outgoing A3P NV Notifica','Outgoing - Bankruptcy','SPOC Outgoing NV Notifica','SPOC Outgoing Hurricane Isais','Outgoing Call -Bankruptcy',
'SPOC Outgoing A3P ServiceTrsf','Outgoing - Title Claim','SPOC Out Call- Hurricane IDA','Outgoing A3P - Mthly Statement','Outgoing Call -Returned Mail','SPOC Outgoing Trans to ASG','Outgoing - T&I Mitigation',
'SPOC Outgoing Call Earthquake','Outgoing Call -Welcome Call','SPOC Outgoing A3P HOA','SPOC Outgoing Equity Loan','Outgoing A3P - T&I Mitigation','Contact - RPC')
and x.created_by in ('James Bickerstaff','James.Bickerstaff','Azhley Henriquez','Azhley.Henriquez','Pablo Elizondo','Pablo.Elizondo','James Minns',
'James.Minns','John Brian Makalintal','Roshiela.Turla','Roshiela Turla','Marvin Nagal Cacho','Marvin Nagal.Cacho','Jetlene Kae.Salvador'
,'Jetlene Kae Salvador','Ivory Nia A Divina','Ivory Nia A.Divina','Don Anthony Eusebio','Don Anthony.Eusebio','Vincent Gherardi','Vincent.Gherardi'
,'Clarisa Centeno','Clarisa.Centeno','Jerrick Natividad','Jerrick.Natividad','Ashima Burton','Ashima.Burton','Gina Martin','Gina.Martin',
'Jack Padillon','Jack.Padillon','John Brian.Makalintal','John Brian Makalintal');

/*IF OBJECT_ID('tempdb..#obtemp1') IS NOT NULL
    DROP TABLE #obtemp1;
select ROW_NUMBER() OVER (PARTITION BY loan_skey,[call Req Date] ORDER BY [OB Time]) as rn,* into #obtemp1
from #obtemp;*/

--select * from #obtemp1;

IF OBJECT_ID('tempdb..#tempTbl1') IS NOT NULL
    DROP TABLE #tempTbl1;
select distinct 
x.*,y.[Call Req Note Type] as 'OB Note Type',y.[OB Note],[OB Time],[OB by]
,case when [OB Time] is null then
		(DATEDIFF(dd, [Call Req Date], getdate()) )
			-(DATEDIFF(WW, [Call Req Date], getdate()) * 2)
			-CASE			
		   WHEN DATEPART(WEEKDAY,[Call Req Date]) IN (1, 7) THEN 1 ELSE 0			
		   END			
		   - CASE			
		   WHEN DATEPART(WEEKDAY,getdate()) IN (1, 7) THEN 1 ELSE 0		
		   end 
	   else
	   
			(DATEDIFF(dd, [Call Req Date], [OB Time]) )
		-(DATEDIFF(WW, [Call Req Date], [OB Time]) * 2)
		-CASE			
       WHEN DATEPART(WEEKDAY,[Call Req Date]) IN (1, 7) THEN 1 ELSE 0			
       END			
       - CASE			
       WHEN DATEPART(WEEKDAY,[OB Time]) IN (1, 7) THEN 1 ELSE 0	
		end
	end
	   as 'Days Pending'
	   into #tempTbl1
from #tempTbl x
left join
#obtemp y
on x.loan_skey=y.loan_skey
order by x.loan_skey;

IF OBJECT_ID('tempdb..#tempTbl2') IS NOT NULL
    DROP TABLE #tempTbl2;
select ROW_NUMBER() OVER (PARTITION BY loan_skey,[call Req Date] ORDER BY [OB Time]) as rn,* 
into #tempTbl2
from #tempTbl1;

delete from #tempTbl2 where rn >1;

select loan_skey,[Call Req Note Type],created_by,[Call Req Date],[OB Note Type],[OB Note],[OB Time],[OB by],[Days Pending],
case when [OB Time] is not null and [Days Pending]<=2 then 'Yes' 
	when [OB Time] is null and [Days Pending]<=2 then 'N/A' 
else 'No' end as 'SLA Met' 
from #tempTbl2
order by [Call Req Note Type] ,[Call Req Date];

/*select top 1
created_by from [ReverseQuest].[rms].[v_Note]
where created_by like 'Gina%';
*/

select created_by,count(created_by) as 'Escalation count' from #tempTbl2
group by created_by;

select count(loan_skey) as 'Total Escalations',
sum(case when [OB Time] is not null and [Days Pending]<=2 then 1 end) as 'Within SLA' 
,sum(case when  [Days Pending]>2 then 1 else 0 end) as 'SLA Missed',
Format(
convert(float,
sum(case when [OB Time] is not null and [Days Pending]<=2 then 1 end))
/
convert(float,(sum(case when [OB Time] is not null and [Days Pending]>2 then 1 else 0 end)) + convert(float,sum(case when [OB Time] is not null and  [Days Pending]<=2 then 1 else 0 end))) * 100 ,'N2') + '%'
as 'SLA%'
from #tempTbl2;