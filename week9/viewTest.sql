/*1*/create view student_shortinfos as
	SELECT student_id, last_name, first_name, gender, dob from student;
--updateable

/*2*/create or replace view student_class_shortinfos as
	select s.student_id, s.first_name, s.last_name, s.gender, c.clazz_id, c.name 
	from student s right join clazz c on s.clazz_id = c.clazz_id;
--non updateable

/*3*/create view class_infos as
	select clazz.clazz_id, name, count(student_id) as number_of_student 
	from student right join clazz on student.clazz_id = clazz.clazz_id 
	group by clazz.clazz_id;
--non updateable

create or replace function insert_class_view_func() returns trigger as 
$$
begin
	insert into clazz values(new.clazz_id, new.name);
	return new;
end;
$$ language plpgsql volatile;

create trigger insert_class_view
instead of insert on class_infos
for each row
execute procedure insert_class_view_func();

create or replace function delete_class_view_func() returns trigger as 
$$
begin
	delete from student where clazz_id = old.clazz_id;
	delete from clazz where clazz_id = old.clazz_id;
	return old;
end;
$$ language plpgsql volatile;

create trigger delete_class_view
instead of delete on class_infos
for each row
execute procedure delete_class_view_func();
