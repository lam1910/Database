CREATE FUNCTION store.test(IN val1 int4, IN val2 int4, out result
int4) AS
$$DECLARE vmultiplier int4 := 3;
BEGIN
result := val1 * vmultiplier + val2;
END; $$
LANGUAGE plpgsql;

select store.test(10, 25);


CREATE FUNCTION clazzes(IN clazzid char(8), out result
int4) AS
$$
BEGIN
select into result count(s.student_id) as number from student s where s.clazz_id = clazzid;
END; $$
LANGUAGE plpgsql;

select clazzes('20162101')

CREATE FUNCTION clazzes(IN clazzid char(8), out result
int4) AS
$$declare rsl int := 0;
BEGIN
select into rsl count(*) as number from student s where s.clazz_id = clazzid;
result := rsl;
END; $$
LANGUAGE plpgsql
immutable
returns null on null input;

select clazzes('2017220')

select clazzes(null)

grant execute on function clazzes to fred;
grant select on student to fred;


CREATE FUNCTION clazzes(IN clazzid char(8), out result
int4) AS
$$ declare rsl int := 0;
BEGIN
select count(*) into rsl from student where clazz_id = clazzid;
result := rsl;
END; $$
LANGUAGE plpgsql
immutable
returns NULL on NULL input
security definer;     --<<<<<<<< when fred calls this function, he doesnt has permission
-- postgres account:
--  nbrstudent().... security definer;
-- number_student() ... security invoker; (by default)
--definer : superuser (postgres)
	 --when fred calls nbrstudent() <--- permission of postgres account;
	 --                number_student() <--- permission of fred account.


alter table clazz add column number_students integer;


create or replace function update_number_students() returns int as
$$
declare
	clazz_var clazz%rowtype;
	number_std integer;
begin
	for clazz_var in (select * from clazz) loop
		select into number_std count(*)
		from student
		where clazz_id = clazz_var.clazz_id;
		
		update clazz set number_students = number_std
		where clazz_id = clazz_var.clazz_id;
	end loop;
	return 1;
end;
$$
LANGUAGE plpgsql

or 
(without loop:)

create or replace function update_number_students() returns int as
$$
declare
	clazz_var clazz%rowtype;
	number_std integer;
begin
	update clazz c 
	set number_students = (select count(*) from student where clazz_id = c.clazz_id);
	return 1;
end;
$$
LANGUAGE plpgsql

Q: Why do we need to write functions?
A: -reduce the function defined on database engine
   -not server side, without transform data

Homework: read second slides about trigger, midterm next week

