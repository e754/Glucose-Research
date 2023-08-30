CREATE TABLE `db_name.my_Mimic.onlyGlucose` AS
select * from `physionet-data.mimiciv_icu.chartevents` where itemid IN (220621, 228388, 225664,226537);
