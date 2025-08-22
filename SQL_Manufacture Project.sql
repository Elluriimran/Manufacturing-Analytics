select * from Manuf;
desc manuf;

#1. Write a SQL query to calculate the total manufactured quantity from the production dataset.
select CONCAT(Round(sum(today_Manufactured_Qty)/1000000,0),"M") Tot_Manufactured from Manuf; 

#2. How would you find the total number of rejected items ?
select Concat(Round(sum(Rejected_Qty)/1000,0)," ","K") Total_Rejected from Manuf;

#3. Write a query to return the total processed quantity from the manufacturing data.
select Concat(Round(sum(Processed_Qty)/10000000,0),0,"M") Total_Processed from Manuf;

#4. How can you calculate the total wastage quantity from the dataset?

select Concat(Round(sum(WO_Qty)/1000000,0),"M") Wastage_Qty from Manuf;

#5. Display employee-wise rejected quantity. Sort the result by highest rejected quantity.

select Emp_Name,sum(Rejected_Qty)Total_Rejected_Qty from Manuf group by Emp_Name;


#6. Write a SQL query to calculate rejected quantity per machine, ordered by rejection in descending order.

select Machine_Code,sum(Rejected_Qty)Total_Rejected from Manuf group by Machine_Code order by sum(Rejected_Qty) desc;


#7. How would you show month-wise production trend ?
with Manuf_Data as (
select month(Doc_DateC)Month_No,Monthname(Doc_DateC)Month,sum(today_Manufactured_Qty)Total_Production 
from Manuf group by 1,2 order by 1)
select Month,Total_Production , 
concat(Round((Total_Production - lag(Total_Production) over(order by Month_No))/Total_Production*100,0),"%")as `MOM%`
from Manuf_Data;

#Rejection trend over time using SQL?

with Manuf_Data as (
select month(Doc_DateC)Month_No,Monthname(Doc_DateC)Month,sum(Rejected_Qty)Total_Reject
from Manuf group by 1,2 order by 1)
select Month,Total_Reject , 
concat(Round((Total_Reject - lag(Total_Reject) over(order by Month_No))/Total_Reject*100,0),"%")as `MOM%`
from Manuf_Data;

ALTER TABLE Manuf ADD COLUMN Doc_DateC DATE;

UPDATE Manuf SET Doc_DateC = STR_TO_DATE(Doc_Date, '%d-%m-%Y');

#8. Write a query to calculate total manufactured quantity, total rejected quantity, and rejection percentage (Rejected ÷ Manufactured × 100).

SELECT 
    SUM(today_Manufactured_Qty) AS Total_Manufactured,
    SUM(Rejected_Qty) AS Total_Rejected,
    ROUND((SUM(Rejected_Qty) / SUM(today_Manufactured_Qty)) * 100, 2) AS Rejection_Percentage
FROM Manuf;


#9. How would you compare department-wise total manufactured quantity and rejected quantity along with rejection percentage?

Create View Department_Info AS
select Department_Name,sum(today_Manufactured_qty)Produced,sum(Rejected_Qty)Rejected,
sum(Rejected_Qty)/sum(today_Manufactured_qty)*100 as `Rejected %`
 from Manuf group by 1;

select * from Department_info;   #vIEW HAS CREATED

#10. Write a query to show employee-wise manufactured quantity, rejected quantity, and rejection percentage.

call Emp_info("Rajesh Verma");       #Pooja patel   #Rajesh Verma

#Trigger that gets alterted when a entry is deleted

Create table Deleted_Records ( log_id int auto_increment Primary key,user_name Varchar(100),Deleted_Manufactured int ,
Deleted_Rejected int ,loginTime TIMESTAMP DEFAULT current_timestamp); 

START TRANSACTION;
DELETE FROM MANUF WHERE  Emp_Name = "Shruti Singh" and EMP_Code = "EM863"; 
ROLLBACK;  -- if mistake
COMMIT; 

select * from Deleted_Records;