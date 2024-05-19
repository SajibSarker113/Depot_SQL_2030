SET LIN 200
SET PAGES 2500

Select bill_no,OUT_DT,Nvl(sum(amnt),0) camnt,MOA
           from scent.out_det 
                   where
                     MOA IN('C','A')
                     and sc_cd  = '16'
                     and out_dt between '18OCT20' AND '18oct21'
                     GROUP BY BILL_NO,OUT_DT,MOA
                     ORDER BY 2;