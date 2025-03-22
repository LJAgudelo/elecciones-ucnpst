CREATE DATABASE desafio_leidy_j_agudelo_112
CREATE TABLE clientes
(
codigo SERIAL PRIMARY KEY,
id VARCHAR (255) UNIQUE NOT NULL,
email VARCHAR(255),
nombre TEXT NOT NULL,
telefono VARCHAR (16),
empresa VARCHAR (50),
tipo SMALLINT NOT NULL CHECK (tipo BETWEEN 1 AND 10)
);
INSERT INTO clientes (id, email, nombre, telefono, empresa, tipo) VALUES 
('1128462488','ricradeufuwi-1622@yopmail.com','Eliseo ','(+57) 3187096846','Apple',1),
('1128462489','nedeimauquege-2443@yopmail.com','Angelica','(+57) 3987653487','Saudi Aramco',6),
('1128462490','voquallittoica-5014@yopmail.com','Cerdan','(+57) 2019872674','Microsoft',2),
('1128462491','yauviquoubogro-5645@yopmail.com','Nieves','(+57) 0192837645','Alphabet',7),
('1128462492','saulessevisso-7419@yopmail.com','Asier','(+57) 9376787612','Amazon',9),
('1128462493','jeibrahocahu-1082@yopmail.com','Samper','(+57) 3987653489','Berkshire',3),
('1128462494','nareheucrauxe-3654@yopmail.com','Paula','(+57) 2987653487','Hathaway',8),
('1128462495','frammaupeubrubrau-1266@yopmail.com','Caceres','(+57) 5987653491','NVIDIA',4),
('1128462496','xuwohugriwe-4115@yopmail.com','Saiz','(+57) 1987653490','Meta',10),
('1128462497','meucumeuhutre-2728@yopmail.com','Hamza','(+57) 5987653492','TSMC',5);
SELECT * FROM clientes; 
SELECT * FROM clientes ORDER BY tipo DESC LIMIT 3;
SELECT * FROM clientes WHERE tipo >5;