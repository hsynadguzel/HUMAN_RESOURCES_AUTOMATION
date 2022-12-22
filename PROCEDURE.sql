-- PROCEDURE

-- Numarasi verilen departmanda calisanlari listeleyecegiz.
CREATE OR REPLACE PROCEDURE proc_emp_oku (p_dept departments.department_id%type)
       IS wdeptadi departments.department_name%type;
       BEGIN 
         For i in (SELECT employee_id, first_name from employees where department_id = p_dept) Loop
           dbms_output.put_line('--------------------------------------------------');
           dbms_output.put_line(i.employee_id || ' ' || i.first_name);
         End Loop;
       END;
/

Declare 
Begin
  proc_emp_oku(60);
End;

-- Departments tablosuna haftasonlari kayit girisini engelleyen bir Procedure yazalim.
CREATE OR REPLACE PROCEDURE proc_ins_dept (
          d_id      in departments.department_id%type,
          d_name    in departments.department_name%type,
          d_mng_id  in departments.manager_id%type,
          d_lctn_id in departments.location_id%type,
          d_result  out varchar2
       )IS
       Begin
         Begin
          IF TO_CHAR(sysdate, 'DAY') IN ('CUMARTESI', 'PAZAR') THEN
              d_result := 'CUMARTESI ve PAZAR KAYIT GÝRÝLEMEZ!';
          ELSE 
              INSERT INTO departments VALUES (d_id, d_name, d_mng_id, d_lctn_id);
              d_result := 'KAYIT ISLEMI BASARILI.';
              commit;
          END IF;
          Exception when others then
           d_result := sqlcode || ' ' || sqlerrm; 
         End;
       END proc_ins_dept;
/

DECLARE
  wresult varchar2(3000);
BEGIN 
  proc_ins_dept(d_id => 310, d_name => 'SCHOOL', d_mng_id => null, d_lctn_id => 1700, d_result => wresult);
  dbms_output.put_line(wresult);
END;

-- EMPLOYEES tablosundan ID, LAST_NAME ve SALARY kolonlarini imlec ile okuyalim, Procedure ile veritabanýna kaydedelim.
CREATE OR REPLACE PROCEDURE proc_emp IS
   Cursor c_emp IS select * from employees;
   cw_oku c_emp%rowtype;
BEGIN
  open c_emp;
  loop
    fetch c_emp into cw_oku;
    exit when not c_emp%found;
    dbms_output.put_line('SIRA NUMARASI: ' || c_emp%rowcount
                                || ', SICIL NUMARASI: ' || cw_oku.department_id
                                || ', SOYADI: ' || cw_oku.last_name
                                || ', MAAS: ' || cw_oku.salary
                                );
  end loop;
  close c_emp;
  
  exception when others then
    dbms_output.put_line(sqlcode || ' ' || sqlerrm);
END;
/

Declare
Begin
  proc_emp();
End;


