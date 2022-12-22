Create Or Replace Package pk_ik
       AS
       Procedure proc_emp_oku(p_dept departments.department_id%type);
       Function f_reg_name(p_reg regions.region_id%type) Return regions.region_name%type;
End pk_ik;
/

Create Or Replace Package Body pk_ik
       AS
       PROCEDURE proc_emp_oku(p_dept departments.department_id%type)
         IS
       BEGIN 
         For i in (SELECT employee_id, first_name from employees where department_id = p_dept) Loop
           dbms_output.put_line('--------------------------------------------------');
           dbms_output.put_line(i.employee_id || ' ' || i.first_name);
         End Loop;
       END proc_emp_oku;
       
       Function f_reg_name(p_reg regions.region_id%type) 
         Return regions.region_name%type
         IS wname regions.region_name%type;
         BEGIN
           select region_name into wname
           from regions
           where region_id = p_reg;
           
           Return (wname);
         END f_reg_name;
End pk_ik;
/

Begin
  pk_ik.proc_emp_oku(60);
  execute immediate 'select pk_ik.f_reg_name(1) from dual';
End;
/
select pk_ik.f_reg_name(1) from dual;
