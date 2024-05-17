DECLARE @ActivePipeline AS INT;
set @ActivePipeline = 0;
IF OBJECT_ID('tempdb..#tempTbl') IS NOT NULL
    DROP TABLE #tempTbl;
SELECT [loan_skey],alert_skey
      --,format([created_date],'MM/dd/yyyy') as 'Intake date',
	  ,[created_date] as 'Assignment date',
	  REPLACE(REPLACE(REPLACE(alert_note, CHAR(13),' '), CHAR(10),' '), CHAR(9),' ') as 'Assignment Note'
	  --alert_note as 'Agent note'
	  --,alert_date
      ,[created_by] as 'Assignment By',
       case when alert_note like '%Repeat Call%' then 'Repeat Calls'
	   when alert_note like '%Repeat Complaint%' then 'Repeat Complaints'
	   when alert_note like '%Duplicate Request%' then 'Duplicate Requests'
	   when alert_note like '%Escalation%' then 'Adhoc Requests'
	   when alert_note like '%Open ICW%' then 'Open Cases'
	   end as 'Channel'
	   ,alert_status_description
	   into #tempTbl
  FROM [ReverseQuest].[rms].[v_Alert]
  where alert_type_description = 'Escalation'
  --and alert_status_description = 'Active'
  --and created_date  >=  DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-0, 0)
  and created_date  >=   Convert(datetime, '2022-08-01' )
  and created_date  <   DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0);
  --and created_date  <  Convert(datetime, '2022-12-01' )
  --select * from #tempTbl where loan_skey = '105947';


	IF OBJECT_ID('tempdb..#tempTbl1') IS NOT NULL
    DROP TABLE #tempTbl1;
select distinct x.loan_skey,x.[Assignment date],x.[Assignment Note],x.[Assignment By],x.Channel
--,CASE WHEN MIN(CASE WHEN x.[Intake Date] IS NULL THEN 0 ELSE 1 END) = 0
--        THEN MIN(x.[Intake Date])
--END
,max(x.[Intake Date]) as [Intake Date]
-- ,x.[Intake Date]
,x.alert_skey
,[Intake by] into #tempTbl1
from
(
select distinct a.*,b.created_date as 'Intake Date',b.[Intake by]
	--,datediff(day,a.[Assignment date],b.created_date) as 'Intake in (Days)',
	--case when datediff(day,a.[Assignment date],b.created_date) > 1 or datediff(day,a.[Assignment date],b.created_date) is null then 0 else 1 end as 'Within SLA'
	from #tempTbl a
	join
	(select loan_skey,max(created_date) as created_date,created_by as 'Intake by' from  [ReverseQuest].[rms].[v_Note]
	where note_type_description = 'Specialized Escalation Review' group by loan_skey,created_by
	) b
	on a.loan_skey=b.loan_skey
	and b.created_date>a.[Assignment date]
	union
	select a.*,b.modified_date as 'Intake Date',b.modified_by as 'Intake By'
	--,datediff(day,a.[Assignment date],b.modified_date) as 'Intake in (Days)',
	--case when datediff(day,a.[Assignment date],b.modified_date) > 1 or datediff(day,a.[Assignment date],b.modified_date) is null then 0 else 1 end as 'Within SLA'
	from #tempTbl a
	 join
	( select loan_skey,alert_skey,max(modified_date) as modified_date,modified_by
		from [ReverseQuest].[rms].[v_Alert] where alert_type_description = 'Escalation' and alert_status_description = 'Inactive'
		group by loan_skey,alert_skey,modified_by
		) b
	on a.alert_skey=b.alert_skey ) x
	group by x.loan_skey,x.[Assignment date],x.[Assignment Note],x.[Assignment By],x.Channel,[Intake by],x.alert_skey
	;

	--select * from #tempTbl1 where loan_skey = '105947';

	/*IF OBJECT_ID('tempdb..#tempTbl2') IS NOT NULL
    DROP TABLE #tempTbl2;
	select loan_skey,[Intake Date] into #tempTbl2 
	from #tempTbl1
	where loan_skey in (
	select loan_skey from #tempTbl1 where [Intake Date] is null);*/
	IF OBJECT_ID('tempdb..#tempTbl2') IS NOT NULL
    DROP TABLE #tempTbl2;
	select x.loan_skey,format([Intake Date],'MM/dd/yyyy') as 'Intake Date',format(x.[Assignment date],'MM/dd/yyyy') as 'Date' ,x.alert_skey,NULL as 'Intake in (Bus Days)'
	into #tempTbl2 
	from #tempTbl x
	left join
	#tempTbl1 y on x.alert_skey=y.alert_skey
	where [Intake Date] is null;

	--select loan_skey,count(loan_skey) as 'cnt'
	--from #tempTbl2 group by loan_skey having count(loan_skey) =1;
	--select * from #tempTbl1 where [Intake Date] is null and loan_skey not in (select loan_skey
	--from #tempTbl2 group by loan_skey having count(loan_skey) =1);

/*	select * from (
	select ROW_NUMBER() over (partition by alert_skey order by [Intake Date]) rn,* from #tempTbl1 ) q
	where rn=1
	 ;*/

	
	delete from #tempTbl1 where [Intake Date] is null and loan_skey not in (select loan_skey
	from #tempTbl2 group by loan_skey having count(loan_skey) =1);

	IF OBJECT_ID('tempdb..#tempTbl3') IS NOT NULL
    DROP TABLE #tempTbl3;
	select loan_skey,[Assignment date],[Assignment Note],[Assignment By],Channel
	,max([Intake Date]) as [Intake Date],alert_skey into #tempTbl3
	from 
	(select * from (
	select ROW_NUMBER() over (partition by alert_skey order by [Intake Date]) rn,* from #tempTbl1 ) q
	where rn=1 ) p
	group by loan_skey,[Assignment date],[Assignment Note],[Assignment By],Channel,alert_skey
	order by loan_skey;

		
	IF OBJECT_ID('tempdb..#tempTbl4') IS NOT NULL
    DROP TABLE #tempTbl4;
	select distinct a.loan_skey,format(a.[Assignment date],'MM/dd/yyyy') as 'Date',a.[Assignment Note],a.[Assignment By],a.Channel,
	format(a.[Intake Date],'MM/dd/yyyy') as  'Intake Date' ,b.[Intake by]
	,a.alert_skey
	into #tempTbl4
	from #tempTbl3 a left join (select * from (
	select ROW_NUMBER() over (partition by alert_skey order by [Intake Date]) rn,* from #tempTbl1 ) q
	where rn=1 )  b on a.loan_skey=b.loan_skey and a.alert_skey=b.alert_skey
	--where a.[Intake Date]=b.[Intake Date] 
	order by loan_skey;
  --select * from #tempTbl7 where loan_skey = '105947';
	
	IF OBJECT_ID('tempdb..#tempTbl5') IS NOT NULL
    DROP TABLE #tempTbl5;
	select *
	--,datediff(day,[date],[Intake Date]) as 'Intake in (Days)'
	,(DATEDIFF(dd, [date], [Intake Date]) )
		-(DATEDIFF(WW, [date], [Intake Date]) * 2)
		-CASE			
       WHEN DATEPART(WEEKDAY,[date]) IN (1, 7) THEN 1 ELSE 0			
       END			
       - CASE			
       WHEN DATEPART(WEEKDAY,[Intake Date]) IN (1, 7) THEN 1 ELSE 0		
	   end as 'Intake in (Bus Days)'
	into #tempTbl5
	from #tempTbl4;

	IF OBJECT_ID('tempdb..#tempTbl6') IS NOT NULL
    DROP TABLE #tempTbl6;
	select *,
	case when [Intake in (Bus Days)] is null then
		(DATEDIFF(dd, [date], getdate()) )
			-(DATEDIFF(WW, [date], getdate()) * 2)
			-CASE			
		   WHEN DATEPART(WEEKDAY,[date]) IN (1, 7) THEN 1 ELSE 0			
		   END			
		   - CASE			
		   WHEN DATEPART(WEEKDAY,getdate()) IN (1, 7) THEN 1 ELSE 0		
		   end 
	   else
			[Intake in (Bus Days)]
		end
	   as 'Aging'
	into #tempTbl6
	from #tempTbl5;


	IF OBJECT_ID('tempdb..#tempTbl7') IS NOT NULL
    DROP TABLE #tempTbl7;
	select *,
	case when ([Intake in (Bus Days)] > 2  or [Intake in (Bus Days)] is null and Aging > 2) then 0 else 1 end as 'Within SLA'
	into #tempTbl7
	from #tempTbl6;

	
	--select * from #tempTbl7 where loan_skey = '16600'
	/*select * from #tempTbl3 where [Intake Date] is null;
	select * from #tempTbl4 where [Intake Date] is null;
	select * from #tempTbl5 where [Intake Date] is null;*/
	select * from #tempTbl7 
	where [Date] >=    DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0) 
	order by Date;

	select x.*,y.[Intake Date],case when [Intake in (Bus Days)] is null then
		(DATEDIFF(dd, [date], getdate()) )
			-(DATEDIFF(WW, [date], getdate()) * 2)
			-CASE			
		   WHEN DATEPART(WEEKDAY,[date]) IN (1, 7) THEN 1 ELSE 0			
		   END			
		   - CASE			
		   WHEN DATEPART(WEEKDAY,getdate()) IN (1, 7) THEN 1 ELSE 0		
		   end 
	   else
			[Intake in (Bus Days)]
		end
	   as 'Aging' from #tempTbl x
	join #tempTbl2 y on x.alert_skey=y.alert_skey;

	--select * from #tempTbl1 where alert_skey = '33833344';


	IF OBJECT_ID('tempdb..#tempTbl8') IS NOT NULL
    DROP TABLE #tempTbl8;
	select [Date],
count(Channel) as 'Total Assignments',
sum(case when [Intake date] is not null then 1 else 0 end) as 'Total Intake',
sum(case when [Intake in (Bus Days)] is null and [Within SLA] = 0 then 1 else 0 end) as 'Total Intake Missed',
sum([Within SLA]) as 'Within SLA',
Format(
convert(float,sum([Within SLA]))/convert(float,count(Channel))*100 
,'N2') +'%'as 'SLA %'
into #tempTbl8
from #tempTbl7
group by [Date] order by [Date];


IF OBJECT_ID('tempdb..#tempTbl9') IS NOT NULL
    DROP TABLE #tempTbl9;

with t as (
select [Date],[Total Assignments],[Total Intake],[Total Intake Missed],[Within SLA],[SLA %]
from #tempTbl8)
select t.*,
--sum([Total Intake Missed]) over (order by [Date] ROWS UNBOUNDED PRECEDING) as 'Active Pipeline',
sum([Total Intake]) over (order by [Date] ROWS UNBOUNDED PRECEDING) as 'Tasks Closed(Till Date)'
into #tempTbl9
from t
;

select * from #tempTbl9
where [Date] >=   DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0) 
;

select 
count(Channel) as 'Total Assignments',
sum(case when [Intake date] is not null then 1 else 0 end) as 'Total Intake',
--sum(case when [Intake date] is null then 1 else 0 end) as 'Total Intake Missed',
sum(case when [Intake in (Bus Days)] is null and [Within SLA] = 0 then 1 else 0 end) as 'Total Intake Missed',
sum([Within SLA]) as 'Within SLA',
Format(
convert(float,sum([Within SLA]))/convert(float,count(Channel))*100 
,'N2') +'%'as 'SLA %'
from 
#tempTbl7
where [Date] >=  DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0) 
;


select a.loan_skey,a.[Assignment date] as [Date],a.[Assignment By]
,a.Channel,b.[Intake Date],b.[Intake by],a.alert_skey,b.[Intake in (Bus Days)]
from #tempTbl a
join
#tempTbl7 b
on a.alert_skey=b.alert_skey
where a.alert_status_description = 'Active';