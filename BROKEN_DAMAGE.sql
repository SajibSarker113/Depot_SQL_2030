ACCEPT LOC_CD CHAR PROMPT 'ENTER DEPOT CODE : '
ACCEPT DATE1 CHAR PROMPT 'DATE1 :'
ACCEPT DATE2 CHAR PROMPT 'DATE2 :'


DROP TABLE BROKEN
/
COMMIT
/
CREATE TABLE BROKEN AS 
SELECT DISTINCT DIV_CD, TYP_CD, CAT_CD, PRD_CD, SUM(RV_QTY) RCV_Q , SUM(T_VAT*RV_QTY) TP_VAT
FROM INV.RECV_SUB
WHERE LOC_CD='&&LOC_CD'
AND TYP_CD='09'
--AND  CAT_CD IN('03','05','06')
AND RV_TYP='39' 
AND RCV_FRM='01'
AND IV_NO IN(SELECT DISTINCT IV_NO FROM INV.FG_IV WHERE IV_DT BETWEEN '&&DATE1' AND '&&DATE2' AND IV_TYPE='39' AND LOC_CD='&&LOC_CD') 
AND LOC_CD='&&LOC_CD'
GROUP BY DIV_CD, TYP_CD, CAT_CD, PRD_CD
/
ALTER TABLE BROKEN ADD(ST_DT DATE)
/
ALTER TABLE BROKEN ADD(EN_DT DATE)
/
UPDATE BROKEN SET ST_DT='&&DATE1', EN_DT='&&DATE2'
/
COMMIT
/
DROP TABLE BROK;
CREATE TABLE BROK AS SELECT TYP_CD, SUM(TP_VAT)TOTAL FROM BROKEN
GROUP BY TYP_CD
ORDER BY TYP_CD;

SET LINESIZE 70
SET PAGESIZE 1000
COL TP_VAT FORMAT 9,99,99,999.99
COLUMN PCT FORMAT 999.99

TTITLE CENTER 'DEPOT: '&&LOC_CD'.' SKIP 1 -
CENTER 'BROKEN AND DAMAGE MEDICINE' SKIP 1 CENTER ''PERIOD: ''&&DATE1''-TO-''&&DATE2'' -
 SKIP 2


COMPUTE SUM OF TP_VAT ON DIV_CD
COMPUTE SUM OF TP_VAT PCT ON REPORT
BREAK ON REPORT ON DIV_CD

SPOOL ON

SELECT DISTINCT A.DIV_CD, A.CAT_CD||A.PRD_CD CODE, INITCAP(SUBSTR(RPAD(B.PROD_NM,'25'),1,25)) PROD_NM, A.RCV_Q, A.TP_VAT, SUM((A.TP_VAT/C.TOTAL)*100) PCT
FROM BROKEN A, SCENT.INV_PROD B, BROK C
WHERE A.TYP_CD=B.TYP_CD 
AND A.CAT_CD=B.CAT_CD 
AND A.PRD_CD=B.PRD_CD 
AND A.TYP_CD=C.TYP_CD 
AND B.TYP_CD=C.TYP_CD 
AND B.TYP_CD='09' 
GROUP BY A.DIV_CD,A.CAT_CD||A.PRD_CD,PROD_NM,A.RCV_Q,A.TP_VAT
ORDER BY A.DIV_CD,PCT,A.CAT_CD||A.PRD_CD,PROD_NM,A.RCV_Q
/

SPOOL OFF

ED ON.LST

DROP TABLE BROKEN
/
