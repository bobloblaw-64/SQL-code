CREATE TABLE items (
    item_id CHAR(3) NOT NULL primary key, 
    descr CHAR(10), 
    on_hand SMALLINT, 
    price DECIMAL(5,2)
);

create table po_items (
    job_id CHAR(3) NOT NULL, 
    po_id CHAR(3) NOT NULL, 
    item_id CHAR(3) NOT NULL, 
    quantity SMALLINT,
    primary key (job_id, po_id, item_id),
    foreign key (job_id, po_id) references pos(job_id, po_id),
    foreign key (item_id) references items(item_id)
);
