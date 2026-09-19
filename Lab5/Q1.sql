ALTER TABLE publishers
ADD COLUMN last_order_date DATE;

CREATE TRIGGER date_updater
AFTER INSERT ON bookjobs
FOR EACH ROW
BEGIN
    UPDATE publishers
    SET last_order_date = new.job_date
    WHERE cust_id = new.cust_id;
END;