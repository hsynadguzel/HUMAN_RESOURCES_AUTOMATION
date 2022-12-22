-- REGIONS TABLOSU (Bölgeler)
CREATE TABLE regions(
       region_id NUMBER NOT NULL 
       ,region_name VARCHAR2(25) 
);

ALTER TABLE regions ADD(
      CONSTRAINT reg_id_pk PRIMARY KEY (region_id)
);

-- COUNTRIES TABLOSU (Ülkeler)
CREATE TABLE countries(
       country_id CHAR(2) NOT NULL 
       ,country_name VARCHAR2(40) 
       ,region_id NUMBER 
);
   
ALTER TABLE countries ADD(
      CONSTRAINT countr_reg_fk FOREIGN KEY (region_id) REFERENCES regions(region_id),
      CONSTRAINT country_c_id_pk PRIMARY KEY (country_id) 
);

-- LOCATIONS TABLOSU (Lokasyon)
CREATE TABLE locations(
       location_id NUMBER(4)
       ,street_address VARCHAR2(40)
       ,postal_code VARCHAR2(12)
       ,city VARCHAR2(30) NOT NULL
       ,state_province VARCHAR2(25)
       ,country_id CHAR(2)
);

ALTER TABLE locations ADD(
      CONSTRAINT loc_id_pk PRIMARY KEY (location_id), 
      CONSTRAINT loc_c_id_fk FOREIGN KEY (country_id) REFERENCES countries(country_id) 
);

--  DEPARTMENTS TABLOSU (Departman)
CREATE TABLE departments(
       department_id NUMBER(4)
       ,department_name VARCHAR2(30) NOT NULL
       ,manager_id NUMBER(6)
       ,location_id NUMBER(4)
);

ALTER TABLE departments ADD(
      CONSTRAINT dept_id_pk PRIMARY KEY (department_id),
      CONSTRAINT dept_loc_fk FOREIGN KEY (location_id) REFERENCES locations (location_id)
);

-- JOBS TABLOSU (Meslekler)
CREATE TABLE jobs( 
       job_id VARCHAR2(10)
       ,job_title VARCHAR2(35) NOT NULL
       ,min_salary NUMBER(6)
       ,max_salary NUMBER(6)
);

ALTER TABLE jobs ADD( 
      CONSTRAINT job_id_pk PRIMARY KEY(job_id)
);

-- EMPLOYEES TABLOSU (Çalışanlar)
CREATE TABLE employees(
       employee_id NUMBER(6)
       ,first_name VARCHAR2(20)
       ,last_name VARCHAR2(25) NOT NULL
       ,email VARCHAR2(25) NOT NULL
       ,phone_number VARCHAR2(20)
       ,hire_date DATE NOT NULL
       ,job_id VARCHAR2(10) NOT NULL
       ,salary NUMBER(8,2)
       ,commission_pct NUMBER(2,2)
       ,manager_id NUMBER(6)
       ,department_id NUMBER(4)
       ,CONSTRAINT emp_salary_min CHECK (salary > 0) 
       ,CONSTRAINT emp_email_uk UNIQUE (email)
);

       
ALTER TABLE employees ADD(
      CONSTRAINT emp_emp_id_pk PRIMARY KEY (employee_id), 
      CONSTRAINT emp_dept_fk FOREIGN KEY (department_id) REFERENCES departments, 
      CONSTRAINT emp_job_fk FOREIGN KEY (job_id) REFERENCES jobs (job_id), 
      CONSTRAINT emp_manager_fk FOREIGN KEY (manager_id) REFERENCES employees
) ;

ALTER TABLE departments ADD (
      CONSTRAINT dept_mgr_fk FOREIGN KEY (manager_id) REFERENCES employees (employee_id)
);

-- JOB HISTORY TABLOSU (Meslek geçmişi)
CREATE TABLE job_history( 
       employee_id NUMBER(6) NOT NULL
       ,start_date DATE NOT NULL
       ,end_date DATE NOT NULL
       ,job_id VARCHAR2(10) NOT NULL
       ,department_id NUMBER(4)
       ,CONSTRAINT jhist_date_interval CHECK (end_date > start_date)
);

ALTER TABLE job_history ADD( 
      CONSTRAINT jhist_emp_id_st_date_pk PRIMARY KEY (employee_id, start_date), 
      CONSTRAINT jhist_job_fk  FOREIGN KEY (job_id) REFERENCES jobs, 
      CONSTRAINT jhist_emp_fk FOREIGN KEY (employee_id) REFERENCES employees, 
      CONSTRAINT jhist_dept_fk FOREIGN KEY (department_id) REFERENCES departments
);
