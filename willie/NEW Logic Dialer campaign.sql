IF OBJECT_ID('tempdb..#rtempDISBURSEMENTS') IS NOT NULL
    DROP TABLE #rtempDISBURSEMENTS;
select a.loan_skey--,b.loan_skey,a.created_date,b.created_date 
into #rtempDISBURSEMENTS
from [ReverseQuest].[rms].[v_Note] a 
left join 
(select loan_skey, created_date from [ReverseQuest].[rms].[v_Note]
where note_type_description in ('Outgoing Call -T&I Mitigation','SPOC Outgoing Loss Mit','SPOC Outgoing Dialer','Outgoing Call -Death','SPOC Outgoing Call Insurance',
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
'SPOC Outgoing Call Earthquake','Outgoing Call -Welcome Call','SPOC Outgoing A3P HOA','SPOC Outgoing Equity Loan','Outgoing A3P - T&I Mitigation'
) ) b
on a.loan_skey=b.loan_skey and b.created_date > a.created_date
where a.note_type_description  in 
('CALL REQUIRED – DISBURSEMENTS','CALL Required – Disbursement','Call Required - DISBURSEMENTS')
and a.created_date >= DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)) 
--Convert(datetime, '2023-05-01' )
and b.created_date IS NULL
;

--select * from #rtempDISBURSEMENTS where loan_skey='110149'

IF OBJECT_ID('tempdb..#limitedattemptstaterules') IS NOT NULL
    DROP TABLE #limitedattemptstaterules;
	select loan_skey,note_text  
	into #limitedattemptstaterules
	from 
	(
SELECT loan_skey,note_text 
  FROM [ReverseQuest].[rms].[v_Note]
  where 
  created_date > DATEADD(DAY, DATEDIFF(DAY, 6, GETDATE()), 0) and  created_date <   DATEADD(DAY, DATEDIFF(DAY, -1, GETDATE()), 0)
  and
  note_type_description in ('Outgoing Call -T&I Mitigation','SPOC Outgoing Loss Mit','SPOC Outgoing Dialer','Outgoing Call -Death','SPOC Outgoing Call Insurance',
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
'SPOC Outgoing Call Earthquake','Outgoing Call -Welcome Call','SPOC Outgoing A3P HOA','SPOC Outgoing Equity Loan','Outgoing A3P - T&I Mitigation')
and loan_skey not in (select loan_skey from #rtempDISBURSEMENTS)
) a where loan_skey in (
select loan_skey from rms.v_PropertyMaster
where state_code in('WA','MA')
union
select loan_skey from rms.v_ContactMaster
where contact_type_description in ('Borrower','Co-Borrower')
and mail_state_code in('WA','MA')
)


--select * from #limitedattemptstaterules order by loan_skey


IF OBJECT_ID('tempdb..#limitedattemptstaterules1') IS NOT NULL
    DROP TABLE #limitedattemptstaterules1;
	select loan_skey,note_text,sn  
	into #limitedattemptstaterules1
	from 
	(
SELECT loan_skey,note_text
,case when note_text like '%(Hung Up)_%' then 
(CONVERT(varchar, CONVERT(varchar, rtrim(ltrim(substring(note_text,CHARINDEX(')_', note_text)+2,10)))),11))
when note_text like '%Wrong Number_%' then 
(CONVERT(varchar, CONVERT(varchar, rtrim(ltrim(substring(note_text,CHARINDEX('r_', note_text)+2,10)))),11))
when note_text like '%Left Message Machine%' then 
(CONVERT(varchar, CONVERT(varchar, rtrim(ltrim(substring(note_text,CHARINDEX('ine_', note_text)+4,10)))),11))
when note_text like '%No Message Left%' then 
(CONVERT(varchar, CONVERT(varchar, rtrim(ltrim(substring(note_text,CHARINDEX('t_', note_text)+2,10)))),11))
when note_text like '%Operator Transfer (Agent Terminated Call)%' then 
(CONVERT(varchar, CONVERT(varchar, rtrim(ltrim(substring(note_text,CHARINDEX(')_', note_text)+2,10)))),11))
when note_text like '%AGENT - PTP by Mail%' then 
(CONVERT(varchar, CONVERT(varchar, rtrim(ltrim(substring(note_text,CHARINDEX('il_', note_text)+3,10)))),11))
when note_text like '%Invalid Phone Number%' then 
(CONVERT(varchar, CONVERT(varchar, rtrim(ltrim(substring(note_text,CHARINDEX('r_', note_text)+2,10)))),11))
when note_text like '%Customer Hung Up%' then 
(CONVERT(varchar, CONVERT(varchar, rtrim(ltrim(substring(note_text,CHARINDEX('Up_', note_text)+3,10)))),11))
when note_text like '%No Answer%' then 
(CONVERT(varchar, CONVERT(varchar, rtrim(ltrim(substring(note_text,CHARINDEX('r_', note_text)+2,10)))),11))
when note_text like '%Busy%' then 
(CONVERT(varchar, CONVERT(varchar, rtrim(ltrim(substring(note_text,CHARINDEX('y_', note_text)+2,10)))),11))
when note_text like '%Operator Transfer (Caller Abandoned)%' then 
(CONVERT(varchar, CONVERT(varchar, rtrim(ltrim(substring(note_text,CHARINDEX('ed)_', note_text)+4,10)))),11))
when note_text like '%Operator Transfer%' then 
(CONVERT(varchar, CONVERT(varchar, rtrim(ltrim(substring(note_text,CHARINDEX('fer_', note_text)+4,10)))),11))
when note_text like '%Hung Up in Opening%' then 
(CONVERT(varchar, CONVERT(varchar, rtrim(ltrim(substring(note_text,CHARINDEX('ing_', note_text)+4,10)))),11))
else '' end as
sn
  FROM [ReverseQuest].[rms].[v_Note]
  where 
  created_date > DATEADD(DAY, DATEDIFF(DAY, 13, GETDATE()), 0) and  created_date <   DATEADD(DAY, DATEDIFF(DAY, -1, GETDATE()), 0)
  and
  note_type_description in ('Outgoing Call -T&I Mitigation','SPOC Outgoing Loss Mit','SPOC Outgoing Dialer','Outgoing Call -Death','SPOC Outgoing Call Insurance',
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
'SPOC Outgoing Call Earthquake','Outgoing Call -Welcome Call','SPOC Outgoing A3P HOA','SPOC Outgoing Equity Loan','Outgoing A3P - T&I Mitigation')
and loan_skey not in (select loan_skey from #rtempDISBURSEMENTS)
) a where loan_skey in (
select loan_skey from rms.v_PropertyMaster
where state_code in('WA','MA')
union
select loan_skey from rms.v_ContactMaster
where contact_type_description in ('Borrower','Co-Borrower')
and mail_state_code in('WA','MA')
)

--select * from #limitedattemptstaterules1;


IF OBJECT_ID('tempdb..#obtemp') IS NOT NULL
    DROP TABLE #obtemp;
SELECT loan_skey into #obtemp
  FROM [ReverseQuest].[rms].[v_Note]
  where 
  created_date > DATEADD(DAY, DATEDIFF(DAY, 2, GETDATE()), 0) and  created_date <  DATEADD(DAY, DATEDIFF(DAY, -1, GETDATE()), 0)
  and
  note_type_description in ('Outgoing Call -T&I Mitigation','SPOC Outgoing Loss Mit','SPOC Outgoing Dialer','Outgoing Call -Death','SPOC Outgoing Call Insurance',
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
'SPOC Outgoing Call Earthquake','Outgoing Call -Welcome Call','SPOC Outgoing A3P HOA','SPOC Outgoing Equity Loan','Outgoing A3P - T&I Mitigation')
and loan_skey not in (select loan_skey from #rtempDISBURSEMENTS)

IF OBJECT_ID('tempdb..#ob4temp') IS NOT NULL
    DROP TABLE #ob4temp;
SELECT loan_skey into #ob4temp
  FROM [ReverseQuest].[rms].[v_Note]
  where 
  created_date >   DATEADD(DAY, DATEDIFF(DAY, 4, GETDATE()), 0) and  created_date <   DATEADD(DAY, DATEDIFF(DAY, -1, GETDATE()), 0)
  and created_by <>'System Load' and
  note_type_description in ('Outgoing Call -T&I Mitigation','SPOC Outgoing Loss Mit','SPOC Outgoing Dialer','Outgoing Call -Death','SPOC Outgoing Call Insurance',
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
'SPOC Outgoing Call Earthquake','Outgoing Call -Welcome Call','SPOC Outgoing A3P HOA','SPOC Outgoing Equity Loan','Outgoing A3P - T&I Mitigation','Call Request - Cust. Follow-Up','Call Request - COP Change','Call Request - Short Payoff','Call Request-Follow-Up Disb.')
and loan_skey not in (select loan_skey from #rtempDISBURSEMENTS)


--select loan_skey from #ob4temp

  IF OBJECT_ID('tempdb..#ob3temp') IS NOT NULL
    DROP TABLE #ob3temp;
SELECT loan_skey into #ob3temp
  FROM [ReverseQuest].[rms].[v_Note]
  where 
  created_date >  DATEADD(DAY, DATEDIFF(DAY, 3, GETDATE()), 0) and  created_date <  DATEADD(DAY, DATEDIFF(DAY, -1, GETDATE()), 0)
  and created_by like 'System Load'
  and note_type_description in ('Outgoing Call -T&I Mitigation','SPOC Outgoing Loss Mit','SPOC Outgoing Dialer','Outgoing Call -Death','SPOC Outgoing Call Insurance',
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
'SPOC Outgoing Call Earthquake','Outgoing Call -Welcome Call','SPOC Outgoing A3P HOA','SPOC Outgoing Equity Loan','Outgoing A3P - T&I Mitigation'
,'Call Request - Cust. Follow-Up','Call Request - COP Change','Call Request - Short Payoff','Call Request-Follow-Up Disb.')
and loan_skey not in (select loan_skey from #rtempDISBURSEMENTS);

IF OBJECT_ID('tempdb..#rtemp12') IS NOT NULL
    DROP TABLE #rtemp12;
select  a.loan_skey,
--a.original_loan_number, 
a.loan_sub_status_description as loan_sub_status,a.investor_name,a.loan_status_description,
c.contact_type_description as 'Contact Type1'
,c.first_name as 'Contact First Name1',c.last_name as 'Contact Last Name1' 
,b.address1 as 'Property Address1',b.address2 as 'Property Address2' ,b.city as 'Property City' 
,b.state_code as 'Property State',left(b.zip_code,5) as 'Property Zip'
,c.mail_address1 as 'Mailing Address 1' ,c.mail_address2 as 'Mailing Address 2',c.mail_city as 'Mailing City'
,c.mail_state_code as 'Mailing State' ,left(c.mail_zip_code,5) as 'Mailing Zip'
,case when c.contact_type_description = 'Attorney' 
--and c.home_phone_number in(NULL,'')
then COALESCE(case when convert (varchar,work_phone_number)='' then NULL else convert (varchar,work_phone_number)  end ,case when convert (varchar,home_phone_number)='' then NULL else  convert (varchar,home_phone_number) end ) else c.home_phone_number end  as 'HOMEPHONE1'
,c.cell_phone_number as 'CELLPHONE1'
,c.work_phone_number as 'Work Phone #'
--,b.curtailment_reason_description,b.date_foreclosure_sale_held,b.date_foreclosure_sale_scheduled
,d.alert_type_description
,d.alert_status_description
,case when c.contact_type_description = 'Attorney' then 1
	  when c.contact_type_description = 'Borrower' then 2
	  when c.contact_type_description = 'Co-Borrower' then 3
	  when c.contact_type_description = 'Legal Owner' then 5
	  when c.contact_type_description = 'Entitled Non-Borrowing Spouse' then 6
	  when c.contact_type_description = 'Alternate Contact' then 14
	  when c.contact_type_description = 'Authorized Party' then 12
	  when c.contact_type_description = 'Executor' then 7
	  when c.contact_type_description = 'Power of Attorney' then 8
	  when c.contact_type_description = 'Trustee' then 11
	  when c.contact_type_description = 'Non-Borrowing Spouse' then 13
	  when c.contact_type_description = 'Conservator' then 9
	  when c.contact_type_description = 'Guardian' then 10
	  when c.contact_type_description = 'Authorized Designee' then 4
	 END as Priority
into #rtemp12
from reversequest.rms.v_LoanMaster a
join
[ReverseQuest].[rms].[v_PropertyMaster] b
on a.loan_skey=b.loan_skey
join reversequest.rms.v_ContactMaster c
on a.loan_skey = c.loan_skey
join ( select * from (
select loan_skey,alert_status_description,alert_type_description,created_date,created_by,
ROW_NUMBER() over (partition by loan_skey order by created_date desc,loan_skey) sn
from 
reversequest.rms.v_Alert
where alert_status_description='Active') a where sn=1) d
on a.loan_skey=d.loan_skey
where 
--a.investor_name not in ('MECA 2011','FNMA') and 
a.loan_status_description not in ('BNK/DEF', 'BNK/FCL','BANKRUPTCY') and 
c.contact_type_description not in('Broker',
'Counseling Agency',
'Contractor',
'Debt Counselor',
'HOA',
'Neighbor',
'Other',
'Payoff Requester',
'Relative',
'Skip Tracing',
'Title Company')
and ((len(c.home_phone_number)>=10 and c.home_phone_number <>'9999999999' and c.home_phone_number <> '4444444444')
or (len(c.cell_phone_number)>=10 and c.cell_phone_number <> '9999999999' and c.cell_phone_number <> '4444444444') or
(len(c.work_phone_number)>=10) and c.work_phone_number <> '9999999999' and c.work_phone_number <> '4444444444') 
--or c.home_phone_number!=c.cell_phone_number
and d.alert_status_description = 'Active';

--update #rtemp set CELLPHONE1=(case when CELLPHONE1=HOMEPHONE1 then '' else CELLPHONE1 end );

--select * from #rtemp where [Contact Type1]='Attorney' and HOMEPHONE1 in('') and CELLPHONE1 in('')
/*
delete  from #rtemp where loan_skey  in(
select loan_skey from [ReverseQuest].[rms].[v_Alert]
where alert_type_description  in ('Borrower Represented by Attorney'
)
and alert_status_description = 'Active')
and [Contact Type1] in ('Borrower','Co-Borrower','Attorney')*/
--and [Property State] in ('AR', 'AZ', 'MA', 'NH', 'OR', 'WA', 'WV' )

/*
select * from (
select a.loan_skey,a.sn,b.contact_type_description 'contact type1'
,b.home_phone_number 'Home phone 1'--,b.cell_phone_number 'Cell Phone 1'
,c.contact_type_description,
c.home_phone_number--,c.cell_phone_number 
from #limitedattemptstaterules1 a 
 left join(
select loan_skey,contact_type_description,home_phone_number,cell_phone_number from rms.v_ContactMaster
where contact_type_description in ('Borrower','Co-Borrower')
and loan_skey in (select loan_skey from #limitedattemptstaterules)
) b on a.loan_skey=b.loan_skey and a.sn=b.home_phone_number
left join(
select loan_skey,contact_type_description,home_phone_number,cell_phone_number 
from rms.v_ContactMaster
where contact_type_description in ('Borrower','Co-Borrower')
and loan_skey in (select loan_skey from #limitedattemptstaterules)
) c on a.loan_skey=c.loan_skey and a.sn!=c.home_phone_number
where a.sn not like '' 
)a where [contact type1] is not null
order by loan_skey
*/

IF OBJECT_ID('tempdb..#temp_home_phone') IS NOT NULL
    DROP TABLE #temp_home_phone;
select * 
into #temp_home_phone
from(
select * 
from (
select a.loan_skey,a.sn--,b.contact_type_description 'contact type1'
,b.home_phone_number 'Home phone 1'--,b.cell_phone_number 'Cell Phone 1'
,c.contact_type_description,
c.home_phone_number--,c.cell_phone_number 
,ROW_NUMBER() over (PARTITION by a.loan_skey,b.home_phone_number order by a.loan_skey,b.home_phone_number) rn
from ( select * from (
select *,
ROW_NUMBER() over(PARTITION by sn order by sn ) tn
from #limitedattemptstaterules1
where sn not like ''
)a where tn=1
) a 
 left join(
select loan_skey,contact_type_description,home_phone_number,cell_phone_number from rms.v_ContactMaster
where contact_type_description in ('Borrower','Co-Borrower')
and loan_skey in (select loan_skey from #limitedattemptstaterules)
) b on a.loan_skey=b.loan_skey and a.sn=b.home_phone_number
left join(
select loan_skey,contact_type_description,home_phone_number,cell_phone_number 
from rms.v_ContactMaster
where contact_type_description in ('Borrower','Co-Borrower')
and loan_skey in (select loan_skey from #limitedattemptstaterules)
) c on a.loan_skey=c.loan_skey and a.sn!=c.home_phone_number
where a.sn not like '' 
)a where [Home phone 1] is not null
)b where rn=1

--select * from #temp_home_phone order by loan_skey

IF OBJECT_ID('tempdb..#temp_cell_phone') IS NOT NULL
    DROP TABLE #temp_cell_phone;
select * 
into #temp_cell_phone
from(
select * 
from (
select a.loan_skey,a.sn--,b.contact_type_description 'contact type1'
--,b.home_phone_number 'Home phone 1'
,b.cell_phone_number 'Cell Phone 1'
,c.contact_type_description,
--c.home_phone_number--,
c.cell_phone_number 
,ROW_NUMBER() over (PARTITION by a.loan_skey,b.cell_phone_number order by a.loan_skey,b.cell_phone_number) rn
from ( select * from (
select *,
ROW_NUMBER() over(PARTITION by sn order by sn ) tn
from #limitedattemptstaterules1
where sn not like ''
)a where tn=1
) a 
 left join(
select loan_skey,contact_type_description,home_phone_number,cell_phone_number from rms.v_ContactMaster
where contact_type_description in ('Borrower','Co-Borrower')
and loan_skey in (select loan_skey from #limitedattemptstaterules)
) b on a.loan_skey=b.loan_skey and a.sn=b.cell_phone_number
left join(
select loan_skey,contact_type_description,home_phone_number,cell_phone_number 
from rms.v_ContactMaster
where contact_type_description in ('Borrower','Co-Borrower')
and loan_skey in (select loan_skey from #limitedattemptstaterules)
) c on a.loan_skey=c.loan_skey and a.sn!=c.cell_phone_number
where a.sn not like '' 
)a where [Cell Phone 1] is not null
)b where rn=1

--select * from #temp_cell_phone

IF OBJECT_ID('tempdb..#rtemp') IS NOT NULL
    DROP TABLE #rtemp;
select 
a.[loan_skey],a.[loan_sub_status],a.[investor_name],a.[loan_status_description],a.[Contact Type1],
a.[Contact First Name1],a.[Contact Last Name1],a.[Property Address1],a.[Property Address2],
a.[Property City],a.[Property State],a.[Property Zip],a.[Mailing Address 1],a.[Mailing Address 2]
,a.[Mailing City],a.[Mailing State],a.[Mailing Zip]
,a.HOMEPHONE1,
case 
when (a.[Property State] in('WA','MA') or a.[Mailing State] in ('WA','MA'))
and a.loan_skey=b.loan_skey
and a.[Contact Type1] in('Borrower','Co-Borrower')
and a.CELLPHONE1=b.[Cell Phone 1] and a.HOMEPHONE1='' then b.[Cell Phone 1]
else a.CELLPHONE1
end as CELLPHONE1,
a.[Work Phone #],a.[alert_type_description],
a.[alert_status_description],
a.[Priority]
into #rtemp
from (
select
a.[loan_skey],a.[loan_sub_status],a.[investor_name],a.[loan_status_description],a.[Contact Type1],
a.[Contact First Name1],a.[Contact Last Name1],a.[Property Address1],a.[Property Address2],
a.[Property City],a.[Property State],a.[Property Zip],a.[Mailing Address 1],a.[Mailing Address 2]
,a.[Mailing City],a.[Mailing State],a.[Mailing Zip],
case when (a.[Property State] in('WA','MA') or a.[Mailing State] in ('WA','MA'))
and a.loan_skey=b.loan_skey
and a.[Contact Type1] in('Borrower','Co-Borrower')
and a.[HOMEPHONE1] =b.[Home phone 1] and a.[CELLPHONE1] ='' then a.[HOMEPHONE1]
when (a.[Property State] in('WA','MA') or a.[Mailing State] in ('WA','MA')
)
and a.loan_skey=b.loan_skey
and a.[Contact Type1] in('Borrower','Co-Borrower')
and a.[HOMEPHONE1] =b.[Home phone 1] and a.[CELLPHONE1] IS not null  then ''
else  
a.[HOMEPHONE1] end as HOMEPHONE1,
a.[CELLPHONE1],
a.[Work Phone #],
a.[alert_type_description],
a.[alert_status_description],
a.[Priority]
 from #rtemp12 a
 left  join #temp_home_phone b on a.loan_skey=b.loan_skey and a.[HOMEPHONE1] =b.[Home phone 1]
 --where (a.[Property State] in ('WA','MA') or a.[Mailing State] in ('WA','MA')) 
 )a 
 left join #temp_cell_phone b on a.loan_skey=b.loan_skey and a.CELLPHONE1 =b.[Cell Phone 1]
-- where (a.[Property State] in ('WA','MA') or a.[Mailing State] in ('WA','MA'))
/*)a
 left join #temp_home_phone b on a.loan_skey=b.loan_skey and a.[HOMEPHONE1] =b.[Home phone 1]
 
 and 
 */


-- select * from #rtemp where loan_skey =271084



 delete from #rtemp where loan_skey  in(
select loan_skey from [ReverseQuest].[rms].v_ContactMaster
where contact_type_description  in ('Attorney')
)


delete from #rtemp where loan_skey  in(
select loan_skey from [ReverseQuest].[rms].[v_Alert]
where alert_type_description  in ('FDCPA -  Call Restrictions','Cease and Desist','Pending Cease and Desist','LITIGATION - Lawsuit Pending','DVN Research Request Pend'
,'Identity Theft','Fraud Suspicion','DVN Research Request Pend','North Carolina emergency declaration','Cease and Desist-Calls'
)
and alert_status_description = 'Active')

--- Skip Trace

delete from #rtemp where loan_skey  in(
select loan_skey from [ReverseQuest].[rms].[v_Alert]
where alert_type_description  in ('SKPADD','SKPEML','SKPEXH','SKPTRC')
and alert_status_description = 'Active')
/*
delete from #rtemp where loan_skey  in(
select loan_skey--,loan_sub_status_description
from rms.v_LoanMaster 
where loan_sub_status_description in('FCL Sale - 3rd Party','FCL- 3rd Party Sale- Funds Pending')
)
*/
delete from #rtemp where loan_skey  in
(select b.loan_skey
  --,a.workflow_instance_skey,a.complete_date
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a join [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
  where a.workflow_task_description ='3rd Party Sale'
  and a.status_description = 'Active' and b.status_description = 'Active'
  and a.complete_date is not null);

   
delete from #rtemp where Priority is null;


IF OBJECT_ID('tempdb..#rtemp1') IS NOT NULL
    DROP TABLE #rtemp1;
select * into #rtemp1 from 
(select ROW_NUMBER() OVER (PARTITION BY loan_skey ORDER BY priority) rn,* from #rtemp) q
WHERE   rn = 1
order by loan_skey

IF OBJECT_ID('tempdb..#tempAlldefault') IS NOT NULL
    DROP TABLE #tempAlldefault;
select a.*
,e.default_reason as 'default reason'
,e.created_date 
into #tempAlldefault
from
#rtemp1 a
join reversequest.rms.v_MonthlyLoanDefaultSummary e
on a.loan_skey=e.loan_skey




delete from #tempAlldefault where loan_skey in
(select loan_skey from #obtemp);


IF OBJECT_ID('tempdb..#finalDefault') IS NOT NULL
    DROP TABLE #finalDefault;

select a.loan_skey,a.loan_sub_status,a.investor_name,
b.[Contact Type1],b.[Contact First Name1],b.[Contact Last Name1],a.[Property Address1]
,a.[Property Address2],a.[Property City],a.[Property State],a.[Property Zip],
b.[Mailing Address 1],b.[Mailing Address 2],b.[Mailing City],b.[Mailing State],b.[Mailing Zip]
,b.[HOMEPHONE1],b.[CELLPHONE1],b.[Work Phone #]
,a.[default reason],a.CALLLIST
into #finalDefault
from 
(select loan_skey,loan_sub_status,investor_name
--,loan_status_description,
,[Contact Type1],[Contact First Name1],[Contact Last Name1],[Property Address1]
,[Property Address2], [Property City],[Property State],[Property Zip],[Mailing Address 1],[Mailing Address 2],[Mailing City],[Mailing State],[Mailing Zip]
,[HOMEPHONE1], [CELLPHONE1], [Work Phone #] 
--,alert_type_description
,[default reason]
--,Priority 
,case   when [Property State] in ('AL','AK','AR','AZ','CA','CO','DE','DC','FL','GA','HI','ID','IL','IN','KS','KY','LA','MD','ME','MA','MI','MN','MO','NM','ND','OH','OK','PA','PR','RI','SD','TN','TX','UT','VT','VA','VI','WV','NY','CT','IA','NV','NH','MT','NE','OR','NC','SC','WA','WI','MS') 
  and investor_name='BAML' then 'RMS_CS_BAML_HOU'
  when [Property State] in ('NJ','WY') and  investor_name='BAML' then 'RMS_CS_BAML_WPB'
when [Property State] in ('AL','AK','AR','AZ','CA','CO','DE','DC','FL','GA','HI','ID','IL','IN','KS','KY','LA','MD','ME','MA','MI','MN','MO','NM','ND','OH','OK','PA','PR','RI','SD','TN','TX','UT','VT','VA','VI','WV','NY','WY') then 'RMS_CS_PMC' 
  when [Property State] in ('NJ') then 'RMS_CS_WPB' 
  when [Property State] in ('CT','IA','NV','NH','MT','NE','OR','NC','SC','WA','WI','MS') then 'RMS_CS_HOU'
else NULL end as 'CALLLIST'
from 
(select ROW_NUMBER() OVER (PARTITION BY loan_skey ORDER BY priority,created_date desc) rownum,* from #tempAlldefault) x
WHERE  
rownum = 1  
--[Contact Type1] in ('Borrower','Co-Borrower','Authorized Party','Legal Owner')
and Priority is not null 
--and loan_skey = '89192'
)a
left join (
select loan_skey--,loan_sub_status,investor_name
--,loan_status_description,
,[Contact Type1],[Contact First Name1],[Contact Last Name1],[Property Address1]
,[Property Address2], [Property City],[Property State],[Property Zip],[Mailing Address 1],[Mailing Address 2],[Mailing City],[Mailing State],[Mailing Zip]
,[HOMEPHONE1], [CELLPHONE1], [Work Phone #] 
--,alert_type_description
/*,[default reason]
--,Priority 
,case when [Property State] in ('AL','AK','AR','AZ','CA','CO','DE','DC','FL','GA','HI','ID','IL','IN','KS','KY','LA','MD','ME','MA','MI','MN','MO','NM','ND','OH','OK','PA','PR','RI','SD','TN','TX','UT','VT','VA','VI','WV','NY','WY') then 'RMS_CS_PMC' 
  when [Property State] in ('NJ') then 'RMS_CS_WPB' 
  when [Property State] in ('CT','IA','NV','NH','MT','NE','OR','NC','SC','WA','WI') then 'RMS_CS_HOU'
  when [Property State] in ('MS') then 'RMS_WFO_CS_HOU'
 -- when [Property State] in () then 'RMS_CS_ALL'
  else NULL end as 'CALLLIST'*/
--into #finalDefault
from 
(select ROW_NUMBER() OVER (PARTITION BY loan_skey ORDER BY priority,created_date desc) rownum,* from #tempAlldefault) x
WHERE  
rownum = 1 and 
[Contact Type1] in ('Borrower','Co-Borrower','Authorized Party','Legal Owner')
and Priority is not null 
--and loan_skey = '89192'
)b on a.loan_skey=b.loan_skey

--select * from #finalDefault order by loan_skey

alter table #finalDefault
add 
CONTACTTYPE2 NVARCHAR(100),
CONTACTFIRSTNAME2 NVARCHAR(200),
CONTACTLASTNAME2 NVARCHAR(200),
HOMEPHONE2 NVARCHAR(20),
CELLPHONE2 NVARCHAR(20),
CONTACTTYPE3 NVARCHAR(100),
CONTACTFIRSTNAME3 NVARCHAR(200),
CONTACTLASTNAME3 NVARCHAR(200),
HOMEPHONE3 NVARCHAR(20),
CELLPHONE3 NVARCHAR(20),
CONTACTTYPE4 NVARCHAR(100),
CONTACTFIRSTNAME4 NVARCHAR(200),
CONTACTLASTNAME4 NVARCHAR(200),
HOMEPHONE4 NVARCHAR(20),
CELLPHONE4 NVARCHAR(20),
MAILINGSTATE2 NVARCHAR(20),
MAILINGZIP2 NVARCHAR(20),
MAILINGSTATE3 NVARCHAR(20),
MAILINGZIP3 NVARCHAR(20),
MAILINGSTATE4 NVARCHAR(20),
MAILINGZIP4 NVARCHAR(20)
;

---------------------------------------------------Exclusion reason

delete from #finalDefault where loan_skey in(
SELECT  [loan_skey]      
  FROM [ReverseQuest].[rms].[v_WorkflowInstance] a 
  join ReverseQuest.rms.v_WorkflowTaskActivity  b on a.workflow_instance_skey=b.workflow_instance_skey 
where workflow_type_description like 'Due & Payable w/ HUD Approval' and a.status_description='Active' and 
    b.workflow_task_description like 'Request to Rescind D&P'  and b.status_description='Active');

delete from #finalDefault where loan_skey in(
SELECT  [loan_skey]      
  FROM [ReverseQuest].[rms].[v_WorkflowInstance] a 
  join ReverseQuest.rms.v_WorkflowTaskActivity  b on a.workflow_instance_skey=b.workflow_instance_skey 
  where workflow_type_description = 'Foreclosure - Judicial' and a.status_description='Active'
  and b.workflow_task_description = 'Send Rescission Request to HUD' and b.status_description='Active');
  
  delete from #finalDefault where loan_skey in(
  SELECT  [loan_skey]      
  FROM [ReverseQuest].[rms].[v_WorkflowInstance] a 
  join ReverseQuest.rms.v_WorkflowTaskActivity  b on a.workflow_instance_skey=b.workflow_instance_skey 
  where  workflow_type_description like 'Foreclosure - Non Judicial' and a.status_description='Active'
  and b.workflow_task_description = 'Send Rescission Request to HUD' and b.status_description='Active')

----------------------------------------------------
--update #finalDefault set [HOMEPHONE1]='',[CELLPHONE1]=''where [CONTACTTYPE1] = 'Attorney';

--select * from #finalDefault where LOANSKEY = '1300';

IF OBJECT_ID('tempdb..#tmpContacts') IS NOT NULL
    DROP TABLE #tmpContacts;
select distinct loan_skey,loan_sub_status,investor_name,[Contact Type1],[Contact First Name1],[Contact Last Name1],[HOMEPHONE1],[CELLPHONE1]
,[Mailing State],[Mailing Zip],Priority
into #tmpContacts
from #rtemp;
--where loan_skey = '211792'
--group by loan_skey,loan_sub_status,investor_name,CONTACTTYPE,CONTACTFIRSTNAME
--select * from #rtemp;;

--update #rtemp set CELLPHONE1=(case when CELLPHONE1=HOMEPHONE1 then '' else CELLPHONE1 end );

delete a from #tmpContacts a
join #finalDefault b on a.loan_skey=b.loan_skey and a.[Contact Type1]=b.[Contact Type1] and a.[Contact First Name1]=b.[Contact First Name1] and a.[Contact Last Name1]=b.[Contact Last Name1];


--select * from #tmpContacts 
--order by loan_skey
--where loan_skey = '1300';

update a set a.CONTACTTYPE2 = b.[Contact Type1],
a.CONTACTFIRSTNAME2=b.[Contact First Name1],
a.CONTACTLASTNAME2=b.[Contact Last Name1],
a.HOMEPHONE2 = b.[HOMEPHONE1],
a.CELLPHONE2=b.[CELLPHONE1],
a.MAILINGSTATE2=b.[Mailing State],
a.MAILINGZIP2=b.[Mailing Zip]
from #finalDefault a
join
(select loan_skey,[Contact Type1],[Contact First Name1],[Contact Last Name1],[HOMEPHONE1],[CELLPHONE1],[Mailing State],[Mailing Zip],priority
from (select loan_skey,[Contact Type1],[Contact First Name1],[Contact Last Name1],[HOMEPHONE1],[CELLPHONE1],[Mailing State],[Mailing Zip],priority,
row_number() over(partition by loan_skey order by priority) as crn
from #tmpContacts) T where crn=1 and [Contact Type1] in ('Borrower','Co-Borrower','Authorized Party','Legal Owner')
) b
on a.loan_skey=b.loan_skey;

--select top 10 * from #tmpContacts

delete a from #tmpContacts a
join #finalDefault b on a.loan_skey=b.loan_skey  and a.[Contact Type1]=b.CONTACTTYPE2 and a.[Contact First Name1]=b.CONTACTFIRSTNAME2 and a.[Contact Last Name1]=b.CONTACTLASTNAME2;

update a set a.CONTACTTYPE3 = b.[Contact Type1],
a.CONTACTFIRSTNAME3=b.[Contact First Name1],
a.CONTACTLASTNAME3=b.[Contact Last Name1],
a.HOMEPHONE3 = b.[HOMEPHONE1],
a.CELLPHONE3=b.[CELLPHONE1],
a.MAILINGSTATE3=b.[Mailing State],
a.MAILINGZIP3=b.[Mailing Zip]
from #finalDefault a
join
(select loan_skey,[Contact Type1],[Contact First Name1],[Contact Last Name1],[HOMEPHONE1],[CELLPHONE1],[Mailing State],[Mailing Zip],priority
from (select loan_skey,[Contact Type1],[Contact First Name1],[Contact Last Name1],[HOMEPHONE1],[CELLPHONE1],[Mailing State],[Mailing Zip],priority,
row_number() over(partition by loan_skey order by priority) as crn
from #tmpContacts) T where crn=1 and [Contact Type1] in ('Borrower','Co-Borrower','Authorized Party','Legal Owner')
) b
on a.loan_skey=b.loan_skey;


delete a from #tmpContacts a
join #finalDefault b on a.loan_skey=b.loan_skey and a.[Contact Type1]=b.CONTACTTYPE3 and a.[Contact First Name1]=b.CONTACTFIRSTNAME3 and a.[Contact Last Name1]=b.CONTACTLASTNAME3;

update a set a.CONTACTTYPE4 = b.[Contact Type1],
a.CONTACTFIRSTNAME4=b.[Contact First Name1],
a.CONTACTLASTNAME4=b.[Contact Last Name1],
a.HOMEPHONE4 = b.[HOMEPHONE1],
a.CELLPHONE4=b.[CELLPHONE1],
a.MAILINGSTATE4=b.[Mailing State],
a.MAILINGZIP4=b.[Mailing Zip]
from #finalDefault a
join
(select loan_skey,[Contact Type1],[Contact First Name1],[Contact Last Name1],[HOMEPHONE1],[CELLPHONE1],[Mailing State],[Mailing Zip],priority
from (select loan_skey,[Contact Type1],[Contact First Name1],[Contact Last Name1],[HOMEPHONE1],[CELLPHONE1],[Mailing State],[Mailing Zip],priority,
row_number() over(partition by loan_skey order by priority) as crn
from #tmpContacts) T where crn=1 and [Contact Type1] not in ('Borrower','Co-Borrower','Authorized Party','Legal Owner')
) b
on a.loan_skey=b.loan_skey;



--update #finalDefault set [HOMEPHONE1]='',[CELLPHONE1]=''where [Contact Type1] = 'Attorney';

-------------------------------------------------------
--select top 10 * from #finalDefault 

update #finalDefault 
set 
investor_name=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(investor_name, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
[Contact Type1]= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([Contact Type1], '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
[Contact First Name1]= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([Contact First Name1], '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
[Contact Last Name1]= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([Contact Last Name1], '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
[Property Address1]= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([Property Address1], '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
[Property Address2] = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([Property Address2], '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
[Property City]= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([Property City], '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
[Mailing Address 1] = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([Mailing Address 1], '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
[Mailing Address 2]= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([Mailing Address 2], '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
loan_sub_status= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(loan_sub_status,'&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
[Property State]= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([Property State], '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
[Property Zip]=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([Property Zip], '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
[Mailing City] =REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([Mailing City], '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTTYPE2= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTTYPE2, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTFIRSTNAME2= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTFIRSTNAME2, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTLASTNAME2 =REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTLASTNAME2, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTTYPE3= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTTYPE3, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTFIRSTNAME3=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTFIRSTNAME3, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTLASTNAME3=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTLASTNAME3, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTTYPE4=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTTYPE4, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTFIRSTNAME4=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTFIRSTNAME4, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTLASTNAME4=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTLASTNAME4, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿','');
 /*
select loan_skey,
loan_sub_status,
HOMEPHONE1,
CELLPHONE1,
HOMEPHONE2,
CELLPHONE2,
HOMEPHONE3,
CELLPHONE3,
HOMEPHONE4,
CELLPHONE4
 from #finalDefault where loan_skey=244696

 update #finalDefault 
set 
CELLPHONE1=(case when HOMEPHONE1=CELLPHONE1 then NULL else CELLPHONE1 end ),
HOMEPHONE2 =(case when HOMEPHONE2=(case when HOMEPHONE1=CELLPHONE1 then NULL else CELLPHONE1 end )
then NULL else HOMEPHONE2 end ),
CELLPHONE2=(case when CELLPHONE2=(case when HOMEPHONE2=(case when HOMEPHONE1=CELLPHONE1 then NULL else CELLPHONE1 end )
then NULL else HOMEPHONE2 end ) then NULL else CELLPHONE2 end ),

HOMEPHONE3=(case when HOMEPHONE3=(case when CELLPHONE2=(case when HOMEPHONE2=(case when HOMEPHONE1=CELLPHONE1 then NULL else CELLPHONE1 end )
then NULL else HOMEPHONE2 end ) then NULL else CELLPHONE2 end )
then NULL else HOMEPHONE3 end ),
CELLPHONE4=(case when CELLPHONE4=(case when HOMEPHONE3=(case when CELLPHONE2=(case when HOMEPHONE2=(case when HOMEPHONE1=CELLPHONE1 then NULL else CELLPHONE1 end )
then NULL else HOMEPHONE2 end ) then NULL else CELLPHONE2 end )
then NULL else HOMEPHONE3 end )
then NULL else CELLPHONE4 end );
*/

--select rtrim(Ltrim(' VISHNU     have      a      good     day          '))

IF OBJECT_ID('tempdb..#finalDefault1') IS NOT NULL
    DROP TABLE #finalDefault1;
select 
a.[loan_skey],
a.[loan_sub_status],
a.[investor_name],
a.[Contact Type1],
a.[Contact First Name1],
a.[Contact Last Name1],
a.[Property Address1],
a.[Property Address2],
a.[Property City],
a.[Property State],
a.[Property Zip],
a.[Mailing Address 1],
a.[Mailing Address 2],
a.[Mailing City],
a.[Mailing State],
a.[Mailing Zip],
coalesce(a.[HOMEPHONE1],'') HOMEPHONE1,
coalesce(a.[CELLPHONE1],'') CELLPHONE1,
--a.[Work Phone #],
a.[default reason],
a.[CALLLIST],
a.[CONTACTTYPE2],
a.[CONTACTFIRSTNAME2],
a.[CONTACTLASTNAME2],
coalesce( a.[HOMEPHONE2],'') HOMEPHONE2 ,
coalesce(a.[CELLPHONE2],'') CELLPHONE2,
a.[CONTACTTYPE3],
a.[CONTACTFIRSTNAME3],
a.[CONTACTLASTNAME3],
coalesce(a.[HOMEPHONE3],'') HOMEPHONE3,
coalesce(a.[CELLPHONE3],'') CELLPHONE3,
a.[CONTACTTYPE4],
a.[CONTACTFIRSTNAME4],
a.[CONTACTLASTNAME4],
coalesce(a.[HOMEPHONE4],'') HOMEPHONE4,
coalesce(a.[CELLPHONE4],'') CELLPHONE4,
a.[MAILINGSTATE2],
a.[MAILINGZIP2],
a.[MAILINGSTATE3],
a.[MAILINGZIP3],
a.[MAILINGSTATE4],
a.[MAILINGZIP4]
	into  #finalDefault1
	from (
select loan_skey,loan_sub_status,investor_name,[Contact Type1],coalesce([Contact First Name1],'No Data') 'Contact First Name1'
,coalesce([Contact Last Name1],'No Data') 'Contact Last Name1',
[Property Address1],[Property Address2],[Property City],[Property State],[Property Zip],[Mailing Address 1],
[Mailing Address 2],[Mailing City],[Mailing State],[Mailing Zip],
RTRIM(LTRIM(HOMEPHONE1)) HOMEPHONE1,
case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end as CELLPHONE1,
[Work Phone #],[default reason],CALLLIST,CONTACTTYPE2,CONTACTFIRSTNAME2,CONTACTLASTNAME2,
case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end as HOMEPHONE2 ,

case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end as  CELLPHONE2,
CONTACTTYPE3,CONTACTFIRSTNAME3,CONTACTLASTNAME3,

case when rtrim(ltrim(HOMEPHONE3))=RTRIM(LTRIM(HOMEPHONE1))  or 
rtrim(ltrim(HOMEPHONE3))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end)
then '' else RTRIM(LTRIM(HOMEPHONE3)) end as HOMEPHONE3,

case when rtrim(ltrim(CELLPHONE3))=(RTRIM(LTRIM(HOMEPHONE1))) or 
rtrim(ltrim(CELLPHONE3))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end) or
rtrim(ltrim(CELLPHONE3))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) or
rtrim(ltrim(CELLPHONE3))=(case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end) or
RTRIM(LTRIM(CELLPHONE3))=(case when rtrim(ltrim(HOMEPHONE3))=RTRIM(LTRIM(HOMEPHONE1))  or 
rtrim(ltrim(HOMEPHONE3))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end)
then '' else RTRIM(LTRIM(HOMEPHONE3)) end)
then '' else RTRIM(LTRIM(CELLPHONE3)) end as CELLPHONE3,

CONTACTTYPE4,CONTACTFIRSTNAME4,CONTACTLASTNAME4,

case when rtrim(ltrim(HOMEPHONE4)) =(RTRIM(LTRIM(HOMEPHONE1))) or 
rtrim(ltrim(HOMEPHONE4)) =(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end) or 
rtrim(ltrim(HOMEPHONE4)) =(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) or 
rtrim(ltrim(HOMEPHONE4)) =(case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end) or 
rtrim(ltrim(HOMEPHONE4)) =(case when rtrim(ltrim(HOMEPHONE3))=RTRIM(LTRIM(HOMEPHONE1))  or 
rtrim(ltrim(HOMEPHONE3))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end)
then '' else RTRIM(LTRIM(HOMEPHONE3)) end) or 
rtrim(ltrim(HOMEPHONE4))=(case when rtrim(ltrim(CELLPHONE3))=(RTRIM(LTRIM(HOMEPHONE1))) or 
rtrim(ltrim(CELLPHONE3))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end) or
rtrim(ltrim(CELLPHONE3))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) or
rtrim(ltrim(CELLPHONE3))=(case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end) or
RTRIM(LTRIM(CELLPHONE3))=(case when rtrim(ltrim(HOMEPHONE3))=RTRIM(LTRIM(HOMEPHONE1))  or 
rtrim(ltrim(HOMEPHONE3))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end)
then '' else RTRIM(LTRIM(HOMEPHONE3)) end)
then '' else RTRIM(LTRIM(CELLPHONE3)) end)
then '' else rtrim(ltrim(HOMEPHONE4)) end as  HOMEPHONE4,

case when rtrim(ltrim(CELLPHONE4))= (RTRIM(LTRIM(HOMEPHONE1))) or 
rtrim(ltrim(CELLPHONE4))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end) or 
rtrim(ltrim(CELLPHONE4))= (case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) or 
rtrim(ltrim(CELLPHONE4))= (case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end) or
rtrim(ltrim(CELLPHONE4))= (case when rtrim(ltrim(HOMEPHONE3))=RTRIM(LTRIM(HOMEPHONE1))  or 
rtrim(ltrim(HOMEPHONE3))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end)
then '' else RTRIM(LTRIM(HOMEPHONE3)) end) or 
rtrim(ltrim(CELLPHONE4))= (case when rtrim(ltrim(CELLPHONE3))=(RTRIM(LTRIM(HOMEPHONE1))) or 
rtrim(ltrim(CELLPHONE3))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end) or
rtrim(ltrim(CELLPHONE3))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) or
rtrim(ltrim(CELLPHONE3))=(case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end) or
RTRIM(LTRIM(CELLPHONE3))=(case when rtrim(ltrim(HOMEPHONE3))=RTRIM(LTRIM(HOMEPHONE1))  or 
rtrim(ltrim(HOMEPHONE3))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end)
then '' else RTRIM(LTRIM(HOMEPHONE3)) end)
then '' else RTRIM(LTRIM(CELLPHONE3)) end) or 
rtrim(ltrim(CELLPHONE4))= (case when rtrim(ltrim(HOMEPHONE4)) =(RTRIM(LTRIM(HOMEPHONE1))) or 
rtrim(ltrim(HOMEPHONE4)) =(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end) or 
rtrim(ltrim(HOMEPHONE4)) =(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) or 
rtrim(ltrim(HOMEPHONE4)) =(case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end) or 
rtrim(ltrim(HOMEPHONE4)) =(case when rtrim(ltrim(HOMEPHONE3))=RTRIM(LTRIM(HOMEPHONE1))  or 
rtrim(ltrim(HOMEPHONE3))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end)
then '' else RTRIM(LTRIM(HOMEPHONE3)) end) or 
rtrim(ltrim(HOMEPHONE4))=(case when rtrim(ltrim(CELLPHONE3))=(RTRIM(LTRIM(HOMEPHONE1))) or 
rtrim(ltrim(CELLPHONE3))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end) or
rtrim(ltrim(CELLPHONE3))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) or
rtrim(ltrim(CELLPHONE3))=(case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end) or
RTRIM(LTRIM(CELLPHONE3))=(case when rtrim(ltrim(HOMEPHONE3))=RTRIM(LTRIM(HOMEPHONE1))  or 
rtrim(ltrim(HOMEPHONE3))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) or
rtrim(ltrim(HOMEPHONE3))=(case when rtrim(ltrim(CELLPHONE2))=RTRIM(LTRIM(HOMEPHONE1)) or
rtrim(ltrim(CELLPHONE2))= (case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then '' else RTRIM(LTRIM(CELLPHONE1)) end)
or rtrim(ltrim(CELLPHONE2))=(case when rtrim(ltrim(HOMEPHONE2))=RTRIM(LTRIM(HOMEPHONE1))
or rtrim(ltrim(HOMEPHONE2))=(case when RTRIM(LTRIM(CELLPHONE1))=RTRIM(LTRIM(HOMEPHONE1)) then 
'' else RTRIM(LTRIM(CELLPHONE1)) end) then '' else rtrim(ltrim(HOMEPHONE2)) end) then '' else  rtrim(ltrim(CELLPHONE2)) end)
then '' else RTRIM(LTRIM(HOMEPHONE3)) end)
then '' else RTRIM(LTRIM(CELLPHONE3)) end)
then '' else rtrim(ltrim(HOMEPHONE4)) end) 
then '' else rtrim(ltrim(CELLPHONE4)) end as CELLPHONE4,
MAILINGSTATE2,
MAILINGZIP2,
MAILINGSTATE3,
MAILINGZIP3,
MAILINGSTATE4,
MAILINGZIP4
--into #finalDefault1
 from #finalDefault ) a 
--where loan_skey=244696

------update for HOMEPHONE 2

update #finalDefault1 set HOMEPHONE2='' ,[CELLPHONE2] = '' where [Property State] in ('WA','MA')
and [CONTACTTYPE2] like 'CoBorrower' and [HOMEPHONE1] not in('') and [CELLPHONE1] not in('');

update #finalDefault1 set HOMEPHONE2='' ,[CELLPHONE2] = '' where [MAILINGSTATE2] in ('WA','MA')
and [CONTACTTYPE2] like 'CoBorrower' and [HOMEPHONE1] not in('') and [CELLPHONE1] not in('');

------update for CELLPHONE 2

update #finalDefault1 set [CELLPHONE2] = '' where [Property State] in ('WA','MA')
and [CONTACTTYPE2] like 'CoBorrower' and [HOMEPHONE1]  in('') and [CELLPHONE1] not in('') and HOMEPHONE2 not in('') ;

update #finalDefault1 set [CELLPHONE2] = '' where [MAILINGSTATE2] in ('WA','MA')
and [CONTACTTYPE2] like 'CoBorrower' and [HOMEPHONE1]  in('') and [CELLPHONE1] not in('') and HOMEPHONE2 not in('') ;

update #finalDefault1 set [CELLPHONE2] = '' where [Property State] in ('WA','MA')
and [CONTACTTYPE2] like 'CoBorrower' and [HOMEPHONE1] not in('')  and [CELLPHONE1] in('') and HOMEPHONE2 not in('') ;

update #finalDefault1 set [CELLPHONE2] = '' where [MAILINGSTATE2] in ('WA','MA')
and [CONTACTTYPE2] like 'CoBorrower' and [HOMEPHONE1] not in('')  and [CELLPHONE1] in('') and HOMEPHONE2 not in('') ;

update #finalDefault1 set [CELLPHONE2] = '' where [Property State] in ('WA','MA')
and [CONTACTTYPE2] like 'CoBorrower' and [HOMEPHONE1] not in('')  and [CELLPHONE1] in(NULL) and HOMEPHONE2 not in('') ;

update #finalDefault1 set [CELLPHONE2] = '' where [MAILINGSTATE2] in ('WA','MA')
and [CONTACTTYPE2] like 'CoBorrower' and [HOMEPHONE1] not in('')  and [CELLPHONE1] in(NULL) and HOMEPHONE2 not in('') ;


-------update for HOMEPHONE3---------
update #finalDefault1 set HOMEPHONE3 = '' where [Property State] in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1] not in('') and [CELLPHONE1] not in('') and HOMEPHONE2 in('') and [CELLPHONE2] in('') ;

update #finalDefault1 set HOMEPHONE3 = '' where [Property State] in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1] not in('') and [CELLPHONE1]  in('') and HOMEPHONE2  not in('') and [CELLPHONE2] in('') ;

update #finalDefault1 set HOMEPHONE3 = '' where [Property State] in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1] not in('') and [CELLPHONE1] in('') and HOMEPHONE2 in('') and [CELLPHONE2] not in('') ;

update #finalDefault1 set HOMEPHONE3 = '' where [Property State] in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1] not in('') and [CELLPHONE1] in('') and HOMEPHONE2 not in('') and [CELLPHONE2] not in('') ;
--
update #finalDefault1 set HOMEPHONE3 = '' where [MAILINGSTATE3] in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1] not in('') and [CELLPHONE1] not in('') and HOMEPHONE2 in('') and [CELLPHONE2] in('') ;

update #finalDefault1 set HOMEPHONE3 = '' where [MAILINGSTATE3] in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1] not in('') and [CELLPHONE1]  in('') and HOMEPHONE2  not in('') and [CELLPHONE2] in('') ;

update #finalDefault1 set HOMEPHONE3 = '' where [MAILINGSTATE3] in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1] not in('') and [CELLPHONE1] in('') and HOMEPHONE2 in('') and [CELLPHONE2] not in('') ;

update #finalDefault1 set HOMEPHONE3 = '' where [MAILINGSTATE3] in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1] not in('') and [CELLPHONE1] in('') and HOMEPHONE2 not in('') and [CELLPHONE2] not in('') ;


--------update for CELLPHONE3--
update #finalDefault1 set CELLPHONE3 = '' where [Property State] in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1] not in('') and [CELLPHONE1] not in('') and HOMEPHONE2 in('') and [CELLPHONE2] in('') and HOMEPHONE3 in ('');

update #finalDefault1 set CELLPHONE3 = '' where [Property State] in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1]  in('') and [CELLPHONE1] not in('') and HOMEPHONE2 not in('') and [CELLPHONE2] in('') and HOMEPHONE3 in ('');

update #finalDefault1 set CELLPHONE3 = '' where [Property State] in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1]  in('') and [CELLPHONE1]  in('') and HOMEPHONE2 not in('') and [CELLPHONE2] not in('') and HOMEPHONE3 in ('');

update #finalDefault1 set CELLPHONE3 = '' where [Property State] in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1]  in('') and [CELLPHONE1]  in('') and HOMEPHONE2  in('') and [CELLPHONE2] not in('') and HOMEPHONE3 not in ('');

update #finalDefault1 set CELLPHONE3 = '' where [Property State] in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1]  not in('') and [CELLPHONE1]  in('') and HOMEPHONE2 not in('') and [CELLPHONE2] in('') and HOMEPHONE3 in ('');

update #finalDefault1 set CELLPHONE3 = '' where [Property State] in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1]  in('') and [CELLPHONE1]  in('') and HOMEPHONE2 not in('') and [CELLPHONE2] not in('') and HOMEPHONE3 in ('');

----
update #finalDefault1 set CELLPHONE3 = '' where MAILINGSTATE3 in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1] not in('') and [CELLPHONE1] not in('') and HOMEPHONE2 in('') and [CELLPHONE2] in('') and HOMEPHONE3 in ('');

update #finalDefault1 set CELLPHONE3 = '' where MAILINGSTATE3 in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1]  in('') and [CELLPHONE1] not in('') and HOMEPHONE2 not in('') and [CELLPHONE2] in('') and HOMEPHONE3 in ('');

update #finalDefault1 set CELLPHONE3 = '' where MAILINGSTATE3 in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1]  in('') and [CELLPHONE1]  in('') and HOMEPHONE2 not in('') and [CELLPHONE2] not in('') and HOMEPHONE3 in ('');

update #finalDefault1 set CELLPHONE3 = '' where MAILINGSTATE3 in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1]  in('') and [CELLPHONE1]  in('') and HOMEPHONE2  in('') and [CELLPHONE2] not in('') and HOMEPHONE3 not in ('');

update #finalDefault1 set CELLPHONE3 = '' where MAILINGSTATE3 in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1]  not in('') and [CELLPHONE1]  in('') and HOMEPHONE2 not in('') and [CELLPHONE2] in('') and HOMEPHONE3 in ('');

update #finalDefault1 set CELLPHONE3 = '' where MAILINGSTATE3 in ('WA','MA') and CONTACTTYPE3 like 'CoBorrower' and
[HOMEPHONE1]  in('') and [CELLPHONE1]  in('') and HOMEPHONE2 not in('') and [CELLPHONE2] not in('') and HOMEPHONE3 in ('');


select * from #finalDefault1 
where ([property state] in ('WA','MA')
or [MAILINGSTATE2] in ('WA','MA') or [MAILINGSTATE3] in ('WA','MA'));