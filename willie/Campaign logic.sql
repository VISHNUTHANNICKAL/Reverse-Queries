select 
loan_skey,alert_type_description,alert_status_description,created_date,created_by,modified_date,modified_by from rms.v_Alert
where alert_type_description='Escalation'
and created_date >= CONVERT(date,'2024-01-01')
and created_date <= CONVERT(date,'2024-12-31')
order by created_date;

------------------------------------------

select a.loan_skey,a.loan_status_description,b.contact_type_description,
concat(b.first_name,concat(' ',b.last_name)) as 'Contact Person',
b.home_phone_number,b.cell_phone_number
from rms.v_LoanMaster a join
rms.v_ContactMaster b on a.loan_skey=b.loan_skey and b.home_phone_number=b.cell_phone_number
where b.home_phone_number  not in('')
and b.cell_phone_number not in('')
order by b.loan_skey;

------SKPTRC/SKPEXH

select loan_skey,alert_type_description,alert_status_description
,convert(date,created_date) 'Task Raised date',created_by 'Task Raised by'
,convert(date,modified_date) 'Task Closed date',modified_by 'Task closed by'
from rms.v_Alert
where created_date>= CONVERT(date,'2023-11-01')
and alert_type_description in ('SKPTRC','SKPEXH')
order by created_date;



---To identify blank contact  name
select * from(
select a.loan_skey,a.loan_status_description,contact_type_description,first_name,middle_name,last_name,
work_phone_number,cell_phone_number,home_phone_number,death_date
from rms.v_LoanMaster a 
 join rms.v_ContactMaster c on a.loan_skey=c.loan_skey
where 
first_name in('remove','.') or middle_name in('remove','.') or last_name in('remove','.')
and death_date is not null) c 
where c.loan_status_description  in ('ACTIVE','BANKRUPTCY','CLAIM','DEFAULT','FORECLOSURE')  
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
order by c.loan_skey



--- to Check count

select 
 a.loan_skey,a.loan_status_description
 ,b.notetext_date as '1st OB Attempt',b.Shift as '1st OB Shift'
 ,c.notetext_date as '2nd OB Attempt',c.Shift as '2nd OB Shift'
 ,d.notetext_date as '3rd OB Attempt',d.Shift as '3rd OB Shift'
 from rms.v_LoanMaster a
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
      WHEN  DATEPART(HOUR,notetext_date) >=16 AND DATEPART(HOUR,notetext_date) < 20 THEN 'EVENING'
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
and note_text  like 'OB_REV_HRD%'
and note_text not like '%HCI__Invalid Phone Number%'
and note_text not like '%MANUAL_%'
) a where rn=1
) b where sn=1
) b on a.loan_skey=b.loan_skey
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
      WHEN  DATEPART(HOUR,notetext_date) >=16 AND DATEPART(HOUR,notetext_date) < 20 THEN 'EVENING'
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
and note_text  like 'OB_REV_HRD%'
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
      WHEN  DATEPART(HOUR,notetext_date) >=16 AND DATEPART(HOUR,notetext_date) < 20 THEN 'EVENING'
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
and note_text  like 'OB_REV_HRD%'
and note_text not like '%HCI__Invalid Phone Number%'
and note_text not like '%MANUAL_%'
) a where rn=3
) b where sn=1
) d on a.loan_skey=d.loan_skey
where a.loan_status_description in('DEFAULT','FORECLOSURE')
and a.loan_skey=268564




select  * 
from [ReverseQuest].[rms].[v_Note] 
where 
--loan_skey=290571 and 
created_date='2023-02-23'
and note_type_skey=40002990
and note_text like '%CA WA NV Homeowners Borrower Rights%'
order by created_date desc

select  * 
from [ReverseQuest].[rms].[v_Note] 
where 
loan_skey in ('70905') 
and created_date>='2023-01-05'
--and note_type_skey=40002990
and( note_type_description in('SPOC Outgoing Dialer') or note_type_description like '%Outgoing%' 
or note_type_description like '%Incom%')
order by created_date desc
*/


--TO check OB update
select  * 
from [ReverseQuest].[rms].[v_Note] 
where 
--loan_skey=2700 and 
created_date between '2023-09-05' and '2023-09-09'--=convert(date,GETDATE())
and note_type_skey=40002990
order by created_date desc

select *
from [ReverseQuest].[rms].[v_Note] 
where --loan_skey='259796' 
--and note_text like ('%Obtain status of the repairs%')
 created_date= convert(date,GETDATE())
and note_type_skey=40002990
order by created_date desc

select loan_skey
,note_type_description,note_text
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
and loan_skey=268564


---------------------------------------------------------------

select loan_skey,contact_type_description,concat(first_name,' ',middle_name,' ',last_name) Contact_name,
state_code,zip_code,work_phone_number,cell_phone_number,home_phone_number
from rms.v_ContactMaster
where contact_type_description='Attorney'
and cell_phone_number is null
and home_phone_number is null
order by loan_skey

select distinct contact_type_skey,contact_type_description from rms.v_ContactMaster
order by contact_type_description



select b.loan_skey
,a.loan_status_description
,contact_type_description,concat(first_name,' ',middle_name,' ',last_name) contact_name
--,work_phone_number,cell_phone_number,home_phone_number 
,email,c.state_code property_state,d.alert_type_description
from
rms.v_LoanMaster a join
rms.v_ContactMaster b
on a.loan_skey=b.loan_skey
join rms.v_PropertyMaster c 
on a.loan_skey=c.loan_skey
left join rms.v_Alert d
on a.loan_skey=d.loan_skey and d.alert_type_description='FDCPA Qualified Loans' and d.alert_status_description='Active'
where contact_type_description in('Borrower','Co-Borrower')
and loan_status_description not in('REO','Inactive')
--and a.loan_skey in()
order by loan_skey


---------------------------------ATP

select a.loan_skey,alert_type_description,alert_status_description,a.created_date 'Alert date',a.created_by,contact_type_description,
first_name,middle_name,last_name,b.created_date 'Contact Created date',b.created_by,b.modified_date,b.modified_by

from rms.v_Alert a
join rms.v_ContactMaster b on a.loan_skey=b.loan_skey and b.contact_type_description in ('Alternate Contact','Authorized Party','Power of Attorney','Conservator','Attorney')
and b.modified_date>=a.created_date
where alert_type_description='Newly Boarded Loan Welcome Call'and 
alert_status_description='Active'
and a.created_date>='2023-09-20'
order by a.loan_skey
-------------------------------------
select distinct contact_type_description from rms.v_ContactMaster order by contact_type_description

--LM
select * from (
/*select  loan_skey,note_type_description,
note_text
,(CONVERT(varchar, CONVERT(datetime, replace(replace(rtrim(ltrim(substring(note_text,CHARINDEX('I_', note_text)+2,28))),'.',':'),'000000','00')),21))  as created_date
--,created_date
,created_by
from rms.v_Note where --loan_skey=245751 and 
note_text like '%Left Message Machine%'
and note_type_description='SPOC Outgoing Dialer'
and created_date >=    GETDATE()-25
and note_text  like 'OB_REV_%'
and note_text not like '%HCI__Invalid Phone Number%'
and note_text not like '%MANUAL_%'
union all
*/
select  loan_skey,note_type_description,
note_text
--,(CONVERT(varchar, CONVERT(datetime, replace(replace(rtrim(ltrim(substring(note_text,CHARINDEX('I_', note_text)+2,28))),'.',':'),'000000','00')),21))  as notetext_date
,created_date,created_by
from rms.v_Note where --loan_skey=245751 and 
(note_text like '%Left voicemail%' or note_text like '%Left VM%' or note_text like '%Left vm%' or note_text like '%Message Left%'  )
and note_type_description='SPOC Outgoing No Contact Estab'
and created_date >=    GETDATE()-25
) a
where loan_skey=245751
order by created_date;

select  loan_skey,note_type_description,
note_text
--,(CONVERT(varchar, CONVERT(datetime, replace(replace(rtrim(ltrim(substring(note_text,CHARINDEX('I_', note_text)+2,28))),'.',':'),'000000','00')),21))  as notetext_date
,convert(date,created_date) created_date,created_by
from rms.v_Note where --loan_skey=245751 and 
(note_text like '%Left voicemail%' or note_text like '%Left VM%' or note_text like '%Left vm%' 
or note_text like '%Message Left%' or note_text like '%message Left%' or note_text like '%Left message%'
or note_text like '%VM left%' or note_text like '%Voicemail Left%'
)
and note_text  not like '%No Message Left%'
--and note_type_description='SPOC Outgoing No Contact Estab'
and created_date>= CONVERT(date,'2024-02-01')
and created_date < DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
--and created_date >=   DATEADD(m,0,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
order by created_date;


-------------------------------------------------------------
select loan_skey
--,note_type_description,note_text
--,CONVERT(datetime2, replace(replace(rtrim(ltrim(substring(note_text,CHARINDEX('I_', note_text)+2,25))),'.',':'),'000000','00'))  as notetext_date2
,CONVERT(datetime2,replace(rtrim(ltrim( substring(note_text,CHARINDEX('I_', note_text)+2,18)  )),'.',':'))  as notetext_date
--,max(created_date)
,DENSE_RANK() OVER (PARTITION BY loan_skey  ORDER BY CONVERT(datetime2,replace(rtrim(ltrim(substring(note_text,CHARINDEX('I_', note_text)+2,18))),'.',':')) desc) rn
from [ReverseQuest].[rms].[v_Note] 
where 
--loan_skey=1930 and 
--created_date  >=    DATEADD(DAY, DATEDIFF(DAY, 140, getdate()), 0) and 
created_date  >=   getdate()-4 and 
 note_type_description='SPOC Outgoing Dialer'
and note_text  like 'OB_REV_%'
and note_text not like '%HCI__Invalid Phone Number%'
and note_text not like '%MANUAL_%'
--and created_date<=   getdate()-4






--------------------------------------------------



select * from (
select loan_skey,document_description,
ROW_NUMBER() OVER (PARTITION BY loan_skey  ORDER BY loan_skey) as 'rn'
from RQER.[dbo].[app_document] 
where document_description like 'ACH Direct Deposit Request'
and loan_skey in('352310',
'352324',
'352343',
'352344',
'352351',
'352352',
'352357',
'352363',
'352364',
'352370',
'352383',
'352388',
'352389',
'352409',
'352412',
'352413',
'352422',
'352440',
'352444',
'352453',
'352456',
'352465',
'352485',
'352486',
'352493',
'352495',
'352509',
'352515',
'352519',
'352531',
'352564',
'352579',
'352599',
'352649',
'353429',
'353506',
'353609',
'353622',
'353626',
'354130',
'354366',
'354626',
'354692',
'354730',
'354934',
'354948',
'355014',
'355099',
'355140',
'355173',
'355174',
'355204',
'355246',
'355325',
'355341',
'355361',
'355367',
'355404',
'355405',
'355627',
'355719',
'356042',
'356059',
'356269',
'356369',
'356382',
'356523',
'356524',
'356560',
'356666',
'356857',
'356875',
'357004',
'357005',
'357129',
'357143',
'357146',
'357214',
'357252',
'357338',
'357634',
'357932',
'357997',
'358034',
'358051',
'358235',
'358417',
'358536',
'358895',
'359000',
'359034',
'359234',
'359321',
'359818',
'359827',
'359931',
'359940',
'359992',
'360385',
'360502',
'360665',
'360690',
'360728',
'360932',
'360990',
'361159',
'361183',
'361219',
'361235',
'361246',
'361260',
'361261',
'361263',
'361264',
'361265',
'361266',
'361267',
'361268',
'361269',
'361271',
'361273',
'361274',
'361276',
'361278',
'361279',
'361281',
'361282',
'361283',
'361284',
'361285',
'361286',
'361287',
'361288',
'361289',
'361292',
'361293',
'361294',
'361296',
'361297',
'361298',
'361299',
'361301',
'361302',
'361303',
'361304',
'361307',
'361308',
'361309',
'361311',
'361312',
'361313',
'361314',
'361316',
'361338',
'361345',
'361346',
'361347',
'361348',
'361349',
'361358',
'361362',
'361363',
'361364',
'361365',
'361379',
'361385',
'361387',
'361388',
'361390',
'361397',
'361407',
'361410',
'361432',
'361433',
'361440',
'361441',
'361442',
'361443',
'361444',
'361445',
'361446',
'361448',
'361458',
'361461',
'361474',
'361475',
'361479',
'361481',
'361484',
'361490',
'361491',
'361494',
'361495',
'361496',
'361498',
'361506',
'361507',
'361508',
'361509',
'361511',
'361512',
'361529',
'361531',
'361533',
'361534',
'361538',
'361541',
'361542',
'361543',
'361546',
'361548',
'361563',
'361564',
'361569',
'361572',
'361573',
'361574',
'361576',
'361577',
'361578',
'361579',
'361580',
'361581',
'361582',
'361592',
'361593',
'361594',
'361595',
'361596',
'361600',
'361601',
'361602',
'361604',
'361605',
'361614',
'361623',
'361624',
'361625',
'361626',
'361627',
'361628',
'361629',
'361630',
'361631',
'361632',
'361633',
'361634',
'361635',
'361636',
'361637',
'361638',
'361639',
'361640',
'361641',
'361642',
'361643',
'361644',
'361645',
'361646',
'361647',
'361648',
'361649',
'361650',
'361651',
'361652',
'361653',
'361654',
'361655',
'361656',
'361657',
'361659',
'361660',
'361662',
'361663',
'361664',
'361665',
'361666',
'361667',
'361668',
'361669',
'361670',
'361672',
'361673',
'361674',
'361675',
'361684',
'361685',
'361686',
'361688',
'361692',
'361693',
'361695',
'361715',
'361717',
'361731',
'361734',
'361735',
'361738',
'361739',
'361740',
'361741',
'361742',
'361761',
'361762',
'361764',
'361766',
'361771',
'361772',
'361775',
'361778',
'361785',
'361786',
'361787',
'361788',
'361789',
'361795',
'361807',
'361808',
'361810',
'361811',
'361813')
) a where rn=1
order by a.loan_skey;


select * from (
select a.loan_skey,b.loan_status_description,a.note_type_description,a.created_date,a.created_by,a.note_text,
ROW_NUMBER() OVER (PARTITION BY a.loan_skey  ORDER BY a.created_date asc) as 'rn'
from rms.v_Note a 
left join rms.v_LoanMaster b on a.loan_skey=b.loan_skey
where
--note_type_description in('Call Request - LOC – Depleted','Call Request - LOC - 10%','Call Request - LOC - 20%' ) order by created_date
(--note_type_description like '%Incom%' or note_type_description like 'Spoc Incom%'or note_type_description like 'Contact - RPC' or
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
or note_type_description like '%Incom%' or note_type_description like 'Spoc Incom%' or note_type_description like 'Contact - RPC')
and a.created_date>= convert (date,'2023-11-07')
and a.loan_skey in (
)) a where rn=1
order by a.loan_skey;

-------------------------


select a.loan_skey,b.loan_status_description,c.state_code,alert_type_description,alert_status_description,a.created_by "Alert Created BY",a.created_date as "Alert Create Date",a.alert_note "Alert Note"
from rms.v_Alert a
join rms.v_LoanMaster b on a.loan_skey=b.loan_skey
join rms.v_PropertyMaster c on a.loan_skey=c.loan_skey
where alert_type_description='Privacy Notice - Opt Out Received'
and alert_status_description='Active'
and a.created_date >= '2023-07-01'
and a.created_date <='2023-12-16'
and b.loan_status_description not in('REO','INACTIVE')
and c.state_code='CA'
order by a.created_date;
-------------------------------------------------------------


select * from (
SELECT x.complete_date as complete_date,y.loan_skey,x.workflow_task_description,
ROW_NUMBER() OVER (PARTITION BY y.loan_skey ORDER BY x.complete_date desc) rn
--,y.workflow_type_description
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] x
  join
  [ReverseQuest].[rms].[v_WorkflowInstance] y
  on x.workflow_instance_skey=y.workflow_instance_skey
  where x.workflow_task_description = 'Default Event Occurred'
  and x.status_description='Active'
  and y.workflow_type_description in ('Pre Due & Payable w/HUD Approval','Due & Payable w/ HUD Approval','Due & Payable w/o HUD Approval')
  and y.status_description in ('Active','Workflow Completed')
 -- and x.created_date >= DATEADD(DAY, DATEDIFF(DAY, 30, GETDATE()), 0)
  and x.complete_date is not null
  --and y.loan_skey='283407'
  ) a where rn=1



SELECT x.complete_date as complete_date,y.loan_skey,x.workflow_task_description,x.task_note,
ROW_NUMBER() OVER (PARTITION BY y.loan_skey ORDER BY x.complete_date desc) rn
--,y.workflow_type_description
  FROM [ReverseQuest].[rms].[v_WorkflowTaskActivity] x
  join
  [ReverseQuest].[rms].[v_WorkflowInstance] y
  on x.workflow_instance_skey=y.workflow_instance_skey
  where x.workflow_task_description = 'Repayment Plan Broken'
  and x.status_description='Active'
  and y.workflow_type_description in ('Repayment Plan')
  and y.status_description in ('Active','Workflow Completed')
 -- and x.created_date >= DATEADD(DAY, DATEDIFF(DAY, 30, GETDATE()), 0)
  and x.complete_date is not null
  and y.loan_skey='10914'

  ------------------------------------------------------------------------------------

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
--and loan_skey not in (select loan_skey from #rtempDISBURSEMENTS)
) a where loan_skey in (
select loan_skey from rms.v_PropertyMaster
where state_code in('WA','MA')
union
select loan_skey from rms.v_ContactMaster
where contact_type_description in ('Borrower','Co-Borrower')
and mail_state_code in('WA','MA')
)


select * from (
select a.loan_skey,a.sn,b.contact_type_description 'contact type1'
,b.home_phone_number 'Home phone 1'--,b.cell_phone_number 'Cell Phone 1'
,c.contact_type_description,
c.home_phone_number,c.cell_phone_number
from (
select * 
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
from #limitedattemptstaterules
)a 
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





select * from (
select a.*,b.contact_type_description 'contact type1'--,b.home_phone_number 'Home phone 1'
,b.cell_phone_number 'Cell Phone 1'
,c.contact_type_description--,c.home_phone_number
,c.cell_phone_number
from (
select * 
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
from #limitedattemptstaterules
)a 
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
)a where [contact type1] is not null
order by loan_skey







union
select a.*,--b.contact_type_description,b.home_phone_number,b.cell_phone_number,
c.contact_type_description,c.cell_phone_number,c.home_phone_number
from (
select * 
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
from #limitedattemptstaterules
)a 
left join(
select loan_skey,contact_type_description,cell_phone_number,home_phone_number from rms.v_ContactMaster
where contact_type_description in ('Borrower','Co-Borrower')
and loan_skey in (select loan_skey from #limitedattemptstaterules)
) c on a.loan_skey=c.loan_skey and a.sn=c.cell_phone_number
where a.sn not like '' 



--where sn not like ''
--and loan_skey =350199
--order by loan_skey
--where note_text like '%AGENT - PTP by Mail%'

select loan_skey,contact_type_description,home_phone_number,cell_phone_number from rms.v_ContactMaster
where contact_type_description in ('Borrower','Co-Borrower')
and loan_skey in (select loan_skey from #limitedattemptstaterules)



----------------------------skip tracing------------------------

select loan_skey,note_type_category_description,note_type_description,note_text,created_date from rms.v_Note 
where note_type_category_description='Skip Tracing'
and created_date >= CONVERT(date,'2023-11-01')
order by created_date;

select a.loan_skey,a.note_type_category_description,a.note_type_description
,b.contact_type_description
,a.note_text,a.created_date 
from rms.v_Note a 
left join rms.v_ContactMaster b on a.loan_skey=b.loan_skey
where a.note_type_category_description='Skip Tracing'
and b.contact_type_description='Skip Tracing'
and a.created_date >= CONVERT(date,'2023-11-01')
order by a.created_date;


