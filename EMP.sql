select a.emp_id ID, INITCAP(a.emp_nm) EMPLOYEE, INITCAP(b.desg_nm) DESIGNATION
from pims.emp_mast a,pims.emp_desg b
where a.grd_cd=b.grd_cd and
a.desg_cd=b.desg_cd and 
a.emp_id in '&Employee_ID'
order by a.emp_id;


