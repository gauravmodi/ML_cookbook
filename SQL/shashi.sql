WITH
    htable AS
        (WITH
            by_day AS (SELECT playername,
                              TD_DATE_TRUNC('day', time, 'PST') AS login_day
                         FROM gameevents
                        WHERE NOT regexp_like(playername ,'Hupia|Pawn')
                          AND playername NOT in (SELECT playername
                                                   FROM gameevents
                                                  WHERE NOT regexp_like(playername ,'Hupia|Pawn')
                                                    AND regexp_like(event ,'StartTalking'))
                        GROUP BY 1,2)}],

            with_first_day AS (SELECT playername,
                                      login_day,
                                      FIRST_VALUE(login_day) OVER (PARTITION BY playername ORDER BY login_day) AS first_day
                                 FROM by_day),

            with_day_number AS (SELECT playername,
                                       login_day,
                                       first_day,
                                       (login_day - first_day) / (24 * 60 * 60) AS day_number
                                  FROM with_first_day)

        SELECT TD_TIME_FORMAT(first_day, 'yyyy-MM-dd', 'PST') AS first_day,
               SUM(CASE WHEN day_number = 0 THEN 1 ELSE 0 END) AS day_0,
               SUM(CASE WHEN day_number = 1 THEN 1 ELSE 0 END) AS day_1,
               SUM(CASE WHEN day_number = 13 THEN 1 ELSE 0 END) AS day_13,
               SUM(CASE WHEN day_number = 14 THEN 1 ELSE 0 END) AS day_14,
               SUM(CASE WHEN day_number = 15  THEN 1 ELSE 0 END) AS day_15
          FROM with_day_number
         GROUP BY 1
         ORDER BY 1),

htable1 AS (WITH by_day
AS (SELECT
  playername,
  TD_DATE_TRUNC('day', time, 'PST') AS login_day
FROM gameevents
WHERE NOT regexp_like(playername ,'Hupia|Pawn')
and playername in (SELECT
  playername
FROM gameevents
WHERE NOT regexp_like(playername ,'Hupia|Pawn')
and regexp_like(event ,'StartTalking'))
group by 1,2),
with_first_day
AS (SELECT
  playername,
  login_day,
  FIRST_VALUE(login_day) OVER (PARTITION BY playername ORDER BY login_day) AS first_day
FROM by_day),
with_day_number
AS (SELECT
  playername,
  login_day,
  first_day,
  (login_day - first_day) / (24 * 60 * 60) AS day_number
FROM with_first_day)
SELECT
  TD_TIME_FORMAT(first_day, 'yyyy-MM-dd', 'PST') AS first_day,
  SUM(CASE WHEN day_number = 0 THEN 1 ELSE 0 END) AS day_0,
  SUM(CASE WHEN day_number = 1 THEN 1 ELSE 0 END) AS day_1,
  SUM(CASE WHEN day_number = 13 THEN 1 ELSE 0 END) AS day_13,
  SUM(CASE WHEN day_number = 14 THEN 1 ELSE 0 END) AS day_14,
   SUM(CASE WHEN day_number = 15  THEN 1 ELSE 0 END) AS day_15
  FROM with_day_number
GROUP BY 1
ORDER BY 1),
-- -----------------------------------------------------------------------------
htable2 as (WITH by_day
AS (SELECT
  playername,
  TD_DATE_TRUNC('day', time, 'PST') AS login_day
FROM gameevents
WHERE NOT regexp_like(playername ,'Hupia|Pawn')
AND regexp_like(event, 'PlayerSpawn')
GROUP BY 1, 2),
with_first_day
AS (SELECT
  playername,
  login_day,
  FIRST_VALUE(login_day) OVER (PARTITION BY playername ORDER BY login_day) AS first_day
FROM by_day),
with_day_number
AS (SELECT
  playername,
  login_day,
  first_day,
  (login_day - first_day) / (24 * 60 * 60) AS day_number
FROM with_first_day)
SELECT
  TD_TIME_FORMAT(first_day, 'yyyy-MM-dd', 'PST') AS first_day,
  SUM(CASE WHEN day_number = 0 THEN 1 ELSE 0 END) AS day_0,
  SUM(CASE WHEN day_number = 1 THEN 1 ELSE 0 END) AS day_1,
  SUM(CASE WHEN day_number = 13 THEN 1 ELSE 0 END) AS day_13,
  SUM(CASE WHEN day_number = 14 THEN 1 ELSE 0 END) AS day_14,
   SUM(CASE WHEN day_number = 15  THEN 1 ELSE 0 END) AS day_15
  FROM with_day_number
GROUP BY 1
ORDER BY 1),
-- -----------------------------------------------------------------------------
htable3 as (WITH by_day
AS (SELECT
  playername,
  TD_DATE_TRUNC('day', time, 'PST') AS login_day
FROM gameevents
WHERE NOT regexp_like(playername ,'Hupia|Pawn')
and playername in (SELECT
  playername
FROM gameevents
WHERE NOT regexp_like(playername ,'Hupia|Pawn')
and regexp_like(event ,'PlayerEscaped'))
group by 1,2),
with_first_day
AS (SELECT
  playername,
  login_day,
  FIRST_VALUE(login_day) OVER (PARTITION BY playername ORDER BY login_day) AS first_day
FROM by_day),
with_day_number
AS (SELECT
  playername,
  login_day,
  first_day,
  (login_day - first_day) / (24 * 60 * 60) AS day_number
FROM with_first_day)
SELECT
  TD_TIME_FORMAT(first_day, 'yyyy-MM-dd', 'PST') AS first_day,
  SUM(CASE WHEN day_number = 0 THEN 1 ELSE 0 END) AS day_0,
  SUM(CASE WHEN day_number = 1 THEN 1 ELSE 0 END) AS day_1,
  SUM(CASE WHEN day_number = 13 THEN 1 ELSE 0 END) AS day_13,
  SUM(CASE WHEN day_number = 14 THEN 1 ELSE 0 END) AS day_14,
   SUM(CASE WHEN day_number = 15  THEN 1 ELSE 0 END) AS day_15
  FROM with_day_number
GROUP BY 1
ORDER BY 1),
-- -----------------------------------------------------------------------------
htable4 as (WITH by_day
AS (SELECT
  playername,
  TD_DATE_TRUNC('day', time, 'PST') AS login_day
FROM gameevents
WHERE NOT regexp_like(playername ,'Hupia|Pawn')
and playername in (SELECT
  playername
FROM gameevents
WHERE not regexp_like(playername ,'Hupia|Pawn')
AND regexp_like(event ,'PlayerDeath')
AND not regexp_like(damagetype ,'DmgType_Thrown_C|DmgType_Melee_Hard_C|DmgType_Bullet_C|DmgType_Melee_Soft_C|DmgType_Suicide_C')
)
group by 1,2),
with_first_day
AS (SELECT
  playername,
  login_day,
  FIRST_VALUE(login_day) OVER (PARTITION BY playername ORDER BY login_day) AS first_day
FROM by_day),
with_day_number
AS (SELECT
  playername,
  login_day,
  first_day,
  (login_day - first_day) / (24 * 60 * 60) AS day_number
FROM with_first_day)
SELECT
  TD_TIME_FORMAT(first_day, 'yyyy-MM-dd', 'PST') AS first_day,
  SUM(CASE WHEN day_number = 0 THEN 1 ELSE 0 END) AS day_0,
  SUM(CASE WHEN day_number = 1 THEN 1 ELSE 0 END) AS day_1,
  SUM(CASE WHEN day_number = 13 THEN 1 ELSE 0 END) AS day_13,
  SUM(CASE WHEN day_number = 14 THEN 1 ELSE 0 END) AS day_14,
   SUM(CASE WHEN day_number = 15  THEN 1 ELSE 0 END) AS day_15
  FROM with_day_number
GROUP BY 1
ORDER BY 1),
-- -----------------------------------------------------------------------------
htable5 as (WITH by_day
AS (SELECT
  playername,
  TD_DATE_TRUNC('day', time, 'PST') AS login_day
FROM gameevents
WHERE NOT regexp_like(playername ,'Hupia|Pawn')
and playername in (SELECT
  playername
FROM gameevents
WHERE not regexp_like(playername ,'Hupia|Pawn')
and regexp_like(event ,'ItemPickup')
and regexp_like(itemname ,'Weapon_Schnauzer_C|Weapon_Wilcox_C|Weapon_Revolver_C')
)
group by 1,2),
with_first_day
AS (SELECT
  playername,
  login_day,
  FIRST_VALUE(login_day) OVER (PARTITION BY playername ORDER BY login_day) AS first_day
FROM by_day),
with_day_number
AS (SELECT
  playername,
  login_day,
  first_day,
  (login_day - first_day) / (24 * 60 * 60) AS day_number
FROM with_first_day)
SELECT
  TD_TIME_FORMAT(first_day, 'yyyy-MM-dd', 'PST') AS first_day,
  SUM(CASE WHEN day_number = 0 THEN 1 ELSE 0 END) AS day_0,
  SUM(CASE WHEN day_number = 1 THEN 1 ELSE 0 END) AS day_1,
  SUM(CASE WHEN day_number = 13 THEN 1 ELSE 0 END) AS day_13,
  SUM(CASE WHEN day_number = 14 THEN 1 ELSE 0 END) AS day_14,
   SUM(CASE WHEN day_number = 15  THEN 1 ELSE 0 END) AS day_15
  FROM with_day_number
GROUP BY 1
ORDER BY 1),
-- -----------------------------------------------------------------------------
htable6 as (WITH by_day
AS (SELECT
  playername,
  TD_DATE_TRUNC('day', time, 'PST') AS login_day
FROM gameevents
WHERE NOT regexp_like(playername ,'Hupia|Pawn')
and playername in (with match_friended as
(SELECT
   playername, count (distinct matchguid) as matchfriended
FROM gameevents
WHERE event = 'PlayerFriended'
group by 1
order by 1),

total_matches as
(SELECT
   playername, count (distinct matchguid) as totalmatches
FROM gameevents
group by 1
order by 1)

SELECT match_friended.playername
from match_friended join total_matches ON match_friended.playername = total_matches.playername
WHERE cast (match_friended.matchfriended as DOUBLE) / cast (total_matches.totalmatches as DOUBLE) > 0.7)
GROUP BY 1, 2),
with_first_day
AS (SELECT
  playername,
  login_day,
  FIRST_VALUE(login_day) OVER (PARTITION BY playername ORDER BY login_day) AS first_day
FROM by_day),
with_day_number
AS (SELECT
  playername,
  login_day,
  first_day,
  (login_day - first_day) / (24 * 60 * 60) AS day_number
FROM with_first_day)
SELECT
  TD_TIME_FORMAT(first_day, 'yyyy-MM-dd', 'PST') AS first_day,
  SUM(CASE WHEN day_number = 0 THEN 1 ELSE 0 END) AS day_0,
  SUM(CASE WHEN day_number = 1 THEN 1 ELSE 0 END) AS day_1,
  SUM(CASE WHEN day_number = 13 THEN 1 ELSE 0 END) AS day_13,
  SUM(CASE WHEN day_number = 14 THEN 1 ELSE 0 END) AS day_14,
   SUM(CASE WHEN day_number = 15  THEN 1 ELSE 0 END) AS day_15
  FROM with_day_number
GROUP BY 1
ORDER BY 1),
-- -----------------------------------------------------------------------------
htable7 as (WITH by_day
AS (SELECT
  playername,
  TD_DATE_TRUNC('day', time, 'PST') AS login_day
FROM gameevents
WHERE NOT regexp_like(playername ,'Hupia|Pawn')
and playername not in (SELECT
  playername
FROM gameevents
WHERE not regexp_like(playername ,'Hupia|Pawn')
and regexp_like(event ,'ItemPickup')
and regexp_like(itemname ,'Weapon_Schnauzer_C|Weapon_Wilcox_C|Weapon_Revolver_C')
)
group by 1,2),
with_first_day
AS (SELECT
  playername,
  login_day,
  FIRST_VALUE(login_day) OVER (PARTITION BY playername ORDER BY login_day) AS first_day
FROM by_day),
with_day_number
AS (SELECT
  playername,
  login_day,
  first_day,
  (login_day - first_day) / (24 * 60 * 60) AS day_number
FROM with_first_day)
SELECT
  TD_TIME_FORMAT(first_day, 'yyyy-MM-dd', 'PST') AS first_day,
  SUM(CASE WHEN day_number = 0 THEN 1 ELSE 0 END) AS day_0,
  SUM(CASE WHEN day_number = 1 THEN 1 ELSE 0 END) AS day_1,
  SUM(CASE WHEN day_number = 13 THEN 1 ELSE 0 END) AS day_13,
  SUM(CASE WHEN day_number = 14 THEN 1 ELSE 0 END) AS day_14,
   SUM(CASE WHEN day_number = 15  THEN 1 ELSE 0 END) AS day_15
  FROM with_day_number
GROUP BY 1
ORDER BY 1),
-- -----------------------------------------------------------------------------
htable8 as (WITH by_day
AS (SELECT
  playername,
  TD_DATE_TRUNC('day', time, 'PST') AS login_day
FROM gameevents
WHERE NOT regexp_like(playername ,'Hupia|Pawn')
and playername not in (SELECT
  playername
FROM gameevents
WHERE NOT regexp_like(playername ,'Hupia|Pawn')
and regexp_like(event ,'PlayerFriended'))
group by 1,2),
with_first_day
AS (SELECT
  playername,
  login_day,
  FIRST_VALUE(login_day) OVER (PARTITION BY playername ORDER BY login_day) AS first_day
FROM by_day),
with_day_number
AS (SELECT
  playername,
  login_day,
  first_day,
  (login_day - first_day) / (24 * 60 * 60) AS day_number
FROM with_first_day)
SELECT
  TD_TIME_FORMAT(first_day, 'yyyy-MM-dd', 'PST') AS first_day,
  SUM(CASE WHEN day_number = 0 THEN 1 ELSE 0 END) AS day_0,
  SUM(CASE WHEN day_number = 1 THEN 1 ELSE 0 END) AS day_1,
  SUM(CASE WHEN day_number = 13 THEN 1 ELSE 0 END) AS day_13,
  SUM(CASE WHEN day_number = 14 THEN 1 ELSE 0 END) AS day_14,
   SUM(CASE WHEN day_number = 15  THEN 1 ELSE 0 END) AS day_15
  FROM with_day_number
GROUP BY 1
ORDER BY 1),
-- -----------------------------------------------------------------------------
htable9 as (WITH by_day
AS (SELECT
  playername,
  TD_DATE_TRUNC('day', time, 'PST') AS login_day
FROM gameevents
WHERE NOT regexp_like(playername ,'Hupia|Pawn')
and playername  not in (SELECT
  playername
FROM gameevents
WHERE NOT regexp_like(playername ,'Hupia|Pawn')
and regexp_like(event ,'PlayerIsNearOtherPlayer'))
group by 1,2),
with_first_day
AS (SELECT
  playername,
  login_day,
  FIRST_VALUE(login_day) OVER (PARTITION BY playername ORDER BY login_day) AS first_day
FROM by_day),
with_day_number
AS (SELECT
  playername,
  login_day,
  first_day,
  (login_day - first_day) / (24 * 60 * 60) AS day_number
FROM with_first_day)
SELECT
  TD_TIME_FORMAT(first_day, 'yyyy-MM-dd', 'PST') AS first_day,
  SUM(CASE WHEN day_number = 0 THEN 1 ELSE 0 END) AS day_0,
  SUM(CASE WHEN day_number = 1 THEN 1 ELSE 0 END) AS day_1,
  SUM(CASE WHEN day_number = 13 THEN 1 ELSE 0 END) AS day_13,
  SUM(CASE WHEN day_number = 14 THEN 1 ELSE 0 END) AS day_14,
   SUM(CASE WHEN day_number = 15  THEN 1 ELSE 0 END) AS day_15
  FROM with_day_number
GROUP BY 1
ORDER BY 1),
-- -----------------------------------------------------------------------------
htable10 as (WITH by_day
AS (SELECT
  playername,
  TD_DATE_TRUNC('day', time, 'PST') AS login_day
FROM gameevents
WHERE NOT regexp_like(playername ,'Hupia|Pawn')
and playername in (SELECT
  playername
FROM gameevents
WHERE not regexp_like(playername ,'Hupia|Pawn')
AND regexp_like(event ,'PlayerDeath')
AND regexp_like(damagetype ,'DmgType_Thrown_C|DmgType_Melee_Hard_C|DmgType_Bullet_C|DmgType_Melee_Soft_C')
AND NOT regexp_like(damagetype ,'DmgType_Suicide_C')
)
group by 1,2),
with_first_day
AS (SELECT
  playername,
  login_day,
  FIRST_VALUE(login_day) OVER (PARTITION BY playername ORDER BY login_day) AS first_day
FROM by_day),
with_day_number
AS (SELECT
  playername,
  login_day,
  first_day,
  (login_day - first_day) / (24 * 60 * 60) AS day_number
FROM with_first_day)
SELECT
  TD_TIME_FORMAT(first_day, 'yyyy-MM-dd', 'PST') AS first_day,
  SUM(CASE WHEN day_number = 0 THEN 1 ELSE 0 END) AS day_0,
  SUM(CASE WHEN day_number = 1 THEN 1 ELSE 0 END) AS day_1,
  SUM(CASE WHEN day_number = 13 THEN 1 ELSE 0 END) AS day_13,
  SUM(CASE WHEN day_number = 14 THEN 1 ELSE 0 END) AS day_14,
   SUM(CASE WHEN day_number = 15  THEN 1 ELSE 0 END) AS day_15
  FROM with_day_number
GROUP BY 1
ORDER BY 1),
-- -----------------------------------------------------------------------------
htable12 as (WITH by_day
AS (SELECT
  playername,
  TD_DATE_TRUNC('day', time, 'PST') AS login_day
FROM gameevents
WHERE NOT regexp_like(playername ,'Hupia|Pawn')
and playername in (SELECT
  playername
FROM gameevents
WHERE NOT regexp_like(playername ,'Hupia|Pawn')
and regexp_like(event ,'MatchSocialWinner'))
group by 1,2),
with_first_day
AS (SELECT
  playername,
  login_day,
  FIRST_VALUE(login_day) OVER (PARTITION BY playername ORDER BY login_day) AS first_day
FROM by_day),
with_day_number
AS (SELECT
  playername,
  login_day,
  first_day,
  (login_day - first_day) / (24 * 60 * 60) AS day_number
FROM with_first_day)
SELECT
  TD_TIME_FORMAT(first_day, 'yyyy-MM-dd', 'PST') AS first_day,
  SUM(CASE WHEN day_number = 0 THEN 1 ELSE 0 END) AS day_0,
  SUM(CASE WHEN day_number = 1 THEN 1 ELSE 0 END) AS day_1,
  SUM(CASE WHEN day_number = 13 THEN 1 ELSE 0 END) AS day_13,
  SUM(CASE WHEN day_number = 14 THEN 1 ELSE 0 END) AS day_14,
   SUM(CASE WHEN day_number = 15  THEN 1 ELSE 0 END) AS day_15
  FROM with_day_number
GROUP BY 1
ORDER BY 1),
htable11 as (WITH by_day
AS (SELECT
  playername,
  TD_DATE_TRUNC('day', time, 'PST') AS login_day
FROM gameevents
WHERE NOT regexp_like(playername ,'Hupia|Pawn')
and playername  in (SELECT
  killername
FROM gameevents
WHERE regexp_like(event ,'NpcDeath'))
group by 1,2),
with_first_day
AS (SELECT
  playername,
  login_day,
  FIRST_VALUE(login_day) OVER (PARTITION BY playername ORDER BY login_day) AS first_day
FROM by_day),
with_day_number
AS (SELECT
  playername,
  login_day,
  first_day,
  (login_day - first_day) / (24 * 60 * 60) AS day_number
FROM with_first_day)
SELECT
  TD_TIME_FORMAT(first_day, 'yyyy-MM-dd', 'PST') AS first_day,
  SUM(CASE WHEN day_number = 0 THEN 1 ELSE 0 END) AS day_0,
  SUM(CASE WHEN day_number = 1 THEN 1 ELSE 0 END) AS day_1,
  SUM(CASE WHEN day_number = 13 THEN 1 ELSE 0 END) AS day_13,
  SUM(CASE WHEN day_number = 14 THEN 1 ELSE 0 END) AS day_14,
   SUM(CASE WHEN day_number = 15  THEN 1 ELSE 0 END) AS day_15
  FROM with_day_number
GROUP BY 1
ORDER BY 1),
-- -----------------------------------------------------------------------------
htable13 as (WITH by_day
AS (SELECT
  playername,
  TD_DATE_TRUNC('day', time, 'PST') AS login_day
FROM gameevents
WHERE NOT regexp_like(playername ,'Hupia|Pawn')
and playername in (SELECT
  playername
FROM gameevents
WHERE NOT regexp_like(playername ,'Hupia|Pawn')
and regexp_like(event ,'PlayerViewScore')
and not regexp_like(Total ,'0')

)
group by 1,2),
with_first_day
AS (SELECT
  playername,
  login_day,
  FIRST_VALUE(login_day) OVER (PARTITION BY playername ORDER BY login_day) AS first_day
FROM by_day),
with_day_number
AS (SELECT
  playername,
  login_day,
  first_day,
  (login_day - first_day) / (24 * 60 * 60) AS day_number
FROM with_first_day)
SELECT
  TD_TIME_FORMAT(first_day, 'yyyy-MM-dd', 'PST') AS first_day,
  SUM(CASE WHEN day_number = 0 THEN 1 ELSE 0 END) AS day_0,
  SUM(CASE WHEN day_number = 1 THEN 1 ELSE 0 END) AS day_1,
  SUM(CASE WHEN day_number = 13 THEN 1 ELSE 0 END) AS day_13,
  SUM(CASE WHEN day_number = 14 THEN 1 ELSE 0 END) AS day_14,
   SUM(CASE WHEN day_number = 15  THEN 1 ELSE 0 END) AS day_15
  FROM with_day_number
GROUP BY 1
ORDER BY 1),
-- -----------------------------------------------------------------------------
htable14 as (WITH feed_stream as (select platform_prod.stream_event.owner_id, TD_DATE_TRUNC('day', platform_prod.stream_event.time, 'PST') AS login_day
from platform_prod.stream_event
WHERE twitch in
(select service_id
from platform_prod.stream_socket
WHERE regexp_like(service ,'twitch')
)
group by 1,2),
by_day
AS (SELECT
  playername,
  TD_DATE_TRUNC('day', time, 'PST') AS login_day
FROM sos_prod.gameevents join feed_stream on sos_prod.gameevents.playerid = feed_stream.owner_id and feed_stream.login_day = td_date_trunc('day',sos_prod.gameevents.time,'PST')
WHERE NOT regexp_like(playername ,'Hupia|Pawn') AND event = 'PlayerSpawn'
GROUP BY 1, 2),
with_first_day
AS (SELECT
  playername,
  login_day,
  FIRST_VALUE(login_day) OVER (PARTITION BY playername ORDER BY login_day) AS first_day
FROM by_day),
with_day_number
AS (SELECT
  playername,
  login_day,
  first_day,
  (login_day - first_day) / (24 * 60 * 60) AS day_number
FROM with_first_day)
SELECT
  TD_TIME_FORMAT(first_day, 'yyyy-MM-dd', 'PST') AS first_day,
  SUM(CASE WHEN day_number = 0 THEN 1 ELSE 0 END) AS day_0,
  SUM(CASE WHEN day_number = 1 THEN 1 ELSE 0 END) AS day_1,
  SUM(CASE WHEN day_number = 13 THEN 1 ELSE 0 END) AS day_13,
  SUM(CASE WHEN day_number = 14 THEN 1 ELSE 0 END) AS day_14,
   SUM(CASE WHEN day_number = 15  THEN 1 ELSE 0 END) AS day_15
  FROM with_day_number
GROUP BY 1
),
-- -----------------------------------------------------------------------------
htable15 as (WITH feed_stream as (select platform_prod.stream_event.owner_id, TD_DATE_TRUNC('day', platform_prod.stream_event.time, 'PST') AS login_day
from platform_prod.stream_event
WHERE stream_id in
(SELECT  distinct stream_id
from platform_prod.stream_event
where event ='feedback'
and conn_id NOT in ( SELECT conn_id from platform_prod.stream_socket where service = 'account')
)
group by 1,2),
by_day
AS (SELECT
  playername,
  TD_DATE_TRUNC('day', time, 'PST') AS login_day
FROM sos_prod.gameevents join feed_stream on sos_prod.gameevents.playerid = feed_stream.owner_id and feed_stream.login_day = td_date_trunc('day',sos_prod.gameevents.time,'PST')
WHERE NOT regexp_like(playername ,'Hupia|Pawn') AND event = 'PlayerSpawn'
GROUP BY 1, 2),
with_first_day
AS (SELECT
  playername,
  login_day,
  FIRST_VALUE(login_day) OVER (PARTITION BY playername ORDER BY login_day) AS first_day
FROM by_day),
with_day_number
AS (SELECT
  playername,
  login_day,
  first_day,
  (login_day - first_day) / (24 * 60 * 60) AS day_number
FROM with_first_day)
SELECT
  TD_TIME_FORMAT(first_day, 'yyyy-MM-dd', 'PST') AS first_day,
  SUM(CASE WHEN day_number = 0 THEN 1 ELSE 0 END) AS day_0,
  SUM(CASE WHEN day_number = 1 THEN 1 ELSE 0 END) AS day_1,
  SUM(CASE WHEN day_number = 13 THEN 1 ELSE 0 END) AS day_13,
  SUM(CASE WHEN day_number = 14 THEN 1 ELSE 0 END) AS day_14,
   SUM(CASE WHEN day_number = 15  THEN 1 ELSE 0 END) AS day_15
  FROM with_day_number
GROUP BY 1
)
-- -----------------------------------------------------------------------------

select t1.first_day, t2.day, t2.value, 'Did Not Talk' as cohort from htable t1 CROSS JOIN unnest (
  array['day_0', 'day_1','day_13', 'day_14', 'day_15'],
  array[day_0, day_1, day_13, day_14, day_15]
) t2 (day, value)
UNION ALL
select t1.first_day, t2.day, t2.value, 'Who Talked' as cohort from htable1 t1 CROSS JOIN unnest (
  array['day_0', 'day_1','day_13', 'day_14', 'day_15'],
  array[day_0, day_1, day_13, day_14, day_15]
) t2 (day, value)
UNION ALL
select t1.first_day, t2.day, t2.value, 'Overall' as cohort from htable2 t1 CROSS JOIN unnest (
  array['day_0', 'day_1','day_13', 'day_14', 'day_15'],
  array[day_0, day_1, day_13, day_14, day_15]
) t2 (day, value)
UNION ALL
select t1.first_day, t2.day, t2.value, 'Who Escaped' as cohort from htable3 t1 CROSS JOIN unnest (
  array['day_0', 'day_1','day_13', 'day_14', 'day_15'],
  array[day_0, day_1, day_13, day_14, day_15]
) t2 (day, value)
UNION ALL
select t1.first_day, t2.day, t2.value, 'Death By Hupia_Environment' as cohort from htable4 t1 CROSS JOIN unnest (
  array['day_0', 'day_1','day_13', 'day_14', 'day_15'],
  array[day_0, day_1, day_13, day_14, day_15]
) t2 (day, value)
UNION ALL
select t1.first_day, t2.day, t2.value, 'Who Found Gun' as cohort from htable5 t1 CROSS JOIN unnest (
  array['day_0', 'day_1','day_13', 'day_14', 'day_15'],
  array[day_0, day_1, day_13, day_14, day_15]
) t2 (day, value)
UNION ALL
select t1.first_day, t2.day, t2.value, 'Made Friends more Than 70%' as cohort from htable6 t1 CROSS JOIN unnest (
  array['day_0', 'day_1','day_13', 'day_14', 'day_15'],
  array[day_0, day_1, day_13, day_14, day_15]
) t2 (day, value)
UNION ALL
select t1.first_day, t2.day, t2.value, 'Who never found a gun' as cohort from htable7 t1 CROSS JOIN unnest (
  array['day_0', 'day_1','day_13', 'day_14', 'day_15'],
  array[day_0, day_1, day_13, day_14, day_15]
) t2 (day, value)
UNION ALL
select t1.first_day, t2.day, t2.value, 'Who never made friends' as cohort from htable8 t1 CROSS JOIN unnest (
  array['day_0', 'day_1','day_13', 'day_14', 'day_15'],
  array[day_0, day_1, day_13, day_14, day_15]
) t2 (day, value)
UNION ALL
select t1.first_day, t2.day, t2.value, 'Never Met Someone' as cohort from htable9 t1 CROSS JOIN unnest (
  array['day_0', 'day_1','day_13', 'day_14', 'day_15'],
  array[day_0, day_1, day_13, day_14, day_15]
) t2 (day, value)
UNION ALL
select t1.first_day, t2.day, t2.value, 'Player Who Killed Player' as cohort from htable10 t1 CROSS JOIN unnest (
  array['day_0', 'day_1','day_13', 'day_14', 'day_15'],
  array[day_0, day_1, day_13, day_14, day_15]
) t2 (day, value)
UNION ALL
select t1.first_day, t2.day, t2.value, 'Playes Who Killed Hupia' as cohort from htable11 t1 CROSS JOIN unnest (
  array['day_0', 'day_1','day_13', 'day_14', 'day_15'],
  array[day_0, day_1, day_13, day_14, day_15]
) t2 (day, value)
UNION ALL
select t1.first_day, t2.day, t2.value, 'Won top perfomer' as cohort from htable12 t1 CROSS JOIN unnest (
  array['day_0', 'day_1','day_13', 'day_14', 'day_15'],
  array[day_0, day_1, day_13, day_14, day_15]
) t2 (day, value)
UNION ALL
select t1.first_day, t2.day, t2.value, 'Received Feedback' as cohort from htable13 t1 CROSS JOIN unnest (
  array['day_0', 'day_1','day_13', 'day_14', 'day_15'],
  array[day_0, day_1, day_13, day_14, day_15]
) t2 (day, value)
UNION ALL
select t1.first_day, t2.day, t2.value, 'Viewed On Hero' as cohort from htable14 t1 CROSS JOIN unnest (
  array['day_0', 'day_1','day_13', 'day_14', 'day_15'],
  array[day_0, day_1, day_13, day_14, day_15]
) t2 (day, value)
UNION ALL
select t1.first_day, t2.day, t2.value, 'Received Feedback' as cohort from htable15 t1 CROSS JOIN unnest (
  array['day_0', 'day_1','day_13', 'day_14', 'day_15'],
  array[day_0, day_1, day_13, day_14, day_15]
) t2 (day, value)
