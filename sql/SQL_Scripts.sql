DROP TABLE IF EXISTS cleaned_data;

CREATE TABLE cleaned_data (
    invoice TEXT,
    stockcode TEXT,
    description TEXT,
    quantity INTEGER,
    invoicedate TIMESTAMP,
    price NUMERIC,
    customer_id TEXT,
    country TEXT,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    weekday TEXT,
    hour INTEGER,
    revenue NUMERIC,
    transactiontype TEXT
);

---824364
select count(*) from cleaned_data

DROP TABLE IF EXISTS rfm_segments_monthly;

CREATE TABLE rfm_segments_monthly (
    customerid TEXT,
    recency INTEGER,
    frequency INTEGER,
    monetary NUMERIC,
    month DATE,
    r_score INTEGER,
    f_score INTEGER,
    m_score INTEGER,
    rfm_score TEXT,
    segment TEXT
);


DROP TABLE IF EXISTS segment_transitions;

CREATE TABLE segment_transitions (
    customerid TEXT,
    month DATE,
    prevsegment TEXT,
    currentsegment TEXT,
    segmenttransition TEXT
);


SELECT DISTINCT a.month, LENGTH(a.month::text)
FROM cleaned_data a
ORDER BY 2;



---824364
select count(*)
from
(
SELECT 
    a.*, 
    b.recency, b.frequency, b.monetary,
    b.r_score, b.f_score, b.m_score, b.rfm_score, b.segment,
    c.prevsegment, c.currentsegment, c.segmenttransition
FROM cleaned_data a
LEFT JOIN rfm_segments_monthly b 
    ON a.customer_id = b.customerid 
   AND TO_DATE(a.year::text || LPAD(a.month::text, 2, '0') || '01', 'YYYYMMDD') = b.month
LEFT JOIN segment_transitions c 
    ON a.customer_id = c.customerid 
   AND TO_DATE(a.year::text || LPAD(a.month::text, 2, '0') || '01', 'YYYYMMDD') = c.month
)X
	

CREATE OR REPLACE VIEW public.rfm_last_segments
 AS
select distinct
a.customerid,
a.segment last_segment
from
(
	select
		customerid,
		max(month) lastmonth
	from rfm_segments_monthly 	
	group by
		customerid
)b
left join
(
	select 
	customerid,
	segment,
	month
	from rfm_segments_monthly
)a on a.customerid = b.customerid and a.month = b.lastmonth




select count(distinct customerid) from rfm_last_segments



CREATE OR REPLACE VIEW public.main_customer_data
 AS
 SELECT a.invoice,
    a.stockcode,
    a.description,
    a.quantity,
    a.invoicedate,
    a.price,
    a.customer_id,
    a.country,
    a.year,
    a.month,
    a.day,
    a.weekday,
    a.hour,
    a.revenue,
    a.transactiontype,
    to_char(to_date((a.year::text || lpad(a.month::text, 2, '0'::text)) || '01'::text, 'YYYYMMDD'::text)::timestamp with time zone, 'YYYY-MM'::text) AS yearmonth,
    to_date((a.year::text || lpad(a.month::text, 2, '0'::text)) || '01'::text, 'YYYYMMDD'::text) AS yearmonth_date,
    b.recency,
    b.frequency,
    b.monetary,
    b.r_score,
    b.f_score,
    b.m_score,
    b.rfm_score,
    b.segment,
    c.prevsegment,
    c.currentsegment,
    c.segmenttransition,
	d.last_segment
	
FROM cleaned_data a
LEFT JOIN rfm_segments_monthly b 
  ON a.customer_id :: INT = b.customerid 
 AND (a.year::text || '-' || lpad(a.month::text, 2, '0')) = b.month
 
LEFT JOIN rfm_last_segments d 
  ON a.customer_id :: INT = d.customerid  

LEFT JOIN segment_transitions c 
  ON a.customer_id :: INT = c.customerid 
 AND (a.year::text || '-' || lpad(a.month::text, 2, '0')) = c.month
 
 




SELECT
    customer_id
FROM
    main_customer_data 
WHERE
    customer_id NOT IN (
        SELECT DISTINCT customer_id
        FROM main_customer_data 
        WHERE yearmonth = '2011-12'
    );
	
	

SELECT
    customer_id, yearmonth, segment
FROM
    main_customer_data 
where customer_id = 12346
order by yearmonth desc



select * from rfm_segments_monthly
where customerid = 12346



select * from cleaned_data
where customer_id = 12346 and year = 2011 and month = 12




