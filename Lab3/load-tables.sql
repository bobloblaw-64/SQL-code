--DROP TABLE po_items; 
--DROP TABLE items; 
--DROP TABLE pos; 
--DROP TABLE bookjobs; 
--DROP TABLE publishers; 

CREATE TABLE publishers ( 
cust_id		CHAR(3)	NOT NULL, 
name 		CHAR(10), 
city 		CHAR(10), 
phone 		CHAR(8), 
creditcode 	CHAR(1),  
PRIMARY KEY (cust_id) 
);  

CREATE TABLE bookjobs ( 
job_id		CHAR(3)  NOT NULL, 
cust_id		CHAR(3), 
job_date       	DATE, 
descr           CHAR(10), 
jobtype         CHAR(1), 
PRIMARY KEY (job_id), 
FOREIGN KEY (cust_id) REFERENCES publishers (cust_id) 
); 

CREATE TABLE pos ( 
job_id	   	CHAR(3) NOT NULL, 
po_id      	CHAR(3) NOT NULL, 
po_date		DATE,  
vendor_id  	CHAR(3), 
PRIMARY KEY (job_id, po_id), 
FOREIGN KEY (job_id) REFERENCES bookjobs (job_id) 
); 

CREATE TABLE items ( 
item_id       	CHAR(3) NOT NULL, 
descr   	    CHAR(10), 
on_hand       	SMALLINT, 
price          	DECIMAL(5,2),  
PRIMARY KEY (item_id) 
);  

CREATE TABLE po_items ( 
job_id	    	CHAR(3) NOT NULL, 
po_id	    	CHAR(3) NOT NULL, 
item_id	  	CHAR(3) NOT NULL, 
quantity    	SMALLINT, 
PRIMARY KEY (job_id, po_id, item_id),  
FOREIGN KEY (job_id,po_id) REFERENCES pos (job_id,po_id), 
FOREIGN KEY (item_id) REFERENCES items (item_id)  
);
