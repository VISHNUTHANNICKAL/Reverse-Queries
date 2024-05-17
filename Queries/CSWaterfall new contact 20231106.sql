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

IF OBJECT_ID('tempdb..#rtemp') IS NOT NULL
    DROP TABLE #rtemp;
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
a.loan_status_description in ('Active', 'Claim')
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
and d.alert_status_description = 'Active';

--select * from #rtemp where loan_skey=90305 [Contact Type1]='Attorney' and HOMEPHONE1 in('') and CELLPHONE1 in('')
/*
delete  from #rtemp where loan_skey  in(
select loan_skey from [ReverseQuest].[rms].[v_Alert]
where alert_type_description  in ('Borrower Represented by Attorney'
)
and alert_status_description = 'Active')
and [Contact Type1] in ('Borrower','Co-Borrower','Attorney')*/
--and [Property State] in ('AR', 'AZ', 'MA', 'NH', 'OR', 'WA', 'WV' )

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
select loan_skey,loan_sub_status,investor_name
--,loan_status_description,
,[Contact Type1],[Contact First Name1],[Contact Last Name1],[Property Address1]
,[Property Address2], [Property City],[Property State],[Property Zip],[Mailing Address 1],[Mailing Address 2],[Mailing City],[Mailing State],[Mailing Zip]
,[HOMEPHONE1], [CELLPHONE1], [Work Phone #] 
--,alert_type_description
,[default reason]
--,Priority 
,case when [Property State] in ('AL','AK','AR','AZ','CA','CO','DE','DC','FL','GA','HI','ID','IL','IN','KS','KY','LA','MD','ME','MA','MI','MN','MO','NM','ND','OH','OK','PA','PR','RI','SD','TN','TX','UT','VT','VA','VI','WV','NY','WY') then 'RMS_CS_PMC' 
  when [Property State] in ('NJ') then 'RMS_CS_WPB' 
  when [Property State] in ('CT','IA','NV','NH','MT','NE','OR','NC','SC','WA','WI') then 'RMS_CS_HOU'
  when [Property State] in ('MS') then 'RMS_WFO_CS_HOU'
 -- when [Property State] in () then 'RMS_CS_ALL'
  else NULL end as 'CALLLIST'
into #finalDefault
from 
(select ROW_NUMBER() OVER (PARTITION BY loan_skey ORDER BY priority,created_date desc) rownum,* from #tempAlldefault) x
WHERE  
rownum = 1 and 
Priority is not null 
--and loan_skey = '89192'
order by loan_skey,alert_type_description;

--select * from #finalDefault where [Contact Type1]='Attorney'

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
from #tmpContacts) T where crn=1
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
from #tmpContacts) T where crn=1
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
from #tmpContacts) T where crn=1
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
CONTACTLASTNAME4=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONTACTLASTNAME4, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),']',''),'{',''),'}',''),'\',''),'|',''),'¿','')

--select Loan_skey from #tmpLoankey_1_10_23

IF OBJECT_ID('tempdb..#tmpLoankey_1_10_23') IS NOT NULL
    DROP TABLE #tmpLoankey_1_10_23;
select * 
into #tmpLoankey_1_10_23
from
(

select 254334 as Loan_skey union all
select 356014 as Loan_skey union all
select 357710 as Loan_skey union all
select 357342 as Loan_skey union all
select 355621 as Loan_skey union all
select 354778 as Loan_skey union all
select 355715 as Loan_skey union all
select 356921 as Loan_skey union all
select 357671 as Loan_skey union all
select 358296 as Loan_skey union all
select 358380 as Loan_skey union all
select 356021 as Loan_skey union all
select 358104 as Loan_skey union all
select 357404 as Loan_skey union all
select 354839 as Loan_skey union all
select 358396 as Loan_skey union all
select 358282 as Loan_skey union all
select 358185 as Loan_skey union all
select 358528 as Loan_skey union all
select 355062 as Loan_skey union all
select 355043 as Loan_skey union all
select 357890 as Loan_skey union all
select 354990 as Loan_skey union all
select 357159 as Loan_skey union all
select 355063 as Loan_skey union all
select 356655 as Loan_skey union all
select 358399 as Loan_skey union all
select 355739 as Loan_skey union all
select 357349 as Loan_skey union all
select 355579 as Loan_skey union all
select 358500 as Loan_skey union all
select 358408 as Loan_skey union all
select 358254 as Loan_skey union all
select 355061 as Loan_skey union all
select 358128 as Loan_skey union all
select 357763 as Loan_skey union all
select 356501 as Loan_skey union all
select 355957 as Loan_skey union all
select 358321 as Loan_skey union all
select 358213 as Loan_skey union all
select 356665 as Loan_skey union all
select 356994 as Loan_skey union all
select 355327 as Loan_skey union all
select 357620 as Loan_skey union all
select 355045 as Loan_skey union all
select 356445 as Loan_skey union all
select 357296 as Loan_skey union all
select 355241 as Loan_skey union all
select 356371 as Loan_skey union all
select 355218 as Loan_skey union all
select 357200 as Loan_skey union all
select 355750 as Loan_skey union all
select 358226 as Loan_skey union all
select 356620 as Loan_skey union all
select 355237 as Loan_skey union all
select 357489 as Loan_skey union all
select 357511 as Loan_skey union all
select 358526 as Loan_skey union all
select 355178 as Loan_skey union all
select 355328 as Loan_skey union all
select 354773 as Loan_skey union all
select 355028 as Loan_skey union all
select 357821 as Loan_skey union all
select 355337 as Loan_skey union all
select 358031 as Loan_skey union all
select 355498 as Loan_skey union all
select 354787 as Loan_skey union all
select 356984 as Loan_skey union all
select 357962 as Loan_skey union all
select 356211 as Loan_skey union all
select 355375 as Loan_skey union all
select 356050 as Loan_skey union all
select 357186 as Loan_skey union all
select 356728 as Loan_skey union all
select 354791 as Loan_skey union all
select 354970 as Loan_skey union all
select 357842 as Loan_skey union all
select 354853 as Loan_skey union all
select 355257 as Loan_skey union all
select 356299 as Loan_skey union all
select 358379 as Loan_skey union all
select 356164 as Loan_skey union all
select 354898 as Loan_skey union all
select 356005 as Loan_skey union all
select 355044 as Loan_skey union all
select 354886 as Loan_skey union all
select 354677 as Loan_skey union all
select 355995 as Loan_skey union all
select 358113 as Loan_skey union all
select 357050 as Loan_skey union all
select 357802 as Loan_skey union all
select 356780 as Loan_skey union all
select 354726 as Loan_skey union all
select 356103 as Loan_skey union all
select 354683 as Loan_skey union all
select 356250 as Loan_skey union all
select 355714 as Loan_skey union all
select 357394 as Loan_skey union all
select 358400 as Loan_skey union all
select 354959 as Loan_skey union all
select 355556 as Loan_skey union all
select 355317 as Loan_skey union all
select 356971 as Loan_skey union all
select 356729 as Loan_skey union all
select 354801 as Loan_skey union all
select 355151 as Loan_skey union all
select 354740 as Loan_skey union all
select 354989 as Loan_skey union all
select 356365 as Loan_skey union all
select 354749 as Loan_skey union all
select 355089 as Loan_skey union all
select 357759 as Loan_skey union all
select 355148 as Loan_skey union all
select 355656 as Loan_skey union all
select 356772 as Loan_skey union all
select 354671 as Loan_skey union all
select 356767 as Loan_skey union all
select 354725 as Loan_skey union all
select 358394 as Loan_skey union all
select 357619 as Loan_skey union all
select 357594 as Loan_skey union all
select 357706 as Loan_skey union all
select 358338 as Loan_skey union all
select 357358 as Loan_skey union all
select 357739 as Loan_skey union all
select 356321 as Loan_skey union all
select 355947 as Loan_skey union all
select 354667 as Loan_skey union all
select 356457 as Loan_skey union all
select 354893 as Loan_skey union all
select 356124 as Loan_skey union all
select 358154 as Loan_skey union all
select 355306 as Loan_skey union all
select 356327 as Loan_skey union all
select 358006 as Loan_skey union all
select 357596 as Loan_skey union all
select 355066 as Loan_skey union all
select 355855 as Loan_skey union all
select 355444 as Loan_skey union all
select 358367 as Loan_skey union all
select 358158 as Loan_skey union all
select 356618 as Loan_skey union all
select 356965 as Loan_skey union all
select 356480 as Loan_skey union all
select 357871 as Loan_skey union all
select 357670 as Loan_skey union all
select 357608 as Loan_skey union all
select 355219 as Loan_skey union all
select 354672 as Loan_skey union all
select 355845 as Loan_skey union all
select 356185 as Loan_skey union all
select 356131 as Loan_skey union all
select 356741 as Loan_skey union all
select 355644 as Loan_skey union all
select 358012 as Loan_skey union all
select 354803 as Loan_skey union all
select 354754 as Loan_skey union all
select 358479 as Loan_skey union all
select 357841 as Loan_skey union all
select 355065 as Loan_skey union all
select 358026 as Loan_skey union all
select 355497 as Loan_skey union all
select 355157 as Loan_skey union all
select 356434 as Loan_skey union all
select 354987 as Loan_skey union all
select 355060 as Loan_skey union all
select 355552 as Loan_skey union all
select 357409 as Loan_skey union all
select 356191 as Loan_skey union all
select 357082 as Loan_skey union all
select 358178 as Loan_skey union all
select 355516 as Loan_skey union all
select 354654 as Loan_skey union all
select 356002 as Loan_skey union all
select 357251 as Loan_skey union all
select 357534 as Loan_skey union all
select 357985 as Loan_skey union all
select 356996 as Loan_skey union all
select 354976 as Loan_skey union all
select 357432 as Loan_skey union all
select 357170 as Loan_skey union all
select 358564 as Loan_skey union all
select 358164 as Loan_skey union all
select 358279 as Loan_skey union all
select 356420 as Loan_skey union all
select 356652 as Loan_skey union all
select 357667 as Loan_skey union all
select 356852 as Loan_skey union all
select 357668 as Loan_skey union all
select 356334 as Loan_skey union all
select 355533 as Loan_skey union all
select 357618 as Loan_skey union all
select 354862 as Loan_skey union all
select 356609 as Loan_skey union all
select 357878 as Loan_skey union all
select 355775 as Loan_skey union all
select 356791 as Loan_skey union all
select 357910 as Loan_skey union all
select 356648 as Loan_skey union all
select 355607 as Loan_skey union all
select 358325 as Loan_skey union all
select 357669 as Loan_skey union all
select 356577 as Loan_skey union all
select 357021 as Loan_skey union all
select 355210 as Loan_skey union all
select 355616 as Loan_skey union all
select 355784 as Loan_skey union all
select 356783 as Loan_skey union all
select 358083 as Loan_skey union all
select 358125 as Loan_skey union all
select 355364 as Loan_skey union all
select 354816 as Loan_skey union all
select 357895 as Loan_skey union all
select 355541 as Loan_skey union all
select 356737 as Loan_skey union all
select 358294 as Loan_skey union all
select 355900 as Loan_skey union all
select 355132 as Loan_skey union all
select 356540 as Loan_skey union all
select 356587 as Loan_skey union all
select 354958 as Loan_skey union all
select 357469 as Loan_skey union all
select 357838 as Loan_skey union all
select 357058 as Loan_skey union all
select 358131 as Loan_skey union all
select 356255 as Loan_skey union all
select 354895 as Loan_skey union all
select 357151 as Loan_skey union all
select 356484 as Loan_skey union all
select 357810 as Loan_skey union all
select 354908 as Loan_skey union all
select 357380 as Loan_skey union all
select 355508 as Loan_skey union all
select 357081 as Loan_skey union all
select 356461 as Loan_skey union all
select 355623 as Loan_skey union all
select 357385 as Loan_skey union all
select 355753 as Loan_skey union all
select 357576 as Loan_skey union all
select 358434 as Loan_skey union all
select 356418 as Loan_skey union all
select 358328 as Loan_skey union all
select 356855 as Loan_skey union all
select 358004 as Loan_skey union all
select 356957 as Loan_skey union all
select 355614 as Loan_skey union all
select 357048 as Loan_skey union all
select 357872 as Loan_skey union all
select 355512 as Loan_skey union all
select 357347 as Loan_skey union all
select 356280 as Loan_skey union all
select 358362 as Loan_skey union all
select 357793 as Loan_skey union all
select 357772 as Loan_skey union all
select 357612 as Loan_skey union all
select 358545 as Loan_skey union all
select 356992 as Loan_skey union all
select 357064 as Loan_skey union all
select 355073 as Loan_skey union all
select 357642 as Loan_skey union all
select 357600 as Loan_skey union all
select 355091 as Loan_skey union all
select 355575 as Loan_skey union all
select 357728 as Loan_skey union all
select 356703 as Loan_skey union all
select 358446 as Loan_skey union all
select 354774 as Loan_skey union all
select 356999 as Loan_skey union all
select 354874 as Loan_skey union all
select 356265 as Loan_skey union all
select 356726 as Loan_skey union all
select 355586 as Loan_skey union all
select 354798 as Loan_skey union all
select 356911 as Loan_skey union all
select 356212 as Loan_skey union all
select 356324 as Loan_skey union all
select 355282 as Loan_skey union all
select 356270 as Loan_skey union all
select 356640 as Loan_skey union all
select 355025 as Loan_skey union all
select 357425 as Loan_skey union all
select 356351 as Loan_skey union all
select 357331 as Loan_skey union all
select 357719 as Loan_skey union all
select 355333 as Loan_skey union all
select 355812 as Loan_skey union all
select 356760 as Loan_skey union all
select 358373 as Loan_skey union all
select 354695 as Loan_skey union all
select 358054 as Loan_skey union all
select 358475 as Loan_skey union all
select 355590 as Loan_skey union all
select 355858 as Loan_skey union all
select 356087 as Loan_skey union all
select 356602 as Loan_skey union all
select 358332 as Loan_skey union all
select 355479 as Loan_skey union all
select 354704 as Loan_skey union all
select 357242 as Loan_skey union all
select 354658 as Loan_skey union all
select 358378 as Loan_skey union all
select 357698 as Loan_skey union all
select 357015 as Loan_skey union all
select 358187 as Loan_skey union all
select 358318 as Loan_skey union all
select 355897 as Loan_skey union all
select 354649 as Loan_skey union all
select 357164 as Loan_skey union all
select 357597 as Loan_skey union all
select 358094 as Loan_skey union all
select 356584 as Loan_skey union all
select 357568 as Loan_skey union all
select 355884 as Loan_skey union all
select 357704 as Loan_skey union all
select 357042 as Loan_skey union all
select 357665 as Loan_skey union all
select 358513 as Loan_skey union all
select 355554 as Loan_skey union all
select 354830 as Loan_skey union all
select 355438 as Loan_skey union all
select 357659 as Loan_skey union all
select 355923 as Loan_skey union all
select 355582 as Loan_skey union all
select 356694 as Loan_skey union all
select 357498 as Loan_skey union all
select 355794 as Loan_skey union all
select 357764 as Loan_skey union all
select 355491 as Loan_skey union all
select 356223 as Loan_skey union all
select 354891 as Loan_skey union all
select 357018 as Loan_skey union all
select 358123 as Loan_skey union all
select 354775 as Loan_skey union all
select 354665 as Loan_skey union all
select 354915 as Loan_skey union all
select 358129 as Loan_skey union all
select 356918 as Loan_skey union all
select 355724 as Loan_skey union all
select 358464 as Loan_skey union all
select 355156 as Loan_skey union all
select 356622 as Loan_skey union all
select 354779 as Loan_skey union all
select 355722 as Loan_skey union all
select 355514 as Loan_skey union all
select 358261 as Loan_skey union all
select 354675 as Loan_skey union all
select 357446 as Loan_skey union all
select 356081 as Loan_skey union all
select 357386 as Loan_skey union all
select 357599 as Loan_skey union all
select 357207 as Loan_skey union all
select 355463 as Loan_skey union all
select 355752 as Loan_skey union all
select 355872 as Loan_skey union all
select 355090 as Loan_skey union all
select 357849 as Loan_skey union all
select 357013 as Loan_skey union all
select 356263 as Loan_skey union all
select 357009 as Loan_skey union all
select 357269 as Loan_skey union all
select 356282 as Loan_skey union all
select 358096 as Loan_skey union all
select 358190 as Loan_skey union all
select 356677 as Loan_skey union all
select 355925 as Loan_skey union all
select 357788 as Loan_skey union all
select 354856 as Loan_skey union all
select 358327 as Loan_skey union all
select 357868 as Loan_skey union all
select 355991 as Loan_skey union all
select 357258 as Loan_skey union all
select 357203 as Loan_skey union all
select 357090 as Loan_skey union all
select 354883 as Loan_skey union all
select 355145 as Loan_skey union all
select 356028 as Loan_skey union all
select 356980 as Loan_skey union all
select 357261 as Loan_skey union all
select 354912 as Loan_skey union all
select 357601 as Loan_skey union all
select 355353 as Loan_skey union all
select 356987 as Loan_skey union all
select 355141 as Loan_skey union all
select 357156 as Loan_skey union all
select 356435 as Loan_skey union all
select 358099 as Loan_skey union all
select 354661 as Loan_skey union all
select 355871 as Loan_skey union all
select 356404 as Loan_skey union all
select 356779 as Loan_skey union all
select 357174 as Loan_skey union all
select 354880 as Loan_skey union all
select 358093 as Loan_skey union all
select 357780 as Loan_skey union all
select 358442 as Loan_skey union all
select 355291 as Loan_skey union all
select 356574 as Loan_skey union all
select 357461 as Loan_skey union all
select 355964 as Loan_skey union all
select 358523 as Loan_skey union all
select 356300 as Loan_skey union all
select 356454 as Loan_skey union all
select 355951 as Loan_skey union all
select 358139 as Loan_skey union all
select 357426 as Loan_skey union all
select 354709 as Loan_skey union all
select 354849 as Loan_skey union all
select 356661 as Loan_skey union all
select 356802 as Loan_skey union all
select 355914 as Loan_skey union all
select 357457 as Loan_skey union all
select 356839 as Loan_skey union all
select 355948 as Loan_skey union all
select 355451 as Loan_skey union all
select 355286 as Loan_skey union all
select 355916 as Loan_skey union all
select 357751 as Loan_skey union all
select 357454 as Loan_skey union all
select 357433 as Loan_skey union all
select 356870 as Loan_skey union all
select 354955 as Loan_skey union all
select 357062 as Loan_skey union all
select 354951 as Loan_skey union all
select 358237 as Loan_skey union all
select 357241 as Loan_skey union all
select 357753 as Loan_skey union all
select 358521 as Loan_skey union all
select 357443 as Loan_skey union all
select 357588 as Loan_skey union all
select 356566 as Loan_skey union all
select 354790 as Loan_skey union all
select 357069 as Loan_skey union all
select 356105 as Loan_skey union all
select 356155 as Loan_skey union all
select 355852 as Loan_skey union all
select 356329 as Loan_skey union all
select 355650 as Loan_skey union all
select 356215 as Loan_skey union all
select 357873 as Loan_skey union all
select 355480 as Loan_skey union all
select 356972 as Loan_skey union all
select 355202 as Loan_skey union all
select 355232 as Loan_skey union all
select 357298 as Loan_skey union all
select 354718 as Loan_skey union all
select 356519 as Loan_skey union all
select 356487 as Loan_skey union all
select 356724 as Loan_skey union all
select 355663 as Loan_skey union all
select 356286 as Loan_skey union all
select 356600 as Loan_skey union all
select 354922 as Loan_skey union all
select 358257 as Loan_skey union all
select 357019 as Loan_skey union all
select 356016 as Loan_skey union all
select 355012 as Loan_skey union all
select 358115 as Loan_skey union all
select 356228 as Loan_skey union all
select 357032 as Loan_skey union all
select 355819 as Loan_skey union all
select 354859 as Loan_skey union all
select 354646 as Loan_skey union all
select 354825 as Loan_skey union all
select 357978 as Loan_skey union all
select 355651 as Loan_skey union all
select 357158 as Loan_skey union all
select 354640 as Loan_skey union all
select 357222 as Loan_skey union all
select 355907 as Loan_skey union all
select 357567 as Loan_skey union all
select 355421 as Loan_skey union all
select 356698 as Loan_skey union all
select 357664 as Loan_skey union all
select 355071 as Loan_skey union all
select 356654 as Loan_skey union all
select 358231 as Loan_skey union all
select 356350 as Loan_skey union all
select 356133 as Loan_skey union all
select 357521 as Loan_skey union all
select 355130 as Loan_skey union all
select 358229 as Loan_skey union all
select 358211 as Loan_skey union all
select 358409 as Loan_skey union all
select 356073 as Loan_skey union all
select 357210 as Loan_skey union all
select 356479 as Loan_skey union all
select 357928 as Loan_skey union all
select 357666 as Loan_skey union all
select 356272 as Loan_skey union all
select 357467 as Loan_skey union all
select 358316 as Loan_skey union all
select 357613 as Loan_skey union all
select 355647 as Loan_skey union all
select 357526 as Loan_skey union all
select 355847 as Loan_skey union all
select 357278 as Loan_skey union all
select 355859 as Loan_skey union all
select 357617 as Loan_skey union all
select 357825 as Loan_skey union all
select 357014 as Loan_skey union all
select 355298 as Loan_skey union all
select 356135 as Loan_skey union all
select 356938 as Loan_skey union all
select 358290 as Loan_skey union all
select 355655 as Loan_skey union all
select 354679 as Loan_skey union all
select 356643 as Loan_skey union all
select 357167 as Loan_skey union all
select 355967 as Loan_skey union all
select 355866 as Loan_skey union all
select 355082 as Loan_skey union all
select 355180 as Loan_skey union all
select 358271 as Loan_skey union all
select 357539 as Loan_skey union all
select 357497 as Loan_skey union all
select 356409 as Loan_skey union all
select 355023 as Loan_skey union all
select 357063 as Loan_skey union all
select 357709 as Loan_skey union all
select 354983 as Loan_skey union all
select 358451 as Loan_skey union all
select 356368 as Loan_skey union all
select 357007 as Loan_skey union all
select 357758 as Loan_skey union all
select 357072 as Loan_skey

)X 
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

--select * from  #rtemp11 where loan_skey=349358;

IF OBJECT_ID('tempdb..#rtemp12') IS NOT NULL
    DROP TABLE #rtemp12;
select a.*,b.IBOB
--,DENSE_RANK() OVER (ORDER BY b.IBOB asc) PRIORITYIBOB
,case when b.IBOB is not null then DENSE_RANK() OVER (ORDER BY b.IBOB asc) else 1 end as PRIORITYIBOB
into  #rtemp12
from #rtemp a 
left join #rtemp10 b on a.loan_skey=b.loan_skey
where b.IBOB is not null
;*/



IF OBJECT_ID('tempdb..#rtemp11') IS NOT NULL
    DROP TABLE #rtemp11;
select a1.*,
case when CAST (a1.[TOTAL Calls] as int)=0 then 1 
  when CAST (a1.[TOTAL Calls] as int)=1 then 2
   when CAST (a1.[TOTAL Calls] as int)=2 then 3
    when CAST (a1.[TOTAL Calls] as int)>=3 then 4 end as 'PRIORITY'
	into #rtemp11
from
(select a.loan_skey,
/*CAST ((select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.loan_skey and( note_type_description like '%Incom%'  or  note_type_description like 'Spoc Incom%')
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 25, GETDATE()), 0)) AS INT) as 'Inbound Calls in 25 days',
CAST((select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.loan_skey and( note_type_description like 'Spoc Incom%'  or  note_type_description like 'Spoc Incom%')
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 25, GETDATE()), 0)) AS INT) as 'Spoc Inbound Calls in 25 days',*/
CAST((select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.loan_skey and( note_type_description like '%Outgoing%'  
-- or  note_type_description like 'Spoc Incom%'
  )
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 25, GETDATE()), 0))AS INT) as 'Outbound Calls in 25 days',
CAST((select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.loan_skey and( note_type_description like 'Spoc Outgoing%'  
-- or  note_type_description like 'Spoc Incom%'
  )
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 25, GETDATE()), 0))AS INT) as 'Spoc Outbound Calls in 25 days',
Convert(int,/*(select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.loan_skey and( note_type_description like '%Incom%'  or  note_type_description like 'Spoc Incom%')
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 25, GETDATE()), 0)) +
(select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.loan_skey and( note_type_description like 'Spoc Incom%'  or  note_type_description like 'Spoc Incom%')
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 25, GETDATE()), 0))+*/
(select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.loan_skey and( note_type_description like '%Outgoing%'  
-- or  note_type_description like 'Spoc Incom%'
  )
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 25, GETDATE()), 0)) +
(select count(loan_skey)  from reversequest.rms.v_note 
  where loan_skey = a.loan_skey and( note_type_description like 'Spoc Outgoing%'  
-- or  note_type_description like 'Spoc Incom%'
  )
  and created_date >=   DATEADD(DAY, DATEDIFF(DAY, 25, GETDATE()), 0)) ) 'TOTAL Calls'
  from #finalDefault a) a1
  order by [TOTAL Calls]


  --select * from #rtemp11 order by PRIORITY where loan_skey=249909
--------CSCampaign without 7/7 rule

IF OBJECT_ID('tempdb..#CSPendingRQCallRequestRollOverwithout7rule') IS NOT NULL
    DROP TABLE #CSPendingRQCallRequestRollOverwithout7rule; 
	select p.*
	--,q.created_date
	into #CSPendingRQCallRequestRollOverwithout7rule
	from(
select x. loan_skey as LOANSKEY,x.loan_sub_status as LOANSUBSTATUS,x.investor_name as  INVESTORNAME
,x.[Contact Type1] as CONTACTTYPE1,x.[Contact First Name1] as CONTACTFIRSTNAME1,x.[Contact Last Name1] as CONTACTLASTNAME1
,x.[Property Address1]  as PROPERTYADDRESS1,x. [Property Address2] as PROPERTYADDRESS2, x.[Property City] as PROPERTYCITY,
x. [Property State] as PROPERTYSTATE,x.[Property Zip] as PROPERTYZIP,x.[Mailing Address 1] as MAILINGADDRESS1
,x.[Mailing Address 2] as MAILINGADDRESS2,x.[Mailing City] as MAILINGCITY,x.[Mailing State] as MAILINGSTATE,
x.[Mailing Zip] as MAILINGZIP,x.[HOMEPHONE1] As HOMEPHONE1,x.[CELLPHONE1] as CELLPHONE1
,b.created_date
,x.CONTACTTYPE2,x.CONTACTFIRSTNAME2,x.CONTACTLASTNAME2,x.HOMEPHONE2,x.CELLPHONE2
,x.CONTACTTYPE3,x.CONTACTFIRSTNAME3,x.CONTACTLASTNAME3,x.HOMEPHONE3,x.CELLPHONE3
,x.CONTACTTYPE4,x.CONTACTFIRSTNAME4,x.CONTACTLASTNAME4,x.HOMEPHONE4,x.CELLPHONE4
, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(b.note_type_description, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),'–',''),'{',''),'}',''),'\',''),'|',''),'¿','') as 'CALLREASON' 
,x.CALLLIST,x.MAILINGSTATE2,x.MAILINGZIP2,x.MAILINGSTATE3,x.MAILINGZIP3,x.MAILINGSTATE4,x.MAILINGZIP4
--,b.note_type_description
from #finalDefault x
join
(select loan_skey,note_type_description,max(created_date) as 'created_date'  from [ReverseQuest].[rms].[v_Note] 
where (note_type_description in ('CALL REQUIRED – DISBURSEMENTS','CALL Required – Disbursement','Call Required - DISBURSEMENTS','Call Required - ACH','Call Required - COP')
) 
and note_type_description not in ('Call Request - CA','Call Request - WA','Call Request - NV')
and created_date >= Convert(datetime, '2022-11-01' ) 
--and loan_skey in ('89991','90279')
group by loan_skey,note_type_description) b
on x.loan_skey=b.loan_skey
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
q.note_type_description like '%Incom%' or note_type_description like 'Spoc Incom%'
--and loan_skey=89991
)
and q.created_date>=p.created_date
where q.created_date is null;


---select * from #CSPendingRQCallRequestRollOverwithout7rule where loan_skey in ('90305','88459')

/*
select distinct a.*,
--case when c.IBOB is not null then DENSE_RANK() OVER (ORDER BY c.IBOB asc) else 1 end as PRIORITYIBOB
case when d.PRIORITY is null then 1 else d.PRIORITY end as 'PRIORITYIBOB'
--into #finalCSPendingRQCallRequest
from (
select  distinct LOANSKEY,LOANSUBSTATUS,INVESTORNAME,CONTACTTYPE1,CONTACTFIRSTNAME1,CONTACTLASTNAME1,PROPERTYADDRESS1
,PROPERTYADDRESS2,PROPERTYCITY,PROPERTYSTATE,PROPERTYZIP,MAILINGADDRESS1,MAILINGADDRESS2,MAILINGCITY,MAILINGSTATE,MAILINGZIP,HOMEPHONE1
,CELLPHONE1,CONTACTTYPE2,CONTACTFIRSTNAME2,CONTACTLASTNAME2,HOMEPHONE2,CELLPHONE2,CONTACTTYPE3,CONTACTFIRSTNAME3,CONTACTLASTNAME3,HOMEPHONE3,CELLPHONE3
,CONTACTTYPE4,CONTACTFIRSTNAME4,CONTACTLASTNAME4,HOMEPHONE4,CELLPHONE4,CALLREASON,CALLLIST
,MAILINGSTATE2,MAILINGZIP2,MAILINGSTATE3,MAILINGZIP3,MAILINGSTATE4,MAILINGZIP4
from #CSPendingRQCallRequestRollOverwithout7rule) a
join [ReverseQuest].[rms].[v_Note] b on a.LOANSKEY=b.loan_skey
--left join #rtemp10 c on a.LOANSKEY=c.loan_skey
left join #rtemp11 d on a.LOANSKEY=d.loan_skey
  where b.note_type_description  in ('CALL REQUIRED – DISBURSEMENTS','CALL Required – Disbursement','Call Required - DISBURSEMENTS','Call Required - ACH','Call Required - COP')
and a.LOANSKEY  not in (select loan_skey from  #ob4temp
union select loan_skey from #ob3temp
union select Loan_skey from #tmpLoankey_1_10_23
)
order by PRIORITYIBOB asc;

*/






----------------------------------7/7 rule for NON disbursement team------------------------------------------------------
delete from #finalDefault 
where loan_skey in
(select a.loan_skey from reversequest.rms.v_note a
where a.created_date
>= DATEADD(d,-7,DATEDIFF(d,0,GETDATE())) and
a.created_date < DATEADD(d,0,DATEDIFF(d,0,GETDATE()))
and (a.note_type_description like '%Incom%' or note_type_description like 'Spoc Incom%')
and a.created_by not like 'System Load')
and loan_skey not in (select loan_skey from #rtempDISBURSEMENTS );

delete from #finalDefault 
where loan_skey in
(select a.loan_skey from reversequest.rms.v_note a
where a.created_date
>= DATEADD(d,-6,DATEDIFF(d,0,GETDATE())) and
a.created_date < DATEADD(d,0,DATEDIFF(d,0,GETDATE()))
and (a.note_type_description like '%Incom%' or note_type_description like 'Spoc Incom%')
and a.created_by like 'System Load')
and loan_skey not in (select loan_skey from #rtempDISBURSEMENTS );

delete from #finalDefault 
where loan_skey in
(select a.loan_skey from reversequest.rms.v_note a
where a.created_date
>= DATEADD(d,-6,DATEDIFF(d,0,GETDATE())) and
a.created_date < DATEADD(d,1,DATEDIFF(d,0,GETDATE()))
and a.note_type_description like 'Contact - RPC' and a.created_by in ('Vishnu V Thannickal','Mohit Gandhi')
);

delete from #finalDefault 
where loan_skey in
(select a.loan_skey from reversequest.rms.v_note a
where a.created_date
>= DATEADD(d,-7,DATEDIFF(d,0,GETDATE())) and
a.created_date < DATEADD(d,0,DATEDIFF(d,0,GETDATE()))
and a.note_type_description like 'Contact - RPC' and a.created_by not in ('Vishnu V Thannickal','Mohit Gandhi')
);

--------------------------------------------CSPendingRQCallRequest

IF OBJECT_ID('tempdb..#CSPendingRQCallRequest') IS NOT NULL
    DROP TABLE #CSPendingRQCallRequest; 
select x. loan_skey as LOANSKEY,x.loan_sub_status as LOANSUBSTATUS,x.investor_name as  INVESTORNAME
,x.[Contact Type1] as CONTACTTYPE1,x.[Contact First Name1] as CONTACTFIRSTNAME1,x.[Contact Last Name1] as CONTACTLASTNAME1
,x.[Property Address1]  as PROPERTYADDRESS1,x. [Property Address2] as PROPERTYADDRESS2, x.[Property City] as PROPERTYCITY,
x. [Property State] as PROPERTYSTATE,x.[Property Zip] as PROPERTYZIP,x.[Mailing Address 1] as MAILINGADDRESS1
,x.[Mailing Address 2] as MAILINGADDRESS2,x.[Mailing City] as MAILINGCITY,x.[Mailing State] as MAILINGSTATE,
x.[Mailing Zip] as MAILINGZIP,x.[HOMEPHONE1] As HOMEPHONE1,x.[CELLPHONE1] as CELLPHONE1
--,b.created_date,
,x.CONTACTTYPE2,x.CONTACTFIRSTNAME2,x.CONTACTLASTNAME2,x.HOMEPHONE2,x.CELLPHONE2
,x.CONTACTTYPE3,x.CONTACTFIRSTNAME3,x.CONTACTLASTNAME3,x.HOMEPHONE3,x.CELLPHONE3
,x.CONTACTTYPE4,x.CONTACTFIRSTNAME4,x.CONTACTLASTNAME4,x.HOMEPHONE4,x.CELLPHONE4
, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(b.note_type_description, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),'–',''),'{',''),'}',''),'\',''),'|',''),'¿','') as 'CALLREASON' 
,x.CALLLIST,x.MAILINGSTATE2,x.MAILINGZIP2,x.MAILINGSTATE3,x.MAILINGZIP3,x.MAILINGSTATE4,x.MAILINGZIP4
into #CSPendingRQCallRequest
from #finalDefault x
join
(select loan_skey,note_type_description,created_date from [ReverseQuest].[rms].[v_Note] 
where 
--created_date >    DATEADD(HOUR, -13, getdate()) and  created_date <   DATEADD(HOUR, -1, getdate())
--created_date between  DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()-3), 0) + '14:01'AND   DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0) + '06:00' --Monday Morning Call prior day 2pm to current day 6am 
--created_date between  DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()-1), 0) + '14:01'AND   DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0) + '06:00' --Morning Call prior day 2pm to current day 6am 
created_date between  DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0) + '06:01' AND   DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0) + '14:00' --Afternoon Call 6am	current day	to 2pm current day		
				) b
on x.loan_skey=b.loan_skey
  where (b.note_type_description like 'Call Req%') and b.note_type_description not in ('Call Request - CA','Call Request - WA','Call Request - NV'
  ,'CALL REQUIRED – DISBURSEMENTS','CALL Required – Disbursement','Call Required - DISBURSEMENTS','Call Required - ACH','Call Required - COP')
  and x.loan_skey not in (select loan_skey from  #ob4temp
union select loan_skey from #ob3temp
union select Loan_skey from #tmpLoankey_1_10_23
)
  ;
 /* select a.*,b.note_type_description from #CSPendingRQCallRequest a
  join [ReverseQuest].[rms].[v_Note] b on a.LOANSKEY=b.loan_skey
  where b.note_type_description  in ('Call Request - Cust. Follow-Up','Call Request - COP Change','Call Request - Short Payoff','Call Request-Follow-Up Disb.')
  */
 
  

  ---------------------------------------------------------

  IF OBJECT_ID('tempdb..#CSPendingRQCallRequestRollOver') IS NOT NULL
    DROP TABLE #CSPendingRQCallRequestRollOver; 
	select p.*
	--,q.created_date
	into #CSPendingRQCallRequestRollOver
	from(
select x. loan_skey as LOANSKEY,x.loan_sub_status as LOANSUBSTATUS,x.investor_name as  INVESTORNAME
,x.[Contact Type1] as CONTACTTYPE1,x.[Contact First Name1] as CONTACTFIRSTNAME1,x.[Contact Last Name1] as CONTACTLASTNAME1
,x.[Property Address1]  as PROPERTYADDRESS1,x. [Property Address2] as PROPERTYADDRESS2, x.[Property City] as PROPERTYCITY,
x. [Property State] as PROPERTYSTATE,x.[Property Zip] as PROPERTYZIP,x.[Mailing Address 1] as MAILINGADDRESS1
,x.[Mailing Address 2] as MAILINGADDRESS2,x.[Mailing City] as MAILINGCITY,x.[Mailing State] as MAILINGSTATE,
x.[Mailing Zip] as MAILINGZIP,x.[HOMEPHONE1] As HOMEPHONE1,x.[CELLPHONE1] as CELLPHONE1
,b.created_date
,x.CONTACTTYPE2,x.CONTACTFIRSTNAME2,x.CONTACTLASTNAME2,x.HOMEPHONE2,x.CELLPHONE2
,x.CONTACTTYPE3,x.CONTACTFIRSTNAME3,x.CONTACTLASTNAME3,x.HOMEPHONE3,x.CELLPHONE3
,x.CONTACTTYPE4,x.CONTACTFIRSTNAME4,x.CONTACTLASTNAME4,x.HOMEPHONE4,x.CELLPHONE4
, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(b.note_type_description, '&', ''), ',', ''), '''', ''),'"',''),'.',''),'?',''),':',''),';',''),'/',''),'>',''),'<',''),'*',''),'^',''),'$',''),'#',''),'!',''),'-',''),'@',''),'%',''),'(',''),')',''),'[',''),'–',''),'{',''),'}',''),'\',''),'|',''),'¿','') as 'CALLREASON' 
,x.CALLLIST,x.MAILINGSTATE2,x.MAILINGZIP2,x.MAILINGSTATE3,x.MAILINGZIP3,x.MAILINGSTATE4,x.MAILINGZIP4
--,b.note_type_description
from #finalDefault x
join
(select loan_skey,note_type_description,max(created_date) as 'created_date'  from [ReverseQuest].[rms].[v_Note] 
where (note_type_description like 'Call Req%') and note_type_description not in ('Call Request - CA','Call Request - WA','Call Request - NV')
and created_date >= Convert(datetime, '2022-11-01' ) 
--and loan_skey in ('89991','90279')
group by loan_skey,note_type_description) b
on x.loan_skey=b.loan_skey
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
q.note_type_description like '%Incom%' or note_type_description like 'Spoc Incom%'
--and loan_skey=89991
)
and q.created_date>=p.created_date
where q.created_date is null;


--select * from #CSPendingRQCallRequestRollOver where LOANSKEY in ('89991','90279')
 

--IF OBJECT_ID('tempdb..#finalCSPendingRQCallRequest') IS NOT NULL
--    DROP TABLE #finalCSPendingRQCallRequest;
select distinct a.*,
--case when c.IBOB is not null then DENSE_RANK() OVER (ORDER BY c.IBOB asc) else 1 end as PRIORITYIBOB
case when d.PRIORITY is null then 1 else d.PRIORITY end as 'PRIORITYIBOB'
--into #finalCSPendingRQCallRequest
from (
select distinct * from #CSPendingRQCallRequest 
union
select  distinct LOANSKEY,LOANSUBSTATUS,INVESTORNAME,CONTACTTYPE1,CONTACTFIRSTNAME1,CONTACTLASTNAME1,PROPERTYADDRESS1
,PROPERTYADDRESS2,PROPERTYCITY,PROPERTYSTATE,PROPERTYZIP,MAILINGADDRESS1,MAILINGADDRESS2,MAILINGCITY,MAILINGSTATE,MAILINGZIP,HOMEPHONE1
,CELLPHONE1,CONTACTTYPE2,CONTACTFIRSTNAME2,CONTACTLASTNAME2,HOMEPHONE2,CELLPHONE2,CONTACTTYPE3,CONTACTFIRSTNAME3,CONTACTLASTNAME3,HOMEPHONE3,CELLPHONE3
,CONTACTTYPE4,CONTACTFIRSTNAME4,CONTACTLASTNAME4,HOMEPHONE4,CELLPHONE4,CALLREASON,CALLLIST
,MAILINGSTATE2,MAILINGZIP2,MAILINGSTATE3,MAILINGZIP3,MAILINGSTATE4,MAILINGZIP4
from #CSPendingRQCallRequestRollOver) a
join [ReverseQuest].[rms].[v_Note] b on a.LOANSKEY=b.loan_skey
--left join #rtemp10 c on a.LOANSKEY=c.loan_skey
left join #rtemp11 d on a.LOANSKEY=d.loan_skey
  where b.note_type_description  in ('Call Req.-Cust. Mail Req. Box','Call Request - COP Change','Call Request - FEMA Follow-Up',
  'Call Request - LOC – 10%','Call Request - LOC – 20%','Call Request - Proof of Ins.','Call Request - Short Payoff ','Call Request-Active Occupancy'
  ,'Call Request-Claim Assignments','Call Request-Follow-Up Disb.','Call Request-Proof of Paid Tax','Call Request - LOC – Depleted')
  and a.LOANSKEY not in(select LOANSKEY from 
  #CSPendingRQCallRequestRollOverwithout7rule where LOANSKEY in (select loan_skey from  
  [ReverseQuest].[rms].[v_Note]  where note_type_description in('CALL REQUIRED – DISBURSEMENTS','CALL Required – Disbursement','Call Required - DISBURSEMENTS','Call Required - ACH','Call Required - COP')))
--order by PRIORITYIBOB asc;
union all

select distinct a.*,
--case when c.IBOB is not null then DENSE_RANK() OVER (ORDER BY c.IBOB asc) else 1 end as PRIORITYIBOB
case when d.PRIORITY is null then 1 else d.PRIORITY end as 'PRIORITYIBOB'
--into #finalCSPendingRQCallRequest
from (
select  distinct LOANSKEY,LOANSUBSTATUS,INVESTORNAME,CONTACTTYPE1,CONTACTFIRSTNAME1,CONTACTLASTNAME1,PROPERTYADDRESS1
,PROPERTYADDRESS2,PROPERTYCITY,PROPERTYSTATE,PROPERTYZIP,MAILINGADDRESS1,MAILINGADDRESS2,MAILINGCITY,MAILINGSTATE,MAILINGZIP,HOMEPHONE1
,CELLPHONE1,CONTACTTYPE2,CONTACTFIRSTNAME2,CONTACTLASTNAME2,HOMEPHONE2,CELLPHONE2,CONTACTTYPE3,CONTACTFIRSTNAME3,CONTACTLASTNAME3,HOMEPHONE3,CELLPHONE3
,CONTACTTYPE4,CONTACTFIRSTNAME4,CONTACTLASTNAME4,HOMEPHONE4,CELLPHONE4,CALLREASON,CALLLIST
,MAILINGSTATE2,MAILINGZIP2,MAILINGSTATE3,MAILINGZIP3,MAILINGSTATE4,MAILINGZIP4
from #CSPendingRQCallRequestRollOverwithout7rule) a
join [ReverseQuest].[rms].[v_Note] b on a.LOANSKEY=b.loan_skey
--left join #rtemp10 c on a.LOANSKEY=c.loan_skey
left join #rtemp11 d on a.LOANSKEY=d.loan_skey
  where b.note_type_description  in ('CALL REQUIRED – DISBURSEMENTS','CALL Required – Disbursement','Call Required - DISBURSEMENTS','Call Required - ACH','Call Required - COP')
and a.LOANSKEY  not in (select loan_skey from  #ob4temp
union select loan_skey from #ob3temp
union select Loan_skey from #tmpLoankey_1_10_23
)
order by PRIORITYIBOB asc;



  ---------------------------------------------------------CS CallOccupancy----------------------------------
  IF OBJECT_ID('tempdb..#CSPendingOCC') IS NOT NULL
    DROP TABLE #CSPendingOCC; 
  select x. loan_skey as LOANSKEY,x.loan_sub_status as LOANSUBSTATUS,x.investor_name as  INVESTORNAME
,x.[Contact Type1] as CONTACTTYPE1,x.[Contact First Name1] as CONTACTFIRSTNAME1,x.[Contact Last Name1] as CONTACTLASTNAME1
,x.[Property Address1]  as PROPERTYADDRESS1,x. [Property Address2] as PROPERTYADDRESS2, x.[Property City] as PROPERTYCITY,
x. [Property State] as PROPERTYSTATE,x.[Property Zip] as PROPERTYZIP,x.[Mailing Address 1] as MAILINGADDRESS1
,x.[Mailing Address 2] as MAILINGADDRESS2,x.[Mailing City] as MAILINGCITY,x.[Mailing State] as MAILINGSTATE,
x.[Mailing Zip] as MAILINGZIP,x.[HOMEPHONE1] As HOMEPHONE1,x.[CELLPHONE1] as CELLPHONE1,
x.CONTACTTYPE2,x.CONTACTFIRSTNAME2,x.CONTACTLASTNAME2,x.HOMEPHONE2,x.CELLPHONE2
,x.CONTACTTYPE3,x.CONTACTFIRSTNAME3,x.CONTACTLASTNAME3,x.HOMEPHONE3,x.CELLPHONE3
,x.CONTACTTYPE4,x.CONTACTFIRSTNAME4,x.CONTACTLASTNAME4,x.HOMEPHONE4,x.CELLPHONE4,
'Need Occupancy Certificate' as 'CALLREASON'
,x.CALLLIST,x.MAILINGSTATE2,x.MAILINGZIP2,x.MAILINGSTATE3,x.MAILINGZIP3,x.MAILINGSTATE4,x.MAILINGZIP4 into #CSPendingOCC
from #finalDefault x
join
(select b.loan_skey
  --,a.workflow_instance_skey,a.complete_date
  ,b.status_description
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a join [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
  where a.workflow_task_description in ( 'Call Attempt - Borrower/CoBorrower'
,'2nd Call Attempt - Borrower/CoBorrower'
,'Final Call Attempt - Borrower/CoBorrower'
,'Call Attempt - Invalid Occupancy Certificate '
,'Task Call to CS to confirm borrower has returned.',
'Call Attempt - Eligible Non-Borrowing Spouse'
,'Call Attempt - Invalid eNBS Occupancy Certificate ')
and a.status_description = ('Active')
and a.complete_date is null
and b.status_description in ('Active')
) b
on x.loan_skey=b.loan_skey
and x.loan_skey not in
(select LOANSKEY from #CSPendingRQCallRequest
union select Loan_skey from #tmpLoankey_1_10_23)

union

(
select m.* from(
select x. loan_skey as LOANSKEY,x.loan_sub_status as LOANSUBSTATUS,x.investor_name as  INVESTORNAME
,x.[Contact Type1] as CONTACTTYPE1,x.[Contact First Name1] as CONTACTFIRSTNAME1,x.[Contact Last Name1] as CONTACTLASTNAME1
,x.[Property Address1]  as PROPERTYADDRESS1,x. [Property Address2] as PROPERTYADDRESS2, x.[Property City] as PROPERTYCITY,
x. [Property State] as PROPERTYSTATE,x.[Property Zip] as PROPERTYZIP,x.[Mailing Address 1] as MAILINGADDRESS1
,x.[Mailing Address 2] as MAILINGADDRESS2,x.[Mailing City] as MAILINGCITY,x.[Mailing State] as MAILINGSTATE,
x.[Mailing Zip] as MAILINGZIP,x.[HOMEPHONE1] As HOMEPHONE,x.[CELLPHONE1] as CELLPHONE,
x.CONTACTTYPE2,x.CONTACTFIRSTNAME2,x.CONTACTLASTNAME2,x.HOMEPHONE2,x.CELLPHONE2
,x.CONTACTTYPE3,x.CONTACTFIRSTNAME3,x.CONTACTLASTNAME3,x.HOMEPHONE3,x.CELLPHONE3
,x.CONTACTTYPE4,x.CONTACTFIRSTNAME4,x.CONTACTLASTNAME4,x.HOMEPHONE4,x.CELLPHONE4,
'Need Occupancy Certificate' as 'CALLREASON',x.CALLLIST,x.MAILINGSTATE2,x.MAILINGZIP2,x.MAILINGSTATE3,x.MAILINGZIP3,x.MAILINGSTATE4,x.MAILINGZIP4
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
on x.loan_skey=b.loan_skey
and x.loan_skey not in
(select LOANSKEY from #CSPendingRQCallRequest) 
) m 

join

(
select x. loan_skey as LOANSKEY,x.loan_sub_status as LOANSUBSTATUS,x.investor_name as  INVESTORNAME
,x.[Contact Type1] as CONTACTTYPE1,x.[Contact First Name1] as CONTACTFIRSTNAME1,x.[Contact Last Name1] as CONTACTLASTNAME1
,x.[Property Address1]  as PROPERTYADDRESS1,x. [Property Address2] as PROPERTYADDRESS2, x.[Property City] as PROPERTYCITY,
x. [Property State] as PROPERTYSTATE,x.[Property Zip] as PROPERTYZIP,x.[Mailing Address 1] as MAILINGADDRESS1
,x.[Mailing Address 2] as MAILINGADDRESS2,x.[Mailing City] as MAILINGCITY,x.[Mailing State] as MAILINGSTATE,
x.[Mailing Zip] as MAILINGZIP,x.[HOMEPHONE1] As HOMEPHONE,x.[CELLPHONE1] as CELLPHONE,
x.CONTACTTYPE2,x.CONTACTFIRSTNAME2,x.CONTACTLASTNAME2,x.HOMEPHONE2,x.CELLPHONE2
,x.CONTACTTYPE3,x.CONTACTFIRSTNAME3,x.CONTACTLASTNAME3,x.HOMEPHONE3,x.CELLPHONE3
,x.CONTACTTYPE4,x.CONTACTFIRSTNAME4,x.CONTACTLASTNAME4,x.HOMEPHONE4,x.CELLPHONE4,
'Need Occupancy Certificate' as 'CALLREASON',x.CALLLIST,x.MAILINGSTATE2,x.MAILINGZIP2,x.MAILINGSTATE3,x.MAILINGZIP3,x.MAILINGSTATE4,x.MAILINGZIP4
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
on x.loan_skey=b.loan_skey
and x.loan_skey not in
(select LOANSKEY from #CSPendingRQCallRequest)

union

select x. loan_skey as LOANSKEY,x.loan_sub_status as LOANSUBSTATUS,x.investor_name as  INVESTORNAME
,x.[Contact Type1] as CONTACTTYPE1,x.[Contact First Name1] as CONTACTFIRSTNAME1,x.[Contact Last Name1] as CONTACTLASTNAME1
,x.[Property Address1]  as PROPERTYADDRESS1,x. [Property Address2] as PROPERTYADDRESS2, x.[Property City] as PROPERTYCITY,
x. [Property State] as PROPERTYSTATE,x.[Property Zip] as PROPERTYZIP,x.[Mailing Address 1] as MAILINGADDRESS1
,x.[Mailing Address 2] as MAILINGADDRESS2,x.[Mailing City] as MAILINGCITY,x.[Mailing State] as MAILINGSTATE,
x.[Mailing Zip] as MAILINGZIP,x.[HOMEPHONE1] As HOMEPHONE,x.[CELLPHONE1] as CELLPHONE,
x.CONTACTTYPE2,x.CONTACTFIRSTNAME2,x.CONTACTLASTNAME2,x.HOMEPHONE2,x.CELLPHONE2
,x.CONTACTTYPE3,x.CONTACTFIRSTNAME3,x.CONTACTLASTNAME3,x.HOMEPHONE3,x.CELLPHONE3
,x.CONTACTTYPE4,x.CONTACTFIRSTNAME4,x.CONTACTLASTNAME4,x.HOMEPHONE4,x.CELLPHONE4,
'Need Occupancy Certificate' as 'CALLREASON',x.CALLLIST,x.MAILINGSTATE2,x.MAILINGZIP2,x.MAILINGSTATE3,x.MAILINGZIP3,x.MAILINGSTATE4,x.MAILINGZIP4
--,b.due_date,b.complete_date,b.workflow_task_description
from #finalDefault x
join
(select b.loan_skey
  --,a.workflow_instance_skey,a.complete_date
  ,b.status_description,a.due_date,a.complete_date,a.workflow_task_description
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a join [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
  where a.workflow_task_description in ('Closing Date Anniversary')
  and a.due_date =   DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)
and a.status_description = ('Active')
and a.complete_date is null
and b.status_description in ('Active')
) b
on x.loan_skey=b.loan_skey
and x.loan_skey not in
(select LOANSKEY from #CSPendingRQCallRequest
union select Loan_skey from #tmpLoankey_1_10_23)
) p
on m.LOANSKEY=p.LOANSKEY
);

--------OCCRollover
select 
a.*,
--case when c.IBOB is not null then DENSE_RANK() OVER (ORDER BY c.IBOB asc) else 1 end as PRIORITYIBOB
case when d.PRIORITY is null then 1 else d.PRIORITY end as 'PRIORITYIBOB'
from(
select * from #CSPendingOCC
union
select x. loan_skey as LOANSKEY,x.loan_sub_status as LOANSUBSTATUS,x.investor_name as  INVESTORNAME
,x.[Contact Type1] as CONTACTTYPE1,x.[Contact First Name1] as CONTACTFIRSTNAME1,x.[Contact Last Name1] as CONTACTLASTNAME1
,x.[Property Address1]  as PROPERTYADDRESS1,x. [Property Address2] as PROPERTYADDRESS2, x.[Property City] as PROPERTYCITY,
x. [Property State] as PROPERTYSTATE,x.[Property Zip] as PROPERTYZIP,x.[Mailing Address 1] as MAILINGADDRESS1
,x.[Mailing Address 2] as MAILINGADDRESS2,x.[Mailing City] as MAILINGCITY,x.[Mailing State] as MAILINGSTATE,
x.[Mailing Zip] as MAILINGZIP,x.[HOMEPHONE1] As HOMEPHONE,x.[CELLPHONE1] as CELLPHONE,
x.CONTACTTYPE2,x.CONTACTFIRSTNAME2,x.CONTACTLASTNAME2,x.HOMEPHONE2,x.CELLPHONE2
,x.CONTACTTYPE3,x.CONTACTFIRSTNAME3,x.CONTACTLASTNAME3,x.HOMEPHONE3,x.CELLPHONE3
,x.CONTACTTYPE4,x.CONTACTFIRSTNAME4,x.CONTACTLASTNAME4,x.HOMEPHONE4,x.CELLPHONE4,
'Need Occupancy Certificate' as 'CALLREASON',x.CALLLIST,x.MAILINGSTATE2,x.MAILINGZIP2,x.MAILINGSTATE3,x.MAILINGZIP3,x.MAILINGSTATE4,x.MAILINGZIP4
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
on x.loan_skey=b.loan_skey
and x.loan_skey not in
(
select b.loan_skey
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] a join [ReverseQuest].[rms].[v_WorkflowInstance] b
  on a.workflow_instance_skey=b.workflow_instance_skey
  where a.workflow_task_description in ('Receipt of Valid Occupancy Certificate' )
and a.status_description = ('Active')
and a.complete_date is not null
and b.status_description in ('Active')
union
select LOANSKEY from #CSPendingRQCallRequest
union select Loan_skey from #tmpLoankey_1_10_23
)) a 
--left join #rtemp10 c on a.LOANSKEY=c.loan_skey
left join #rtemp11 d on a.LOANSKEY=d.loan_skey
order by PRIORITYIBOB asc;





-----------------------------------------------CSReturnMail----------------------------------------
IF OBJECT_ID('tempdb..#CSReturnMail') IS NOT NULL
    DROP TABLE #CSReturnMail;

select x. loan_skey as LOANSKEY,x.loan_sub_status as LOANSUBSTATUS,x.investor_name as  INVESTORNAME
,x.[Contact Type1] as CONTACTTYPE1,x.[Contact First Name1] as CONTACTFIRSTNAME1,x.[Contact Last Name1] as CONTACTLASTNAME1
,x.[Property Address1]  as PROPERTYADDRESS1,x. [Property Address2] as PROPERTYADDRESS2, x.[Property City] as PROPERTYCITY,
x. [Property State] as PROPERTYSTATE,x.[Property Zip] as PROPERTYZIP,x.[Mailing Address 1] as MAILINGADDRESS1
,x.[Mailing Address 2] as MAILINGADDRESS2,x.[Mailing City] as MAILINGCITY,x.[Mailing State] as MAILINGSTATE,
x.[Mailing Zip] as MAILINGZIP,x.[HOMEPHONE1] As HOMEPHONE,x.[CELLPHONE1] as CELLPHONE,
x.CONTACTTYPE2,x.CONTACTFIRSTNAME2,x.CONTACTLASTNAME2,x.HOMEPHONE2,x.CELLPHONE2
,x.CONTACTTYPE3,x.CONTACTFIRSTNAME3,x.CONTACTLASTNAME3,x.HOMEPHONE3,x.CELLPHONE3
,x.CONTACTTYPE4,x.CONTACTFIRSTNAME4,x.CONTACTLASTNAME4,x.HOMEPHONE4,x.CELLPHONE4,
'Return Mail Follow up' as 'CALLREASON',x.CALLLIST,x.MAILINGSTATE2,x.MAILINGZIP2,x.MAILINGSTATE3,x.MAILINGZIP3,x.MAILINGSTATE4,x.MAILINGZIP4
into #CSReturnMail
from  #finalDefault x
join
[ReverseQuest].[rms].[v_Alert] y
on x.loan_skey = y.loan_skey
where y.alert_type_description  in ('Returned Mail - Follow Up Required')
and y.alert_status_description = 'Active'
and alert_date  >= Convert(datetime, '2023-03-01' )
 ;

 select distinct x.*, 
 --case when c.IBOB is not null then DENSE_RANK() OVER (ORDER BY c.IBOB asc) else 1 end as PRIORITYIBOB
 case when d.PRIORITY is null then 1 else d.PRIORITY end as 'PRIORITYIBOB'
 from #CSReturnMail x
 -- left join #rtemp10 c on x.LOANSKEY=c.loan_skey
 left join #rtemp11 d on x.LOANSKEY=d.loan_skey
 where LOANSKEY not in
 (
 select LOANSKEY from #CSPendingOCC
 union
 select LOANSKEY from #CSPendingRQCallRequest
 union select Loan_skey from #tmpLoankey_1_10_23
 )
order by PRIORITYIBOB asc;

 ---------------------------------------------------------CSRepairs------------------


IF OBJECT_ID('tempdb..#CSRepair') IS NOT NULL
    DROP TABLE #CSRepair; 
select x. loan_skey as LOANSKEY,x.loan_sub_status as LOANSUBSTATUS,x.investor_name as  INVESTORNAME
,x.[Contact Type1] as CONTACTTYPE1,x.[Contact First Name1] as CONTACTFIRSTNAME1,x.[Contact Last Name1] as CONTACTLASTNAME1
,x.[Property Address1]  as PROPERTYADDRESS1,x. [Property Address2] as PROPERTYADDRESS2, x.[Property City] as PROPERTYCITY,
x. [Property State] as PROPERTYSTATE,x.[Property Zip] as PROPERTYZIP,x.[Mailing Address 1] as MAILINGADDRESS1
,x.[Mailing Address 2] as MAILINGADDRESS2,x.[Mailing City] as MAILINGCITY,x.[Mailing State] as MAILINGSTATE,
x.[Mailing Zip] as MAILINGZIP,x.[HOMEPHONE1] As HOMEPHONE,x.[CELLPHONE1] as CELLPHONE,
x.CONTACTTYPE2,x.CONTACTFIRSTNAME2,x.CONTACTLASTNAME2,x.HOMEPHONE2,x.CELLPHONE2
,x.CONTACTTYPE3,x.CONTACTFIRSTNAME3,x.CONTACTLASTNAME3,x.HOMEPHONE3,x.CELLPHONE3
,x.CONTACTTYPE4,x.CONTACTFIRSTNAME4,x.CONTACTLASTNAME4,x.HOMEPHONE4,x.CELLPHONE4,
'Repairs Follow up' as 'CALLREASON',x.CALLLIST,x.MAILINGSTATE2,x.MAILINGZIP2,x.MAILINGSTATE3,x.MAILINGZIP3,x.MAILINGSTATE4,x.MAILINGZIP4
into #CSRepair
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
on x.loan_skey=b.loan_skey;

select distinct a.*, 
-- case when c.IBOB is not null then DENSE_RANK() OVER (ORDER BY c.IBOB asc) else 1 end as PRIORITYIBOB
case when d.PRIORITY is null then 1 else d.PRIORITY end as 'PRIORITYIBOB'
from #CSRepair a
--left join #rtemp10 c on a.LOANSKEY=c.loan_skey
left join #rtemp11 d on a.LOANSKEY=d.loan_skey
where LOANSKEY not in (
select LOANSKEY from #CSPendingOCC
 union
 select LOANSKEY from #CSPendingRQCallRequest
 union
  select LOANSKEY from #CSReturnMail
  union select Loan_skey from #tmpLoankey_1_10_23
 )
 order by PRIORITYIBOB asc;