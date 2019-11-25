-- trigger func after insert
create or replace function tg_af_insert_student_test() returns trigger as
$$
begin
	return NULL;
end;
$$
language plpgsql;

-- trigger after insert
create trigger af_insert_test
after insert on student
for each row
execute procedure tg_af_insert_student_test();
-/*drop trigger af_insert_test on student;*/

-- trigger before insert (ignore if return null) (still insert if return new)
create trigger bf_insert_test
before insert on student
for each row
execute procedure tg_af_insert_student_test(); 
/*drop trigger bf_insert_test on student;*/

/*When a new student arrives (a new record is inserted into student table), the
number of students in her/his class must be automatically updated*/
-- define a trigger function
create or replace function tf_af_insert() returns trigger as $$
begin
	update clazz set number_students = update_number_students() + 1
	where clazz_id = NEW.clazz_id;
	return new;
end;
$$ language plpgsql;

-- define a trigger
create trigger af_insert
after insert on student
for each row
when (NEW.clazz_id is not null)
execute procedure tf_af_insert();

create or replace function tg_af_idu_student() returns trigger as
$$
begin
	if (TG_OP = 'INSERT') and (NEW.clazz_id is not null) then
		update clazz set number_students = number_students + 1
		where clazz_id = NEW.clazz_id;
	elsif (TG_OP = 'UPDATE') and (OLD.clazz_id is distinct from NEW.clazz_id) then
		update clazz set number_students = number_students + 1
		where clazz_id = NEW.clazz_id;
		
		update clazz set number_students = number_students - 1
		where clazz_id = OLD.clazz_id;
	elsif (TG_OP = 'DELETE') and (OLD.clazz_id is not null) then
		update clazz set number_students = number_students - 1
		where clazz_id = OLD.clazz_id;
	end if;
return NULL;
end;
$$
language plpgsql;

create trigger af_idu_student
after insert or update or delete on student
for each row
execute procedure tg_af_idu_student(); 

create or replace function tf_check_enrollment() returns trigger as
$$
declare int tmp = 0;
begin
	select into tmp count(student_id) from enrollment where subject_id = NEW.subject_id and semester = NEW.semester;
	if (TG_OP = 'INSERT') and (tmp < 200) then
		return NEW;
	elsif (TG_OP = 'INSERT') and (tmp >= 200) then
		return NULL;
	elsif (TG_OP = 'UPDATE') and (((OLD.student_id is distinct from NEW.student_id) or (OLD.subject_id is distinct from NEW.subject_id) or (OLD.semester is distinct from NEW.semester)) and (tmp < 200)) then
		return NEW;
	elsif (TG_OP = 'UPDATE')
		return NULL;
	end if; 
	
return NULL;
end;
$$s
language plpgsql;

create trigger tg_bf_check_enrollment
before insert or update on enrollment
for each row
execute procedure function tf_check_enrollment
