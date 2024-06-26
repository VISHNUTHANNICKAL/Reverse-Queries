select  distinct
a.loan_skey,
--a.original_loan_number, 
c.contact_type_description as 'Contact Type'
,CONCAT(c.mail_first_name,' ',c.mail_middle_name,' ',c.mail_last_name) as 'Contact Mail Name' 
--,b.address1 as 'Property Address1',b.address2 as 'Property Address2' ,b.city as 'Property City' 
--,b.state_code as 'Property State',left(b.zip_code,5) as 'Property Zip'
,Upper(c.mail_address1) as 'Mailing Address 1' ,Upper(c.mail_address2) as 'Mailing Address 2',upper(c.mail_city) as 'Mailing City'
,c.mail_state_code as 'Mailing State' ,left(c.mail_zip_code,5) as 'Mailing Zip'
from reversequest.rms.v_LoanMaster a
join reversequest.rms.v_ContactMaster c
on a.loan_skey = c.loan_skey
join reversequest.rms.v_Alert d
on a.loan_skey=d.loan_skey
where c.contact_type_description in ('Borrower'
--,'Co-Borrower'
)
and
a.loan_skey in ('101648',
'109547',
'112395',
'17914',
'203551',
'204138',
'205284',
'205677',
'221481',
'222801',
'231804',
'255896',
'257815',
'264551',
'283018',
'323349',
'45666',
'503914',
'539072',
'222850',
'223501',
'261733',
'262926',
'263631',
'265376',
'265475',
'283333',
'309042',
'125005',
'139009',
'16500',
'239876',
'240210',
'251547',
'281944',
'290953',
'356888',
'64171',
'130987',
'133408',
'148447',
'187874',
'201512',
'208861',
'210922',
'214172',
'215854',
'221213',
'223839',
'224185',
'224659',
'224806',
'235137',
'237295',
'259660',
'265375',
'267905',
'274928',
'281681',
'294899',
'303587',
'319484',
'323202',
'323419',
'357908',
'358119',
'567583',
'82685',
'84322',
'99849',
'111136',
'125419',
'137365',
'18569',
'217921',
'221812',
'228245',
'231998',
'232791',
'236639',
'240343',
'244801',
'251840',
'256847',
'258194',
'261617',
'262515',
'262733',
'263648',
'263947',
'264385',
'264504',
'265050',
'265501',
'266419',
'266623',
'266820',
'280254',
'285294',
'285650',
'300879',
'311825',
'317992',
'356228',
'356989',
'64528',
'107049',
'206242',
'228914',
'258075',
'311626',
'237303')
order by a.loan_skey;
