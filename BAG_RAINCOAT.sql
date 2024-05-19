ACCEPT SC_NO CHAR PROMPT 'ENTER YOUR DEPOT CODE : '
set pages 5000
SET LINES 93


SPOOL ON

SELECT M.FP_ID,S.CAT_CD||S.PRD_CD,INITCAP(N.PROD_NM),SUM(SAM_QTY) SAM_QTY,SUM(SAM_QTY*SAM_VAL) SAM_VAL
FROM SCENT.SAMP_DET S,SCENT.INV_PROD N,SCENT.SAMP_MAS M
WHERE S.SC_NO='&SC_NO' AND M.SC_NO='&SC_NO' 
AND S.BILL_V_NO=M.BILL_V_NO
AND M.BILL_V_DT BETWEEN '&&Date1' AND '&&Date2' AND M.CANCL IS NULL
AND S.CAT_CD||S.PRD_CD IN('011018','051056','011010') 
AND S.TYP_CD='06'
AND N.TYP_CD='06'
AND S.CAT_CD||S.PRD_CD=N.CAT_CD||N.PRD_CD
GROUP BY  M.FP_ID,S.CAT_CD||S.PRD_CD,N.PROD_NM
ORDER BY  SAM_QTY, N.PROD_NM, M.FP_ID
/


--with Bill_no
set pages 5000
SET LINES 93
SELECT M.FP_ID,S.CAT_CD||S.PRD_CD,INITCAP(N.PROD_NM),M.BILL_V_NO, M.BILL_V_DT, SUM(SAM_QTY) SAM_QTY,SUM(SAM_QTY*SAM_VAL) SAM_VAL
FROM SCENT.SAMP_DET S,SCENT.INV_PROD N,SCENT.SAMP_MAS M
WHERE S.SC_NO='&SC_NO' AND M.SC_NO='&SC_NO' 
AND S.BILL_V_NO=M.BILL_V_NO
AND M.BILL_V_DT BETWEEN '&&Date1' AND '&&Date2' AND M.CANCL IS NULL
AND S.CAT_CD||S.PRD_CD IN('011018','051056','011010') 
AND S.TYP_CD='06'
AND N.TYP_CD='06'
AND S.CAT_CD||S.PRD_CD=N.CAT_CD||N.PRD_CD
GROUP BY  M.FP_ID,S.CAT_CD||S.PRD_CD,N.PROD_NM,M.BILL_V_NO, M.BILL_V_DT
ORDER BY  M.FP_ID,S.CAT_CD||S.PRD_CD,N.PROD_NM,M.BILL_V_NO
/

SPOOL OFF

ED ON.LST