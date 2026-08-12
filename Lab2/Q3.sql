CREATE TABLE pos (
    job_id CHAR(3) NOT NULL, 
    po_id CHAR(3) NOT NULL, 
    po_date DATE, 
    vendor_id CHAR(3),
    primary key (job_id, po_id),
    foreign key (job_id) references bookjobs(job_id)
);