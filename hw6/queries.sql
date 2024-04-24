-- 3) request for the sum of points with grouping and sorting by year
SELECT year_game, sum(points)
FROM aggregating.statistic
GROUP BY year_game
ORDER BY year_game;
-- 4) The same request by using CTE
WITH stat AS (SELECT year_game, sum(points) as points_sum
              FROM aggregating.statistic
              GROUP BY year_game
              ORDER BY year_game)
SELECT stat.year_game, stat.points_sum FROM stat;
-- 3) number of points for each player for the current year and for the previous one
SELECT player_id,
       year_game current_year,
       points as current_point,
       lag(points) over (partition by player_id order by year_game) as prev_year_point
FROM aggregating.statistic;
