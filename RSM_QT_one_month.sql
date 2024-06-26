
SET LINES 70

COMPUTE SUM OF QTY ON REPORT
COMPUTE SUM OF SAM_VAL ON REPORT
COMPUTE SUM OF SAM_QTY ON REPORT
COMPUTE SUM OF SAM_VAL ON FM_ID
COMPUTE SUM OF SAM_VAL ON RM_ID
COMPUTE SUM OF SAM_VAL ON REPORT
COMPUTE SUM OF SAM_VAL ON REPORT

BREAK ON RM_ID ON REPORT

BREAK ON RM_ID ON FM_ID ON FP_ID ON CAT_CD ON PRD_CD ON PROD_NAME ON FM_ID ON REPORT

COLUMN TARG  FORMAT 9999
COLUMN QTY  FORMAT 9999
COLUMN SAM_VAL FORMAT 999999.99
COLUMN ACHV FORMAT 999.99


SPOOL ON

SELECT DISTINCT C.RM_ID, C.FM_ID, a.PROM_CAT, A.FP_ID, A.BILL_V_DT,W_DT, SUBSTR((A.REMARKS),1,10) REMARKS, B.BILL_V_NO, SUM(B.SAM_VAL)SAM_VAL   
FROM SCENT.SAMP_MAS A, SCENT.SAMP_DET B,SCENT.FP_MGR C, SCENT.INV_PROD D
	WHERE A.SC_NO='&&SC_CD'
	AND A.SC_NO=B.SC_NO
	AND A.SC_NO=C.SC_CD
	and a.fl_mvh=C.FL_MVH
	AND C.FL_MVH=D.DIV_CD
	---AND C.RM_ID IN('20041')
	AND A.BILL_v_DT>='&DATE1' AND A.BILL_V_DT<='&DATE2'
	AND A.BILL_V_NO=B.BILL_V_NO  
	AND A.FP_ID=C.FP_ID
	AND B.TYP_CD=D.TYP_CD
	AND B.CAT_CD||B.PRD_CD=D.CAT_CD||D.PRD_CD
	AND B.TYP_CD='09'
	AND A.PROM_CAT IN('18')
	AND CANCL IS NULL 
	AND C.STATUS NOT IN('P')
group by C.RM_ID, C.FM_ID, a.PROM_CAT, A.FP_ID, A.BILL_V_DT, W_DT, A.REMARKS, B.BILL_V_NO
ORDER BY C.RM_ID, B.BILL_V_NO, RM_ID, C.FM_ID, FP_ID
/

SPOOL OFF
ED ON.LST