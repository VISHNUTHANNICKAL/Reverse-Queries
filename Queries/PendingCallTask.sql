IF OBJECT_ID('tempdb..#tempTbl') IS NOT NULL
    DROP TABLE #tempTbl;
select b.loan_skey,c.loan_status_description,b.workflow_type_description,a.workflow_task_description,a.status_description,
a.schedule_date,a.due_date,a.complete_date, b.workflow_instance_skey,b.workflow_type_skey
into #tempTbl
from [ReverseQuest].[rms].[v_WorkflowTaskActivity] a
join [ReverseQuest].[rms].[v_WorkflowInstance] b
on a.workflow_instance_skey=b.workflow_instance_skey
join [ReverseQuest].[rms].v_LoanMaster c
on c.loan_skey=b.loan_skey
where a.status_description='Active' and b.status_description = 'Active'
and c.loan_status_description  not in ('INACTIVE','Deleted')
and b.workflow_type_description in ('Due & Payable w/ HUD Approval','Due & Payable w/o HUD Approval'
,'Pre Due & Payable w/HUD Approval','Occupancy Compliance Certification','Cash Flow Analysis','Repayment Plan')
and a.workflow_task_description in ('1st Call Attempt - HBOR Call Campaign',
'2nd Call Attempt - HBOR Call Campaign',
'3rd Call Attempt - HBOR Call Campaign',
'Call Attempt - Borrower/CoBorrower',
'2nd Call Attempt - Borrower/CoBorrower',
'Final Call Attempt - Borrower/CoBorrower',
'Call Attempt - Eligible Non-Borrowing Spouse',
'Call Attempt - Invalid Occupancy Certificate ',
'Call Attempt - Invalid eNBS Occupancy Certificate ',
'Task Call to CS to confirm borrower has returned',
'Notify Borrower of Denied Plan',
'Notify Borrower of Approved Repayment Plan',
'Missed Payment - 1st Call',
'Missed Payment -  2nd Call',
'Unreturned Signed Agreement - 1st Call',
'Unreturned Signed Agreement - 2nd Call')
and a.complete_date is null;

--select * from #tempTbl where loan_skey = '14953';

IF OBJECT_ID('tempdb..#tempTbl1') IS NOT NULL
    DROP TABLE #tempTbl1;
select * 
into #tempTbl1
from (
select loan_skey,note_type_description,created_date from reversequest.rms.v_note 
where (note_type_description like '%Incom%' or note_type_description like 'Spoc Incom%')
union
select loan_skey,note_type_description ,created_date from reversequest.rms.v_note where
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
) x where x.loan_skey in (select loan_skey from #tempTbl)
;

update #tempTbl1 set created_date = dateadd(dd,-1,created_date)
where note_type_description in ('Incoming','SPOC Outgoing Dialer');
delete from #tempTbl1 where created_date <
dateadd(day,datediff(day,1,GETDATE()),0)
--dateadd(day,datediff(day,3,GETDATE()),0) --friday data every monday uncomment it
or created_date >= 
 dateadd(day,datediff(day,0,GETDATE()),0)
--  dateadd(day,datediff(day,1,GETDATE()),0) --friday data every monday uncomment it
;


select a.loan_skey,a.loan_status_description,a.workflow_type_description,a.workflow_task_description,a.status_description
,a.schedule_date as 'start date',a.due_date,a.workflow_instance_skey,a.workflow_type_skey
--,b.note_type_description
,b.created_date as 'complete_date'
from
#tempTbl a
left join
(select loan_skey,max(created_date) 
as created_date from #tempTbl1 group by loan_skey) b
on a.loan_skey=b.loan_skey
and b.created_date >=a.schedule_date
--where a.workflow_type_description = 'Pre Due & Payable w/HUD Approval'
order by a.loan_skey
;


