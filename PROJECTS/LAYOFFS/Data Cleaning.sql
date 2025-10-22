#Data Cleaning
SELECT* 
FROM layoffs;

/* we clean the data in several steps
 1. Remove Duplicates  
 2. Standerdize the data 
 3. NULL values or BLANCK values 
 4. Remove any coulmns that we dont need
 */
 
 #1. Remove Duplicates
 
 CREATE TABLE layoffs_staging # 1- عملنا نسخة من الداتا الحقيقية علشان نلعب براحتنا 
 LIKE layoffs;
 
 SELECT * 
 FROM layoffs_staging; # تمام اخدنا كوبي من التابل 
 
 INSERT layoffs_staging
 SELECT * 
 FROM layoffs; # كدة اخدنا كمان كل الداتا اللي كانت في التابل الرئيسية حطيناها في التابل التانية , نبدأ شغل 
 
 
 
 
 
# 1. remove daplicates 

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER () OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,
`date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
) # عملنا سي تي اي علشان نقدر نحط الرو نامبر كعمود في التابل دي وبقي معانا تابل جديدة فيها روو نمبر 
SELECT * 
FROM duplicate_cte
WHERE row_num > 1; # منطقيا اي قيمة اكبر من 1 هتكون صف مكرر فكدة عرفنا الصفوف المكررة 

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci; 
# عملنا تابل جديدة علشان نحط فيها كل الداتا القديمة ونحط صف الرو نامبر كصف اساسي 

SELECT * 
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER () OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,
`date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging; # كدة بقي معانا تابل جاهزة للشغل 

DELETE  
FROM layoffs_staging2
WHERE row_num > 1; # ببساطة هنمسح القيم الاكبر من 1 علشان دي المكررة 

SELECT *
FROM layoffs_staging2;

TRUNCATE TABLE layoffs_staging; # فضيت التابل الاساسية 

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;  # مسحت عمود الرو نامبر علشان انا مش محتاجه تاني من التابل الفرعية 

SELECT *
FROM layoffs_staging2 ;

INSERT INTO layoffs_staging
SELECT *
FROM layoffs_staging2;   # رجعت البيانات الجديدة للتابل الاساسية من غير عمود الرو نمبر ومن غير الصفوف المتكررة 

SELECT *
FROM layoffs_staging;





#2. Standerdize the data

SELECT *
FROM layoffs_staging;


SELECT company, TRIM(company)
FROM layoffs_staging;

UPDATE layoffs_staging
SET company = TRIM(company); 
/* كان فية بيانات كتير اولها مسافة واخرها مسافة فأحنا نضفنا اسامي الشركات , طبعا لما تبص علي الداتا ممكن تشوف ان مثلا الداتا محتاجة تبقي كلها بتبدأ بحرف كابتل
او اي شيء محتاج يتغير , انه عالمك الخاص لأكتشافه
*/

SELECT *
FROM layoffs_staging
WHERE industry LIKE 'crypto%';

UPDATE layoffs_staging
SET industry = 'crypto'
WHERE industry LIKE 'crypto%';
# نفس المجال لكن بأسامي مختلفة زي كريبتو كارنسي فوحدت الداتا 

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging;

UPDATE layoffs_staging
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';  
# لقيت ان فية داتا بعد اسم الدولة محطوط نقطة فأنا شيلت النقطة دي

SELECT *
FROM layoffs_staging
WHERE country LIKE '%United States%';

SELECT `date`
FROM layoffs_staging;

UPDATE layoffs_staging
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
# التاريخ كان محطوط سترينج مش تاريخ فعدلنا الموضوع دة واول خطوة ان احنا نخلي شكلهم واحد 

ALTER TABLE layoffs_staging
MODIFY COLUMN `date` DATE;
# تاني خطوة ان احنا نحول نوع الداتا نفسه بس الخطوة دي مكانتش هتنفع لو احنا موحدناش طريقة كتابة التاريخ في الخطوة الاولي




#3. NULL values or BLANCK values

SELECT *
FROM layoffs_staging;

SELECT *
FROM layoffs_staging
WHERE (industry IS NULL
OR industry = ''); 

 


SELECT t1.company AS 1_com, t1.industry AS 1_ind, t2.company AS 2_com, t2.industry AS 2_ind
FROM layoffs_staging t1
JOIN layoffs_staging t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL AND
t2.industry IS NOT NULL);
# ممكن يكون فية داتا ناقصة بس تتكمل من جداول تاني وهو دة اللي انا كنت بدور علية هنا 

SELECT *
FROM layoffs_staging
WHERE company = 'Juul';
# اخدت لبالي ان فية بعض الداتا ممكن اكملها من داتا في صفوف تاني

UPDATE layoffs_staging
SET industry = NULL 
WHERE industry = '';
# وحدت البيانات الفاضية علشان جوين تشتغل صحححح

UPDATE layoffs_staging t1
JOIN layoffs_staging t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL AND 
t2.industry IS NOT NULL); 
# اللة ينور عليك يا هندسة 




#4. Remove any coulmns that we dont need

SELECT * 
FROM layoffs_staging
WHERE (total_laid_off IS NULL OR total_laid_off = '') AND
(percentage_laid_off IS NULL OR percentage_laid_off = '');

DELETE 
FROM layoffs_staging
WHERE (total_laid_off IS NULL OR total_laid_off = '') AND
(percentage_laid_off IS NULL OR percentage_laid_off = '');

SELECT *
FROM layoffs_staging;







