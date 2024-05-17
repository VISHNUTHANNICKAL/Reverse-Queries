IF OBJECT_ID('tempdb..#tblTemp') IS NOT NULL
    DROP TABLE #tblTemp;
select  IDENTITY( int ) AS idcol,a.loan_skey,
--a.original_loan_number, 
a.loan_sub_status_description as loan_sub_status,a.loan_status_description as loan_status, a.investor_name,
c.contact_type_description as 'Contact Type'
,concat(concat(c.first_name,' ' ), c.last_name) as  'Borrower'
,b.address1 as 'Property Address1',b.address2 as 'Property Address2' ,b.city as 'Property City' 
,b.state_code as 'Property State',b.zip_code as 'Property Zip'
,c.mail_address1 as 'Mailing Address 1' ,c.mail_address2 as 'Mailing Address 2',c.mail_city as 'Mailing City'
,c.mail_state_code as 'Mailing State' ,c.mail_zip_code as 'Mailing Zip',c.home_phone_number as 'Home Phone #',c.cell_phone_number as 'Cell Phone #'
,c.work_phone_number as 'Work Phone #'
,c.email,c.death_date
into #tblTemp
from reversequest.rms.v_LoanMaster a
join
[ReverseQuest].[rms].[v_PropertyMaster] b
on a.loan_skey=b.loan_skey
join reversequest.rms.v_ContactMaster c
on a.loan_skey = c.loan_skey
where 
a.loan_status_description in ('DEFAULT', 'FORECLOSURE','BNK/FCL')
and b.state_code ='NY'
and c.contact_type_description in ('Attorney','Borrower','Authorized Party','Co-Borrower','Trustee','Executor',
'Power of Attorney','Guardian','Legal Owner','Conservator','Entitled Non-Borrowing Spouse','Authorized Designee');

select a.loan_sub_status_description as loan_sub_status,a.loan_status_description as loan_status
 from reversequest.rms.v_LoanMaster a where a.loan_skey = '247515';
select * from #tblTemp order by idcol;
select * from #tblTemp where loan_skey ='84103';

IF OBJECT_ID('tempdb..#tblTemp1') IS NOT NULL
    DROP TABLE #tblTemp1;
select a.*,b.tax_authority_name,max(b.post_date) post_date
,e.default_reason,max(e.created_date) created_date into #tblTemp1
from #tblTemp  a
join [ReverseQuest].[rms].[v_TaxPayment] b
on a.loan_skey=b.loan_skey 
inner join  reversequest.rms.v_MonthlyLoanDefaultSummary e
on a.loan_skey=e.loan_skey
--where b.post_date is not null
group by a.idcol,a.loan_skey,a.loan_sub_status,a.loan_status,a.investor_name,a.[Contact Type],a.Borrower,a.[Property Address1],a.[Property Address2]
,a.[Property City],a.[Property State],a.[Property Zip], a.[Mailing Address 1],a.[Mailing Address 2],a.[Mailing City],a.[Mailing State],a.[Mailing Zip]
,a.[Home Phone #],a.[Cell Phone #],a.[Work Phone #],a.email,a.death_date,e.default_reason
,b.tax_authority_name;

select * from #tblTemp1 order by idcol;

IF OBJECT_ID('tempdb..#tblTemp2') IS NOT NULL
    DROP TABLE #tblTemp2;
select * into #tblTemp2 from 
(select ROW_NUMBER() OVER (PARTITION BY idcol ORDER BY created_date desc) rn,* from #tblTemp1 ) q
WHERE   rn = 1
order by idcol

IF OBJECT_ID('tempdb..#tblTemp3') IS NOT NULL
    DROP TABLE #tblTemp3;
	select idcol,a.loan_skey,loan_sub_status, loan_status,[Contact Type], borrower, [Property Address1],[Property Address2],[Property City],[Property State],[Property Zip],
[Mailing Address 1],[Mailing Address 2],[Mailing City],[Mailing State],[Mailing Zip],[Home Phone #],[Cell Phone #],[Work Phone #],email,death_date,tax_authority_name,default_reason
,f.county_clerk_name into #tblTemp3
from #tblTemp2 a
join [ReverseQuest].[rms].[v_PropertyMaster] f
on a.loan_skey = f.loan_skey

select * from #tblTemp3 order by idcol;

select loan_skey,loan_sub_status, loan_status,[Contact Type], borrower, [Property Address1],[Property Address2],[Property City],[Property State],[Property Zip],
[Mailing Address 1],[Mailing Address 2],[Mailing City],[Mailing State],[Mailing Zip],[Home Phone #],[Cell Phone #],[Work Phone #],email,death_date,tax_authority_name,default_reason
,county_clerk_name
from #tblTemp3 order by idcol;

select * from #tblTemp3 where loan_skey = '84103';
select distinct loan_skey from #tblTemp3;