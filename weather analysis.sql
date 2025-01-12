-- weather analysis --

SELECT
    EXTRACT(MONTH FROM record_date) as MONTH,
    MAX(CASE WHEN data_type = 'max' THEN data_value END) as MAX,
    MIN(CASE WHEN data_type = 'min' THEN data_value END) as min,
    ROUND(AVG(CASE WHEN data_type = 'avg' THEN data_value END)) as avg
FROM temperature_records
GROUP BY EXTRACT(MONTH FROM record_date);
