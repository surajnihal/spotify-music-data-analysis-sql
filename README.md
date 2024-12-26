# Spotify Music Data Analysis and Query Optimization 

![image](https://github.com/user-attachments/assets/32f2af4a-ab8d-4170-b5ab-eb6a3c867378)

## Overview
This project involves analyzing a Spotify dataset containing detailed attributes about tracks, albums, and artists using **SQL**. The goal is to strengthen SQL skills by covering an end-to-end process:
1. Normalizing a denormalized dataset.
2. Writing SQL queries of varying complexity—easy, medium, and advanced.
3. Optimizing query performance.
4. Generating actionable insights.

---

## Project Highlights

### Key Skills Demonstrated
- **SQL Proficiency**:
  - Writing and executing complex queries, including window functions, CTEs, and subqueries.
  - Performance optimization through indexing and query execution plans.
- **Data Analysis**:
  - Exploring patterns in music data (e.g., track popularity, artist trends).
  - Deriving meaningful insights using advanced SQL techniques.
- **Database Design**:
  - Normalizing data for efficient querying and analysis.

---

## Steps in the Project Workflow

### 1. Data Exploration
A thorough understanding of the dataset was the first step. Key attributes include:
- **Tracks**: Song names, popularity, and metrics like `danceability`, `energy`, `tempo`, and `loudness`.
- **Artists and Albums**: Information about performers, album type (e.g., single, album), and release details.

### 2. Data Normalization
The dataset was normalized to:
- Reduce redundancy.
- Improve database design.
- Enable efficient querying.

### 3. Query Categorization
Queries were structured into three levels—**easy**, **medium**, and **advanced**—to progressively enhance SQL expertise.

#### Easy Queries
- Retrieving and filtering data.
- Basic aggregations like counts and sums.

#### Medium Queries
- Grouping data by categories (e.g., albums or artists).
- Applying aggregation functions and joins.

#### Advanced Queries
- Using window functions for ranking and partitioning.
- Writing reusable CTEs and optimizing complex subqueries.
- Evaluating query performance with tools like `EXPLAIN ANALYZE`.

### 4. Query Optimization
Advanced optimizations included:
- **Indexing**: Applied indexes on frequently used columns to enhance query speed.
- **Execution Plans**: Analyzed and refined queries using `EXPLAIN ANALYZE`.

---

## Practice Questions

### Easy 
1. Retrieve all tracks with over 1 billion streams.
2. List all albums and their respective artists.
3. Find all tracks with the album type `single`.
4. Count the number of tracks for each artist.
5. Retrieve the names of tracks where `licensed = TRUE`.

### Medium 
1. Calculate the average `danceability` for tracks in each album.
2. Find the top 5 tracks with the highest energy values.
3. List tracks, views, and likes where `official_video = TRUE`.
4. For each album, calculate the total views of associated tracks.
5. Identify tracks streamed on Spotify more than on YouTube.
6. Retrieve tracks where the `liveness` score exceeds the dataset’s average.

### Advanced 
1. Use a window function to find the top 3 most-viewed tracks for each artist.
   ```sql
   SELECT * 
   FROM(
       SELECT
	  artist,
	  track,
	  views,
	  DENSE_RANK() OVER (PARTITION BY artist ORDER BY views DESC) as views_rank
        FROM spotify
   ) as ranked
   WHERE views_rank <= 3;
2. Calculate the difference between the highest and lowest `energy` values for tracks in each album using a `WITH` clause:
   ```sql
   WITH energy_stats AS (
       SELECT 
           album,
           MAX(energy) AS max_energy,
           MIN(energy) AS min_energy
       FROM spotify
       GROUP BY album
   )
   SELECT 
       album,
       max_energy - min_energy AS energy_difference
   FROM energy_stats
   ORDER BY energy_difference DESC;

---

## Query Optimization Technique 

To improve query performance, we carried out the following optimization process:

- **Initial Query Performance Analysis Using `EXPLAIN`**
    - We began by analyzing the performance of a query using the `EXPLAIN` function.
    - The query retrieved tracks based on the `artist` column, and the performance metrics were as follows:
        - Execution time (E.T.): **9.575 ms**
        - Planning time (P.T.): **2.705 ms**
    - Below is the **screenshot** of the `EXPLAIN` result before optimization:
      ![image](https://github.com/user-attachments/assets/3ebfa29a-5c4d-4bac-a99e-cf4b2f11c11f)

- **Index Creation on the `artist` Column**
    - To optimize the query performance, we created an index on the `artist` column. This ensures faster retrieval of rows where the artist is queried.
    - **SQL command** for creating the index:
      ```sql
      CREATE INDEX idx_artist ON spotify(artist);
      ```
	
- **Performance Analysis After Index Creation**
    - After creating the index, we ran the same query again and observed significant improvements in performance:
        - Execution time (E.T.): **1.155 ms**
        - Planning time (P.T.): **2.990 ms**
    - Below is the **screenshot** of the `EXPLAIN` result after index creation:
      ![image](https://github.com/user-attachments/assets/fe447f3c-bbd0-4879-8e4f-0de932ff15c2)

- **Graphical Performance Comparison**
    - A graph illustrating the comparison between the initial query execution time and the optimized query execution time after index creation.
    - **Graph view** shows the significant drop in both execution and planning times:
     ![image](https://github.com/user-attachments/assets/c20bcf27-e612-490c-a92e-499b0decf381)
     ![image](https://github.com/user-attachments/assets/3323aec3-e36a-4437-9b79-240d194ae16d)

This optimization shows how indexing can drastically reduce query time, improving the overall performance of our database operations in the Spotify project.
---

## Technology Stack
- **Database**: PostgreSQL
- **SQL Queries**: DDL, DML, Aggregations, Joins, Subqueries, Window Functions
- **Tools**: pgAdmin 4 (or any SQL editor), PostgreSQL (via Homebrew, Docker, or direct installation)

## How to Run the Project
1. Install PostgreSQL and pgAdmin (if not already installed).
2. Set up the database schema and tables using the provided normalization structure.
3. Insert the sample data into the respective tables.
4. Execute SQL queries to solve the listed problems.
5. Explore query optimization techniques for large datasets.

---

## License
This project is licensed under the MIT License.
