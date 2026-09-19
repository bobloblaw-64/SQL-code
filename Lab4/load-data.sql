
insert into publishers values ('A01', 'ART BOOKS', 'SYDNEY', '555-1234', 'N');
insert into publishers values ('B02', 'BIBLECO', NULL, '555-2468', 'C');
insert into publishers values ('C03', 'CABLE-EX', 'BRISBANE', '555-3690', 'N');
insert into publishers values ('D04', 'DIABLO CO', 'MELBOURNE', NULL, 'D');
insert into publishers values ('E05', 'EASYPRINT', 'PERTH', '555-5050', 'C');
insert into publishers values ('F06', 'FOX-PAW', 'HOBART', '555-6789', 'C');
insert into publishers values ('G07', 'GOLD PRESS', 'ADELAIDE', '555-7777', 'N');
insert into publishers values ('H08', 'HELP BOOKS', 'DARWIN', NULL, 'C');


insert into bookjobs values ('001', 'E05', '1990-04-04', 'TEXT BOOKS', 'R');
insert into bookjobs values ('002', 'E05', '1990-03-03', 'BUS REPORT', 'N');
insert into bookjobs values ('003', 'E05', '1989-12-25', 'COMMERCIAL', 'N');
insert into bookjobs values ('004', 'A01', '1990-01-01', 'PAMPHLETS', 'R');
insert into bookjobs values ('005', 'A01', '1989-11-23', 'GOVT', 'N');
insert into bookjobs values ('006', 'D04', '1988-07-04', 'CAMPAIGN', 'H');


insert into pos values ('002', 'AAA', '1990-05-20', 'ABC');
insert into pos values ('002', 'BBB', '1990-03-15', 'XYZ');
insert into pos values ('004', 'CCC', '1990-01-05', 'SOS');
insert into pos values ('004', 'DDD', '1990-01-01', 'ABC');
insert into pos values ('005', 'EEE', '1990-01-15', 'SOS');
insert into pos values ('005', 'FFF', '1989-12-01', 'ABC');
insert into pos values ('006', 'GGG', '1988-07-15', 'XYZ');


insert into items values ('P9', '9KG PAPER', 300, 25.25);
insert into items values ('P12', '12KG PAPER', 700, 49.99);
insert into items values ('P18', '18KG PAPER', 100, 100.00);
insert into items values ('IRN', 'INK-RESIN', 3, 500.00);
insert into items values ('IWS', 'INK-WRSOL', 5, 350.00);
insert into items values ('CBD', 'CARDBOARD', 47, 15.00);


insert into po_items values ('004', 'CCC', 'P9', 150);
insert into po_items values ('004', 'CCC', 'IRN', 4);
insert into po_items values ('004', 'DDD', 'P18', 100);
insert into po_items values ('002', 'AAA', 'P9', 50);
insert into po_items values ('002', 'AAA', 'IWS', 2);
insert into po_items values ('002', 'AAA', 'CBD', 17);
insert into po_items values ('002', 'BBB', 'CBD', 17);
insert into po_items values ('006', 'GGG', 'IRN', 2);
