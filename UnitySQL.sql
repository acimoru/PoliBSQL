CREATE DATABASE restauranteu;
GO

USE restauranteu;
GO



CREATE TABLE sala (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    mesas INT NOT NULL
);
GO


CREATE TABLE pedido (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_sala INT NOT NULL,
    num_mesa INT NOT NULL,
    fecha DATETIME NOT NULL DEFAULT GETDATE(),
    total DECIMAL(10,2) NOT NULL,
    estado VARCHAR(20) CHECK (estado IN ('PENDIENTE', 'FINALIZADO')) DEFAULT 'PENDIENTE',
    usuario VARCHAR(100) NOT NULL,
    CONSTRAINT FK_pedido_sala FOREIGN KEY (id_sala) REFERENCES sala(id)
);
GO


CREATE TABLE detalle_pedido (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    cantidad INT NOT NULL,
    id_pedido INT NOT NULL,
    CONSTRAINT FK_detalle_pedido FOREIGN KEY (id_pedido) REFERENCES pedido(id)
);
GO


CREATE TABLE detalle_factura (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_detallepedido INT NOT NULL,
    CONSTRAINT FK_detalle_factura FOREIGN KEY (id_detallepedido) REFERENCES detalle_pedido(id)
);
GO


CREATE TABLE horarios (
    id INT IDENTITY(1,1) PRIMARY KEY,
    horas INT NOT NULL,
    descripcion VARCHAR(45) NOT NULL,
    turno VARCHAR(45) NOT NULL
);
GO


CREATE TABLE rol (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(45) NOT NULL
);
GO


CREATE TABLE empleado (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(45) NOT NULL,
    documento VARCHAR(45) NOT NULL,
    cargo VARCHAR(45) NOT NULL,
    id_rol INT NOT NULL,
    id_horario INT NOT NULL,
    CONSTRAINT FK_empleado_rol FOREIGN KEY (id_rol) REFERENCES rol(id),
    CONSTRAINT FK_empleado_horario FOREIGN KEY (id_horario) REFERENCES horarios(id)
);
GO


CREATE TABLE formas_pago (
    id INT IDENTITY(1,1) PRIMARY KEY,
    [desc] VARCHAR(100) NOT NULL
);
GO


CREATE TABLE factura (
    id INT IDENTITY(1,1) PRIMARY KEY,
    codigo BIGINT NOT NULL,
    fecha DATETIME NOT NULL,
    total DECIMAL(10,5) NOT NULL,
    id_formas INT NOT NULL,
    id_detallefactura INT NOT NULL,
    CONSTRAINT FK_factura_formas_pago FOREIGN KEY (id_formas) REFERENCES formas_pago(id),
    CONSTRAINT FK_factura_detalle_factura FOREIGN KEY (id_detallefactura) REFERENCES detalle_factura(id)
);
GO


CREATE TABLE platos (
    id INT PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    fecha DATE NULL,
    pedidos INT NOT NULL,
    CONSTRAINT FK_platos_pedido FOREIGN KEY (pedidos) REFERENCES pedido(id)
);
GO


CREATE TABLE usuario (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    correo VARCHAR(200) NOT NULL,
    pass VARCHAR(50) NOT NULL,
    rol INT NOT NULL,
    CONSTRAINT FK_usuario_rol FOREIGN KEY (rol) REFERENCES rol(id)
);
GO

--INSERTS

-- Tabla sala
INSERT INTO sala (nombre, mesas) VALUES
('Sala Principal', 10),
('Terraza', 8),
('VIP', 4),
('Zona Exterior', 6),
('Comedor', 12);
-- Tabla rol
INSERT INTO rol (nombre) VALUES
('Administrador'),
('Mesero'),
('Cocinero'),
('Cajero'),
('Limpieza');
-- Tabla horarios
INSERT INTO horarios (horas, descripcion, turno) VALUES
(8, 'Turno Mañana', 'Mañana'),
(6, 'Turno Tarde', 'Tarde'),
(4, 'Turno Noche', 'Noche'),
(10, 'Turno Completo', 'Completo'),
(5, 'Turno Especial', 'Especial');
-- Tabla empleado
INSERT INTO empleado (nombre, documento, cargo, id_rol, id_horario)
VALUES
('Juan Perez', '123456789', 'Mesero', 2, 1),
('Maria Gomez', '987654321', 'Cocinera', 3, 2),
('Carlos Diaz', '456789123', 'Cajero', 4, 3),
('Ana Martinez', '789123456', 'Limpieza', 5, 4),
('Sofia Rodriguez', '321654987', 'Administrador', 1, 5);
-- Tabla formas_pago
INSERT INTO formas_pago ([desc]) VALUES
('Efectivo'), ('Tarjeta de Crédito'),
('Tarjeta de Débito'),
('Transferencia Bancaria'),
('Pago Móvil');
-- Tabla usuario
INSERT INTO usuario (nombre, correo, pass, rol) VALUES
('admin', 'admin@example.com', 'password1', 1),
('mesero1', 'mesero1@example.com', 'password2', 2),
('cocinero1', 'cocinero1@example.com', 'password3', 3),
('cajero1', 'cajero1@example.com', 'password4', 4),
('limpieza1', 'limpieza1@example.com', 'password5', 5);
-- Tabla pedido
INSERT INTO pedido (id_sala, num_mesa, fecha, total, estado, usuario)
VALUES
(1, 1, GETDATE(), 25000.50, 'PENDIENTE', 'admin'),
(2, 2, GETDATE(), 45000.75, 'FINALIZADO', 'mesero1'),
(3, 3, GETDATE(), 15000.00, 'PENDIENTE', 'cocinero1'),
(4, 4, GETDATE(), 37000.25, 'FINALIZADO', 'cajero1'),
(5, 5, GETDATE(), 18000.00, 'PENDIENTE', 'limpieza1');
-- Tabla detalle_pedido
INSERT INTO detalle_pedido (nombre, precio, cantidad, id_pedido) VALUES
('Bandeja Paisa', 15000.00, 2, 1),
('Ajiaco', 12000.00, 1, 2),
('Arepa de Huevo', 5000.00, 3, 3),
('Sancocho', 18000.00, 1, 4),
('Empanadas', 3000.00, 5, 5);
-- Tabla detalle_factura
INSERT INTO detalle_factura (id_detallepedido) VALUES
(1), (2), (3), (4), (5);
-- Tabla factura
INSERT INTO factura (codigo, fecha, total, id_formas, id_detallefactura)
VALUES
(1234567890, GETDATE(), 35000.50, 1, 1),
(9876543210, GETDATE(), 15000.75, 2, 2),
(4567891230, GETDATE(), 12000.00, 3, 3),
(7891234560, GETDATE(), 25000.25, 4, 4),
(3216549870, GETDATE(), 18000.00, 5, 5);
-- Tabla platos
INSERT INTO platos (id, nombre, precio, fecha, pedidos) VALUES
(1, 'Bandeja Paisa', 15000.00, '2024-11-01', 1),
(2, 'Ajiaco', 12000.00, '2024-11-02', 2),
(3, 'Arepa de Huevo', 5000.00, '2024-11-03', 3),
(4, 'Sancocho', 18000.00, '2024-11-04', 4),
(5, 'Empanadas', 3000.00, '2024-11-05', 5);
GO
