set FOREIGN_KEY_CHECKS = 0;
set default_storage_engine = innoDB;

Drop table if exists information;
Drop table if exists workweeks;
Drop table if exists staffplanning;

create table information (
	id int not null auto_increment,
	Bdl varchar(5),
	TplStr varchar(15),
	Typ varchar(50),
	UNE varchar(10),
	Sparnr varchar(20),
	Agare varchar(10),
	Bklass varchar(5),
	Mall varchar(5),
	Benamning varchar(20),
	Kmmfr varchar(20),
	Kmmti varchar(20),
	Recentdate varchar(15),
	Nextdate varchar(15),
	Lastdate varchar(15),
	Lastweek varchar(5),
	Plannedweek varchar(5) default '',
	Year1 boolean,
	Year2 boolean,
	Year3 boolean,
	Year4 boolean,
	Tested varchar(15) default '',
	Testedweek varchar(5) default '',
	primary key(id)
);

create table workweeks (
	Week int not null,
	Mondaydate varchar(15) not null,
	Syd boolean default false,
	Vast boolean default false,
	Ost boolean default false,
	Mitt boolean default false,
	Nord boolean default false,
	primary key (Mondaydate)
);



create table staffplanning (
	Week int not null,
	Mondaydate varchar(15) not null,
	Region varchar(50) not null,
	Verification int default 0,
	Switches int default 0,
	Crosses int default 0,
	Ahsp int default 0,
	Vacation int default 0,
	Other int default 0,
	primary key (region, week)
);

select * from staffplanning where Region='Nord';

set FOREIGN_KEY_CHECKS = 1;

ALTER TABLE staffplanning CONVERT TO CHARACTER SET utf8;


select * from information where Agare = 'Syd' and Lastdate < '2016-01-01' and Tested = 0 order by Lastweek, Bklass desc;

select * from information where Agare = 'Syd' and Plannedweek != '';

select * from information where Tested = '';

select * from information where Agare='Syd' and Lastweek < 33 and Lastweek > 0	 and Tested = 0;

update information set Tested='', Testedweek='' where Agare='Syd' and Testedweek='20';
update information set Tested='', Testedweek='' where Agare='Syd' and Lastweek<'20';

select * from information order by Bklass desc, Lastweek;



select * from information where UNE != '' or (UNE = '' and (Bklass != 'B1' and Bklass != 'B2'));

select * from information where Nextdate < '2016-01-01' and Agare='Syd' and TplStr='JÖGB';
update information set Plannedweek = 0 where Tested = 0;

update information set Plannedweek = 0 where id > 0;

update information set Tested = 0 where Lastweek < 21 and Lastweek > 0;
select * from workweeks;

select Lastweek, count(*) from information where Agare = 'Nord' and Nextdate < '2016-01-01' group by Lastweek;

select distinct(information.Lastweek), Syd.countSyd, Vast.countVast, Mitt.countMitt, Nord.countNord from 
information left join
(select Lastweek, count(*) as countSyd from information where Agare = 'Syd' and Nextdate < '2016-01-01' group by Lastweek) as Syd on information.Lastweek = Syd.Lastweek left join
(select Lastweek, count(*) as countVast from information where Agare = 'Väst' and Nextdate < '2016-01-01' group by Lastweek) as Vast on information.Lastweek = Vast.Lastweek left join
(select Lastweek, count(*) as countOst from information where Agare = 'Öst' and Nextdate < '2016-01-01' group by Lastweek) as Ost on information.Lastweek = Ost.Lastweek left join
(select Lastweek, count(*) as countMitt from information where Agare = 'Mitt' and Nextdate < '2016-01-01' group by Lastweek) as Mitt on information.Lastweek = Mitt.Lastweek left join
(select Lastweek, count(*) as countNord from information where Agare = 'Nord' and Nextdate < '2016-01-01' group by Lastweek) as Nord on information.Lastweek = Nord.Lastweek order by information.Lastweek;


select distinct(information.Lastweek), Syd.countSyd from 
information,
(select Lastweek, count(*) as countSyd from information where Agare = 'Syd' and Nextdate < '2016-01-01' group by Lastweek) as Syd 
where  information.Lastweek = Syd.Lastweek order by Lastweek;

select * from workweeks order by Mondaydate asc;
select * from information;

ALTER TABLE information CONVERT TO CHARACTER SET utf8;


select staffplanning.Week, staffplanning.Mondaydate, Totsyd, Totregion45, Totregion3, Totregion12, Testregion45, Testregion3, Testregion12, Untestregion45, Untestregion3, Untestregion12, Totväst, Totöst, Totmitt, Totnord from Staffplanning left join 
(select Week, count(*) as Totsyd from Staffplanning left join information as Syd on Staffplanning.Week = Syd.Lastweek where staffplanning.Region='Syd' and Syd.Agare='Syd' group by staffplanning.Week) 
as Syd1 on staffplanning.Week = Syd1.Week left join 
(select Week, count(*) as Totväst from Staffplanning left join information as Väst on Staffplanning.Week = Väst.Lastweek where staffplanning.Region='Väst' and Väst.Agare='Väst' group by staffplanning.Week) 
as Väst1 on staffplanning.Week = Väst1.Week left join 
(select Week, count(*) as Totöst from Staffplanning left join information as Öst on Staffplanning.Week = Öst.Lastweek where staffplanning.Region='Öst' and Öst.Agare='Öst' group by staffplanning.Week) 
as Öst1 on staffplanning.Week = Öst1.Week left join 
(select Week, count(*) as Totmitt from Staffplanning left join information as Mitt on Staffplanning.Week = Mitt.Lastweek where staffplanning.Region='Mitt' and Mitt.Agare='Mitt' group by staffplanning.Week) 
as Mitt1 on staffplanning.Week = Mitt1.Week left join 
(select Week, count(*) as Totnord from Staffplanning left join information as Nord on Staffplanning.Week = Nord.Lastweek where staffplanning.Region='Nord' and Nord.Agare='Nord' group by staffplanning.Week) 
as Nord1 on staffplanning.Week = Nord1.Week left join

(select Week, count(*) as Totregion45 from Staffplanning left join information as Sydt45 on Staffplanning.Week = Sydt45.Lastweek where staffplanning.Region='Syd' and Sydt45.Agare='Syd' and (Sydt45.Bklass = 'B5' or Sydt45.Bklass = 'B4') group by staffplanning.Week) 
as SydTot45 on staffplanning.Week = SydTot45.Week left join
(select Week, count(*) as Totregion3 from Staffplanning left join information as Sydt3 on Staffplanning.Week = Sydt3.Lastweek where staffplanning.Region='Syd' and Sydt3.Agare='Syd' and (Sydt3.Bklass = 'B3') group by staffplanning.Week) 
as SydTot3 on staffplanning.Week = SydTot3.Week left join
(select Week, count(*) as Totregion12 from Staffplanning left join information as Sydt12 on Staffplanning.Week = Sydt12.Lastweek where staffplanning.Region='Syd' and Sydt12.Agare='Syd' and (Sydt12.Bklass = 'B2' or Sydt12.Bklass = 'B1') group by staffplanning.Week) 
as SydTot12 on staffplanning.Week = SydTot12.Week left join

(select Week, count(*) as Testregion45 from Staffplanning left join information as Sydtest45 on Staffplanning.Week = Sydtest45.Lastweek where staffplanning.Region='Syd' and Sydtest45.Agare='Syd' and (Sydtest45.Bklass = 'B5' or Sydtest45.Bklass = 'B4') group by staffplanning.Week) 
as SydTested45 on staffplanning.Week = SydTested45.Week left join
(select Week, count(*) as Testregion3 from Staffplanning left join information as Sydtest3 on Staffplanning.Week = Sydtest3.Lastweek where staffplanning.Region='Syd' and Sydtest3.Agare='Syd' and (Sydtest3.Bklass = 'B3') group by staffplanning.Week) 
as SydTested3 on staffplanning.Week = SydTested3.Week left join
(select Week, count(*) as Testregion12 from Staffplanning left join information as Sydtest12 on Staffplanning.Week = Sydtest12.Lastweek where staffplanning.Region='Syd' and Sydtest12.Agare='Syd' and (Sydtest12.Bklass = 'B2' or Sydtest12.Bklass = 'B1') group by staffplanning.Week) 
as SydTested12 on staffplanning.Week = SydTested12.Week left join

(select Week, count(*) as Untestregion45 from Staffplanning left join information as Sydu45 on Staffplanning.Week = Sydu45.Lastweek where staffplanning.Region='Syd' and Sydu45.Agare='Syd' and (Sydu45.Bklass = 'B5' or Sydu45.Bklass = 'B4') group by staffplanning.Week) 
as SydUntested45 on staffplanning.Week = SydUntested45.Week left join
(select Week, count(*) as Untestregion3 from Staffplanning left join information as Sydu3 on Staffplanning.Week = Sydu3.Lastweek where staffplanning.Region='Syd' and Sydu3.Agare='Syd' and (Sydu3.Bklass = 'B3') group by staffplanning.Week) 
as SydUntested3 on staffplanning.Week = SydUntested3.Week left join
(select Week, count(*) as Untestregion12 from Staffplanning left join information as Sydu12 on Staffplanning.Week = Sydu12.Lastweek where staffplanning.Region='Syd' and Sydu12.Agare='Syd' and (Sydu12.Bklass = 'B2' or Sydu12.Bklass = 'B1') group by staffplanning.Week) 
as SydUntested12 on staffplanning.Week = SydUntested12.Week;

select Week, count(Testedweek) as Testedweek from Staffplanning left join information as Tested on Staffplanning.Week = Tested.Testedweek where staffplanning.Region='Syd' and Tested.Agare='Syd' group by staffplanning.Week;

select * from information where Tested != '';


select distinct(information.Lastweek) as week, workweeks.Mondaydate as mondaydate, Syd.countSyd as countSyd, Syd45.countSyd45, Syd3.countSyd3, Syd12.countSyd12, Syd45T.countSyd45T, Syd3T.countSyd3T, Syd12T.countSyd12T, Syd45U.countSyd45U, Syd3U.countSyd3U, Syd12U.countSyd12U, Vast.countVast as countVast, Ost.countOst as countOst, Mitt.countMitt as countMitt, Nord.countNord as countNord, 
(IFNULL(countSyd,0) + IFNULL(countVast,0) + IFNULL(countOst,0) + IFNULL(countMitt,0) + IFNULL(countNord,0)) as countTotal, 
(IFNULL(countSyd,0) + IFNULL(countVast,0) + IFNULL(countOst,0) + IFNULL(countMitt,0) + IFNULL(countNord,0))*0.7 as hoursTotal 
from information left join workweeks on information.Lastweek = workweeks.Week left join
(select Week, IFNULL(count(*), 0) as countSyd from staffplanning left join information as Syd1 on Staffplanning.Week = Syd1.Lastweek where Agare = 'Syd' and Nextdate < '2016-01-01' group by Lastweek) as Syd on workweeks.Week = Syd.Week left join
(select Lastweek, IFNULL(count(*), 0) as countSyd45, Tested from information where Agare = 'Syd' and Nextdate < '2016-01-01' and (Bklass = 'B5' or Bklass = 'B4') group by Lastweek) as Syd45 on workweeks.Week = Syd45.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countSyd3, Tested from information where Agare = 'Syd' and Nextdate < '2016-01-01' and (Bklass = 'B3') group by Lastweek) as Syd3 on workweeks.Week = Syd3.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countSyd12, Tested from information where Agare = 'Syd' and Nextdate < '2016-01-01' and (Bklass = 'B1' or Bklass = 'B2') group by Lastweek) as Syd12 on workweeks.Week = Syd12.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countVast from information where Agare = 'Väst' and Nextdate < '2016-01-01' group by Lastweek) as Vast on workweeks.Week = Vast.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countOst from information where Agare = 'Öst' and Nextdate < '2016-01-01' group by Lastweek) as Ost on workweeks.Week = Ost.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countMitt from information where Agare = 'Mitt' and Nextdate < '2016-01-01' group by Lastweek) as Mitt on workweeks.Week = Mitt.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countNord from information where Agare = 'Nord' and Nextdate < '2016-01-01' group by Lastweek) as Nord on workweeks.Week = Nord.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countSyd45T from information where Tested ='1' and Agare = 'Syd' and Nextdate < '2016-01-01' and (Bklass = 'B5' or Bklass = 'B4') group by Lastweek) as Syd45T on workweeks.Week = Syd45T.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countSyd3T from information where Tested ='1' and Agare = 'Syd' and Nextdate < '2016-01-01' and (Bklass = 'B3') group by Lastweek) as Syd3T on workweeks.Week = Syd3T.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countSyd12T from information where Tested ='1' and Agare = 'Syd' and Nextdate < '2016-01-01' and (Bklass = 'B1' or Bklass = 'B2') group by Lastweek) as Syd12T on workweeks.Week = Syd12T.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countSyd45U from information where Tested ='0' and Agare = 'Syd' and Nextdate < '2016-01-01' and (Bklass = 'B5' or Bklass = 'B4') group by Lastweek) as Syd45U on workweeks.Week = Syd45U.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countSyd3U from information where Tested ='0' and Agare = 'Syd' and Nextdate < '2016-01-01' and (Bklass = 'B3') group by Lastweek) as Syd3U on workweeks.Week = Syd3U.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countSyd12U from information where Tested ='0' and Agare = 'Syd' and Nextdate < '2016-01-01' and (Bklass = 'B1' or Bklass = 'B2') group by Lastweek) as Syd12U on workweeks.Week = Syd12U.Lastweek 
where information.Lastweek > 0 order by workweeks.Week;

select distinct(information.Lastweek) as week, workweeks.Mondaydate as mondaydate, Syd.countSyd as countSyd, Syd45.countSyd45, Syd3.countSyd3, Syd12.countSyd12, Syd45T.countSyd45T, Syd3T.countSyd3T, Syd12T.countSyd12T, Syd45U.countSyd45U, Syd3U.countSyd3U, Syd12U.countSyd12U, Vast.countVast as countVast, Ost.countOst as countOst, Mitt.countMitt as countMitt, Nord.countNord as countNord, 
(IFNULL(countSyd,0) + IFNULL(countVast,0) + IFNULL(countOst,0) + IFNULL(countMitt,0) + IFNULL(countNord,0)) as countTotal, 
(IFNULL(countSyd,0) + IFNULL(countVast,0) + IFNULL(countOst,0) + IFNULL(countMitt,0) + IFNULL(countNord,0))*0.7 as hoursTotal 
from information left join workweeks on information.Lastweek = workweeks.Week left join
(select Lastweek, IFNULL(count(*), 0) as countSyd from information where Agare = 'Syd' and Nextdate < '2016-01-01' group by Lastweek) as Syd on workweeks.Week = Syd.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countSyd45, Tested from information where Agare = 'Syd' and Nextdate < '2016-01-01' and (Bklass = 'B5' or Bklass = 'B4') group by Lastweek) as Syd45 on workweeks.Week = Syd45.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countSyd3, Tested from information where Agare = 'Syd' and Nextdate < '2016-01-01' and (Bklass = 'B3') group by Lastweek) as Syd3 on workweeks.Week = Syd3.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countSyd12, Tested from information where Agare = 'Syd' and Nextdate < '2016-01-01' and (Bklass = 'B1' or Bklass = 'B2') group by Lastweek) as Syd12 on workweeks.Week = Syd12.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countVast from information where Agare = 'Väst' and Nextdate < '2016-01-01' group by Lastweek) as Vast on workweeks.Week = Vast.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countOst from information where Agare = 'Öst' and Nextdate < '2016-01-01' group by Lastweek) as Ost on workweeks.Week = Ost.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countMitt from information where Agare = 'Mitt' and Nextdate < '2016-01-01' group by Lastweek) as Mitt on workweeks.Week = Mitt.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countNord from information where Agare = 'Nord' and Nextdate < '2016-01-01' group by Lastweek) as Nord on workweeks.Week = Nord.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countSyd45T from information where Tested ='1' and Agare = 'Syd' and Nextdate < '2016-01-01' and (Bklass = 'B5' or Bklass = 'B4') group by Lastweek) as Syd45T on workweeks.Week = Syd45T.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countSyd3T from information where Tested ='1' and Agare = 'Syd' and Nextdate < '2016-01-01' and (Bklass = 'B3') group by Lastweek) as Syd3T on workweeks.Week = Syd3T.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countSyd12T from information where Tested ='1' and Agare = 'Syd' and Nextdate < '2016-01-01' and (Bklass = 'B1' or Bklass = 'B2') group by Lastweek) as Syd12T on workweeks.Week = Syd12T.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countSyd45U from information where Tested ='0' and Agare = 'Syd' and Nextdate < '2016-01-01' and (Bklass = 'B5' or Bklass = 'B4') group by Lastweek) as Syd45U on workweeks.Week = Syd45U.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countSyd3U from information where Tested ='0' and Agare = 'Syd' and Nextdate < '2016-01-01' and (Bklass = 'B3') group by Lastweek) as Syd3U on workweeks.Week = Syd3U.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countSyd12U from information where Tested ='0' and Agare = 'Syd' and Nextdate < '2016-01-01' and (Bklass = 'B1' or Bklass = 'B2') group by Lastweek) as Syd12U on workweeks.Week = Syd12U.Lastweek 
where information.Lastweek > 0 order by workweeks.Week;

select distinct(information.Lastweek) as week, workweeks.Mondaydate as mondaydate,
 Syd.countSyd, Syd45.countSyd45, Syd3.countSyd3, Syd12.countSyd12, Syd45T.countSyd45T, Syd3T.countSyd3T, Syd12T.countSyd12T, Syd45U.countSyd45U, Syd3U.countSyd3U, Syd12U.countSyd12U,
 Vast.countVast, Vast45.countVast45, Vast3.countVast3, Vast12.countVast12, Vast45T.countVast45T, Vast3T.countVast3T, Vast12T.countVast12T, Vast45U.countVast45U, Vast3U.countVast3U, Vast12U.countVast12U,
 Ost.countOst, Ost45.countOst45, Ost3.countOst3, Ost12.countOst12, Ost45T.countOst45T, Ost3T.countOst3T, Ost12T.countOst12T, Ost45U.countOst45U, Ost3U.countOst3U, Ost12U.countOst12U,
 Mitt.countMitt, Mitt45.countMitt45, Mitt3.countMitt3, Mitt12.countMitt12, Mitt45T.countMitt45T, Mitt3T.countMitt3T, Mitt12T.countMitt12T, Mitt45U.countMitt45U, Mitt3U.countMitt3U, Mitt12U.countMitt12U,
 Nord.countNord, Nord45.countNord45, Nord3.countNord3, Nord12.countNord12, Nord45T.countNord45T, Nord3T.countNord3T, Nord12T.countNord12T, Nord45U.countNord45U, Nord3U.countNord3U, Nord12U.countNord12U,
(IFNULL(countSyd,0) + IFNULL(countVast,0) + IFNULL(countOst,0) + IFNULL(countMitt,0) + IFNULL(countNord,0)) as countTotal, 
(IFNULL(countSyd,0) + IFNULL(countVast,0) + IFNULL(countOst,0) + IFNULL(countMitt,0) + IFNULL(countNord,0))*0.7 as hoursTotal 
from information left join workweeks on information.Lastweek = workweeks.Week left join

(select Lastweek, IFNULL(count(*), 0) as countSyd from information where Agare = 'Syd' and Nextdate < '2016-01-01' group by Lastweek) as Syd on workweeks.Week = Syd.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countSyd45, Tested from information where Agare = 'Syd' and Nextdate < '2016-01-01' and (Bklass = 'B5' or Bklass = 'B4') group by Lastweek) as Syd45 on workweeks.Week = Syd45.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countSyd3, Tested from information where Agare = 'Syd' and Nextdate < '2016-01-01' and (Bklass = 'B3') group by Lastweek) as Syd3 on workweeks.Week = Syd3.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countSyd12, Tested from information where Agare = 'Syd' and Nextdate < '2016-01-01' and (Bklass = 'B1' or Bklass = 'B2') group by Lastweek) as Syd12 on workweeks.Week = Syd12.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countSyd45T from information where Tested ='1' and Agare = 'Syd' and Nextdate < '2016-01-01' and (Bklass = 'B5' or Bklass = 'B4') group by Lastweek) as Syd45T on workweeks.Week = Syd45T.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countSyd3T from information where Tested ='1' and Agare = 'Syd' and Nextdate < '2016-01-01' and (Bklass = '3') group by Lastweek) as Syd3T on workweeks.Week = Syd3T.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countSyd12T from information where Tested ='1' and Agare = 'Syd' and Nextdate < '2016-01-01' and (Bklass = 'B1' or Bklass = 'B2') group by Lastweek) as Syd12T on workweeks.Week = Syd12T.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countSyd45U from information where Tested ='0' and Agare = 'Syd' and Nextdate < '2016-01-01' and (Bklass = 'B5' or Bklass = 'B4') group by Lastweek) as Syd45U on workweeks.Week = Syd45U.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countSyd3U from information where Tested ='0' and Agare = 'Syd' and Nextdate < '2016-01-01' and (Bklass = '3') group by Lastweek) as Syd3U on workweeks.Week = Syd3U.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countSyd12U from information where Tested ='0' and Agare = 'Syd' and Nextdate < '2016-01-01' and (Bklass = 'B1' or Bklass = 'B2') group by Lastweek) as Syd12U on workweeks.Week = Syd12U.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countVast from information where Agare = 'Väst' and Nextdate < '2016-01-01' group by Lastweek) as Vast on workweeks.Week = Vast.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countVast45, Tested from information where Agare = 'Väst' and Nextdate < '2016-01-01' and (Bklass = 'B5' or Bklass = 'B4') group by Lastweek) as Vast45 on workweeks.Week = Vast45.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countVast3, Tested from information where Agare = 'Väst' and Nextdate < '2016-01-01' and (Bklass = 'B3') group by Lastweek) as Vast3 on workweeks.Week = Vast3.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countVast12, Tested from information where Agare = 'Väst' and Nextdate < '2016-01-01' and (Bklass = 'B1' or Bklass = 'B2') group by Lastweek) as Vast12 on workweeks.Week = Vast12.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countVast45T from information where Tested ='1' and Agare = 'Väst' and Nextdate < '2016-01-01' and (Bklass = 'B5' or Bklass = 'B4') group by Lastweek) as Vast45T on workweeks.Week = Vast45T.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countVast3T from information where Tested ='1' and Agare = 'Väst' and Nextdate < '2016-01-01' and (Bklass = '3') group by Lastweek) as Vast3T on workweeks.Week = Vast3T.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countVast12T from information where Tested ='1' and Agare = 'Väst' and Nextdate < '2016-01-01' and (Bklass = 'B1' or Bklass = 'B2') group by Lastweek) as Vast12T on workweeks.Week = Vast12T.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countVast45U from information where Tested ='0' and Agare = 'Väst' and Nextdate < '2016-01-01' and (Bklass = 'B5' or Bklass = 'B4') group by Lastweek) as Vast45U on workweeks.Week = Vast45U.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countVast3U from information where Tested ='0' and Agare = 'Väst' and Nextdate < '2016-01-01' and (Bklass = '3') group by Lastweek) as Vast3U on workweeks.Week = Vast3U.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countVast12U from information where Tested ='0' and Agare = 'Väst' and Nextdate < '2016-01-01' and (Bklass = 'B1' or Bklass = 'B2') group by Lastweek) as Vast12U on workweeks.Week = Vast12U.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countOst from information where Agare = 'Öst' and Nextdate < '2016-01-01' group by Lastweek) as Ost on workweeks.Week = Ost.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countOst45, Tested from information where Agare = 'Öst' and Nextdate < '2016-01-01' and (Bklass = 'B5' or Bklass = 'B4') group by Lastweek) as Ost45 on workweeks.Week = Ost45.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countOst3, Tested from information where Agare = 'Öst' and Nextdate < '2016-01-01' and (Bklass = 'B3') group by Lastweek) as Ost3 on workweeks.Week = Ost3.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countOst12, Tested from information where Agare = 'Öst' and Nextdate < '2016-01-01' and (Bklass = 'B1' or Bklass = 'B2') group by Lastweek) as Ost12 on workweeks.Week = Ost12.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countOst45T from information where Tested ='1' and Agare = 'Öst' and Nextdate < '2016-01-01' and (Bklass = 'B5' or Bklass = 'B4') group by Lastweek) as Ost45T on workweeks.Week = Ost45T.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countOst3T from information where Tested ='1' and Agare = 'Öst' and Nextdate < '2016-01-01' and (Bklass = '3') group by Lastweek) as Ost3T on workweeks.Week = Ost3T.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countOst12T from information where Tested ='1' and Agare = 'Öst' and Nextdate < '2016-01-01' and (Bklass = 'B1' or Bklass = 'B2') group by Lastweek) as Ost12T on workweeks.Week = Ost12T.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countOst45U from information where Tested ='0' and Agare = 'Öst' and Nextdate < '2016-01-01' and (Bklass = 'B5' or Bklass = 'B4') group by Lastweek) as Ost45U on workweeks.Week = Ost45U.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countOst3U from information where Tested ='0' and Agare = 'Öst' and Nextdate < '2016-01-01' and (Bklass = '3') group by Lastweek) as Ost3U on workweeks.Week = Ost3U.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countOst12U from information where Tested ='0' and Agare = 'Öst' and Nextdate < '2016-01-01' and (Bklass = 'B1' or Bklass = 'B2') group by Lastweek) as Ost12U on workweeks.Week = Ost12U.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countMitt from information where Agare = 'Mitt' and Nextdate < '2016-01-01' group by Lastweek) as Mitt on workweeks.Week = Mitt.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countMitt45, Tested from information where Agare = 'Mitt' and Nextdate < '2016-01-01' and (Bklass = 'B5' or Bklass = 'B4') group by Lastweek) as Mitt45 on workweeks.Week = Mitt45.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countMitt3, Tested from information where Agare = 'Mitt' and Nextdate < '2016-01-01' and (Bklass = 'B3') group by Lastweek) as Mitt3 on workweeks.Week = Mitt3.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countMitt12, Tested from information where Agare = 'Mitt' and Nextdate < '2016-01-01' and (Bklass = 'B1' or Bklass = 'B2') group by Lastweek) as Mitt12 on workweeks.Week = Mitt12.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countMitt45T from information where Tested ='1' and Agare = 'Mitt' and Nextdate < '2016-01-01' and (Bklass = 'B5' or Bklass = 'B4') group by Lastweek) as Mitt45T on workweeks.Week = Mitt45T.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countMitt3T from information where Tested ='1' and Agare = 'Mitt' and Nextdate < '2016-01-01' and (Bklass = '3') group by Lastweek) as Mitt3T on workweeks.Week = Mitt3T.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countMitt12T from information where Tested ='1' and Agare = 'Mitt' and Nextdate < '2016-01-01' and (Bklass = 'B1' or Bklass = 'B2') group by Lastweek) as Mitt12T on workweeks.Week = Mitt12T.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countMitt45U from information where Tested ='0' and Agare = 'Mitt' and Nextdate < '2016-01-01' and (Bklass = 'B5' or Bklass = 'B4') group by Lastweek) as Mitt45U on workweeks.Week = Mitt45U.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countMitt3U from information where Tested ='0' and Agare = 'Mitt' and Nextdate < '2016-01-01' and (Bklass = '3') group by Lastweek) as Mitt3U on workweeks.Week = Mitt3U.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countMitt12U from information where Tested ='0' and Agare = 'Mitt' and Nextdate < '2016-01-01' and (Bklass = 'B1' or Bklass = 'B2') group by Lastweek) as Mitt12U on workweeks.Week = Mitt12U.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countNord from information where Agare = 'Nord' and Nextdate < '2016-01-01' group by Lastweek) as Nord on workweeks.Week = Nord.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countNord45, Tested from information where Agare = 'Nord' and Nextdate < '2016-01-01' and (Bklass = 'B5' or Bklass = 'B4') group by Lastweek) as Nord45 on workweeks.Week = Nord45.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countNord3, Tested from information where Agare = 'Nord' and Nextdate < '2016-01-01' and (Bklass = 'B3') group by Lastweek) as Nord3 on workweeks.Week = Nord3.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countNord12, Tested from information where Agare = 'Nord' and Nextdate < '2016-01-01' and (Bklass = 'B1' or Bklass = 'B2') group by Lastweek) as Nord12 on workweeks.Week = Nord12.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countNord45T from information where Tested ='1' and Agare = 'Nord' and Nextdate < '2016-01-01' and (Bklass = 'B5' or Bklass = 'B4') group by Lastweek) as Nord45T on workweeks.Week = Nord45T.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countNord3T from information where Tested ='1' and Agare = 'Nord' and Nextdate < '2016-01-01' and (Bklass = '3') group by Lastweek) as Nord3T on workweeks.Week = Nord3T.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countNord12T from information where Tested ='1' and Agare = 'Nord' and Nextdate < '2016-01-01' and (Bklass = 'B1' or Bklass = 'B2') group by Lastweek) as Nord12T on workweeks.Week = Nord12T.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countNord45U from information where Tested ='0' and Agare = 'Nord' and Nextdate < '2016-01-01' and (Bklass = 'B5' or Bklass = 'B4') group by Lastweek) as Nord45U on workweeks.Week = Nord45U.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countNord3U from information where Tested ='0' and Agare = 'Nord' and Nextdate < '2016-01-01' and (Bklass = '3') group by Lastweek) as Nord3U on workweeks.Week = Nord3U.Lastweek left join
(select Lastweek, IFNULL(count(*), 0) as countNord12U from information where Tested ='0' and Agare = 'Nord' and Nextdate < '2016-01-01' and (Bklass = 'B1' or Bklass = 'B2') group by Lastweek) as Nord12U on workweeks.Week = Nord12U.Lastweek 

where information.Lastweek > 0 order by workweeks.Week;


select distinct(week), Lastweek from staffplanning left join information on week = lastweek;

select distinct(information.Plannedweek) as week, staffplanning.Mondaydate as mondaydate, IFNULL(Syd.countSyd, 0) as countPlannedSyd, IFNULL(round(Syd.countSyd*0.7), 0) as occupiedTimeSyd, TimeSyd.Switches as timePlanned, 
IFNULL(round(Syd.countSyd*0.7) -TimeSyd.Switches, 0) as missingHours, IFNULL(round(round(Syd.countSyd*0.7)/TimeSyd.Switches*100), 0) as ratio
from information left join staffplanning on information.Plannedweek = staffplanning.Week left join  
(select Plannedweek, IFNULL(count(*), 0) as countSyd from information where Agare = 'Syd' and Nextdate < '2016-01-01' group by Plannedweek) as Syd on staffplanning.Week = Syd.Plannedweek left join 
(select Week, Switches from staffplanning where Region = 'Syd') as TimeSyd on staffplanning.Week = TimeSyd.Week 
where information.Plannedweek > 0 and information.Agare = 'Syd' order by staffplanning.Week ;

select distinct(staffplanning.Week) as week, staffplanning.Mondaydate as mondaydate, countPlannedRegion, round(countPlannedRegion*0.7) as occupiedTimeRegion, TimeRegion.Switches, 
IFNULL(round(countPlannedRegion*0.7) - TimeRegion.Switches, 0) as missingHours, 
IFNULL(round(round(countPlannedRegion*0.7)/TimeRegion.Switches*100), 0) as ratio from staffplanning left join 
(select Week, count(Plannedweek) as countPlannedRegion from Staffplanning left join information as Planned on Staffplanning.Week = Planned.Plannedweek 
				where staffplanning.Region='Syd' and Planned.Agare='Syd' group by staffplanning.Week) as Planned on staffplanning.Week = Planned.Week left join 
(select Week, Switches from staffplanning where Region = 'Syd') as TimeRegion on staffplanning.Week = TimeRegion.Week group by staffplanning.Week;





select distinct(information.Testedweek) as Testedweek, information.Plannedweek as Plannedweek, staffplanning.Mondaydate as mondaydate, IFNULL(SydPlanned.countSyd, 0) as countPlannedSyd, IFNULL(SydTested.countSyd, 0) as countTestedSyd
from information left join 
staffplanning as staff1 on information.Testedweek = staff1.Week left join 
staffplanning on information.Plannedweek = staffplanning.Week left join  
(select Testedweek, IFNULL(count(*), 0) as countSyd from information where Agare = 'Syd' and Nextdate < '2016-01-01' group by Testedweek) as SydTested on staffplanning.Week = SydTested.Testedweek left join 
(select Plannedweek, IFNULL(count(*), 0) as countSyd from information where Agare = 'Syd' and Nextdate < '2016-01-01' group by Plannedweek) as SydPlanned on staffplanning.Week = SydPlanned.Plannedweek left join 
(select Week from staffplanning where Region = 'Syd') as TimeSyd on staffplanning.Week = TimeSyd.Week 
where information.Testedweek > 0 and information.Agare = 'Syd' order by staffplanning.Week ;

select * from information where plannedweek='10';

select staffplanning.Week as Week, staffplanning.Mondaydate as Mondaydate, IFNULL(Planned.Plannedweek, 0) as Countplanned, IFNULL(Tested.Testedweek,0) as Counttested, IFNULL(Delayedtable.Delayedweek,0) as Countdelayed from staffplanning left join
(select Week, count(Testedweek) as Testedweek from Staffplanning left join information as Tested on Staffplanning.Week = Tested.Testedweek where staffplanning.Region='Syd' and Tested.Agare='Syd' group by staffplanning.Week) as Tested on staffplanning.Week = Tested.Week left join
(select Week, count(Plannedweek) as Plannedweek from Staffplanning left join information as Planned on Staffplanning.Week = Planned.Plannedweek where staffplanning.Region='Syd' and Planned.Agare='Syd' group by staffplanning.Week) as Planned on staffplanning.Week = Planned.Week left join 
(select Week, count(*) as Delayedweek from Staffplanning left join information as Delayedweeks on Staffplanning.Week = Delayedweeks.Plannedweek where staffplanning.Region='Syd' and Delayedweeks.Agare='Syd' and Delayedweeks.Testedweek > Delayedweeks.Plannedweek group by staffplanning.Week) as Delayedtable on staffplanning.Week = Delayedtable.Week where staffplanning.Region='Syd';



select Staffplanning.Week, count(Plannedweek), count(Testedweek) from Staffplanning left join information as Planned on Staffplanning.Week = Planned.Plannedweek left join
(select Week, count(Testedweek) from Staffplanning left join information as Tested on Staffplanning.Week = Tested.Testedweek where staffplanning.Region='Syd' and Tested.Agare='Syd' group by staffplanning.Week) as countTested on staffplanning.Week = Planned.Testedweek where staffplanning.Region='Syd' group by staffplanning.Week ;

select week, Switches from staffplanning where Region = 'Syd';

select * from information where Testedweek > Plannedweek;


select * from 

