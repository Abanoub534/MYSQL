SELECT *
FROM employee_demographics;
# TRIGGERSSSSSSS
DELIMITER $$
CREATE TRIGGER employee_insert # اعملي تريجر بأسم كذا
	AFTER INSERT ON employee_salary # التريجر هيشتغل في الحالة دي
    FOR EACH ROW # معناها ان التريجر دي تشتغل مرة لكل صف يتأثر بالعملية , يعني مثلا لو احنا بنعمل تحديث لمرتبات الموظفين وبنعملهم جدول وحدهم فية المرتبات قبل وبعد ومثلا فية 5 موظفين مرتباتهم زادت ساعتها التريجر هتشتغل 5 مرات 
BEGIN
	INSERT INTO employee_demographics (employee_id, first_name, last_name)
    VALUES (NEW.employee_id, NEW.first_name, NEW.last_name);
END $$ # دة الفعل اللي التريجر هيعمله
DELIMITER ;

INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES(13, 'Abanoub', 'Emad', 'CEO', 250000, NULL);



#EVENTSSSSSSSS
#know look you can use events in this way 
DELIMITER $$
CREATE EVENT delete_retires  # اعملي حدث اسمه كذا
ON SCHEDULE EVERY 1 MONTH # كرر الحدث دة كل فترة قد كدة 
DO  # اعمل في الحدث دة كدة 
BEGIN
	DELETE 
    FROM employee_demographics
    WHERE age >= 60;
END $$
DELIMITER ;


















