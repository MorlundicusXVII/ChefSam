CREATE DATABASE IF NOT EXISTS TurismoDB;
USE TurismoDB;

DROP TABLE IF EXISTS Eventi;
DROP TABLE IF EXISTS Attrazioni;
DROP TABLE IF EXISTS Citta;

CREATE TABLE Citta (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE Attrazioni (
    id INT PRIMARY KEY AUTO_INCREMENT,
    citta_id INT,
    nome VARCHAR(100),
    tipo VARCHAR(50),
    descrizione TEXT,
    FOREIGN KEY (citta_id) REFERENCES Citta(id)
);

CREATE TABLE Eventi (
    id INT PRIMARY KEY AUTO_INCREMENT,
    citta_id INT,
    nome VARCHAR(100),
    data DATE,
    descrizione TEXT,
    FOREIGN KEY (citta_id) REFERENCES Citta(id)
);

INSERT INTO Citta (nome) VALUES
('Roma'),
('Parigi'),
('Berlino'),
('Madrid'),
('Londra');

INSERT INTO Attrazioni (citta_id, nome, tipo, descrizione) VALUES
(1, 'Colosseo', 'Monumento', 'Antico anfiteatro romano'),
(1, 'Fontana di Trevi', 'Fontana', 'Famosa fontana barocca'),
(2, 'Tour Eiffel', 'Monumento', 'Simbolo di Parigi'),
(2, 'Museo del Louvre', 'Museo', 'Museo darte famoso'),
(3, 'Porta di Brandeburgo', 'Monumento', 'Simbolo di Berlino'),
(3, 'Muro di Berlino', 'Sito storico', 'Resti del muro'),
(4, 'Palazzo Reale', 'Palazzo', 'Residenza reale'),
(4, 'Museo del Prado', 'Museo', 'Museo darte'),
(5, 'Big Ben', 'Monumento', 'Torre dellorologio'),
(5, 'London Eye', 'Attrazione', 'Ruota panoramica');

INSERT INTO Eventi (citta_id, nome, data, descrizione) VALUES
(1, 'Maratona di Roma', '2026-03-15', 'Evento sportivo'),
(1, 'Notte dei Musei', '2026-05-20', 'Musei aperti'),
(2, 'Fête de la Musique', '2026-06-21', 'Festival musicale'),
(2, 'Bastille Day', '2026-07-14', 'Festa nazionale'),
(3, 'Festival del Cinema', '2026-02-10', 'Festival internazionale'),
(3, 'Festival delle Luci', '2026-10-08', 'Spettacolo di luci'),
(4, 'San Isidro', '2026-05-15', 'Festa di Madrid'),
(4, 'Madrid Pride', '2026-07-01', 'Evento LGBTQ+'),
(5, 'Notting Hill Carnival', '2026-08-25', 'Festival caraibico'),
(5, 'New Year Fireworks', '2026-12-31', 'Fuochi dartificio');