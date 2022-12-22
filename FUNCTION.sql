-- Function

-- Numarasi verilen departmanin ismini listeleyecegiz.
CREATE OR REPLACE FUNCTION d_name(p_dept departments.department_id%type)
       RETURN departments.department_name%type
       IS wname departments.department_name%type;
       Begin
         select departments.department_name into wname
         from departments
         where departments.department_id = p_dept;

         RETURN wname;
       End;
/
SELECT d_name(60) FROM DUAL;

-- EMPLOYEE ID'si girilen calisanin is gecmisini listeleyecegiz.
CREATE OR REPLACE FUNCTION d_emp (p_emp employees.employee_id%type)
       RETURN varchar2
       IS 
              w_start_date job_history.start_date%type;
              w_end_date   job_history.end_date%type;
              w_job_id     job_history.job_id%type;
              w_dept_id    job_history.department_id%type;
              w_result     varchar2(150);
       Begin
         select jh.start_date, jh.end_date, jh.job_id, jh.department_id
         into w_start_date, w_end_date, w_job_id, w_dept_id
         from job_history jh
         where jh.employee_id = p_emp;
         
         w_result := (w_start_date || ' - ' || w_end_date || ' - ' || w_job_id || ' - ' || w_dept_id);
         
         RETURN w_result;
       End;
/

SELECT d_emp(102) FROM DUAL;
