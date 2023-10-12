-- 1. Write a query to get the sum of impressions by day.

SELECT date, SUM(impressions) AS total_impressions
FROM marketing_data
GROUP BY date
ORDER BY date;

-- 2. Write a query to get the top three revenue-generating states in order of best to worst. How much revenue did the third best state generate?

SELECT state, SUM(revenue) AS total_revenue
FROM website_revenue
GROUP BY state
ORDER BY total_revenue DESC
LIMIT 3;

-- The third best state, Ohio, generated $37,577.

-- 3. Write a query that shows total cost, impressions, clicks, and revenue of each campaign. Make sure to include the campaign name in the output.

SELECT ci.name AS campaign_name,
       mp.campaign_id,
       SUM(mp.cost) AS total_cost,
       SUM(mp.impressions) AS total_impressions,
       SUM(mp.clicks) AS total_clicks,
       SUM(wr.revenue) AS total_revenue
FROM marketing_data mp
JOIN campaign_info ci ON mp.campaign_id = ci.id
LEFT JOIN website_revenue wr ON mp.campaign_id = wr.campaign_id AND mp.date = wr.date
GROUP BY ci.name, mp.campaign_id
ORDER BY ci.name;

-- 4. Write a query to get the number of conversions of Campaign5 by state. Which state generated the most conversions for this campaign?

SELECT 
    SUBSTRING(mp.geo, -2) AS state,
    SUM(mp.conversions) AS total_conversions
FROM 
    marketing_data mp
JOIN 
    campaign_info ci 
ON 
    mp.campaign_id = ci.id
WHERE 
    ci.name = 'Campaign5'
GROUP BY 
    state
ORDER BY 
    total_conversions DESC;

-- Georgia generated the highest number of conversions for campaign 5 at 672.

-- 5. In your opinion, which campaign was the most efficient, and why?

SELECT 
    ci.name AS campaign_name,
    SUM(mp.cost) AS total_cost,
    SUM(mp.impressions) AS total_impressions,
    SUM(mp.clicks) AS total_clicks,
    SUM(mp.conversions) AS total_conversions,
    SUM(wr.revenue) AS total_revenue,
    (SUM(mp.cost) / SUM(mp.clicks)) AS CPC,
    (SUM(mp.cost) / SUM(mp.conversions)) AS CPA,
    (SUM(wr.revenue) / SUM(mp.cost)) AS ROAS
FROM 
    marketing_data mp
JOIN 
    campaign_info ci ON mp.campaign_id = ci.id
LEFT JOIN 
    website_revenue wr ON mp.campaign_id = wr.campaign_id AND mp.date = wr.date
GROUP BY 
    ci.name
ORDER BY 
    ci.name;

-- In my opinion, Campaign 5 was the most efficient due to it having the highest return on ad spend (ROAS) at 12.27, indicating that for every dollar spent on Campaign 5, $12.27 was generated.
-- Additionally, Campaign 5's clicks were competitive with Campaigns 2 and 3 despite having half the impressions. However, since Campaign 5's clicks are greater than their impressions, this information should not be used in decision-making. 
-- Despite this issue with the click-data in Campaign 5, the impressions and conversion data seem reasonable, so the ROAS still is indicative of an efficient campaign.

--**Bonus Question**

--6. Write a query that showcases the best day of the week (e.g., Sunday, Monday, Tuesday, etc.) to run ads.

SELECT 
    DAYNAME(date) AS day_of_week,
    SUM(conversions) AS total_conversions
FROM 
    marketing_data
GROUP BY 
    day_of_week
ORDER BY 
    total_conversions DESC
LIMIT 3;

SELECT 
    DAYNAME(date) AS day_of_week,
    AVG((clicks / impressions) * 100) AS avg_ctr
FROM 
    marketing_data
GROUP BY 
    day_of_week
ORDER BY 
    avg_ctr DESC
LIMIT 3;

SELECT 
    DAYNAME(date) AS day_of_week,
    AVG(cost / conversions) AS avg_cpa
FROM 
    marketing_data
GROUP BY 
    day_of_week
ORDER BY 
    avg_cpa ASC
LIMIT 3;

-- Based on total conversions alone, Friday would be considered the best day of the week to run ads at 3457 conversions.
-- Upon further analysis considering metrics such as the average Click-through rate, Wednesday was found to be the best day of the week with 109.88%.
-- However, average CTR should never be above 100%, meaning there are either issues with how this data was collected or some bad-actors are click-farming to increase the perceived effectiveness of the campaign. 
-- Therefore, average CTR should be disregarded in determining the most effective day of the week.
-- An additional metric to consider is the average cost per conversion, which would indicate that Wednesday is the most effective day to run ads due to it having the lowest CPA at 0.363. Friday closely follows with a CPA of 0.381.
-- The data shows that when considering total conversions as your KPI, Friday is the best day to run ads. With a more cost-conscious goal in mind with a KPI such as CPA, Wednesday is the most effective day to get high conversions for low cost. 
-- Overall, since Friday is ranked first for total conversions and is also competitive when measuring CPA, my recommendation would be to run ads on Friday.