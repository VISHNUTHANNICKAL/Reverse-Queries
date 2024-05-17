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


IF OBJECT_ID('tempdb..#obtentemp') IS NOT NULL
    DROP TABLE #obtentemp;
SELECT loan_skey into #obtentemp
  FROM [ReverseQuest].[rms].[v_Note]
  where 
  created_date > DATEADD(DAY, DATEDIFF(DAY, 10, GETDATE()), 0) and  created_date <  DATEADD(DAY, DATEDIFF(DAY, -1, GETDATE()), 0)
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


------------------------------------------------------exclusion 12 days
  IF OBJECT_ID('tempdb..#ob12temp') IS NOT NULL
    DROP TABLE #ob12temp;
SELECT loan_skey into #ob12temp
  FROM [ReverseQuest].[rms].[v_Note]
  where 
  created_date >  DATEADD(DAY, DATEDIFF(DAY, 12, GETDATE()), 0) and  created_date <  DATEADD(DAY, DATEDIFF(DAY, -1, GETDATE()), 0)
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
'SPOC Outgoing Call Earthquake','Outgoing Call -Welcome Call','SPOC Outgoing A3P HOA','SPOC Outgoing Equity Loan','Outgoing A3P - T&I Mitigation');


--select * from  #ob12temp;
-----------------------Exclusion loan key 11 days System load
 IF OBJECT_ID('tempdb..#ob11temp') IS NOT NULL
    DROP TABLE #ob11temp;
SELECT loan_skey into #ob11temp
  FROM [ReverseQuest].[rms].[v_Note]
  where 
  created_date >  DATEADD(DAY, DATEDIFF(DAY, 11, GETDATE()), 0) and  created_date <  DATEADD(DAY, DATEDIFF(DAY, -1, GETDATE()), 0)
  and created_by like 'System Load' and
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
'SPOC Outgoing Call Earthquake','Outgoing Call -Welcome Call','SPOC Outgoing A3P HOA','SPOC Outgoing Equity Loan','Outgoing A3P - T&I Mitigation');

--select loan_skey from #ob11temp




------------------------exclusion 4 days
  IF OBJECT_ID('tempdb..#ob4temp') IS NOT NULL
    DROP TABLE #ob4temp;
SELECT loan_skey into #ob4temp
  FROM [ReverseQuest].[rms].[v_Note]
  where 
  created_date >  DATEADD(DAY, DATEDIFF(DAY, 4, GETDATE()), 0) and  created_date <  DATEADD(DAY, DATEDIFF(DAY, -1, GETDATE()), 0)
  and created_by <>'System Load'
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
'SPOC Outgoing Call Earthquake','Outgoing Call -Welcome Call','SPOC Outgoing A3P HOA','SPOC Outgoing Equity Loan','Outgoing A3P - T&I Mitigation');

 -- select distinct created_by  from #ob4temp  where created_by like '%System%'order by created_by

 ---------------Exclusion 3 days System load

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
'SPOC Outgoing Call Earthquake','Outgoing Call -Welcome Call','SPOC Outgoing A3P HOA','SPOC Outgoing Equity Loan','Outgoing A3P - T&I Mitigation');

--select loan_skey from #ob3temp

IF OBJECT_ID('tempdb..#rtemp') IS NOT NULL
    DROP TABLE #rtemp;
select  a.loan_skey,
--a.original_loan_number, 
a.loan_sub_status_description as loan_sub_status,a.investor_name,a.loan_status_description,
c.contact_type_description as 'CONTACTTYPE1'
,c.first_name as 'CONTACTFIRSTNAME1',c.last_name as 'CONTACTLASTNAME1' 
,b.address1 as 'PROPERTYADDRESS1',b.address2 as 'PROPERTYADDRESS2' ,b.city as 'PROPERTYCITY' 
,b.state_code as 'PROPERTYSTATE',left(b.zip_code,5) as 'PROPERTYZIP'
,c.mail_address1 as 'MAILINGADDRESS1' ,c.mail_address2 as 'MAILINGADDRESS2',c.mail_city as 'MAILINGCITY'
,c.mail_state_code as 'MAILINGSTATE' ,left(c.mail_zip_code,5) as 'MAILINGZIP'
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
into #rtemp
from reversequest.rms.v_LoanMaster a
join
[ReverseQuest].[rms].[v_PropertyMaster] b
on a.loan_skey=b.loan_skey
join reversequest.rms.v_ContactMaster c
on a.loan_skey = c.loan_skey
join reversequest.rms.v_Alert d
on a.loan_skey=d.loan_skey
where 
a.loan_status_description in ('DEFAULT', 'FORECLOSURE')
and c.contact_type_description not in('Broker',
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
and ((len(c.home_phone_number)>=10 and c.home_phone_number <>'9999999999' and c.home_phone_number <> '4444444444')or (len(c.cell_phone_number)>=10 and c.cell_phone_number <> '9999999999' and c.cell_phone_number <> '4444444444') or
(len(c.work_phone_number)>=10) and c.work_phone_number <> '9999999999' and c.work_phone_number <> '4444444444')
and d.alert_status_description = 'Active'
and a.loan_skey in(select loan_skey from [ReverseQuest].[rms].v_ContactMaster
where contact_type_description  in ('Attorney'));

--select  * from #rtemp where CONTACTTYPE1='Attorney' and HOMEPHONE1 in('') and CELLPHONE1 in('')

/*
delete  from #rtemp where loan_skey  in(
select loan_skey from [ReverseQuest].[rms].[v_Alert]
where alert_type_description  in ('Borrower Represented by Attorney'
)
and alert_status_description = 'Active')
and CONTACTTYPE1 in ('Borrower','Co-Borrower','Attorney')
--and [Property State] in ('AR', 'AZ', 'MA', 'NH', 'OR', 'WA', 'WV' )

 
 delete from #rtemp where loan_skey  in(
select loan_skey from [ReverseQuest].[rms].v_ContactMaster
where contact_type_description  in ('Attorney')
)
*/



delete from #rtemp where loan_skey  in(
select loan_skey from [ReverseQuest].[rms].[v_Alert]
where alert_type_description  in ('FDCPA -  Call Restrictions','Cease and Desist','Pending Cease and Desist','LITIGATION - Lawsuit Pending','DVN Research Request Pend',
'Identity Theft','Fraud Suspicion','DVN Research Request Pend','Cease and Desist-Calls'
)
and alert_status_description = 'Active')

-------Skip Trace
delete from #rtemp where loan_skey  in(
select loan_skey from [ReverseQuest].[rms].[v_Alert]
where alert_type_description  in ('SKPADD','SKPEML','SKPEXH','SKPTRC')
and alert_status_description = 'Active')



delete from #rtemp where loan_skey  in
(select b.loan_skey
  --,a.workflow_instance_skey,a.complete_date
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a join [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
  where a.workflow_task_description ='3rd Party Sale'
  and a.status_description = 'Active' and b.status_description = 'Active'
  and a.complete_date is not null);
  
delete from #rtemp where Priority is null;
--select * from #rtemp1 where loan_skey = '25111';

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

delete from #tempAlldefault
where loan_skey in
(select a.loan_skey from reversequest.rms.v_note a
where a.created_date
>= DATEADD(d,-7,DATEDIFF(d,0,GETDATE())) and
a.created_date < DATEADD(d,0,DATEDIFF(d,0,GETDATE()))
and (a.note_type_description like '%Incom%' or note_type_description like 'Spoc Incom%')
and a.created_by not like 'System Load');

delete from #tempAlldefault
where loan_skey in
(select a.loan_skey from reversequest.rms.v_note a
where a.created_date
>= DATEADD(d,-6,DATEDIFF(d,0,GETDATE())) and
a.created_date < DATEADD(d,0,DATEDIFF(d,0,GETDATE()))
and (a.note_type_description like '%Incom%' or note_type_description like 'Spoc Incom%')
and a.created_by like 'System Load');



delete from #tempAlldefault
where loan_skey in
(select a.loan_skey from reversequest.rms.v_note a
where a.created_date
>= DATEADD(d,-6,DATEDIFF(d,0,GETDATE())) and
a.created_date < DATEADD(d,1,DATEDIFF(d,0,GETDATE()))
and a.note_type_description like 'Contact - RPC' and a.created_by in ('Vishnu V Thannickal','Mohit Gandhi')
);

delete from #tempAlldefault
where loan_skey in
(select a.loan_skey from reversequest.rms.v_note a
where a.created_date
>= DATEADD(d,-7,DATEDIFF(d,0,GETDATE())) and
a.created_date < DATEADD(d,0,DATEDIFF(d,0,GETDATE()))
and a.note_type_description like 'Contact - RPC' and a.created_by not in ('Vishnu V Thannickal','Mohit Gandhi')
);

IF OBJECT_ID('tempdb..#finalDefault') IS NOT NULL
    DROP TABLE #finalDefault;
select loan_skey as [LOANSKEY],loan_sub_status as [LOANSUBSTATUS],investor_name as [INVESTORNAME]
--,loan_status_description,
,CONTACTTYPE1,CONTACTFIRSTNAME1,[CONTACTLASTNAME1],[PROPERTYADDRESS1]
,[PROPERTYADDRESS2], [PROPERTYCITY],[PROPERTYSTATE],[PROPERTYZIP],[MAILINGADDRESS1],[MAILINGADDRESS2],[MAILINGCITY],[MAILINGSTATE],[MAILINGZIP]
, [HOMEPHONE1],[CELLPHONE1]
--, [Work Phone #] 
--,alert_type_description
,[default reason]
--,Priority 
,case when PROPERTYSTATE in('AL','AK','AR','AZ','CA','CO','DE','DC','FL','GA','HI','ID','IL','IN','KS','KY','LA','MD','ME','MA','MI','MN','MO','NM','ND','OH','OK','PA','PR','RI','SD','TN','TX','UT','VT','VA','VI','WV') then 'RMS_HRD_ALL'
  when PROPERTYSTATE in ('NJ') then 'RMS_HRD_WPB'
  when PROPERTYSTATE in ('CT','IA','MT','NE','NH','OR','SC','WA','WI','NV','NC') then 'RMS_HRD_HOU'
  when PROPERTYSTATE in ('NY','WY') then 'RMS_HRD_PMC' 
  when PROPERTYSTATE in ('MS') then 'RMS_WFO_HRD_HOU'
  else null end  as 'CALLLIST'
into #finalDefault
from 
(select ROW_NUMBER() OVER (PARTITION BY loan_skey ORDER BY priority,created_date desc) rownum,* from #tempAlldefault) x
WHERE  
rownum = 1 and 
Priority is not null 
--and loan_skey = '89192'
order by loan_skey,alert_type_description;

--select * from #finalDefault where CONTACTTYPE1='Attorney' and HOMEPHONE1 in('')


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

delete from #finalDefault where LOANSKEY in(
SELECT  [loan_skey]      
  FROM [ReverseQuest].[rms].[v_WorkflowInstance] a 
  join ReverseQuest.rms.v_WorkflowTaskActivity  b on a.workflow_instance_skey=b.workflow_instance_skey 
where workflow_type_description like 'Due & Payable w/ HUD Approval' and a.status_description='Active' and 
    b.workflow_task_description like 'Request to Rescind D&P'  and b.status_description='Active');

delete from #finalDefault where LOANSKEY in(
SELECT  [loan_skey]      
  FROM [ReverseQuest].[rms].[v_WorkflowInstance] a 
  join ReverseQuest.rms.v_WorkflowTaskActivity  b on a.workflow_instance_skey=b.workflow_instance_skey 
  where workflow_type_description = 'Foreclosure - Judicial' and a.status_description='Active'
  and b.workflow_task_description = 'Send Rescission Request to HUD' and b.status_description='Active');
  
  delete from #finalDefault where LOANSKEY in(
  SELECT  [loan_skey]      
  FROM [ReverseQuest].[rms].[v_WorkflowInstance] a 
  join ReverseQuest.rms.v_WorkflowTaskActivity  b on a.workflow_instance_skey=b.workflow_instance_skey 
  where  workflow_type_description like 'Foreclosure - Non Judicial' and a.status_description='Active'
  and b.workflow_task_description = 'Send Rescission Request to HUD' and b.status_description='Active');

----------------------------------------------------
--update #finalDefault set [HOMEPHONE1]='',[CELLPHONE1]='' where [CONTACTTYPE1] = 'Attorney';

--select * from #finalDefault where LOANSKEY = '1300';

IF OBJECT_ID('tempdb..#tmpContacts') IS NOT NULL
    DROP TABLE #tmpContacts;
select distinct loan_skey,loan_sub_status,investor_name,CONTACTTYPE1,CONTACTFIRSTNAME1,CONTACTLASTNAME1,HOMEPHONE1,CELLPHONE1,MAILINGSTATE,MAILINGZIP,Priority
into #tmpContacts
from #rtemp;
--where loan_skey = '211792'
--group by loan_skey,loan_sub_status,investor_name,CONTACTTYPE,CONTACTFIRSTNAME
--select *from #tmpContacts where loan_skey=24490;
--select *from #rtemp where loan_skey=123516;

delete a from #tmpContacts a
join #finalDefault b on a.loan_skey=b.LOANSKEY and a.CONTACTTYPE1=b.CONTACTTYPE1 and a.CONTACTFIRSTNAME1=b.CONTACTFIRSTNAME1 and a.CONTACTLASTNAME1=b.CONTACTLASTNAME1;


--select * from #finalDefault where LOANSKEY=24490;
--order by loan_skey
--where loan_skey = '1300';

update a set a.CONTACTTYPE2 = b.CONTACTTYPE1,
a.CONTACTFIRSTNAME2=b.CONTACTFIRSTNAME1,
a.CONTACTLASTNAME2=b.CONTACTLASTNAME1,
a.HOMEPHONE2 = b.HOMEPHONE1,
a.CELLPHONE2=b.CELLPHONE1,
a.MAILINGSTATE2=b.MAILINGSTATE,
a.MAILINGZIP2=b.MAILINGZIP
from #finalDefault a
join
(select loan_skey,CONTACTTYPE1,CONTACTFIRSTNAME1,CONTACTLASTNAME1,HOMEPHONE1,CELLPHONE1,MAILINGSTATE,MAILINGZIP,priority
from (select loan_skey,CONTACTTYPE1,CONTACTFIRSTNAME1,CONTACTLASTNAME1,HOMEPHONE1,CELLPHONE1,MAILINGSTATE,MAILINGZIP,priority,
row_number() over(partition by loan_skey order by priority) as crn
from #tmpContacts) T where crn=1
) b
on a.LOANSKEY=b.loan_skey;



delete a from #tmpContacts a
join #finalDefault b on a.loan_skey=b.LOANSKEY and a.CONTACTTYPE1=b.CONTACTTYPE2 and a.CONTACTFIRSTNAME1=b.CONTACTFIRSTNAME2 and a.CONTACTLASTNAME1=b.CONTACTLASTNAME2;

update a set a.CONTACTTYPE3 = b.CONTACTTYPE1,
a.CONTACTFIRSTNAME3=b.CONTACTFIRSTNAME1,
a.CONTACTLASTNAME3=b.CONTACTLASTNAME1,
a.HOMEPHONE3 = b.HOMEPHONE1,
a.CELLPHONE3=b.CELLPHONE1,
a.MAILINGSTATE3=b.MAILINGSTATE,
a.MAILINGZIP3=b.MAILINGZIP
from #finalDefault a
join
(select loan_skey,CONTACTTYPE1,CONTACTFIRSTNAME1,CONTACTLASTNAME1,HOMEPHONE1,CELLPHONE1,MAILINGSTATE,MAILINGZIP,priority
from (select loan_skey,CONTACTTYPE1,CONTACTFIRSTNAME1,CONTACTLASTNAME1,HOMEPHONE1,CELLPHONE1,MAILINGSTATE,MAILINGZIP,priority,
row_number() over(partition by loan_skey order by priority) as crn
from #tmpContacts) T where crn=1
) b
on a.LOANSKEY=b.loan_skey;


delete a from #tmpContacts a
join #finalDefault b on a.loan_skey=b.LOANSKEY and a.CONTACTTYPE1=b.CONTACTTYPE3 and a.CONTACTFIRSTNAME1=b.CONTACTFIRSTNAME3 and a.CONTACTLASTNAME1=b.CONTACTLASTNAME3;

update a set a.CONTACTTYPE4 = b.CONTACTTYPE1,
a.CONTACTFIRSTNAME4=b.CONTACTFIRSTNAME1,
a.CONTACTLASTNAME4=b.CONTACTLASTNAME1,
a.HOMEPHONE4 = b.HOMEPHONE1,
a.CELLPHONE4=b.CELLPHONE1,
a.MAILINGSTATE4=b.MAILINGSTATE,
a.MAILINGZIP4=b.MAILINGZIP
from #finalDefault a
join
(select loan_skey,CONTACTTYPE1,CONTACTFIRSTNAME1,CONTACTLASTNAME1,HOMEPHONE1,CELLPHONE1,MAILINGSTATE,MAILINGZIP,priority
from (select loan_skey,CONTACTTYPE1,CONTACTFIRSTNAME1,CONTACTLASTNAME1,HOMEPHONE1,CELLPHONE1,MAILINGSTATE,MAILINGZIP,priority,
row_number() over(partition by loan_skey order by priority) as crn
from #tmpContacts) T where crn=1
) b
on a.LOANSKEY=b.loan_skey;

--select TOP 100 * from #finalDefault  where LOANSKEY=123516;

update #finalDefault 
set 
INVESTORNAME=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(INVESTORNAME, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTTYPE1= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTTYPE1, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTFIRSTNAME1= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTFIRSTNAME1, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTLASTNAME1= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTLASTNAME1, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
PROPERTYADDRESS1= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(PROPERTYADDRESS1, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
PROPERTYADDRESS2 = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(PROPERTYADDRESS2, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
PROPERTYCITY= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(PROPERTYCITY, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
MAILINGADDRESS1 = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(MAILINGADDRESS1, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
MAILINGADDRESS2= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(MAILINGADDRESS2, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
LOANSUBSTATUS= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOANSUBSTATUS,'&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
PROPERTYSTATE= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(PROPERTYSTATE, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
PROPERTYZIP=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(PROPERTYZIP, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
MAILINGCITY =REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(MAILINGCITY, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTTYPE2= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTTYPE2, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTFIRSTNAME2= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTFIRSTNAME2, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTLASTNAME2 =REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTLASTNAME2, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTTYPE3= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTTYPE3, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTFIRSTNAME3=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTFIRSTNAME3, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTLASTNAME3=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTLASTNAME3, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTTYPE4=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTTYPE4, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTFIRSTNAME4=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTFIRSTNAME4, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿',''),
CONTACTLASTNAME4=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTLASTNAME4, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿','');

--select * from #finalDefault where LOANSKEY = '226';
IF OBJECT_ID('tempdb..#tmpLoankey_1_10_23') IS NOT NULL
    DROP TABLE #tmpLoankey_1_10_23;
select * 
into #tmpLoankey_1_10_23
from
(

select 254334 as Loan_skey 


)X 

--select Loan_skey from #tmpLoankey_1_10_23
--------------------------------IBOB Priority------------------------------------------
/*IF OBJECT_ID('tempdb..#rtemp10') IS NOT NULL
    DROP TABLE #rtemp10;
select loan_skey,max(IBOB) as 'IBOB'
into #rtemp10
from(
select f.loan_skey
,f.note_type_description  'note'
,max (f.created_date) 'IBOB'
from 
[ReverseQuest].[rms].[v_Note]  f
where 
f.note_type_description like '%Incom%'
or f.note_type_description like 'Spoc Incom%' 
or f.note_type_description like '%Outgoing%' 
or f.note_type_description like 'Spoc Outgoing%'
group by f.loan_skey,f.note_type_description) a
group by a.loan_skey;
*/
--select * from  #rtemp11 where loan_skey=263951;
IF OBJECT_ID('tempdb..#rtemp11') IS NOT NULL
    DROP TABLE #rtemp11;
select a1.*,
case when CAST (a1.[TOTAL Calls] as int)=0 then 1 
  when CAST (a1.[TOTAL Calls] as int)=1 then 2
   when CAST (a1.[TOTAL Calls] as int)=2 then 3
    when CAST (a1.[TOTAL Calls] as int)>=3 then 4 end as 'PRIORITY'
	into #rtemp11
from
(select a.LOANSKEY,
/*CAST ((select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.LOANSKEY and( note_type_description like '%Incom%'  or  note_type_description like 'Spoc Incom%')
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 25, GETDATE()), 0)) AS INT) as 'Inbound Calls in 25 days',
CAST((select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.LOANSKEY and( note_type_description like 'Spoc Incom%'  or  note_type_description like 'Spoc Incom%')
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 25, GETDATE()), 0)) AS INT) as 'Spoc Inbound Calls in 25 days',*/
CAST((select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.LOANSKEY and( note_type_description like '%Outgoing%'  
 -- or  note_type_description like 'Spoc Incom%'
  )
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 25, GETDATE()), 0))AS INT) as 'Outbound Calls in 25 days',
CAST((select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.LOANSKEY and( note_type_description like 'Spoc Outgoing%' 
--  or  note_type_description like 'Spoc Incom%'
  )
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 25, GETDATE()), 0))AS INT) as 'Spoc Outbound Calls in 25 days',
Convert(int,/*(select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.LOANSKEY and( note_type_description like '%Incom%'  or  note_type_description like 'Spoc Incom%')
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 25, GETDATE()), 0)) +
(select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.LOANSKEY and( note_type_description like 'Spoc Incom%'  or  note_type_description like 'Spoc Incom%')
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 25, GETDATE()), 0))+*/
(select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.LOANSKEY and( note_type_description like '%Outgoing%'  
 -- or  note_type_description like 'Spoc Incom%'
  )
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 25, GETDATE()), 0)) +
(select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.LOANSKEY and( note_type_description like 'Spoc Outgoing%'  
 -- or  note_type_description like 'Spoc Incom%'
  )
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 25, GETDATE()), 0)) ) 'TOTAL Calls'
  from #finalDefault a) a1
  order by [TOTAL Calls]

    --select * from #rtemp11 order by PRIORITY

  -----------------------1. HRDHOBR------------------------
IF OBJECT_ID('tempdb..#HRDHOBR') IS NOT NULL
    DROP TABLE #HRDHOBR;

select x.LOANSKEY,x.LOANSUBSTATUS,x.INVESTORNAME,x.CONTACTTYPE1,x.CONTACTFIRSTNAME1,x.CONTACTLASTNAME1,x.PROPERTYADDRESS1
,x.PROPERTYADDRESS2,x.PROPERTYCITY,x.PROPERTYSTATE,x.PROPERTYZIP,x.MAILINGADDRESS1,x.MAILINGADDRESS2
,x.MAILINGCITY,x.MAILINGSTATE,x.MAILINGZIP,x.HOMEPHONE1,x.CELLPHONE1
,x.CONTACTTYPE2,x.CONTACTFIRSTNAME2,x.CONTACTLASTNAME2,x.HOMEPHONE2,x.CELLPHONE2
,x.CONTACTTYPE3,x.CONTACTFIRSTNAME3,x.CONTACTLASTNAME3,x.HOMEPHONE3,x.CELLPHONE3
,x.CONTACTTYPE4,x.CONTACTFIRSTNAME4,x.CONTACTLASTNAME4,x.HOMEPHONE4,x.CELLPHONE4
--,b.workflow_task_description
--,status_description,b.complete_date
,'CA WA NV Homeowners Borrower Rights' as 'CALLREASON',x.[CALLLIST]
,x.MAILINGSTATE2,x.MAILINGZIP2,x.MAILINGSTATE3,x.MAILINGZIP3,x.MAILINGSTATE4,x.MAILINGZIP4
into #HRDHOBR
from #finalDefault x
join
(select b.loan_skey,a.workflow_task_description
--,a.status_description,a.complete_date
  --,a.workflow_instance_skey,a.complete_date
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a join [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
  where a.workflow_task_description in ( '1st Call Attempt - HBOR Call Campaign'
,'2nd Call Attempt - HBOR Call Campaign'
,'3rd Call Attempt - HBOR Call Campaign'
)
and b.status_description ='Active' and a.status_description ='Active'
and a.complete_date is null) b
on x.LOANSKEY =b.loan_skey;


IF OBJECT_ID('tempdb..#HRDHOBR1') IS NOT NULL
    DROP TABLE #HRDHOBR1;
select distinct a.* 
into #HRDHOBR1
from #HRDHOBR a
union
(
select x.LOANSKEY,x.LOANSUBSTATUS,x.INVESTORNAME,x.CONTACTTYPE1,x.CONTACTFIRSTNAME1,x.CONTACTLASTNAME1,x.PROPERTYADDRESS1
,x.PROPERTYADDRESS2,x.PROPERTYCITY,x.PROPERTYSTATE,x.PROPERTYZIP,x.MAILINGADDRESS1,x.MAILINGADDRESS2
,x.MAILINGCITY,x.MAILINGSTATE,x.MAILINGZIP,x.HOMEPHONE1,x.CELLPHONE1
,x.CONTACTTYPE2,x.CONTACTFIRSTNAME2,x.CONTACTLASTNAME2,x.HOMEPHONE2,x.CELLPHONE2
,x.CONTACTTYPE3,x.CONTACTFIRSTNAME3,x.CONTACTLASTNAME3,x.HOMEPHONE3,x.CELLPHONE3
,x.CONTACTTYPE4,x.CONTACTFIRSTNAME4,x.CONTACTLASTNAME4,x.HOMEPHONE4,x.CELLPHONE4
,'CA WA NV Homeowners Borrower Rights' as 'CALLREASON',x.[CALLLIST],
x.MAILINGSTATE2,x.MAILINGZIP2,x.MAILINGSTATE3,x.MAILINGZIP3,x.MAILINGSTATE4,x.MAILINGZIP4
from #finalDefault x where LOANSKEY in(
  select loan_skey from [ReverseQuest].[rms].[v_Note] 
  where note_type_description in ('Call Request - CA','Call Request - WA','Call Request - NV')
  and created_date > Convert(date, getdate()-1) and  created_date < Convert(date, getdate())
  )
 )

 
IF OBJECT_ID('tempdb..#HRDHOBROBattempt') IS NOT NULL
    DROP TABLE #HRDHOBROBattempt;
 select 
 a.loan_skey,a.loan_status_description
 ,b.notetext_date as '1st OB Attempt',b.Shift as '1st OB Shift'
 ,c.notetext_date as '2nd OB Attempt',c.Shift as '2nd OB Shift'
 ,d.notetext_date as '3rd OB Attempt',d.Shift as '3rd OB Shift'
 into #HRDHOBROBattempt
 from [ReverseQuest].[rms].[v_LoanMaster] a
 left join (
select * from (
select
loan_skey
--,note_skey,note_type_skey
--,note_type_description,
--note_text,
,notetext_date
,convert(date,notetext_date) as to_date
,rn
,case when  DATEPART(HOUR,notetext_date) < 8 THEN 'NO SHIFT'
      WHEN  DATEPART(HOUR,notetext_date) >=8 AND  DATEPART(HOUR,notetext_date) < 12 THEN 'MORNING'
      WHEN  DATEPART(HOUR,notetext_date) >=12 AND DATEPART(HOUR,notetext_date) < 16 THEN 'NOON'
      WHEN  DATEPART(HOUR,notetext_date) >=16 AND DATEPART(HOUR,notetext_date) < 19 THEN 'EVENING'
      else 'NO SHIFT'
end as 'Shift',
ROW_NUMBER() over (PARTITION by loan_skey order by notetext_date desc) sn
from(
select loan_skey
--,note_type_description,note_text
,(CONVERT(varchar, CONVERT(datetime, replace(replace(rtrim(ltrim(substring(note_text,CHARINDEX('I_', note_text)+2,28))),'.',':'),'000000','00')),21))  as notetext_date
--,max(created_date)
,DENSE_RANK() OVER (PARTITION BY loan_skey  ORDER BY (CONVERT(date, CONVERT(datetime, replace(replace(rtrim(ltrim(substring(note_text,CHARINDEX('I_', note_text)+2,28))),'.',':'),'000000','00')))) desc) rn
from [ReverseQuest].[rms].[v_Note] 
where 
--loan_skey=1930 and 
created_date  >=    DATEADD(DAY, DATEDIFF(DAY, 140, getdate()), 0) and 
 note_type_description='SPOC Outgoing Dialer'
and note_text  like 'OB_REV_%'
and note_text not like '%HCI__Invalid Phone Number%'
and note_text not like '%MANUAL_%'
) a where rn=1
) b where sn=1
) b on a.loan_skey=b.loan_skey
left  join (
select * from (
select
loan_skey
--,note_skey,note_type_skey
--,note_type_description,
--note_text,
,notetext_date
,convert(date,notetext_date) as to_date
,rn
,case when  DATEPART(HOUR,notetext_date) < 8 THEN 'NO SHIFT'
      WHEN  DATEPART(HOUR,notetext_date) >=8 AND  DATEPART(HOUR,notetext_date) < 12 THEN 'MORNING'
      WHEN  DATEPART(HOUR,notetext_date) >=12 AND DATEPART(HOUR,notetext_date) < 16 THEN 'NOON'
      WHEN  DATEPART(HOUR,notetext_date) >=16 AND DATEPART(HOUR,notetext_date) < 19 THEN 'EVENING'
      else 'NO SHIFT'
end as 'Shift',
ROW_NUMBER() over (PARTITION by loan_skey order by notetext_date desc) sn
from(
select loan_skey
--,note_type_description,note_text
,(CONVERT(varchar, CONVERT(datetime, replace(replace(rtrim(ltrim(substring(note_text,CHARINDEX('I_', note_text)+2,28))),'.',':'),'000000','00')),21))  as notetext_date
--,max(created_date)
,DENSE_RANK() OVER (PARTITION BY loan_skey  ORDER BY (CONVERT(date, CONVERT(datetime, replace(replace(rtrim(ltrim(substring(note_text,CHARINDEX('I_', note_text)+2,28))),'.',':'),'000000','00')))) desc) rn
from [ReverseQuest].[rms].[v_Note] 
where 
--loan_skey=1930 and 
created_date  >=    DATEADD(DAY, DATEDIFF(DAY, 140, getdate()), 0) and 
 note_type_description='SPOC Outgoing Dialer'
and note_text  like 'OB_REV_%'
and note_text not like '%HCI__Invalid Phone Number%'
and note_text not like '%MANUAL_%'
) a where rn=2
) b where sn=1
) c on a.loan_skey=c.loan_skey
left join (
select * from (
select
loan_skey
--,note_skey,note_type_skey
--,note_type_description,
--note_text,
,notetext_date
,convert(date,notetext_date) as to_date
,rn
,case when  DATEPART(HOUR,notetext_date) < 8 THEN 'NO SHIFT'
      WHEN  DATEPART(HOUR,notetext_date) >=8 AND  DATEPART(HOUR,notetext_date) < 12 THEN 'MORNING'
      WHEN  DATEPART(HOUR,notetext_date) >=12 AND DATEPART(HOUR,notetext_date) < 16 THEN 'NOON'
      WHEN  DATEPART(HOUR,notetext_date) >=16 AND DATEPART(HOUR,notetext_date) < 19 THEN 'EVENING'
      else 'NO SHIFT'
end as 'Shift',
ROW_NUMBER() over (PARTITION by loan_skey order by notetext_date desc) sn
from(
select loan_skey
--,note_type_description,note_text
,(CONVERT(varchar, CONVERT(datetime, replace(replace(rtrim(ltrim(substring(note_text,CHARINDEX('I_', note_text)+2,28))),'.',':'),'000000','00')),21))  as notetext_date
--,max(created_date)
,DENSE_RANK() OVER (PARTITION BY loan_skey  ORDER BY (CONVERT(date, CONVERT(datetime, replace(replace(rtrim(ltrim(substring(note_text,CHARINDEX('I_', note_text)+2,28))),'.',':'),'000000','00')))) desc) rn
from [ReverseQuest].[rms].[v_Note] 
where 
--loan_skey=1930 and 
created_date  >=    DATEADD(DAY, DATEDIFF(DAY, 140, getdate()), 0) and 
 note_type_description='SPOC Outgoing Dialer'
and note_text  like 'OB_REV_%'
and note_text not like '%HCI__Invalid Phone Number%'
and note_text not like '%MANUAL_%'
) a where rn=3
) b where sn=1
) d on a.loan_skey=d.loan_skey
where a.loan_status_description in('DEFAULT','FORECLOSURE')




 select distinct x.*,
--case when c.IBOB is not null then DENSE_RANK() OVER (ORDER BY c.IBOB asc) else 1 end as PRIORITYIBOB  
 case when d.PRIORITY is null then 1 else d.PRIORITY end as 'PRIORITYIBOB'
 ,f.[1st OB Attempt],f.[1st OB Shift],f.[2nd OB Attempt],f.[2nd OB Shift],f.[3rd OB Attempt],f.[3rd OB Shift]
 from #HRDHOBR1 x 
 -- left join #rtemp10 c on x.LOANSKEY=c.loan_skey
   left join #rtemp11 d on x.LOANSKEY=d.LOANSKEY
  left join #HRDHOBROBattempt f on x.LOANSKEY=f.loan_skey
  --order by x.LOANSKEY
 where x.LOANSKEY not in
 (
select loan_skey from #obtemp
union 
select loan_skey from  #ob4temp
union 
select loan_skey from #ob3temp
union select Loan_skey from #tmpLoankey_1_10_23
)order by PRIORITYIBOB asc;


--------------------------------------------2. HRDPendingRQCallRequest---------------------
IF OBJECT_ID('tempdb..#HRDPendingRQCallRequest') IS NOT NULL
    DROP TABLE #HRDPendingRQCallRequest; 
select x.LOANSKEY,x.LOANSUBSTATUS,x.INVESTORNAME,x.CONTACTTYPE1,x.CONTACTFIRSTNAME1,x.CONTACTLASTNAME1,x.PROPERTYADDRESS1
,x.PROPERTYADDRESS2,x.PROPERTYCITY,x.PROPERTYSTATE,x.PROPERTYZIP,x.MAILINGADDRESS1,x.MAILINGADDRESS2
,x.MAILINGCITY,x.MAILINGSTATE,x.MAILINGZIP,x.HOMEPHONE1,x.CELLPHONE1
,x.CONTACTTYPE2,x.CONTACTFIRSTNAME2,x.CONTACTLASTNAME2,x.HOMEPHONE2,x.CELLPHONE2
,x.CONTACTTYPE3,x.CONTACTFIRSTNAME3,x.CONTACTLASTNAME3,x.HOMEPHONE3,x.CELLPHONE3
,x.CONTACTTYPE4,x.CONTACTFIRSTNAME4,x.CONTACTLASTNAME4,x.HOMEPHONE4,x.CELLPHONE4
--,b.created_date
,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(b.note_type_description, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿','') as 'CALLREASON',x.[CALLLIST] 
,x.MAILINGSTATE2,x.MAILINGZIP2,x.MAILINGSTATE3,x.MAILINGZIP3,x.MAILINGSTATE4,x.MAILINGZIP4
into #HRDPendingRQCallRequest
from #finalDefault x
join
(select loan_skey,note_type_description,created_date from [ReverseQuest].[rms].[v_Note] 
where 
--created_date > Convert(date, getdate()-1) and  created_date < Convert(date, getdate())
--created_date between  DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()-3), 0) + '14:01'AND   DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0) + '06:00' -- Monday Morning Call prior day 2pm to current day 6am 
created_date between  DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()-1), 0) + '14:01'AND   DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0) + '06:00' --Morning Call prior day 2pm to current day 6am 
--created_date between  DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0) + '06:01' AND   DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0) + '14:00' --Afternoon Call 6am	current day	to 2pm current day		
) b
on x.LOANSKEY=b.loan_skey
  where b.note_type_description in ('Call Reques - NY 1st Attempt','Call Request - Borrower Intent','Call Request - CA '
  ,'Call Request - Covid Ext.','Call Request - Cust. Follow-Up','Call Request - DIL','Call Request - HAF Calls  ','Call Request - HOA default  '
  ,'Call Request - Mktg. Ext.','Call Request - NBS Follow-Up','Call Request - NV'
  ,'Call Request - NY 2nd Attempt','Call Request - NY 3rd Attempt','Call Request - Property Pres.','Call Request - Repayment Plan'
  ,'Call Request - MAM','Call Request - Seattle Bank','Call Request - Short Sale','Call Request - WA','Call Request-At-Risk Ext.'
  ,'Call Request-BOA Death Notice','Call Request-Conveyed Title','Call Request-FCReferral Review','Call Request-Loss Draft&Repair','Call Request-Tax & Ins Default');
  --and  x.LOANSKEY not in (select loan_skey from  #ob4temp union select loan_skey from #ob3temp)
  ;

  /*select distinct a.* from #HRDPendingRQCallRequest a where
   a.LOANSKEY not in 
(select LOANSKEY from #MAMHRDLossMit
union
select LOANSKEY from #HRDBAML
union
select loan_skey from #obtemp
union 
select loan_skey from  #ob4temp 
union 
select loan_skey from #ob3temp
)

  order by a.LOANSKEY;*/




  -----------------------------
  IF OBJECT_ID('tempdb..#HRDPendingRQCallRequestRollOver') IS NOT NULL
    DROP TABLE #HRDPendingRQCallRequestRollOver; 

  select distinct p.*
  --,q.created_date
  into #HRDPendingRQCallRequestRollOver
  from (
  select x.LOANSKEY,x.LOANSUBSTATUS,x.INVESTORNAME,x.CONTACTTYPE1,x.CONTACTFIRSTNAME1,x.CONTACTLASTNAME1,x.PROPERTYADDRESS1
,x.PROPERTYADDRESS2,x.PROPERTYCITY,x.PROPERTYSTATE,x.PROPERTYZIP,x.MAILINGADDRESS1,x.MAILINGADDRESS2
,x.MAILINGCITY,x.MAILINGSTATE,x.MAILINGZIP,x.HOMEPHONE1,x.CELLPHONE1
,x.CONTACTTYPE2,x.CONTACTFIRSTNAME2,x.CONTACTLASTNAME2,x.HOMEPHONE2,x.CELLPHONE2
,x.CONTACTTYPE3,x.CONTACTFIRSTNAME3,x.CONTACTLASTNAME3,x.HOMEPHONE3,x.CELLPHONE3
,x.CONTACTTYPE4,x.CONTACTFIRSTNAME4,x.CONTACTLASTNAME4,x.HOMEPHONE4,x.CELLPHONE4
,x.MAILINGSTATE2,x.MAILINGZIP2,x.MAILINGSTATE3,x.MAILINGZIP3,x.MAILINGSTATE4,x.MAILINGZIP4
,b.created_date
,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(b.note_type_description, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿','') as 'CALLREASON',x.[CALLLIST] 
from #finalDefault x
join
(select loan_skey,note_type_description,created_date from [ReverseQuest].[rms].[v_Note] ) b
on x.LOANSKEY=b.loan_skey
  where b.note_type_description in ('Call Reques - NY 1st Attempt','Call Request - Borrower Intent','Call Request - CA '
  ,'Call Request - Covid Ext.','Call Request - Cust. Follow-Up','Call Request - DIL ','Call Request - HAF Calls  ','Call Request - HOA default  '
  ,'Call Request - Mktg. Ext.','Call Request - NBS Follow-Up ','Call Request - NV '
  ,'Call Request - NY 2nd Attempt','Call Request - NY 3rd Attempt','Call Request - Property Pres.','Call Request - Repayment Plan '
  ,'Call Request - MAM','Call Request - MAM ','Call Request - Seattle Bank','Call Request - Short Sale','Call Request - WA','Call Request - AT-Risk Ext.','Call Request - BOA Death Notice','Call Request - Conveyed Title','Call Request - FC Referral Review','Call Request - Loss Drafts&Repairs',
  'Call Request - Tax & Ins Default') 
  and  x.LOANSKEY not in (select LOANSKEY from #HRDPendingRQCallRequest)
  ) p
  left join
  (select loan_skey,note_type_description,created_date from [ReverseQuest].[rms].[v_Note]) q
  on p.LOANSKEY=q.loan_skey and (q.note_type_description in ('Outgoing Call -T&I Mitigation','SPOC Outgoing Loss Mit','SPOC Outgoing Dialer','Outgoing Call -Death','SPOC Outgoing Call Insurance',
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
or
note_type_description like '%Incom%' or note_type_description like 'Spoc Incom%'
)
and q.created_date>=p.created_date
where q.created_date is null;

--select * from #HRDPendingRQCallRequestRollOver where LOANSKEY='222710'

select x.*,
--case when c.IBOB is not null then DENSE_RANK() OVER (ORDER BY c.IBOB asc) else 1 end as PRIORITYIBOB 
case when d.PRIORITY is null then 1 else d.PRIORITY end as 'PRIORITYIBOB'
from (
select distinct a.* from #HRDPendingRQCallRequest a
union
select LOANSKEY,LOANSUBSTATUS,INVESTORNAME,CONTACTTYPE1,CONTACTFIRSTNAME1,CONTACTLASTNAME1,PROPERTYADDRESS1
,PROPERTYADDRESS2,PROPERTYCITY,PROPERTYSTATE,PROPERTYZIP,MAILINGADDRESS1,MAILINGADDRESS2,MAILINGCITY,MAILINGSTATE,MAILINGZIP,HOMEPHONE1
,CELLPHONE1,CONTACTTYPE2,CONTACTFIRSTNAME2,CONTACTLASTNAME2,HOMEPHONE2,CELLPHONE2,CONTACTTYPE3,CONTACTFIRSTNAME3,CONTACTLASTNAME3,HOMEPHONE3,CELLPHONE3
,CONTACTTYPE4,CONTACTFIRSTNAME4,CONTACTLASTNAME4,HOMEPHONE4,CELLPHONE4,CALLREASON,[CALLLIST]
,MAILINGSTATE2,MAILINGZIP2,MAILINGSTATE3,MAILINGZIP3,MAILINGSTATE4,MAILINGZIP4
from #HRDPendingRQCallRequestRollOver
 )x
 --left join #rtemp10 c on x.LOANSKEY=c.loan_skey
 left join #rtemp11 d on x.LOANSKEY=d.LOANSKEY
 where
 x.LOANSKEY not in 
(select LOANSKEY from #HRDHOBR1
union
select loan_skey from #obtemp
union 
select loan_skey from  #ob4temp 
union 
select loan_skey from #ob3temp
union select Loan_skey from #tmpLoankey_1_10_23
)
order by PRIORITYIBOB asc
;


-----------------------------3. MAMHRDLossMit----------------------------

IF OBJECT_ID('tempdb..#MAMHRDLossMit') IS NOT NULL
    DROP TABLE #MAMHRDLossMit;

select x.LOANSKEY,x.LOANSUBSTATUS,
 REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(x.INVESTORNAME, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿','') as 'INVESTORNAME'
,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(x.CONTACTTYPE1, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿','') as 'CONTACTTYPE1'
,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(x.CONTACTFIRSTNAME1, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿','')  as 'CONTACTFIRSTNAME1'
,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(x.CONTACTLASTNAME1,'&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿','') as 'CONTACTLASTNAME1'
,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(x.PROPERTYADDRESS1,'&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿','') as 'PROPERTYADDRESS1' 
,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(x.PROPERTYADDRESS2,'&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿','') as 'PROPERTYADDRESS2'
,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(x.PROPERTYCITY,'&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿','') as 'PROPERTYCITY'
,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(x.PROPERTYSTATE,'&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿','') as 'PROPERTYSTATE'
,x.PROPERTYZIP
,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(x.MAILINGADDRESS1,'&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿','') as 'MAILINGADDRESS1'
,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(x.MAILINGADDRESS2,'&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿','') as'MAILINGADDRESS2'
,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(x.MAILINGCITY,'&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿','') as 'MAILINGCITY'
,x.MAILINGSTATE
,x.MAILINGZIP,x.HOMEPHONE1,x.CELLPHONE1
,x.CONTACTTYPE2
,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(x.CONTACTFIRSTNAME2,'&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿','') as 'CONTACTFIRSTNAME2'
,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(x.CONTACTLASTNAME2,'&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿','')  as 'CONTACTLASTNAME2'
,x.HOMEPHONE2,x.CELLPHONE2
,x.CONTACTTYPE3
,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(x.CONTACTFIRSTNAME3,'&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿','')  as 'CONTACTFIRSTNAME3'
,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(x.CONTACTLASTNAME3,'&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿','')  as 'CONTACTLASTNAME3'
,x.HOMEPHONE3,x.CELLPHONE3
,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(x.CONTACTTYPE4,'&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿','') as 'CONTACTTYPE4'
,x.CONTACTFIRSTNAME4,x.CONTACTLASTNAME4,x.HOMEPHONE4,x.CELLPHONE4
,'MAM SS and DIL Campaign' as 'CALLREASON'
,x.[CALLLIST],x.MAILINGSTATE2,x.MAILINGZIP2,x.MAILINGSTATE3,x.MAILINGZIP3,x.MAILINGSTATE4,x.MAILINGZIP4
into #MAMHRDLossMit
from #finalDefault x
join
[ReverseQuest].[rms].[v_Alert] y
on x.LOANSKEY = y.loan_skey
where y.alert_type_description  in ('Loss Mitigation Pilot Program	')
and y.alert_status_description = 'Active'
and x.LOANSKEY not in 
(select loan_skey from  #ob4temp
union select loan_skey from #ob3temp
union select Loan_skey from #tmpLoankey_1_10_23
)
;

--select * from #MAMHRDLossMit

select distinct a.*
--case when c.IBOB is not null then DENSE_RANK() OVER (ORDER BY c.IBOB asc) else 1 end as PRIORITYIBOB
,case when d.PRIORITY is null then 1 else d.PRIORITY end as 'PRIORITYIBOB'
from #MAMHRDLossMit a
left join #obtemp b on a.LOANSKEY=b.loan_skey
--left join #rtemp10 c on a.LOANSKEY=c.loan_skey
left join #rtemp11 d on a.LOANSKEY=d.LOANSKEY
where a.loanskey  not in 
(select LOANSKEY from #HRDHOBR1
union
select LOANSKEY from #HRDPendingRQCallRequest
union
select LOANSKEY from #HRDPendingRQCallRequestRollOver
union
select loan_skey from #obtemp
union 
select loan_skey from  #ob4temp 
union 
select loan_skey from #ob3temp
union select Loan_skey from #tmpLoankey_1_10_23
)
order by PRIORITYIBOB asc;

----------------------------------4. HRD BAML----------------------------------------

IF OBJECT_ID('tempdb..#HRDBAML') IS NOT NULL
    DROP TABLE #HRDBAML;

select x.LOANSKEY,x.LOANSUBSTATUS,x.INVESTORNAME,x.CONTACTTYPE1,x.CONTACTFIRSTNAME1,x.CONTACTLASTNAME1,x.PROPERTYADDRESS1
,x.PROPERTYADDRESS2,x.PROPERTYCITY,x.PROPERTYSTATE,x.PROPERTYZIP,x.MAILINGADDRESS1,x.MAILINGADDRESS2
,x.MAILINGCITY,x.MAILINGSTATE,x.MAILINGZIP,x.HOMEPHONE1,x.CELLPHONE1
,x.CONTACTTYPE2,x.CONTACTFIRSTNAME2,x.CONTACTLASTNAME2,x.HOMEPHONE2,x.CELLPHONE2
,x.CONTACTTYPE3,x.CONTACTFIRSTNAME3,x.CONTACTLASTNAME3,x.HOMEPHONE3,x.CELLPHONE3
,x.CONTACTTYPE4,x.CONTACTFIRSTNAME4,x.CONTACTLASTNAME4,x.HOMEPHONE4,x.CELLPHONE4
,'BOA Need Death Certificate' as 'CALLREASON',x.[CALLLIST], x.MAILINGSTATE2,x.MAILINGZIP2,x.MAILINGSTATE3,x.MAILINGZIP3,x.MAILINGSTATE4,x.MAILINGZIP4
into #HRDBAML

from #finalDefault x
join
[ReverseQuest].[rms].[v_Alert] y
on x.LOANSKEY = y.loan_skey
where y.alert_type_description  in ('BAML- Death Cert Needed')
and y.alert_status_description = 'Active'
 ;

select distinct a.*,
--case when c.IBOB is not null then DENSE_RANK() OVER (ORDER BY c.IBOB asc) else 1 end as PRIORITYIBOB
case when d.PRIORITY is null then 1 else d.PRIORITY end as 'PRIORITYIBOB'
from #HRDBAML a
--left join #rtemp10 c on a.LOANSKEY=c.loan_skey
left join #rtemp11 d on a.LOANSKEY=d.LOANSKEY
where
a.LOANSKEY not in 
(select LOANSKEY from #HRDHOBR1
union
select LOANSKEY from #HRDPendingRQCallRequest
union
select LOANSKEY from #HRDPendingRQCallRequestRollOver
union
select LOANSKEY from #MAMHRDLossMit
union
select loan_skey from #obtentemp
union 
select loan_skey from  #ob12temp 
union
select loan_skey from #ob11temp
union select Loan_skey from #tmpLoankey_1_10_23
)
order by PRIORITYIBOB asc;


-------------------------------5. PHHLossMit---------------------------------------

IF OBJECT_ID('tempdb..#HRDPHHLossMit') IS NOT NULL
    DROP TABLE #HRDPHHLossMit;

select x.LOANSKEY,x.LOANSUBSTATUS,x.INVESTORNAME,x.CONTACTTYPE1,x.CONTACTFIRSTNAME1,x.CONTACTLASTNAME1,x.PROPERTYADDRESS1
,x.PROPERTYADDRESS2,x.PROPERTYCITY,x.PROPERTYSTATE,x.PROPERTYZIP,x.MAILINGADDRESS1,x.MAILINGADDRESS2
,x.MAILINGCITY,x.MAILINGSTATE,x.MAILINGZIP,x.HOMEPHONE1,x.CELLPHONE1
,x.CONTACTTYPE2,x.CONTACTFIRSTNAME2,x.CONTACTLASTNAME2,x.HOMEPHONE2,x.CELLPHONE2
,x.CONTACTTYPE3,x.CONTACTFIRSTNAME3,x.CONTACTLASTNAME3,x.HOMEPHONE3,x.CELLPHONE3
,x.CONTACTTYPE4,x.CONTACTFIRSTNAME4,x.CONTACTLASTNAME4,x.HOMEPHONE4,x.CELLPHONE4
,'PHH SS and DIL Campaign' as 'CALLREASON',x.[CALLLIST], x.MAILINGSTATE2,x.MAILINGZIP2,x.MAILINGSTATE3,x.MAILINGZIP3,x.MAILINGSTATE4,x.MAILINGZIP4
into #HRDPHHLossMit
from #finalDefault x
join
(select ldi.loan_skey
/*,lm.servicer_name
,lm.loan_status_description
,lm.loan_sub_status_description
,cast(ldi.curtailment_date as date) as 'Curtailment Date'
,ldi.curtailment_reason_description
,lm.loan_pool_long_description*/
from [ReverseQuest].rms.v_LoanDefaultInformation ldi
       left join [ReverseQuest].rms.v_LoanMaster lm on ldi.loan_skey=lm.loan_skey
where lm.servicer_name='PHH Mortgage Corporation'
       and ldi.curtailment_reason_description is not null
       and lm.loan_status_description  in ('DEFAULT', 'FORECLOSURE')
       and ldi.date_foreclosure_sale_held is null
	   union
	   select lm.loan_skey
/*,lm.servicer_name
,lm.loan_status_description
,lm.loan_sub_status_description
,null as 'Curtailment Date'
,'-'as curtailment_reason_description
,lm.loan_pool_long_description*/
from 
        [ReverseQuest].rms.v_LoanMaster lm 
where 
lm.servicer_name like 'PHH Mortgage %'
       --and ldi.curtailment_reason_description is not null
       and lm.loan_status_description  in ('DEFAULT', 'FORECLOSURE')
       --and ldi.date_foreclosure_sale_held is null
	   and lm.loan_pool_long_description = 'Buy Out - LHFS FV'
) y
on x.LOANSKEY=y.loan_skey;


select distinct x.*,
--case when c.IBOB is not null then DENSE_RANK() OVER (ORDER BY c.IBOB asc) else 1 end as PRIORITYIBOB 
case when d.PRIORITY is null then 1 else d.PRIORITY end as 'PRIORITYIBOB'
from #HRDPHHLossMit x
 --left join #rtemp10 c on x.LOANSKEY=c.loan_skey
  left join #rtemp11 d on x.LOANSKEY=d.LOANSKEY
where x.LOANSKEY not in 
(select LOANSKEY from #HRDHOBR1
union
select LOANSKEY from #HRDPendingRQCallRequest
union
select LOANSKEY from #HRDPendingRQCallRequestRollOver
union
select LOANSKEY from #MAMHRDLossMit
union
select LOANSKEY from #HRDBAML
union
select loan_skey from #obtemp
union
select loan_skey from  #ob4temp
union 
select loan_skey from #ob3temp
union select Loan_skey from #tmpLoankey_1_10_23
)order by PRIORITYIBOB asc;





-----------------------------------6. HRD Pending Occ

IF OBJECT_ID('tempdb..#HRDPendingOcc') IS NOT NULL
    DROP TABLE #HRDPendingOcc;
select x.LOANSKEY,x.LOANSUBSTATUS,x.INVESTORNAME,x.CONTACTTYPE1,x.CONTACTFIRSTNAME1,x.CONTACTLASTNAME1,x.PROPERTYADDRESS1
,x.PROPERTYADDRESS2,x.PROPERTYCITY,x.PROPERTYSTATE,x.PROPERTYZIP,x.MAILINGADDRESS1,x.MAILINGADDRESS2
,x.MAILINGCITY,x.MAILINGSTATE,x.MAILINGZIP,x.HOMEPHONE1,x.CELLPHONE1
,x.CONTACTTYPE2,x.CONTACTFIRSTNAME2,x.CONTACTLASTNAME2,x.HOMEPHONE2,x.CELLPHONE2
,x.CONTACTTYPE3,x.CONTACTFIRSTNAME3,x.CONTACTLASTNAME3,x.HOMEPHONE3,x.CELLPHONE3
,x.CONTACTTYPE4,x.CONTACTFIRSTNAME4,x.CONTACTLASTNAME4,x.HOMEPHONE4,x.CELLPHONE4
,'Need Occupancy Certificate' as 'CALLREASON',x.[CALLLIST]
,x.MAILINGSTATE2,x.MAILINGZIP2,x.MAILINGSTATE3,x.MAILINGZIP3,x.MAILINGSTATE4,x.MAILINGZIP4 into #HRDPendingOcc
from #finalDefault x
join
(select b.loan_skey
  --,a.workflow_instance_skey,a.complete_date
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a join [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
  where a.workflow_task_description in ( 'Call Attempt - Borrower/CoBorrower'
,'2nd Call Attempt - Borrower/CoBorrower'
,'Final Call Attempt - Borrower/CoBorrower'
,'Call Attempt - Invalid Occupancy Certificate '
,'Task Call to CS to confirm borrower has returned.',
'Call Attempt - Eligible Non-Borrowing Spouse'
,'Call Attempt - Invalid eNBS Occupancy Certificate ')
and a.status_description = 'Active' and b.status_description = 'Active'
and a.complete_date is null) b
on x.LOANSKEY=b.loan_skey

union


(
select m.* from(
select x.LOANSKEY,x.LOANSUBSTATUS,x.INVESTORNAME
,x.CONTACTTYPE1 ,x.CONTACTFIRSTNAME1,x.CONTACTLASTNAME1
,x.PROPERTYADDRESS1,x.PROPERTYADDRESS2, x.PROPERTYCITY,
x.PROPERTYSTATE,x.PROPERTYZIP,x.MAILINGADDRESS1
,x.MAILINGADDRESS2,x.MAILINGCITY,x.MAILINGSTATE,
x.MAILINGZIP,x.HOMEPHONE1,x.CELLPHONE1,
x.CONTACTTYPE2,x.CONTACTFIRSTNAME2,x.CONTACTLASTNAME2,x.HOMEPHONE2,x.CELLPHONE2
,x.CONTACTTYPE3,x.CONTACTFIRSTNAME3,x.CONTACTLASTNAME3,x.HOMEPHONE3,x.CELLPHONE3
,x.CONTACTTYPE4,x.CONTACTFIRSTNAME4,x.CONTACTLASTNAME4,x.HOMEPHONE4,x.CELLPHONE4,
'Need Occupancy Certificate' as 'CALLREASON',x.[CALLLIST]
,x.MAILINGSTATE2,x.MAILINGZIP2,x.MAILINGSTATE3,x.MAILINGZIP3,x.MAILINGSTATE4,x.MAILINGZIP4
--,b.due_date,b.complete_date,b.workflow_task_description
from #finalDefault x
join
(select b.loan_skey
  --,a.workflow_instance_skey,a.complete_date
  ,b.status_description,a.due_date,a.complete_date,a.workflow_task_description
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a join [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
  where a.workflow_task_description in ('Receipt of Annual Occupancy Certification Letter' )
and a.status_description = ('Active')
and a.complete_date is null
and b.status_description in ('Active')
) b
on x.LOANSKEY=b.loan_skey
) m 

join

(
select x.LOANSKEY ,x.LOANSUBSTATUS,x.INVESTORNAME
,x.CONTACTTYPE1,x.CONTACTFIRSTNAME1,x.CONTACTLASTNAME1
,x.PROPERTYADDRESS1,x.PROPERTYADDRESS2, x.PROPERTYCITY,
x.PROPERTYSTATE,x.PROPERTYZIP,x.MAILINGADDRESS1
,x.MAILINGADDRESS2,x.MAILINGCITY,x.MAILINGSTATE,
x.MAILINGZIP,x.HOMEPHONE1,x.CELLPHONE1,
x.CONTACTTYPE2,x.CONTACTFIRSTNAME2,x.CONTACTLASTNAME2,x.HOMEPHONE2,x.CELLPHONE2
,x.CONTACTTYPE3,x.CONTACTFIRSTNAME3,x.CONTACTLASTNAME3,x.HOMEPHONE3,x.CELLPHONE3
,x.CONTACTTYPE4,x.CONTACTFIRSTNAME4,x.CONTACTLASTNAME4,x.HOMEPHONE4,x.CELLPHONE4,
'Need Occupancy Certificate' as 'CALLREASON',x.[CALLLIST]
,x.MAILINGSTATE2,x.MAILINGZIP2,x.MAILINGSTATE3,x.MAILINGZIP3,x.MAILINGSTATE4,x.MAILINGZIP4
--,b.due_date,b.complete_date,b.workflow_task_description
from #finalDefault x
join
(select b.loan_skey
  --,a.workflow_instance_skey,a.complete_date
  ,b.status_description,a.due_date,a.complete_date,a.workflow_task_description
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a join [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
  where a.workflow_task_description in ('Closing Date Anniversary')
  and a.due_date =  DATEADD(DAY, DATEDIFF(DAY, -15, GETDATE()), 0)
and a.status_description = ('Active')
and a.complete_date is null
and b.status_description in ('Active')
) b
on x.LOANSKEY=b.loan_skey

union

select x.LOANSKEY,x.LOANSUBSTATUS,x.INVESTORNAME
,x.CONTACTTYPE1,x.CONTACTFIRSTNAME1,x.CONTACTLASTNAME1
,x.PROPERTYADDRESS1,x.PROPERTYADDRESS2, x.PROPERTYCITY,
x.PROPERTYSTATE,x.PROPERTYZIP,x.MAILINGADDRESS1
,x.MAILINGADDRESS2,x.MAILINGCITY,x.MAILINGSTATE,
x.MAILINGZIP,x.HOMEPHONE1,x.CELLPHONE1,
x.CONTACTTYPE2,x.CONTACTFIRSTNAME2,x.CONTACTLASTNAME2,x.HOMEPHONE2,x.CELLPHONE2
,x.CONTACTTYPE3,x.CONTACTFIRSTNAME3,x.CONTACTLASTNAME3,x.HOMEPHONE3,x.CELLPHONE3
,x.CONTACTTYPE4,x.CONTACTFIRSTNAME4,x.CONTACTLASTNAME4,x.HOMEPHONE4,x.CELLPHONE4,
'Need Occupancy Certificate' as 'CALLREASON',x.[CALLLIST]
,x.MAILINGSTATE2,x.MAILINGZIP2,x.MAILINGSTATE3,x.MAILINGZIP3,x.MAILINGSTATE4,x.MAILINGZIP4
--,b.due_date,b.complete_date,b.workflow_task_description
from #finalDefault x
join
(select b.loan_skey
  --,a.workflow_instance_skey,a.complete_date
  ,b.status_description,a.due_date,a.complete_date,a.workflow_task_description
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a join [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
  where a.workflow_task_description in ('Closing Date Anniversary')
  and a.due_date =    DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)
and a.status_description = ('Active')
and a.complete_date is null
and b.status_description in ('Active')
) b
on x.LOANSKEY=b.loan_skey
) p
on m.LOANSKEY=p.LOANSKEY
);

-----------------------


/*select distinct a.* from #HRDPendingOcc a
where
   a.LOANSKEY not in 
(select LOANSKEY from #MAMHRDLossMit
union
select LOANSKEY from #HRDBAML
union 
select LOANSKEY from #HRDHOBR1
union
select LOANSKEY from #HRDPendingRQCallRequest
union
select loan_skey from #obtemp
union 
select loan_skey from  #ob4temp
union 
select loan_skey from #ob3temp
);*/

---------------------------------------------------------------------------------

IF OBJECT_ID('tempdb..#HRDPendingOccRollOver') IS NOT NULL
    DROP TABLE #HRDPendingOccRollOver;
select * 
into #HRDPendingOccRollOver
from  (
select x.LOANSKEY ,x.LOANSUBSTATUS,x.INVESTORNAME
,x.CONTACTTYPE1,x.CONTACTFIRSTNAME1,x.CONTACTLASTNAME1
,x.PROPERTYADDRESS1,x.PROPERTYADDRESS2, x.PROPERTYCITY,
x.PROPERTYSTATE,x.PROPERTYZIP,x.MAILINGADDRESS1
,x.MAILINGADDRESS2,x.MAILINGCITY,x.MAILINGSTATE,
x.MAILINGZIP,x.HOMEPHONE1,x.CELLPHONE1,
x.CONTACTTYPE2,x.CONTACTFIRSTNAME2,x.CONTACTLASTNAME2,x.HOMEPHONE2,x.CELLPHONE2
,x.CONTACTTYPE3,x.CONTACTFIRSTNAME3,x.CONTACTLASTNAME3,x.HOMEPHONE3,x.CELLPHONE3
,x.CONTACTTYPE4,x.CONTACTFIRSTNAME4,x.CONTACTLASTNAME4,x.HOMEPHONE4,x.CELLPHONE4,
'Need Occupancy Certificate' as 'CALLREASON',x.[CALLLIST],
x.MAILINGSTATE2,x.MAILINGZIP2,x.MAILINGSTATE3,x.MAILINGZIP3,x.MAILINGSTATE4,x.MAILINGZIP4
--,b.due_date,b.complete_date,b.workflow_task_description
,b.due_date
from #finalDefault x
join
(select b.loan_skey
  --,a.workflow_instance_skey,a.complete_date
  ,b.status_description,a.due_date,a.complete_date,a.workflow_task_description
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a join [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
  where a.workflow_task_description in ('Closing Date Anniversary')
and a.status_description = ('Active')
and a.complete_date is null
--and b.loan_skey=210799
and b.status_description in ('Active')
) b
on x.LOANSKEY=b.loan_skey
--where x.LOANSKEY=210799
) p;

--select * from #HRDPendingOccRollOver order by LOANSKEY;

select a.*,
--case when c.IBOB is not null then DENSE_RANK() OVER (ORDER BY c.IBOB asc) else 1 end as PRIORITYIBOB  
 case when d.PRIORITY is null then 1 else d.PRIORITY end as 'PRIORITYIBOB'
from(
select distinct * from #HRDPendingOcc 

union

select distinct
p.LOANSKEY ,p.LOANSUBSTATUS,p.INVESTORNAME
,p.CONTACTTYPE1,p.CONTACTFIRSTNAME1,p.CONTACTLASTNAME1
,p.PROPERTYADDRESS1,p.PROPERTYADDRESS2, p.PROPERTYCITY,
p.PROPERTYSTATE,p.PROPERTYZIP,p.MAILINGADDRESS1
,p.MAILINGADDRESS2,p.MAILINGCITY,p.MAILINGSTATE,
p.MAILINGZIP,p.HOMEPHONE1,p.CELLPHONE1,
p.CONTACTTYPE2,p.CONTACTFIRSTNAME2,p.CONTACTLASTNAME2,p.HOMEPHONE2,p.CELLPHONE2
,p.CONTACTTYPE3,p.CONTACTFIRSTNAME3,p.CONTACTLASTNAME3,p.HOMEPHONE3,p.CELLPHONE3
,p.CONTACTTYPE4,p.CONTACTFIRSTNAME4,p.CONTACTLASTNAME4,p.HOMEPHONE4,p.CELLPHONE4,
'Need Occupancy Certificate' as 'CALLREASON',p.[CALLLIST]
,p.MAILINGSTATE2,p.MAILINGZIP2,p.MAILINGSTATE3,p.MAILINGZIP3,p.MAILINGSTATE4,p.MAILINGZIP4
--,p.due_date,q.note_type_description,q.created_date
from #HRDPendingOccRollOver p
left join
  (select loan_skey,note_type_description,created_date from [ReverseQuest].[rms].[v_Note]
  where note_type_description  in ('Outgoing Call -T&I Mitigation','SPOC Outgoing Loss Mit','SPOC Outgoing Dialer','Outgoing Call -Death','SPOC Outgoing Call Insurance',
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
or (note_type_description like '%Incom%' or note_type_description like 'Spoc Incom%') 
  )q
	on (p.LOANSKEY=q.loan_skey  and q.created_date >dateadd(day,-15,p.due_date))
	where q.created_date is  null
	) a
	--left join #rtemp10 c on a.LOANSKEY=c.loan_skey
	 left join #rtemp11 d on a.LOANSKEY=d.LOANSKEY
	where
   a.LOANSKEY not in 
(select LOANSKEY from #HRDHOBR1
union
select LOANSKEY from #HRDPendingRQCallRequest
union
select LOANSKEY from #HRDPendingRQCallRequestRollOver
union
select LOANSKEY from #MAMHRDLossMit
union
select LOANSKEY from #HRDBAML
union
select LOANSKEY from #HRDPHHLossMit
union
select loan_skey from #obtemp
union 
select loan_skey from  #ob4temp
union 
select loan_skey from #ob3temp
union select Loan_skey from #tmpLoankey_1_10_23
)order by PRIORITYIBOB asc;


--------------------7. HRDPending RPP----------------------------
IF OBJECT_ID('tempdb..#HRDPendingRPP') IS NOT NULL
    DROP TABLE #HRDPendingRPP;
select x.LOANSKEY,x.LOANSUBSTATUS,x.INVESTORNAME,x.CONTACTTYPE1,x.CONTACTFIRSTNAME1,x.CONTACTLASTNAME1,x.PROPERTYADDRESS1
,x.PROPERTYADDRESS2,x.PROPERTYCITY,x.PROPERTYSTATE,x.PROPERTYZIP,x.MAILINGADDRESS1,x.MAILINGADDRESS2
,x.MAILINGCITY,x.MAILINGSTATE,x.MAILINGZIP,x.HOMEPHONE1,x.CELLPHONE1
,x.CONTACTTYPE2,x.CONTACTFIRSTNAME2,x.CONTACTLASTNAME2,x.HOMEPHONE2,x.CELLPHONE2
,x.CONTACTTYPE3,x.CONTACTFIRSTNAME3,x.CONTACTLASTNAME3,x.HOMEPHONE3,x.CELLPHONE3
,x.CONTACTTYPE4,x.CONTACTFIRSTNAME4,x.CONTACTLASTNAME4,x.HOMEPHONE4,x.CELLPHONE4
,'Repayment Plan Follow Up' as 'CALLREASON',x.[CALLLIST]
,x.MAILINGSTATE2,x.MAILINGZIP2,x.MAILINGSTATE3,x.MAILINGZIP3,x.MAILINGSTATE4,x.MAILINGZIP4
into #HRDPendingRPP
from #finalDefault x
join
(select b.loan_skey
  --,a.workflow_instance_skey,a.complete_date
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a join [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
  where a.workflow_task_description in ( 'Notify Borrower of Approved Repayment Plan'
,'Missed Payment - 1st Call'
,'Missed Payment - 2nd Call'
,'Unreturned Signed Agreement - 1st Call'
,'Unreturned Signed Agreement - 2nd Call')
and a.status_description ='Active' and b.status_description = 'Active'
and a.complete_date is null) b
on x.LOANSKEY=b.loan_skey;

IF OBJECT_ID('tempdb..#HRDPendingRPP1') IS NOT NULL
    DROP TABLE #HRDPendingRPP1;
select distinct x.LOANSKEY,x.LOANSUBSTATUS,x.INVESTORNAME,x.CONTACTTYPE1,x.CONTACTFIRSTNAME1,x.CONTACTLASTNAME1,x.PROPERTYADDRESS1
,x.PROPERTYADDRESS2,x.PROPERTYCITY,x.PROPERTYSTATE,x.PROPERTYZIP,x.MAILINGADDRESS1,x.MAILINGADDRESS2
,x.MAILINGCITY,x.MAILINGSTATE,x.MAILINGZIP,x.HOMEPHONE1,x.CELLPHONE1
,x.CONTACTTYPE2,x.CONTACTFIRSTNAME2,x.CONTACTLASTNAME2,x.HOMEPHONE2,x.CELLPHONE2
,x.CONTACTTYPE3,x.CONTACTFIRSTNAME3,x.CONTACTLASTNAME3,x.HOMEPHONE3,x.CELLPHONE3
,x.CONTACTTYPE4,x.CONTACTFIRSTNAME4,x.CONTACTLASTNAME4,x.HOMEPHONE4,x.CELLPHONE4
,x.CALLREASON,x.[CALLLIST],x.MAILINGSTATE2,x.MAILINGZIP2,x.MAILINGSTATE3,x.MAILINGZIP3,x.MAILINGSTATE4,x.MAILINGZIP4 into #HRDPendingRPP1
from #HRDPendingRPP x;

select distinct x.*,
--case when c.IBOB is not null then DENSE_RANK() OVER (ORDER BY c.IBOB asc) else 1 end as PRIORITYIBOB
 case when d.PRIORITY is null then 1 else d.PRIORITY end as 'PRIORITYIBOB'
from #HRDPendingRPP1 x
--left join #rtemp10 c on x.LOANSKEY=c.loan_skey
left join #rtemp11 d on x.LOANSKEY=d.LOANSKEY
where x.LOANSKEY not in 
(select LOANSKEY from #HRDHOBR1
union
select LOANSKEY from #HRDPendingRQCallRequest
union
select LOANSKEY from #HRDPendingRQCallRequestRollOver
union
select LOANSKEY from #MAMHRDLossMit
union
select LOANSKEY from #HRDBAML
union
select LOANSKEY from #HRDPHHLossMit
union
select LOANSKEY from #HRDPendingOcc
union
select loan_skey from #obtemp
union 
select loan_skey from  #ob4temp
union 
select loan_skey from #ob3temp
union select Loan_skey from #tmpLoankey_1_10_23
)order by PRIORITYIBOB asc; 


------------------------8.HRDPendingCFW
IF OBJECT_ID('tempdb..#HRDPendingCFW') IS NOT NULL
    DROP TABLE #HRDPendingCFW; 
select x.LOANSKEY,x.LOANSUBSTATUS,x.INVESTORNAME,x.CONTACTTYPE1,x.CONTACTFIRSTNAME1,x.CONTACTLASTNAME1,x.PROPERTYADDRESS1
,x.PROPERTYADDRESS2,x.PROPERTYCITY,x.PROPERTYSTATE,x.PROPERTYZIP,x.MAILINGADDRESS1,x.MAILINGADDRESS2
,x.MAILINGCITY,x.MAILINGSTATE,x.MAILINGZIP,x.HOMEPHONE1,x.CELLPHONE1
,x.CONTACTTYPE2,x.CONTACTFIRSTNAME2,x.CONTACTLASTNAME2,x.HOMEPHONE2,x.CELLPHONE2
,x.CONTACTTYPE3,x.CONTACTFIRSTNAME3,x.CONTACTLASTNAME3,x.HOMEPHONE3,x.CELLPHONE3
,x.CONTACTTYPE4,x.CONTACTFIRSTNAME4,x.CONTACTLASTNAME4,x.HOMEPHONE4,x.CELLPHONE4
--,b.status_description
,'Repayment Plan Follow Up' as 'CALLREASON',x.[CALLLIST]
,x.MAILINGSTATE2,x.MAILINGZIP2,x.MAILINGSTATE3,x.MAILINGZIP3,x.MAILINGSTATE4,x.MAILINGZIP4
into #HRDPendingCFW
from #finalDefault x
join
(select b.loan_skey
  --,a.workflow_instance_skey,a.complete_date
  --,b.status_description
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a join [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
  where a.workflow_task_description in ( 'Notify Borrower of Denied Plan')
and a.status_description ='Active'
and a.complete_date is null
and b.status_description = 'Active') b
on x.LOANSKEY=b.loan_skey;

select distinct x.*,
--case when c.IBOB is not null then DENSE_RANK() OVER (ORDER BY c.IBOB asc) else 1 end as PRIORITYIBOB
 case when d.PRIORITY is null then 1 else d.PRIORITY end as 'PRIORITYIBOB'
from #HRDPendingCFW x
--left join #rtemp10 c on x.LOANSKEY=c.loan_skey
left join #rtemp11 d on x.LOANSKEY=d.LOANSKEY
where x.LOANSKEY not in 
(select LOANSKEY from #HRDHOBR1
union
select LOANSKEY from #HRDPendingRQCallRequest
union
select LOANSKEY from #HRDPendingRQCallRequestRollOver
union
select LOANSKEY from #MAMHRDLossMit
union
select LOANSKEY from #HRDBAML
union
select LOANSKEY from #HRDPHHLossMit
union
select LOANSKEY from #HRDPendingOcc
union
select LOANSKEY from #HRDPendingRPP1
union
select loan_skey from #obtemp
union
select loan_skey from  #ob4temp
union 
select loan_skey from #ob3temp
union select Loan_skey from #tmpLoankey_1_10_23
)order by PRIORITYIBOB asc;

  
-------------------------------------------------------9.HRDReturnMail--------------------------------------
IF OBJECT_ID('tempdb..#HRDReturnMail') IS NOT NULL
    DROP TABLE #HRDReturnMail;

select x.LOANSKEY,x.LOANSUBSTATUS,x.INVESTORNAME,x.CONTACTTYPE1,x.CONTACTFIRSTNAME1,x.CONTACTLASTNAME1,x.PROPERTYADDRESS1
,x.PROPERTYADDRESS2,x.PROPERTYCITY,x.PROPERTYSTATE,x.PROPERTYZIP,x.MAILINGADDRESS1,x.MAILINGADDRESS2
,x.MAILINGCITY,x.MAILINGSTATE,x.MAILINGZIP,x.HOMEPHONE1,x.CELLPHONE1
,x.CONTACTTYPE2,x.CONTACTFIRSTNAME2,x.CONTACTLASTNAME2,x.HOMEPHONE2,x.CELLPHONE2
,x.CONTACTTYPE3,x.CONTACTFIRSTNAME3,x.CONTACTLASTNAME3,x.HOMEPHONE3,x.CELLPHONE3
,x.CONTACTTYPE4,x.CONTACTFIRSTNAME4,x.CONTACTLASTNAME4,x.HOMEPHONE4,x.CELLPHONE4
,'Return Mail Follow up' as 'CALLREASON',x.[CALLLIST], x.MAILINGSTATE2,x.MAILINGZIP2,x.MAILINGSTATE3,x.MAILINGZIP3,x.MAILINGSTATE4,x.MAILINGZIP4
into #HRDReturnMail

from #finalDefault x
join
[ReverseQuest].[rms].[v_Alert] y
on x.LOANSKEY = y.loan_skey
where y.alert_type_description  in ('Returned Mail - Follow Up Required')
and y.alert_status_description = 'Active'
and alert_date  >= Convert(datetime, '2023-03-01' )
 ;

select distinct x.*,
--case when c.IBOB is not null then DENSE_RANK() OVER (ORDER BY c.IBOB asc) else 1 end as PRIORITYIBOB 
 case when d.PRIORITY is null then 1 else d.PRIORITY end as 'PRIORITYIBOB'
from #HRDReturnMail x
--left join #rtemp10 c on x.LOANSKEY=c.loan_skey
left join #rtemp11 d on x.LOANSKEY=d.LOANSKEY
where x.LOANSKEY not in 
(select LOANSKEY from #HRDHOBR1
union
select LOANSKEY from #HRDPendingRQCallRequest
union
select LOANSKEY from #HRDPendingRQCallRequestRollOver
union
select LOANSKEY from #MAMHRDLossMit
union
select LOANSKEY from #HRDBAML
union
select LOANSKEY from #HRDPHHLossMit
union
select LOANSKEY from #HRDPendingOcc
union
select LOANSKEY from #HRDPendingRPP1
union
select LOANSKEY from #HRDPendingCFW
union
select loan_skey from #obtemp
union
select loan_skey from  #ob4temp
union 
select loan_skey from #ob3temp
union select Loan_skey from #tmpLoankey_1_10_23
)order by PRIORITYIBOB asc;
  
  
-----------------------------------------10.HRDRepair
IF OBJECT_ID('tempdb..#HRDRepair') IS NOT NULL
    DROP TABLE #HRDRepair; 
select x.LOANSKEY,x.LOANSUBSTATUS,x.INVESTORNAME,x.CONTACTTYPE1,x.CONTACTFIRSTNAME1,x.CONTACTLASTNAME1,x.PROPERTYADDRESS1
,x.PROPERTYADDRESS2,x.PROPERTYCITY,x.PROPERTYSTATE,x.PROPERTYZIP,x.MAILINGADDRESS1,x.MAILINGADDRESS2
,x.MAILINGCITY,x.MAILINGSTATE,x.MAILINGZIP,x.HOMEPHONE1,x.CELLPHONE1
,x.CONTACTTYPE2,x.CONTACTFIRSTNAME2,x.CONTACTLASTNAME2,x.HOMEPHONE2,x.CELLPHONE2
,x.CONTACTTYPE3,x.CONTACTFIRSTNAME3,x.CONTACTLASTNAME3,x.HOMEPHONE3,x.CELLPHONE3
,x.CONTACTTYPE4,x.CONTACTFIRSTNAME4,x.CONTACTLASTNAME4,x.HOMEPHONE4,x.CELLPHONE4
,'Repairs Follow Up' as 'CALLREASON',x.[CALLLIST]
,x.MAILINGSTATE2,x.MAILINGZIP2,x.MAILINGSTATE3,x.MAILINGZIP3,x.MAILINGSTATE4,x.MAILINGZIP4
into #HRDRepair
from #finalDefault x
join(
SELECT A.LOAN_SKEY
/*, B.ORIGINAL_LOAN_NUMBER, B.INVESTOR_LOAN_NUMBER, B.SERVICER_NAME, B.INVESTOR_NAME, B.LOAN_POOL_LONG_DESCRIPTION,					
B.LOAN_STATUS_DESCRIPTION, B.LOAN_SUB_STATUS_DESCRIPTION, B.PRODUCT_TYPE_DESCRIPTION, B.PAYMENT_PLAN_DESCRIPTION,					
B.PAYMENT_STATUS_DESCRIPTION, FORMAT(B.CREATED_DATE,'d','us') AS BOARDED_DATE, FORMAT(B.FUNDED_DATE,'d','us') AS FUNDED_DATE,					
C.STATE_CODE, D.FIRST_NAME, D.MIDDLE_NAME, D.LAST_NAME, A.WORKFLOW_TYPE_DESCRIPTION, A.STATUS_DESCRIPTION,					
FORMAT(A.CREATED_DATE,'d','us') AS CREATEDDATE, A.WORKFLOW_MANAGER, AB.WORKFLOW_TASK_DESCRIPTION,					
FORMAT(AB.SCHEDULE_DATE,'d','us') AS SCHEDULE_DATE, FORMAT(AB.DUE_DATE,'d','us') AS DUE_DATE,					
FORMAT(AB.CREATED_DATE,'d','us') AS CREATED_DATE, E.REPAIR_SET_ASIDE_AMOUNT AS ORIGINAL_REPAIR_SET_ASIDE, A.REPAIR_SET_ASIDE_AMOUNT,					
FORMAT(A.REPAIR_COMPLETION_DUE_DATE,'d','us') AS REPAIR_COMPLETION_DUE_DATE, A.REPAIR_TYPE, A.COMMENTS AS REPAIR_DESC,					
FORMAT(A.HUD_COMPLETION_DUE_DATE,'d','us') AS HUD_COMPLETION_DUE_DATE, B.RSA_INCLUDES_ADMINISTRATION_FEE_FLAG,					
DATEDIFF(DAY,A.CREATED_DATE,GETDATE()) AS REPAIR_AGING,					
DATEDIFF(DAY,AB.CREATED_DATE,GETDATE()) AS REPAIR_TASK_AGING,					
CASE WHEN DATEDIFF(DAY,A.CREATED_DATE,GETDATE()) <= 60 THEN '0-60 DAYS'					
	 WHEN DATEDIFF(DAY,A.CREATED_DATE,GETDATE()) <= 120 THEN '61-120 DAYS'				
	 WHEN DATEDIFF(DAY,A.CREATED_DATE,GETDATE()) <= 180 THEN '121-180 DAYS'				
	 WHEN DATEDIFF(DAY,A.CREATED_DATE,GETDATE()) <= 240 THEN '181-240 DAYS'				
	 WHEN DATEDIFF(DAY,A.CREATED_DATE,GETDATE()) <= 365 THEN '241-365 DAYS'				
     ELSE 'GT 1 YEAR' END AS REPAIR_AGE_BUCKET,					
CASE WHEN DATEDIFF(DAY,AB.CREATED_DATE,GETDATE()) <= 5 THEN '0-5 DAYS'					
	 WHEN DATEDIFF(DAY,AB.CREATED_DATE,GETDATE()) <= 10 THEN '6-10 DAYS'				
	 WHEN DATEDIFF(DAY,AB.CREATED_DATE,GETDATE()) <= 15 THEN '11-15 DAYS'				
	 WHEN DATEDIFF(DAY,AB.CREATED_DATE,GETDATE()) <= 20 THEN '16-20 DAYS'				
	 ELSE 'GT 20 DAYS' END AS TASK_AGE_BUCKET*/
FROM REVERSEQUEST.RMS.V_WORKFLOWINSTANCE A	
LEFT JOIN					
(SELECT * FROM [ReverseQuest].RMS.V_WORKFLOWTASKACTIVITY A					
WHERE A.COMPLETE_DATE IS NULL AND A.STATUS_SKEY = '1'					
     AND A.WORKFLOW_TASK_ACTIVITY_SKEY = (SELECT MIN(X.WORKFLOW_TASK_ACTIVITY_SKEY) FROM [ReverseQuest].RMS.V_WORKFLOWTASKACTIVITY X					
					WHERE X.COMPLETE_DATE IS NULL AND X.STATUS_SKEY = '1' AND X.WORKFLOW_INSTANCE_SKEY = A.WORKFLOW_INSTANCE_SKEY)
) AB ON A.WORKFLOW_INSTANCE_SKEY = AB.WORKFLOW_INSTANCE_SKEY					
LEFT JOIN REVERSEQUEST.RMS.V_LOANMASTER B ON A.LOAN_SKEY=B.LOAN_SKEY					
LEFT JOIN REVERSEQUEST.RMS.V_PROPERTYMASTER C ON A.LOAN_SKEY=C.LOAN_SKEY					
LEFT JOIN REVERSEQUEST.RMS.V_CONTACTMASTER D ON A.LOAN_SKEY=D.LOAN_SKEY AND D.CONTACT_TYPE_DESCRIPTION='BORROWER'					
LEFT JOIN REVERSEQUEST.RMS.V_TRANSACTION E ON A.LOAN_SKEY=E.LOAN_SKEY AND E.SHORT_TRANSACTION_DESCRIPTION='RSA'					
WHERE A.WORKFLOW_TYPE_DESCRIPTION='REPAIRS'	and AB.workflow_task_description in ('Receipt of Contractor W-9','Receipt of Property Inspection Report for Repairs'
,'Receipt of Repairs Contract','Repair Rider - Repairs Completion Due')				
AND A.STATUS_SKEY='1') b
on x.LOANSKEY=b.loan_skey;




select distinct a.* ,
--case when c.IBOB is not null then DENSE_RANK() OVER (ORDER BY c.IBOB asc) else 1 end as PRIORITYIBOB
 case when d.PRIORITY is null then 1 else d.PRIORITY end as 'PRIORITYIBOB'
from #HRDRepair a
left join #obtemp b
on a.LOANSKEY =b.loan_skey
--left join #rtemp10 c on a.LOANSKEY=c.loan_skey
left join #rtemp11 d on a.LOANSKEY=d.LOANSKEY
where b.loan_skey is null
and a.LOANSKEY not in (
select LOANSKEY from #HRDHOBR1
union
select LOANSKEY from #HRDPendingRQCallRequest
union
select LOANSKEY from #HRDPendingRQCallRequestRollOver
union
select LOANSKEY from #MAMHRDLossMit
union
select LOANSKEY from #HRDBAML
union
select LOANSKEY from #HRDPHHLossMit
union
select LOANSKEY from #HRDPendingOcc
union
select LOANSKEY from #HRDPendingRPP1
union
select LOANSKEY from #HRDPendingCFW
union
select LOANSKEY from #HRDReturnMail
union
select loan_skey from  #ob12temp 
union
select loan_skey from #ob11temp
union select Loan_skey from #tmpLoankey_1_10_23
)order by PRIORITYIBOB asc ;


-----------------------11.finalDefault

select x.LOANSKEY,x.LOANSUBSTATUS,x.INVESTORNAME,x.CONTACTTYPE1,x.CONTACTFIRSTNAME1,x.CONTACTLASTNAME1,x.PROPERTYADDRESS1
,x.PROPERTYADDRESS2,x.PROPERTYCITY,x.PROPERTYSTATE,x.PROPERTYZIP,x.MAILINGADDRESS1,x.MAILINGADDRESS2
,x.MAILINGCITY,x.MAILINGSTATE,x.MAILINGZIP,x.HOMEPHONE1,x.CELLPHONE1
,x.CONTACTTYPE2,x.CONTACTFIRSTNAME2,x.CONTACTLASTNAME2,x.HOMEPHONE2,x.CELLPHONE2
,x.CONTACTTYPE3,x.CONTACTFIRSTNAME3,x.CONTACTLASTNAME3,x.HOMEPHONE3,x.CELLPHONE3
,x.CONTACTTYPE4,x.CONTACTFIRSTNAME4,x.CONTACTLASTNAME4,x.HOMEPHONE4,x.CELLPHONE4
, 'Default Follow Up' as 'CALLREASON',x.[CALLLIST]
,x.MAILINGSTATE2,x.MAILINGZIP2,x.MAILINGSTATE3,x.MAILINGZIP3,x.MAILINGSTATE4,x.MAILINGZIP4,
--case when c.IBOB is not null then DENSE_RANK() OVER (ORDER BY c.IBOB asc) else 1 end as PRIORITYIBOB
 case when d.PRIORITY is null then 1 else d.PRIORITY end as 'PRIORITYIBOB'
from #finalDefault x
--left join #rtemp10 c on x.LOANSKEY=c.loan_skey
left join #rtemp11 d on x.LOANSKEY=d.LOANSKEY
where x.LOANSKEY not in 
(select LOANSKEY from #HRDHOBR1
union
select LOANSKEY from #HRDPendingRQCallRequest
union
select LOANSKEY from #HRDPendingRQCallRequestRollOver
union
select LOANSKEY from #MAMHRDLossMit
union
select LOANSKEY from #HRDBAML
union
select LOANSKEY from #HRDPHHLossMit
union
select LOANSKEY from #HRDPendingOcc
union
select LOANSKEY from #HRDPendingRPP1
union
select LOANSKEY from #HRDPendingCFW
union
select LOANSKEY from #HRDReturnMail
union
select LOANSKEY from #HRDRepair
union
select loan_skey from #obtentemp
union
select loan_skey from  #ob12temp 
union
select loan_skey from #ob11temp
union select Loan_skey from #tmpLoankey_1_10_23
)order by PRIORITYIBOB asc;




