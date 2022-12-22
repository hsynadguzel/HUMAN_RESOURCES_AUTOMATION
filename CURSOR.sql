-- CURSOR

-- EMPLOYEES tablosundan ID, LAST_NAME ve SALARY kolonlarini imlec ile okuyalim.
DECLARE
   Cursor c_emp IS select * from employees;
   cw_oku c_emp%rowtype;
BEGIN
  if not c_emp%isopen then
     open c_emp;
  end if;
  loop
    fetch c_emp into cw_oku;
    exit when not c_emp%found;
    dbms_output.put_line('SIRA NUMARASI: ' || c_emp%rowcount
                                || ', SICIL NUMARASI: ' || cw_oku.department_id
                                || ', SOYADI: ' || cw_oku.last_name
                                || ', MAAS: ' || cw_oku.salary
                                );
  end loop;
  if c_emp%isopen then
     close c_emp;
  end if;
  
  exception when others then
    dbms_output.put_line(sqlcode || ' ' || sqlerrm);
END;

