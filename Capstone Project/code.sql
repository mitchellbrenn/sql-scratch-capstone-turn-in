/*Getting the number of campaigns.*/
SELECT COUNT(DISTINCT utm_campaign) AS 'Number of Distinct Campaigns'
FROM page_visits;

/*Getting the number of sources.*/
SELECT COUNT(DISTINCT utm_source) AS 'Number of Distinct Sources'
FROM page_visits;

/*Getting relationship between sources and campaigns.*/
SELECT DISTINCT utm_source AS 'Source', utm_campaign AS 'Campaign'
FROM page_visits
ORDER BY 1;


/*Getting what pages are on CoolTShirts.com*/
SELECT DISTINCT page_name AS 'Pages'
FROM page_visits;


/*Determining number of first touches for each campaign.*/
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_sources AS (
SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
        pv.utm_campaign
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp)
    
SELECT ft_sources.utm_campaign AS 'Campaign',
		COUNT(*) AS 'Number of First Touches'
FROM ft_sources
GROUP BY 1
ORDER BY 2 DESC;


/*Determining number of last touches for each campaign.*/
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
lt_sources AS (
SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
        pv.utm_campaign
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp)
    
SELECT lt_sources.utm_campaign AS 'Campaign',
		COUNT(*) AS 'Number of Last Touches'
FROM lt_sources
GROUP BY 1
ORDER BY 2 DESC;

/*Determining unique users who made a purchase.*/
SELECT COUNT(DISTINCT user_id) AS 'Visitors Who Made a Purchase'
FROM page_visits
WHERE page_name = '4 - purchase';


/*Determining how many last touches were purchase for each campaign.*/
WITH last_touch AS (
SELECT user_id,
		MAX(timestamp) AS last_touch_at
FROM page_visits
WHERE page_name = '4 - purchase'
GROUP BY user_id),
lt_sources AS (
SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
        pv.utm_campaign
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp)


SELECT lt_sources.utm_campaign AS 'Campaign',
		COUNT(*) AS 'Last Touches On Purchase Page'
FROM lt_sources
GROUP BY 1
ORDER BY 2 DESC;

SELECT COUNT(DISTINCT user_id)
FROM page_visits;
