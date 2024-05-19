DROP TABLE SS;

CREATE TABLE SS AS
Select distinct a.fp_id, a.cl_id, SUBSTR(initcap(c.cl_nm),1,20) cl_nm, a.sale_cd, a.bill_no, a.deli_dt, Nvl(Sum(a.sale_net),0) Bill_amnt,
(select NVL(sum(AMNT),0) from scent.out_det d where sc_cd='&&SC_CD' and d.bill_no=a.bill_no and moa='R') RTN,
(Nvl(Sum(a.sale_net),0))-(select (Nvl(sum(AMNT),0)) from scent.out_det d where sc_cd='&&SC_CD' and d.bill_no=a.bill_no and moa='R') NET_SALE,To_date(B.out_dt) COLLEC_DATE,
(select sum(AMNT) from scent.out_det d where sc_cd='&&SC_CD' and d.bill_no=a.bill_no and moa='C' 
and d.out_dt between TO_DATE('&&DATE1',' DDMMYYYY') AND TO_DATE('&&DATE2',' DDMMYYYY')) COLLEC_AMNT,
To_date(B.out_dt)-to_date(a.deli_dt) Days
from scent.bill_mas a, scent.out_det b, scent.cl_info c
where a.sc_cd='&&SC_CD' and a.sc_cd=b.sc_cd and a.sc_cd=c.sc_cd and b.out_dt between TO_DATE('&&DATE1',' DDMMYYYY') AND TO_DATE('&&DATE2',' DDMMYYYY') and  
a.fl_mvh='2' and
a.bill_no=b.bill_no and
a.dist_cd=c.dist_cd and
a.tha_cd=c.tha_cd and
a.un_cd=c.un_cd and
a.cl_id=c.cl_id and
a.sale_cd in ('RS') and
SEQ=(Select MAX(SEQ) from SCENT.out_det where a.sc_cd=sc_cd and a.bill_no=bill_no and sc_cd='&&SC_CD') 
group by a.fp_id, a.cl_id, a.sale_cd, a.bill_no, a.deli_dt, c.cl_nm, b.out_dt
having (b.out_dt-a.deli_dt)>'31'
order by a.fp_id;

SET LINES 135
SET PAGES 300
col COLLEC_AMNT format 999,99,99,999.99

COMPUTE SUM OF Bill_amnt RTN NET_SALE COLLEC_AMNT ON REPORT
COMPUTE COUNT OF BILL_NO ON REPORT
BREAK ON REPORT ON REPORT SKIP-1

TTITLE CENTER 'Depot: '&&SC_CD'....' SKIP 1 -
CENTER 'Delay Collection RS' SKIP 1 CENTER ''Period : ''&&DATE1'' -to- ''&&DATE2'' -
RIGHT 'More than 31 Days' SKIP 2

SPOOL ON

SELECT FP_ID,CL_ID,CL_NM,SALE_CD,BILL_NO,DELI_DT,BILL_AMNT,RTN,NET_SALE,COLLEC_DATE,COLLEC_AMNT,ROUND(SUM(COLLEC_AMNT*100/BILL_AMNT)) PER,DAYS
FROM SS
GROUP BY FP_ID,CL_ID,CL_NM,SALE_CD,BILL_NO,DELI_DT,BILL_AMNT,RTN,NET_SALE,COLLEC_DATE,COLLEC_AMNT,DAYS
ORDER BY DAYS,FP_ID;

SPOOL OFF

ED ON.LST

DROP TABLE SS;