# ipl-cricket-analytics
Analyzing IPL player and team performance data to uncover insights using Python, SQL, and Power BI

# IPL Cricket Analytics 🏏

## Problem Statement
IPL franchises and analysts rely on player and match statistics to understand performance trends and team strategy. This project analyzes IPL match and delivery data (2008–2024) to evaluate batting and bowling performance, examine how toss decisions affect match outcomes, and surface head-to-head and venue-level patterns across 17 seasons.

## Objectives
- Evaluate batting and bowling performance across seasons (top run scorers, wicket takers, strike rate, economy rate)
- Analyze the impact of toss decisions (bat vs. field) on match outcomes
- Examine head-to-head records and venue-specific win patterns between teams
- Present findings through an interactive Power BI dashboard
- Identify statistically undervalued batters and bowlers based on performance metrics (Python analysis — not included in the Power BI dashboard)
- Design a normalized PostgreSQL schema and resolve data-quality issues (inconsistent team/venue naming across seasons)

## Tools Used
- **Python** (Pandas, Matplotlib, Seaborn) — Data cleaning, analysis & visualization
- **PostgreSQL** — Schema design, data cleaning, and relational analysis (window functions, joins, views)
- **Power BI** — Interactive dashboard

## Dataset
IPL Complete Dataset 2008–2024 (Kaggle)
- `matches.csv` — Match-level data
- `deliveries.csv` — Ball-by-ball data

## Project Structure
```
ipl-cricket-analytics/
├── README.md
├── notebooks/
│   └── ipl_analysis.ipynb
├── dashboard/
│   └── ipl_dashboard.pbix
├── queries/
│   └── analysis.sql
└── screenshots/
    ├── overview.png
    ├── toss_chase_impact.png
    ├── batting_leaderboard.png
    ├── bowling_leaderboard.png
    └── head_to_head_venues.png
```

## Dashboard Preview
**Overview**
![Overview](screenshots/overview.png)

**Toss & Chase Impact**
![Toss & Chase Impact](screenshots/toss_chase_impact.png)

**Batting Leaderboard**
![Batting Leaderboard](screenshots/batting_leaderboard.png)

**Bowling Leaderboard**
![Bowling Leaderboard](screenshots/bowling_leaderboard.png)

**Head-to-Head & Venues**
![Head-to-Head & Venues](screenshots/head_to_head_venues.png)
