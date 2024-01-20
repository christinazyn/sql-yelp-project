# Analyze Yelp using SQL

This project analyzes Yelp's data using SQL.
![key insights](./assets/insights-visualization.jpg)

## Table of Contents

- [Project Overview](#project-overview)
- [Report](#report)
- [Data Analysis](#data-analysis)
  - [Data Source](#data-source)
  - [Data Analysis](#data-analysis)
  - [Insights](#insights)

## Project Overview

We've all used Yelp or some other online review portal to decide where to eat, visit, and stay, etc. In this project, I am working with real data from Yelp.com and using my creative skills to analyze it using SQLite.

## Report

For a detailed report, please [Click Here](https://docs.google.com/document/d/e/2PACX-1vSMDCTqIhCabfUHPtas5RYxV0H4XMSWn1Y62Vp5QMPqjUUx9-_FZRhkvMEy8t8JjazEeyNsntCWbwtf/pub).

## Data Analysis

### Data Source

The Yelp data was officially released as part of an academic initiative at the company. See [here](www.yelp.com/dataset) for documentation and background on the dataset.

Because SQLite is not designed to work with larger databases, I have used a reduced version that includes only data corresponding to a random sample of 1% of users, downloadable [here](https://www.dropbox.com/s/8gc7ssuotga0iqq/yelp_reduced.sqlite?dl=0).

Below is a schema of the database that Yelp released, which can help understand the table relations. Although the schema does not exactly match the database, it is still quite helpful. Please also note that some parts of the data are quite messy and will require preprocessing in SQLite before extracting useful information.

![schema](./assets/yelp_dataset_schema.png)

### Data Analysis

I have analyzed the following KPIs to generate insights:

1. **User and Business Metrics:**

   - Total distinct user count.
   - Total distinct business count.
   - Total distinct review count.
   - Total distinct reviewer count.

2. **User Engagement and Activity:**

   - Active user count (users who posted reviews in 2017).
   - Number of new users each year.
   - Number of reviews each year.

3. **Business Statistics:**

   - Maximum, minimum, and average reviews per business.
   - Top five cities with the highest number of businesses.

4. **First Review Analysis:**

   - Extracting the first review from each user.
   - Joining business information to the first review data.
   - Analyzing the star ratings and average stars for businesses receiving new comments.
   - Identifying which businesses attract more new users to leave the first comment.

5. **Keyword Occurrences:**
   - Number of occurrences of specific business keywords (e.g., restaurants, services, bars, hotels) in the first reviews.
   - Business category keyword occurrence analysis.

These SQL queries cover a comprehensive range of research questions, providing insights into user behavior, business dynamics, and the impact of first reviews on businesses on Yelp.

### Insights

1. **User Growth:**

   - Yelp has experienced increasing user growth since 2005.
   - User growth peaked in 2014 and 2015 with nearly 2,000 new users each year.
   - Despite a decline in new user growth in recent years, the number of reviews on Yelp continues to surge.

2. **First Reviews Insights:**

   - Users tend to write their first reviews for exceptional businesses, both positively (5-star) and negatively (1-star).
   - The analysis of business categories indicates that users predominantly write their first reviews for businesses in the restaurant, bar, beauty and spas, and shopping sectors.

3. **Business Distribution:**

   - Distribution of first reviews among businesses is heavily skewed to the right, with only a few restaurants having a large number of first reviews.

4. **Business Strategy Recommendations for Yelp:**
   - Encourage more users to share experiences by offering incentives or rewards for writing reviews, especially for exceptional businesses.
   - Focus on targeted campaigns in sectors like restaurants, bars, beauty and spas, and shopping to attract more users and reviews.
   - Leverage data insights to improve the recommendation engine for more personalized recommendations.
   - Implementing these strategies can enhance the user experience and lead to sustainable growth for Yelp.
