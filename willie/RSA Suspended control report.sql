IF OBJECT_ID('tempdb..#tblTemp') IS NOT NULL
    DROP TABLE #tblTemp;
select 
a.loan_skey,
concat(c.first_name,' ',c.middle_name,' ',c.last_name) as 'Borrower Name',
a.loan_status_description,
a.loan_sub_status_description,
a.payment_status_description,
a.closing_date,
b.repair_completion_due_date,
b.repair_set_aside_amount
into #tblTemp
from [ReverseQuest].[rms].[v_WorkflowInstance] b
join ReverseQuest.rms.v_LoanMaster a  on b.loan_skey=a.loan_skey
join ReverseQuest.rms.v_ContactMaster c on a.loan_skey=c.loan_skey 
where 
a.loan_status_description in('ACTIVE')
and b.repair_set_aside_amount > 0
and b.workflow_type_description='Repairs'
and b.repair_completion_due_date > GETDATE()
--and a.loan_skey=(select distinct loan_skey from ReverseQuest.rms.v_ContactMaster order by loan_skey)
--and a.loan_skey='225270'
order by a.loan_skey

select * from #tblTemp

IF OBJECT_ID('tempdb..#tblfinal') IS NOT NULL
    DROP TABLE #tblfinal;
select * 
into #tblfinal from
(select ROW_NUMBER() OVER (PARTITION BY [Borrower Name],loan_skey order by loan_skey) rownum,* from #tblTemp) x
WHERE  
rownum  =1;
select * from #tblfinal;
--select top 10 * from ReverseQuest.rms.v_ContactMaster where loan_skey='225270'

--select top 10 * from ReverseQuest.rms.v_LoanMaster where loan_skey='225270'

--select * from [ReverseQuest].[rms].[v_WorkflowInstance] where loan_skey='225270'