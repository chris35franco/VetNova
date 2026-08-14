-- VETNOVA - Diseño inicial de Base de Datos
-- PostgreSQL
-- Entidades: empresas, roles y usuarios

-- Eliminar tablas si ya existen (solo para pruebas/desarrollo)
DROP TABLE IF EXISTS usuarios CASCADE;
DROP TABLE IF EXISTS roles CASCADE;
DROP TABLE IF EXISTS empresas CASCADE;

-- =========================
-- TABLA: empresas
-- =========================
CREATE TABLE empresas (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    nit VARCHAR(30) NOT NULL UNIQUE,
    telefono VARCHAR(30),
    email VARCHAR(150),
    direccion VARCHAR(255),
    ciudad VARCHAR(100),
    estado BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- TABLA: roles
-- =========================
CREATE TABLE roles (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    estado BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- TABLA: usuarios
-- =========================
CREATE TABLE usuarios (
    id BIGSERIAL PRIMARY KEY,
    empresa_id BIGINT NULL,
    rol_id BIGINT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100),
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    telefono VARCHAR(30),
    estado BOOLEAN NOT NULL DEFAULT TRUE,
    email_verified_at TIMESTAMP NULL,
    remember_token VARCHAR(100),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_usuario_empresa
        FOREIGN KEY (empresa_id)
        REFERENCES empresas(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_usuario_rol
        FOREIGN KEY (rol_id)
        REFERENCES roles(id)
        ON DELETE RESTRICT
);

-- =========================
-- DATOS INICIALES DE ROLES
-- =========================
INSERT INTO roles (nombre, descripcion) VALUES
('SUPER_USUARIO', 'Administrador general de la plataforma VetNova'),
('ADMINISTRADOR', 'Administrador de una clínica veterinaria'),
('VETERINARIO', 'Profesional veterinario de una clínica'),
('PERSONAL', 'Personal operativo de una clínica');

-- =========================
-- EMPRESA DE PRUEBA
-- =========================
INSERT INTO empresas
(nombre, nit, telefono, email, direccion, ciudad)
VALUES
('Clinica Veterinaria Huellas',
 '900123456-1',
 '3001234567',
 'contacto@huellas.com',
 'Carrera 5 # 10-20',
 'Neiva');

-- =========================
-- USUARIOS DE PRUEBA
-- IMPORTANTE: las contraseñas aquí son solo ejemplos.
-- En Laravel/Sanctum deben almacenarse usando Hash::make().
-- =========================
INSERT INTO usuarios
(empresa_id, rol_id, nombre, apellido, email, password, telefono)
VALUES
(
    NULL,
    (SELECT id FROM roles WHERE nombre = 'SUPER_USUARIO'),
    'Super',
    'Administrador',
    'superadmin@vetnova.com',
    'CAMBIAR_POR_PASSWORD_HASHEADO',
    '3000000000'
),
(
    (SELECT id FROM empresas WHERE nit = '900123456-1'),
    (SELECT id FROM roles WHERE nombre = 'ADMINISTRADOR'),
    'Juan',
    'Administrador',
    'admin@huellas.com',
    'CAMBIAR_POR_PASSWORD_HASHEADO',
    '3001111111'
);

-- =========================
-- CONSULTA PARA VERIFICAR
-- =========================
SELECT
    u.id,
    u.nombre,
    u.apellido,
    u.email,
    r.nombre AS rol,
    e.nombre AS empresa
FROM usuarios u
JOIN roles r ON r.id = u.rol_id
LEFT JOIN empresas e ON e.id = u.empresa_id
ORDER BY u.id;
