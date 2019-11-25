/*1*/select * from subject where credit >=5;

/*2*/select student_id, first_name, last_name, name from 
(student join clazz on student.clazz_id = clazz.clazz_id)
where name = 'CNTT 2 K58';

/*3*/select student_id, first_name, last_name, name from 
(student join clazz on student.clazz_id = clazz.clazz_id)
where name like '%CNTT%';

/*4*/select s.student_id, s.first_name, s.last_name 
from student s, enrollment e
where s.student_id = e.student_id and e.subject_id = 'IT4866'
	intersect
select s.student_id, s.first_name, s.last_name 
from student s, enrollment e
where s.student_id = e.student_id and e.subject_id = 'IT3080';
  
/*5*/select s.student_id, s.first_name, s.last_name 
from student s, enrollment e
where s.student_id = e.student_id and e.subject_id = 'IT4866'
        union
select s.student_id, s.first_name, s.last_name 
from student s, enrollment e
where s.student_id = e.student_id and e.subject_id = 'IT3080';

/*6*/select subject.* from subject, enrollment 
where subject.subject_id not in 
(select subject_id from enrollment group by subject_id);

/*select * from subject
	except
select s.* from subject s, enrollment e
where s.subject_id = e.subject_id;*/

/*7*/select s.name, s.credit
from subject s, (student natural join enrollment) as e
where s.subject_id = e.subject_id and e.first_name = 'Hoai An' and e.last_name = 'Nguyen' and e.semester = '20162';

/*8*/select s.student_id, concat_ws(' ', last_name, first_name) as name, e.midterm_score, e.final_score, midterm_score * (1 - sub.percentage_final_exam :: decimal / 100) + e.final_score *  (sub.percentage_final_exam :: decimal / 100) as score 
from student s, enrollment e, subject sub
where s.student_id = e.student_id and sub.subject_id = e.subject_id and sub.name = 'Cơ sở dữ liệu' and e.semester = '20171';

/*9*/select tmp.student_id 
from (select s.student_id, concat_ws(' ', last_name, first_name) as name, e.midterm_score, 		e.final_score, midterm_score * (1 - sub.percentage_final_exam :: decimal / 100) + 		e.final_score *  (sub.percentage_final_exam :: decimal / 100) as score 
	from student s, enrollment e, subject sub
	where s.student_id = e.student_id and sub.subject_id = e.subject_id
	and sub.subject_id = 'IT3090' and e.semester = '20171')as tmp 
where tmp.midterm_score < 3 or tmp.final_score < 3 or tmp.score < 4;

/*10*/select tmp.student_id, tmp.name, tmp.dob, tmp.gender, tmp.address  
from (select s.student_id, concat_ws(' ', last_name, first_name) as name, s.dob, s.gender, 		s.address,
	midterm_score * (1 - sub.percentage_final_exam :: decimal /100) + e.final_score *  		(sub.percentage_final_exam :: decimal / 100) as score 
 	from student s, enrollment e, subject sub
 	where s.student_id = e.student_id and sub.subject_id = e.subject_id 
	and sub.subject_id = 'IT1110' and e.semester = '20171')as tmp
where tmp.score >= all(select midterm_score * (1 - sub.percentage_final_exam :: decimal /100) + e.final_score * (sub.percentage_final_exam :: decimal / 100) as score from enrollment e, subject sub where sub.subject_id = e.subject_id and sub.subject_id = 'IT1110' and e.semester = '20171');

/*11*/select *, extract (year from age(dob)) as age from student where extract (year from age(dob)) >= 31;

/*12*/select * from  student where dob <='1987-06-30' and dob >= '1987-06-01';

/*13*/select s.* from subject s,
(select tmp.subject_id, tmp.count from (select subject_id, count(subject_id) as count from teaching group by subject_id) as tmp where tmp.count >= 2) as temp 
where temp.subject_id = s.subject_id;
/*select * from subject
where subject_id in
(select subject_id from teaching group by subject_id having count(*) >= 2);*/ 

/*14*//*select s.* from subject s,
(select subject_id from (select subject_id, count(subject_id) as count from teaching group by subject_id) as tmp where tmp.count < 2) as temp 
where temp.subject_id = s.subject_id;*/ /*do not count subject that have 0 lecturer*/
/*select * from subject
where subject_id in
(select subject_id from teaching group by subject_id having count(*) < 2);*//*do not count subject that have 0 lecturer*/
select * from subject
where subject_id not in
(select subject_id from teaching group by subject_id having count(*) >= 2);/*count 0-lecturer subjects*/


/*15*/select lecturer_id, last_name || ' ' || first_name as full_name, tmp."number of subjects"
from lecturer l natural join (select lecturer_id, count(subject_id) as "number of subjects" 
	from teaching group by lecturer_id order by lecturer_id asc) tmp;

/*16*/select s.*, tmp."number of students" 
from subject s, (select subject_id,semester, count(student_id) as "number of students" from enrollment group by subject_id, semester having semester = '20172') as tmp 
where tmp.subject_id = s.subject_id and tmp."number of students" >= 5;

/*17*/select clazz_id, count(clazz_id) as number_of_students from student group by(clazz_id);

/*18*/with monitor_name as (select last_name || ' ' || first_name  as monitor_name , s.student_id as monitor from student s), 

lecturer_name as (select last_name || ' ' || first_name as lecturer_name, lecturer_id as lecturer from lecturer )

select s.student_id, s.last_name || ' ' || s.first_name as full_name,

c."name" as class_name, c.monitor_id, m.*, c.lecturer_id, lec.*

from student s, clazz c, lecturer l, monitor_name m, lecturer_name lec

where s.clazz_id = c.clazz_id and c.lecturer_id = l.lecturer_id

and m.monitor = c.monitor_id and lec.lecturer = c.lecturer_id




