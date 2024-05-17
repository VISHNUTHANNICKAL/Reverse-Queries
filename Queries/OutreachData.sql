IF OBJECT_ID('tempdb..#tblTemp') IS NOT NULL
    DROP TABLE #tblTemp;
select a.loan_skey,
a.loan_status_description as 'Loan status',a.loan_sub_status_description as 'Loan Sub-Status',
a.servicer_name as 'Servicer Name',a.investor_name as 'Investor Name',
c.contact_type_description as 'Contact Type'
,concat(concat(c.first_name,' '),c.last_name) as 'Borrower  Name',
c.address1 as 'Property Address1',c.address2 as 'Property Address2' ,c.city as 'Property City' 
,c.state_code as 'Property State',c.zip_code as 'Property Zip',c.mail_address1 as 'Mailing Address 1'
,c.mail_address2 as 'Mailing Address 2',c.mail_city as 'Mailing City'
,c.mail_state_code as 'Mailing State' ,c.mail_zip_code as 'Mailing Zip',c.email
,d.tax_authority_name as 'County'
,d.state_code as 'County State'
,e.default_reason as 'default reason',
c.death_date
into #tblTemp
from reversequest.rms.v_LoanMaster a
join reversequest.rms.v_ContactMaster c
on a.loan_skey = c.loan_skey
join ReverseQuest.rms.v_TaxPayment d
on a.loan_skey=d.loan_skey
join reversequest.rms.v_MonthlyLoanDefaultSummary e
on a.loan_skey=e.loan_skey
where
a.loan_status_description in ('DEFAULT','FORECLOSURE')
and d.state_code in ('NJ','PA')
--c.state_code in ('FL','NC','SC','GA','TN','MS','AL')
--and c.state_code in ('VA','WB','ME','CT','MA','VT','RI','PA','NJ','MD','NY','NH')
;

IF OBJECT_ID('tempdb..#tblfinal') IS NOT NULL
    DROP TABLE #tblfinal;
select * 
into #tblfinal from
(select ROW_NUMBER() OVER (PARTITION BY [Borrower  Name],[Contact Type],loan_skey order by [Property State]) rownum,* from #tblTemp) x
WHERE  
rownum  =1;

--select * from #tblTemp where loan_skey = '4090';
--select * from #tblfinal 
--where loan_skey = '4090'
--order by loan_skey,rownum;

select * from(
select ROW_NUMBER() OVER (PARTITION BY [Contact Type],loan_skey order by [Property State]) rownum,* from #tblTemp
) x
WHERE rownum < 2;