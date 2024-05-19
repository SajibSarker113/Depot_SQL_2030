SET LINES 88
SET PAGES 1200

SET VER OFF
ACCEPT SC CHAR PROMPT 'SC :'
ACCEPT FL CHAR PROMPT 'FL :'
ACCEPT DATE1 CHAR PROMPT 'DATE1 :'
ACCEPT DATE2 CHAR PROMPT 'DATE2 :'

DROP TABLE RTN_HASAN
/
COMMIT;

CREATE TABLE RTN_HASAN AS
SELECT D.SC_CD,D.RM_ID,D.FM_ID,A.FP_ID,I.EMP_NM,G.FPBS_NM,SUM(A.SALE_NET-A.VAT_AMT)SAL,0 RT,0 RV FROM SCENT.BILL_DET A,PIMS.EMP_MAST B,
SCENT.FP_MGR C,SCENT.BILL_MAS D,PIMS.EMP_MAST I,SCENT.FP_BASE G 
WHERE A.FP_ID=B.EMP_ID 
AND B.EMP_ID=C.FP_ID 
AND C.FL_MVH='&FL' 
AND CANCL IS NULL 
AND A.BILL_NO=D.BILL_NO
AND D.SC_CD='&SC' 
AND D.SC_CD=C.SC_CD
AND D.BS_CD=C.BS_CD  
AND A.FP_ID=I.EMP_ID
AND D.DELI_DT BETWEEN TO_DATE('&DATE1','DDMMYYYY') AND TO_DATE('&DATE2','DDMMYYYY')
AND D.BS_CD=G.FPBS_CD
AND C.BS_CD=G.FPBS_CD
AND D.SC_CD=G.SC_CD
AND G.SC_CD=C.SC_CD
GROUP BY D.SC_CD,D.RM_ID,D.FM_ID,A.FP_ID,I.EMP_NM,G.FPBS_NM
UNION
SELECT A.SC_CD,D.RM_ID,D.FM_ID,A.FP_ID,B.EMP_NM,C.FPBS_NM,0 SAL,SUM(A.RTN_NET-A.R_VAT)RT,0 RV FROM SCENT.RTN_MAS A,SCENT.FP_BASE C,PIMS.EMP_MAST B,SCENT.FP_MGR D
WHERE A.FP_ID=D.FP_ID
AND D.BS_CD=C.FPBS_CD
AND A.SC_CD=D.SC_CD
AND A.SC_CD=C.SC_CD
AND D.SC_CD=C.SC_CD
AND A.FP_ID=B.EMP_ID
AND A.FL_MVH='&FL'
AND A.RSN_NO NOT IN('1','0','2')
AND A.RTN_DT BETWEEN TO_DATE('&DATE1','DDMMYYYY') AND TO_DATE('&DATE2','DDMMYYYY') 
AND A.CANCL IS NULL AND A.SC_CD='&SC'
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
SET NUMFORMAT 999999999
COLUMN ACV FORMAT 999.99
SET UNDERLINE=

TTITLE CENTER 'DEPOT: '&SC'.' SKIP 1 -
CENTER 'FP WISE RETURN' SKIP 1 CENTER ''PERIOD: ''&DATE1''-TO-''&DATE2'' -
 SKIP 2

SPOOL ON

SELECT RM_ID,FM_ID,FP_ID,SUBSTR((EMP_NM),1,20)NM,SUBSTR((FPBS_NM),1,18)FPBS_NM,SUM(SAL)SAL,SUM(RT)RTN,(SUM(RT)/SUM(SAL)*100)ACV FROM RTN_HASAN
GROUP BY RM_ID,FM_ID,FP_ID,EMP_NM,FPBS_NM
ORDER BY RM_ID,FM_ID
/

COMPUTE SUM OF SAL ON RM_ID
COMPUTE SUM OF RTN ON RM_ID
BREAK ON RM_ID

SELECT A.RM_ID,A.FM_ID,SUBSTR((B.EMP_NM),1,20)FM_NM,SUBSTR((C.FMBS_NM),1,25)FMBS_NM,SUM(SAL)SAL,
SUM(RT)RTN,(SUM(RT)/SUM(SAL)*100)ACV FROM RTN_HASAN A, PIMS.EMP_MAST B, SCENT.FM_BASE C
WHERE A.FM_ID=B.EMP_ID 
AND A.FM_ID=C.FM_ID 
AND C.SC_CD='&SC'
GROUP BY A.RM_ID,A.FM_ID,B.EMP_NM,C.FMBS_NM
ORDER BY A.RM_ID,A.FM_ID
/

COMPUTE SUM OF SAL ON RM_ID
COMPUTE SUM OF RTN ON RM_ID
BREAK ON RM_ID

SELECT A.RM_ID,SUBSTR((B.EMP_NM),1,20)RM_NM,SUBSTR((C.RMBS_NM),1,25)RMBS_NM,SUM(SAL)SAL,
SUM(RT)RTN,(SUM(RT)/SUM(SAL)*100)ACV FROM RTN_HASAN A, PIMS.EMP_MAST B, SCENT.RM_BASE C
WHERE A.RM_ID=B.EMP_ID 
AND A.RM_ID=C.RSM_ID 
AND A.SC_CD='&SC'
GROUP BY A.RM_ID,B.EMP_NM,C.RMBS_NM
ORDER BY A.RM_ID
/


SPOOL OFF

ED ON.LST