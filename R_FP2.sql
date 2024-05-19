SET LINES 170
SET PAGES 1200

SET VER OFF
accept SC char prompt 'SC :'
accept FL char prompt 'FL :'
accept Date1 char prompt 'Date1 :'
accept Date2 char prompt 'Date2 :'

DROP TABLE RTN_HASAN
/
COMMIT;

CREATE TABLE RTN_HASAN AS
select C.SC_CD,C.RM_ID,C.FM_ID,A.FP_ID,I.EMP_NM,G.FPBS_NM,sum(A.SALE_NET-A.VAT_AMT)SAL,0 RT,0 RV from scent.bill_DET a,pims.emp_mast b,
scent.FP_MGR C,scent.bill_mas d,PIMS.EMP_MAST I,SCENT.FP_BASE G where a.fp_id=b.emp_id and
B.EMP_ID=C.FP_ID AND c.fl_mvh='&FL' and
cancl is null and a.bill_no=d.bill_no
and d.sc_cd='&SC' AND D.SC_CD=C.SC_CD
AND D.BS_CD=C.BS_CD AND A.FP_ID=I.EMP_ID
and D.DELI_dt between TO_DATE('&DATE1','DDMMYYYY') and TO_DATE('&DATE2','DDMMYYYY')
AND D.BS_CD=G.FPBS_CD
AND C.BS_CD=G.FPBS_CD
AND D.SC_CD=G.SC_CD
AND G.SC_CD=C.SC_CD
group by C.SC_CD,C.RM_ID,C.FM_ID,A.FP_ID,I.EMP_NM,G.FPBS_NM
UNION
SELECT A.SC_CD,D.RM_ID,D.FM_ID,A.FP_ID,B.EMP_NM,C.FPBS_NM,0 SAL,SUM(A.RTN_NET-A.R_VAT)RT,0 RV FROM SCENT.RTN_MAS A,SCENT.FP_BASE C,PIMS.EMP_MAST B,SCENT.FP_MGR D
WHERE A.FP_ID=D.FP_ID
AND D.BS_CD=C.FPBS_CD
AND A.SC_CD=D.SC_CD
AND A.SC_CD=C.SC_CD
AND D.SC_CD=C.SC_CD
AND A.FP_ID=B.EMP_ID
AND A.FL_MVH='&FL'
AND A.RSN_NO NOT IN ('0','1','2')
AND A.RTN_DT BETWEEN TO_DATE('&DATE1','DDMMYYYY') and TO_DATE('&DATE2','DDMMYYYY') AND A.CANCL IS NULL AND A.SC_CD='&SC'
GROUP BY A.SC_CD,D.RM_ID,D.FM_ID,A.FP_ID,B.EMP_NM,C.FPBS_NM
/
UPDATE RTN_HASAN SET SAL='.01' WHERE SAL='0'
/
UPDATE RTN_HASAN SET RT='.01' WHERE SAL='0'
/


COMPUTE SUM OF SAL ON RM_ID
COMPUTE SUM OF SAL ON FM_ID
COMPUTE SUM OF RTN ON RM_ID
COMPUTE SUM OF RTN ON FM_ID
BREAK ON RM_ID ON FM_ID

SET VER OFF
set numformat 999999999
column acv format 999.99
SET UNDERLINE=

SELECT RM_ID,FM_ID,FP_ID,SUBSTR((EMP_NM),1,20)NM,SUBSTR((FPBS_NM),1,18)FPBS_NM,SUM(SAL)SAL,SUM(RT)RTN,(SUM(RT)/SUM(SAL)*100)ACV FROM RTN_HASAN
GROUP BY RM_ID,FM_ID,FP_ID,EMP_NM,FPBS_NM
ORDER BY RM_ID,FM_ID
/

COMPUTE SUM OF SAL ON RM_ID
COMPUTE SUM OF RTN ON RM_ID
BREAK ON RM_ID

SELECT A.RM_ID,A.FM_ID,SUBSTR((B.EMP_NM),1,20)FM_NM,substr((C.FMBS_NM),1,25)FMBS_NM,SUM(SAL)SAL,
SUM(RT)RTN,(SUM(RT)/SUM(SAL)*100)ACV FROM RTN_HASAN A, PIMS.EMP_MAST B, SCENT.FM_BASE C
WHERE A.FM_ID=B.EMP_ID AND A.FM_ID=C.FM_ID AND C.SC_CD='&SC'
GROUP BY A.RM_ID,A.FM_ID,B.EMP_NM,C.FMBS_NM
ORDER BY A.RM_ID,A.FM_ID
/

COMPUTE SUM OF SAL ON RM_ID
COMPUTE SUM OF RTN ON RM_ID
BREAK ON RM_ID

SELECT A.RM_ID,SUBSTR((B.EMP_NM),1,20)RM_NM,substr((C.RMBS_NM),1,25)RMBS_NM,SUM(SAL)SAL,
SUM(RT)RTN,(SUM(RT)/SUM(SAL)*100)ACV FROM RTN_HASAN A, PIMS.EMP_MAST B, SCENT.RM_BASE C
WHERE A.RM_ID=B.EMP_ID AND A.RM_ID=C.RSM_ID AND A.SC_CD='&SC'
GROUP BY A.RM_ID,B.EMP_NM,C.RMBS_NM
ORDER BY A.RM_ID
/


DROP TABLE RTN_HASAN;

-------select sum(rtn_net-r_vat) from scent.rtn_mas where rtn_dt between '01feb21'and '28feb21'and fl_mvh='1'and rsn_no not in('1','0','4') and cancl is null and sc_cd='28'
-------select sum(rtn_net-r_vat) from scent.rtn_mas where rtn_dt between '01feb21'and '28feb21'and fl_mvh='2'and rsn_no not in('1','0','4') and cancl is null and sc_cd='28'
