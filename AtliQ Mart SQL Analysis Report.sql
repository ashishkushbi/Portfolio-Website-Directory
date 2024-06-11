/* Q.01 */

SELECT distinct(product_name), base_price FROM dim_products AS P
INNER JOIN fact_events AS E ON P.PRODUCT_CODE = E.PRODUCT_CODE
WHERE E.base_price > 500 AND promo_type  = "BOGOF"
group by product_name



/* Q.02 */

SELECT city , COUNT(store_id) as store_count FROM dim_stores
GROUP BY city 
ORDER BY store_count desc;



/* Q.03 */

SELECT campaign_name, ROUND(sum(base_price * `quantity_sold(before_promo)`)/1000000,2) as 'Total_Revenue(before_promo) in M'
, ROUND(sum(base_price * `quantity_sold(after_promo)`)/1000000,2) as 'Total_Revenue(after_promo) in M'
FROM dim_campaigns as cp 
INNER JOIN fact_events as fe ON cp.campaign_id = fe.campaign_id
group by campaign_name



/* Q.04 */

SELECT category, ROUND(((sum(`quantity_sold(after_promo)`) - sum(`quantity_sold(before_promo)`) ) / sum(`quantity_sold(before_promo)`) )* 100,2) as 'ISU%'
, RANK () OVER (order by ((sum(`quantity_sold(after_promo)`) - sum(`quantity_sold(before_promo)`) ) / sum(`quantity_sold(before_promo)`) ) desc) AS rnk
FROM dim_products as p 
INNER JOIN fact_events as f ON p.product_code = f.product_code 
INNER JOIN dim_campaigns as c ON f.campaign_id = c.campaign_id
WHERE campaign_name = "Diwali"
group by category



/* Q.05 */

SELECT distinct(product_name), (category), 
((base_price*(`quantity_sold(after_promo)`)) - (base_price*(`quantity_sold(before_promo)`) ) )*100 / (base_price*(`quantity_sold(before_promo)`) ) as 'IR%',
RANK () OVER (ORDER BY ((base_price*(`quantity_sold(after_promo)`)) - (base_price*(`quantity_sold(before_promo)`) ) )*100 / (base_price*(`quantity_sold(before_promo)`) ) DESC ) AS RNK
FROM dim_products as p 
INNER JOIN fact_events as f ON p.product_code = f.product_code 
INNER JOIN dim_campaigns as c ON f.campaign_id = c.campaign_id
LIMIT 5



