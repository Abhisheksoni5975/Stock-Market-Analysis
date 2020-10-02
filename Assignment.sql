
##QUESTION1
select * from `Bajaj Auto`;
set sql_safe_updates=0;
update  `Bajaj Auto`
set `Date` = str_to_date(`Date`,"%d-%M-%Y");
CREATE TABLE `BAJAJ1` as select row_number() over(order by `Date`)sno,`Date`,`Close Price`,if((ROW_NUMBER() OVER() ) > 19, (avg(`Close Price`) OVER (order by `Date` asc rows 19 PRECEDING)), null) 20DayMA,
if((ROW_NUMBER() OVER() ) > 49,(avg(`Close Price`) OVER (order by Date asc rows 49 PRECEDING)),null) 50DayMA
from `Bajaj Auto` 
order by `Date`;
select * from BAJAJ1;

####QUESTION2
CREATE TABLE `MASTER` AS select b.`date` as `DATE`,b.`Close price` as Bajaj, t.`Close price` as TCS,
TVS.`close price` as TVS ,i.`close price` as Infosys, e.`close price` as `Eicher Motors`, h.`close price` as `Hero motorcorp`
 from `Bajaj Auto` b , `Eicher Motors` e,`Hero Motocorp` h, 
Infosys i, TCS t,`TVS Motors` TVS  
where b.`date`= e.`date` and e.`date`= h.`date` and h.`date`=i.`date` and i.`date`=t.`date` and 
t.`date`=TVS.`date`;
SELECT * FROM  MASTER;

##QUESTION 3
create table tempora1 as
select `sno`,`Date`,`Close Price`,20DayMA,lag(20DayMA,1) over w as 20MAprevious,50DayMA,
lag(50DayMA,1) over w as 50MAprevious
from BAJAJ1
window w as (order by `Sno`);
select * from tempora1;
create table bajaj2 
select `Date` ,`Close Price`,
(case when `sno` > 49 and 20DayMA > 50DayMA and 20MAprevious < 50MAprevious then 'Buy'
when `Sno`  > 49 and 20DayMA < 50DayMA and 20MAprevious > 50MAprevious then 'Sell'
else 'Hold' end) as 'Signal'
from tempora1;
SELECT * FROM bajaj2;

##question04


delimiter &&
create function Dateinput ( dt Date) 
returns varchar(50) deterministic
begin
declare dt_value varchar(50); 
set dt_value = (select `Signal` from bajaj2 where Date = dt); 
return dt_value;
end
&&
delimiter ;