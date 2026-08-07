-- ============================================================
-- IPL Cricket Analytics — SQL Analysis
-- Database: PostgreSQL
-- Data source: IPL Complete Dataset 2008–2024 (Kaggle)
-- ============================================================

-- ------------------------------------------------------------
-- 1. SCHEMA
-- ------------------------------------------------------------

CREATE DATABASE ipl_analytics;

CREATE TABLE matches (
    id INT PRIMARY KEY,
    season TEXT,
    city TEXT,
    date DATE,
    match_type TEXT,
    player_of_match TEXT,
    venue TEXT,
    team1 TEXT,
    team2 TEXT,
    toss_winner TEXT,
    toss_decision TEXT,
    winner TEXT,
    result TEXT,
    result_margin NUMERIC,
    target_runs NUMERIC,
    target_overs NUMERIC,
    super_over TEXT,
    method TEXT,
    umpire1 TEXT,
    umpire2 TEXT
);

CREATE TABLE deliveries (
    match_id INT,
    inning INT,
    batting_team TEXT,
    bowling_team TEXT,
    over INT,
    ball INT,
    batter TEXT,
    bowler TEXT,
    non_striker TEXT,
    batsman_runs INT,
    extra_runs INT,
    total_runs INT,
    extras_type TEXT,
    is_wicket INT,
    player_dismissed TEXT,
    dismissal_kind TEXT,
    fielder TEXT
);

ALTER TABLE deliveries
ADD CONSTRAINT fk_match
FOREIGN KEY (match_id) REFERENCES matches(id);

CREATE INDEX idx_deliveries_match_id ON deliveries(match_id);
CREATE INDEX idx_deliveries_batter ON deliveries(batter);
CREATE INDEX idx_deliveries_bowler ON deliveries(bowler);
CREATE INDEX idx_matches_season ON matches(season);

-- ------------------------------------------------------------
-- 2. DATA CLEANING
-- Team names and venue names in the raw dataset are inconsistent
-- across seasons (franchise rebrands, naming variants, prefix-only
-- duplicates). This section normalizes both to a single canonical
-- name per team/venue so aggregate queries don't silently split
-- one team's or venue's totals across multiple rows.
-- ------------------------------------------------------------

-- Team rebrands (same franchise, different name across seasons)
UPDATE matches SET team1 = 'Delhi Capitals' WHERE team1 = 'Delhi Daredevils';
UPDATE matches SET team2 = 'Delhi Capitals' WHERE team2 = 'Delhi Daredevils';
UPDATE matches SET toss_winner = 'Delhi Capitals' WHERE toss_winner = 'Delhi Daredevils';
UPDATE matches SET winner = 'Delhi Capitals' WHERE winner = 'Delhi Daredevils';

UPDATE matches SET team1 = 'Sunrisers Hyderabad' WHERE team1 = 'Deccan Chargers';
UPDATE matches SET team2 = 'Sunrisers Hyderabad' WHERE team2 = 'Deccan Chargers';
UPDATE matches SET toss_winner = 'Sunrisers Hyderabad' WHERE toss_winner = 'Deccan Chargers';
UPDATE matches SET winner = 'Sunrisers Hyderabad' WHERE winner = 'Deccan Chargers';

UPDATE matches SET team1 = 'Punjab Kings' WHERE team1 = 'Kings XI Punjab';
UPDATE matches SET team2 = 'Punjab Kings' WHERE team2 = 'Kings XI Punjab';
UPDATE matches SET toss_winner = 'Punjab Kings' WHERE toss_winner = 'Kings XI Punjab';
UPDATE matches SET winner = 'Punjab Kings' WHERE winner = 'Kings XI Punjab';

UPDATE matches SET team1 = 'Royal Challengers Bengaluru' WHERE team1 = 'Royal Challengers Bangalore';
UPDATE matches SET team2 = 'Royal Challengers Bengaluru' WHERE team2 = 'Royal Challengers Bangalore';
UPDATE matches SET toss_winner = 'Royal Challengers Bengaluru' WHERE toss_winner = 'Royal Challengers Bangalore';
UPDATE matches SET winner = 'Royal Challengers Bengaluru' WHERE winner = 'Royal Challengers Bangalore';

UPDATE matches SET team1 = 'Rising Pune Supergiants' WHERE team1 = 'Rising Pune Supergiant';
UPDATE matches SET team2 = 'Rising Pune Supergiants' WHERE team2 = 'Rising Pune Supergiant';
UPDATE matches SET toss_winner = 'Rising Pune Supergiants' WHERE toss_winner = 'Rising Pune Supergiant';
UPDATE matches SET winner = 'Rising Pune Supergiants' WHERE winner = 'Rising Pune Supergiant';

-- Same rebrands, mirrored onto the ball-by-ball table
UPDATE deliveries SET batting_team = 'Delhi Capitals' WHERE batting_team = 'Delhi Daredevils';
UPDATE deliveries SET bowling_team = 'Delhi Capitals' WHERE bowling_team = 'Delhi Daredevils';

UPDATE deliveries SET batting_team = 'Sunrisers Hyderabad' WHERE batting_team = 'Deccan Chargers';
UPDATE deliveries SET bowling_team = 'Sunrisers Hyderabad' WHERE bowling_team = 'Deccan Chargers';

UPDATE deliveries SET batting_team = 'Punjab Kings' WHERE batting_team = 'Kings XI Punjab';
UPDATE deliveries SET bowling_team = 'Punjab Kings' WHERE bowling_team = 'Kings XI Punjab';

UPDATE deliveries SET batting_team = 'Royal Challengers Bengaluru' WHERE batting_team = 'Royal Challengers Bangalore';
UPDATE deliveries SET bowling_team = 'Royal Challengers Bengaluru' WHERE bowling_team = 'Royal Challengers Bangalore';

UPDATE deliveries SET batting_team = 'Rising Pune Supergiants' WHERE batting_team = 'Rising Pune Supergiant';
UPDATE deliveries SET bowling_team = 'Rising Pune Supergiants' WHERE bowling_team = 'Rising Pune Supergiant';

-- Venue naming variants (same stadium, inconsistent naming across rows)
UPDATE matches SET venue = 'Eden Gardens'
WHERE venue IN ('Eden Gardens', 'Eden Gardens, Kolkata');

UPDATE matches SET venue = 'Arun Jaitley Stadium, Delhi'
WHERE venue IN ('Feroz Shah Kotla', 'Arun Jaitley Stadium', 'Arun Jaitley Stadium, Delhi');

UPDATE matches SET venue = 'M Chinnaswamy Stadium'
WHERE venue IN ('M Chinnaswamy Stadium', 'M.Chinnaswamy Stadium', 'M Chinnaswamy Stadium, Bengaluru');

UPDATE matches SET venue = 'MA Chidambaram Stadium, Chepauk, Chennai'
WHERE venue IN ('MA Chidambaram Stadium', 'MA Chidambaram Stadium, Chepauk', 'MA Chidambaram Stadium, Chepauk, Chennai');

UPDATE matches SET venue = 'Punjab Cricket Association IS Bindra Stadium, Mohali, Chandigarh'
WHERE venue IN (
    'Punjab Cricket Association IS Bindra Stadium',
    'Punjab Cricket Association Stadium, Mohali',
    'Punjab Cricket Association IS Bindra Stadium, Mohali'
);

UPDATE matches SET venue = 'Rajiv Gandhi International Stadium, Uppal, Hyderabad'
WHERE venue IN ('Rajiv Gandhi International Stadium', 'Rajiv Gandhi International Stadium, Uppal', 'Rajiv Gandhi International Stadium, Uppal, Hyderabad');

UPDATE matches SET venue = 'Sawai Mansingh Stadium, Jaipur'
WHERE venue IN ('Sawai Mansingh Stadium', 'Sawai Mansingh Stadium, Jaipur');

UPDATE matches SET venue = 'Wankhede Stadium, Mumbai'
WHERE venue IN ('Wankhede Stadium', 'Wankhede Stadium, Mumbai');

UPDATE matches SET venue = 'Brabourne Stadium, Mumbai'
WHERE venue = 'Brabourne Stadium';

UPDATE matches SET venue = 'Dr DY Patil Sports Academy, Mumbai'
WHERE venue = 'Dr DY Patil Sports Academy';

UPDATE matches SET venue = 'Dr. Y.S. Rajasekhara Reddy ACA-VDCA Cricket Stadium, Visakhapatnam'
WHERE venue = 'Dr. Y.S. Rajasekhara Reddy ACA-VDCA Cricket Stadium';

UPDATE matches SET venue = 'Himachal Pradesh Cricket Association Stadium, Dharamsala'
WHERE venue = 'Himachal Pradesh Cricket Association Stadium';

UPDATE matches SET venue = 'Maharashtra Cricket Association Stadium, Pune'
WHERE venue = 'Maharashtra Cricket Association Stadium';

-- Same physical stadium, renamed by sponsor (Sardar Patel Stadium -> Narendra Modi Stadium)
UPDATE matches SET venue = 'Narendra Modi Stadium, Ahmedabad'
WHERE venue = 'Sardar Patel Stadium, Motera';

-- Same physical stadium, formal vs. common name (IPL 2020, hosted in the UAE)
UPDATE matches SET venue = 'Sheikh Zayed Stadium'
WHERE venue = 'Zayed Cricket Stadium, Abu Dhabi';

-- Verification: every venue should now have a single row per team
-- with no near-duplicate names left un-merged.
SELECT venue, COUNT(*) OVER (PARTITION BY LEFT(venue, 15)) AS similar_count
FROM (SELECT DISTINCT venue FROM matches) v
ORDER BY LEFT(venue, 15), venue;

-- ------------------------------------------------------------
-- 3. ANALYTICAL QUERIES
-- ------------------------------------------------------------

-- 3.1 Head-to-head record between every pair of teams that have played each other
SELECT
    LEAST(team1, team2) AS team_a,
    GREATEST(team1, team2) AS team_b,
    COUNT(*) AS matches_played,
    SUM(CASE WHEN winner = LEAST(team1, team2) THEN 1 ELSE 0 END) AS team_a_wins,
    SUM(CASE WHEN winner = GREATEST(team1, team2) THEN 1 ELSE 0 END) AS team_b_wins
FROM matches
WHERE winner IS NOT NULL
GROUP BY LEAST(team1, team2), GREATEST(team1, team2)
ORDER BY matches_played DESC;

-- 3.2 Teams with the most close wins (margin-based tiebreaker for "clutch" performance)
SELECT
    winner,
    COUNT(*) AS close_wins
FROM matches
WHERE (result = 'runs' AND result_margin <= 10)
   OR (result = 'wickets' AND result_margin <= 2)
GROUP BY winner
ORDER BY close_wins DESC;

-- 3.3 Season-over-season win consistency per team
-- Uses a season_order CTE (ranked by each season's earliest match date)
-- instead of raw season-label comparison, so year-over-year change is
-- only computed between genuinely consecutive seasons — this avoids
-- misreading a season label gap (e.g. no season played) as a 1-season change.
WITH season_order AS (
    SELECT DISTINCT season,
        ROW_NUMBER() OVER (ORDER BY MIN(date)) AS season_seq
    FROM matches
    GROUP BY season
),
season_wins AS (
    SELECT
        so.season_seq,
        m.season,
        m.winner AS team,
        COUNT(*) AS wins
    FROM matches m
    JOIN season_order so ON m.season = so.season
    WHERE m.winner IS NOT NULL
    GROUP BY so.season_seq, m.season, m.winner
),
ranked AS (
    SELECT
        season_seq,
        season,
        team,
        wins,
        RANK() OVER (PARTITION BY season ORDER BY wins DESC) AS season_rank,
        LAG(wins) OVER (PARTITION BY team ORDER BY season_seq) AS prev_wins,
        LAG(season_seq) OVER (PARTITION BY team ORDER BY season_seq) AS prev_seq
    FROM season_wins
)
SELECT
    team,
    season,
    wins,
    season_rank,
    CASE WHEN season_seq - prev_seq = 1 THEN prev_wins ELSE NULL END AS prev_season_wins,
    CASE WHEN season_seq - prev_seq = 1 THEN wins - prev_wins ELSE NULL END AS change_from_prev_season
FROM ranked
ORDER BY team, season_seq;

-- 3.4 Venue advantage — which team wins most often at each ground (min. 5 wins)
SELECT
    venue,
    winner AS team,
    COUNT(*) AS wins_at_venue
FROM matches
WHERE winner IS NOT NULL
GROUP BY venue, winner
HAVING COUNT(*) >= 5
ORDER BY venue, wins_at_venue DESC;

-- ------------------------------------------------------------
-- 4. VIEWS
-- Reusable, pre-aggregated views that Power BI connects to directly,
-- rather than running raw joins/aggregations against 260,920 rows
-- of ball-by-ball data on every visual refresh.
-- ------------------------------------------------------------

-- 4.1 One flat table: every delivery joined to its match's season, venue, and outcome
CREATE VIEW deliveries_full AS
SELECT
    d.*,
    m.season,
    m.city,
    m.venue,
    m.date,
    m.winner AS match_winner,
    m.toss_winner,
    m.toss_decision
FROM deliveries d
JOIN matches m ON d.match_id = m.id;

-- 4.2 Career batting stats per player (min. 500 runs, filters out low-sample players)
CREATE VIEW batting_leaderboard AS
SELECT
    batter,
    COUNT(DISTINCT match_id) AS innings_played,
    SUM(batsman_runs) AS total_runs,
    SUM(CASE WHEN batsman_runs = 4 THEN 1 ELSE 0 END) AS fours,
    SUM(CASE WHEN batsman_runs = 6 THEN 1 ELSE 0 END) AS sixes,
    COUNT(*) FILTER (WHERE extras_type IS NULL OR extras_type NOT IN ('wides')) AS legal_balls_faced,
    ROUND(
        SUM(batsman_runs)::NUMERIC /
        NULLIF(COUNT(*) FILTER (WHERE extras_type IS NULL OR extras_type NOT IN ('wides')), 0) * 100,
        2
    ) AS strike_rate
FROM deliveries
GROUP BY batter
HAVING SUM(batsman_runs) >= 500
ORDER BY total_runs DESC;

-- 4.3 Career bowling stats per player (min. 30 wickets, filters out low-sample players)
CREATE VIEW bowling_leaderboard AS
SELECT
    bowler,
    COUNT(DISTINCT match_id) AS matches_bowled,
    SUM(CASE WHEN is_wicket = 1 AND (dismissal_kind NOT IN ('run out', 'retired hurt', 'retired out', 'obstructing the field') OR dismissal_kind IS NULL) THEN 1 ELSE 0 END) AS total_wickets,
    SUM(total_runs) AS runs_conceded,
    COUNT(*) FILTER (WHERE extras_type IS NULL OR extras_type NOT IN ('byes', 'legbyes')) AS balls_bowled,
    ROUND(
        SUM(total_runs)::NUMERIC /
        NULLIF(COUNT(*) FILTER (WHERE extras_type IS NULL OR extras_type NOT IN ('byes', 'legbyes')), 0) * 6,
        2
    ) AS economy_rate
FROM deliveries
GROUP BY bowler
HAVING SUM(CASE WHEN is_wicket = 1 AND (dismissal_kind NOT IN ('run out', 'retired hurt', 'retired out', 'obstructing the field') OR dismissal_kind IS NULL) THEN 1 ELSE 0 END) >= 30
ORDER BY total_wickets DESC;

-- 4.4 Head-to-head, saved as a view so Power BI can query it directly
CREATE VIEW head_to_head AS
SELECT
    LEAST(team1, team2) AS team_a,
    GREATEST(team1, team2) AS team_b,
    COUNT(*) AS matches_played,
    SUM(CASE WHEN winner = LEAST(team1, team2) THEN 1 ELSE 0 END) AS team_a_wins,
    SUM(CASE WHEN winner = GREATEST(team1, team2) THEN 1 ELSE 0 END) AS team_b_wins
FROM matches
WHERE winner IS NOT NULL
GROUP BY LEAST(team1, team2), GREATEST(team1, team2);

-- 4.5 Venue advantage, saved as a view so Power BI can query it directly
CREATE VIEW venue_advantage AS
SELECT
    venue,
    winner AS team,
    COUNT(*) AS wins_at_venue
FROM matches
WHERE winner IS NOT NULL
GROUP BY venue, winner
HAVING COUNT(*) >= 5;
