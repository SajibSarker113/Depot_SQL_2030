SET PAGES 1500
SELECT DISTINCT SC_CD, RMT_NO, RMT_DT, FP_ID, RMT_AMT, FL_MVH, SR_ID, CANCL_REASON FROM SCENT.REMIT_MAS WHERE SC_CD='&SC_CD' AND CANCL='C' AND RMT_DT
BETWEEN '&&Date1' AND '&&Date2'
ORDER BY RMT_DT
/  