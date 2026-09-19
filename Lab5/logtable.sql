CREATE TABLE log_table (
 log_id INTEGER PRIMARY KEY AUTOINCREMENT,
 job_id CHAR(3),
 po_id CHAR(3),
 item_id CHAR(3),
 message TEXT);
