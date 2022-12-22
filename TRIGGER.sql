-- TRIGGER

-- Mesai saatleri disinda DML islemleri yapilmasini onleyen trigger yazalim.
CREATE OR REPLACE TRIGGER dml_dept 
       BEFORE INSERT OR UPDATE OR DELETE ON departments
       
BEGIN
  IF TO_CHAR (sysdate, 'HH24:MI') not between '08:00' and '18:00'
    or TO_CHAR (sysdate, 'DAY') in ('CUMARTESI', 'PAZAR') then
    
    raise_application_error(-20205, 'Mesai saatleri dýþýnda veri iþlemi yapýlamaz.');
    
  END IF;
END;
/

delete from departments where department_id = 60;


-- Regions tablosu üzerinde yapýlan dml iþlemlerinin log'unu tutalým.
CREATE TABLE regions_log(
     region_id number
    ,region_name varchar2(25)
    ,kim varchar2(30)
    ,ne_zaman date
    ,ne_yapti varchar2(10)
);
commit;
/

CREATE OR REPLACE TRIGGER regions_audit_trg
       AFTER INSERT OR UPDATE OR DELETE ON regions 
       FOR EACH ROW
DECLARE
  wislem varchar2(10);
BEGIN
  wislem := case
            when INSERTING  then 'INSERT'
            when UPDATING  then 'UPDATE'
            when DELETING then 'DELETE'
            END;
            
  If INSERTING then
    insert into regions_log (region_id, region_name, kim, ne_zaman, ne_yapti) 
           values (:NEW.region_id, :NEW.region_name, USER, sysdate, wislem );
  end if;
  
  If UPDATING then
    insert into regions_log (region_id, region_name, kim, ne_zaman, ne_yapti) 
           values (:OLD.region_id, :OLD.region_name, USER, sysdate, wislem || ' OLD');
    
    insert into regions_log (region_id, region_name, kim, ne_zaman, ne_yapti) 
           values (NVL(:NEW.region_id, :OLD.region_id), 
                   NVL(:NEW.region_name, :OLD.region_name), USER, sysdate, wislem || ' NEW');
  end if;
  
  If DELETING then
    insert into regions_log (region_id, region_name, kim, ne_zaman, ne_yapti) 
           values (:OLD.region_id, :OLD.region_name, USER, sysdate, wislem );
  end if;
END;
/

update regions set region_name = 'Europe' where region_id = 1;
/


