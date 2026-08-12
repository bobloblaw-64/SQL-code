CREATE TABLE bookjobs (

    job_id CHAR(3) primary key not NULL,
    cust_id CHAR(3),
    job_date DATE, 
    descr CHAR(10),
    jobtype CHAR(1),
    foreign key (cust_id) references publishers(cust_id)

);

