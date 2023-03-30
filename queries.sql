# OLYMPICS HISTORY

#CREATE TABLE OLYMPIC HISTORY

CREATE TABLE OLYMPICS_HISTORY
(
    id          INT,
    name        VARCHAR,
    sex         VARCHAR,
    age         VARCHAR,
    height      VARCHAR,
    weight      VARCHAR,
    team        VARCHAR,
    noc         VARCHAR,
    games       VARCHAR,
    year        INT,
    season      VARCHAR,
    city        VARCHAR,
    sport       VARCHAR,
    event       VARCHAR,
    medal       VARCHAR
);

#CREATE TABLE OLYMPICS HISTORY NOC REGIONS

CREATE TABLE OLYMPICS_HISTORY_NOC_REGIONS
(
    noc         VARCHAR,
    region      VARCHAR,
    notes       VARCHAR
);

select * from OLYMPICS_HISTORY;
select * from OLYMPICS_HISTORY
_NOC_REGIONS;
-- QUE1: FIND TOTAL NUMBER OF SUMMER OLYMPIC GAMES.
-- FIND FOR EACH SPORT, HOW MANY GAMES WERE THEY PLAYED IN.

WITH T1 AS
(SELECT COUNT(DISTINCT Games) AS TOTAL_NUMBER_OF_GAMES 
 FROM OLYMPICS_HISTORY WHERE SEASON ='Summer'),
 T2 AS
 (SELECT DISTINCT sport, games 
  FROM OLYMPICS_HISTORY WHERE SEASON ='Summer'
 ORDER BY games),
 T3 AS
 (SELECT sport, count(games) AS no_of_games
 FROM T2 GROUP BY sport)
 SELECT * FROM T3
 JOIN T1 ON T1.total_number_of_games = T3.no_of_games;


-- QUE2: FETCH THE TOP 5 ATHLETES WHO HAVE WON THE MOST GOLD MEDALS.

WITH T1 AS 
(SELECT name, COUNT(1) AS total_medals
FROM OLYMPICS_HISTORY WHERE medal = 'Gold'
GROUP BY name 
ORDER BY COUNT(1) DESC),
T2 AS 
(SELECT * , DENSE_RANK () OVER (ORDER BY total_medals DESC )AS rnk_no
FROM T1)
SELECT * FROM T2
WHERE rnk_no <= 5 ;

-- QUE3: LIST DOWN TOTAL GOLD, SILVER AND BRONZE MEDALS WON BY EACH COUNTRY.

SELECT country
    	, coalesce(gold, 0) as gold
    	, coalesce(silver, 0) as silver
    	, coalesce(bronze, 0) as bronze
    FROM CROSSTAB('SELECT nr.region as country
    			, medal
    			, count(1) as total_medals
    			FROM olympics_history oh
    			JOIN olympics_history_noc_regions nr ON nr.noc = oh.noc
    			where medal <> ''NA''
    			GROUP BY nr.region,medal
    			order BY nr.region,medal',
            'values (''Bronze''), (''Gold''), (''Silver'')')
    AS FINAL_RESULT(country varchar, bronze bigint, gold bigint, silver bigint)
    order by gold desc, silver desc, bronze desc;


-- QUE4: IDENTIFY WHICH COUNTRY WON THE MOST GOLD, MOST SILVER AND MOST BRONZE MEDALS IN EACH OLYMPIC GAMES.

   
 
