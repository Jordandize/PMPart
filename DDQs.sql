###C:\Users\Constantine\Documents\springspace\Book>java -cp  target/book.jar ua.edu.ukma.pm.book.gui.WelcomeJFrame

CREATE DATABASE IF NOT EXISTS book;

USE book;

###   ###   ###   ###   ###   ###   ###   ###   ###   ###   ###   ###   ###   ###   ###   ###


DROP TABLE IF EXISTS supplies_books;

DROP TABLE IF EXISTS supplies;

DROP TABLE IF EXISTS books;

DROP TABLE IF EXISTS customers;

DROP TABLE IF EXISTS publishing_houses;


###   ###   ###   ###   ###   ###   ###   ###   ###   ###   ###   ###   ###   ###   ###   ###


##Перелік сутностей типу Видавництво
CREATE TABLE publishing_houses (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR (512) NOT NULL,
  phone VARCHAR (15) NOT NULL
) engine = InnoDB;


##Перелік сутностей типу Книга
CREATE TABLE books (
  id INT PRIMARY KEY AUTO_INCREMENT,
# Посилання на Видавництво, яке опублікувало цю книгу
  publishing_house_id INT NOT NULL,
  title VARCHAR (512) NOT NULL,
  theme VARCHAR (512) NOT NULL,
# Кількість сторінок/об`єм книги 
  volume SMALLINT UNSIGNED NOT NULL,
# Ціна книги у копійках
  price INT UNSIGNED NOT NULL,
  
##Поля {advance, royalty} відповідають сутності ER-моделі Гонорар. Так як зв`язок з
##таблицею Книга один до одного, то таблиці можна поєднати в одну. При цьому ми отримаємо
##менше програмного коду для обробки запитів до бази та відсутність необхідності додаткового
##INNER JOIN-а.
# Аванс за книгу автору/авторам у копійках
  advance INT UNSIGNED NULL,
# Гонорар за кожну продану книгу автору/авторам у відцотках від вартості. Формат: `XXX,YYYY`
  royalty DOUBLE (7,4) NULL,
  
# Дата публікації
  date DATE NOT NULL,
# Кількість на складі
# reserve SMALLINT UNSIGNED NOT NULL,
  FOREIGN KEY (publishing_house_id) REFERENCES publishing_houses (id) ON DELETE RESTRICT ON UPDATE CASCADE
) engine = InnoDB;


##Перелік сутностей типу Клієнт
CREATE TABLE customers (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR (512) NOT NULL,
# Тип клієнта (бібліотека/магазин/приватний колеціонер/тощо)
  type VARCHAR (128) NOT NULL,
  address VARCHAR (512) NOT NULL
) engine = InnoDB;


##Перелік сутностей типу Поставка
CREATE TABLE supplies (
  id INT PRIMARY KEY AUTO_INCREMENT,
# Посилання на Клієнта цієї поставки
  customer_id INT NOT NULL,
  date DATE NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE RESTRICT ON UPDATE CASCADE
) engine = InnoDB;


##Звязок сутності Книга та сутності Поставка. Відображає список замовлених Книг в Поставці
CREATE TABLE supplies_books (
  supply_id INT NOT NULL,
  book_id INT NOT NULL,
# В одній поставці може бути декілька одинакових книг
  qty MEDIUMINT UNSIGNED NOT NULL,
  FOREIGN KEY (supply_id) REFERENCES supplies (id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (book_id) REFERENCES books (id) ON DELETE RESTRICT ON UPDATE CASCADE,
# Ця пара полів сутності однозначно ідентифікує запис таблиці
  PRIMARY KEY (supply_id, book_id)
) engine = InnoDB;


###   ###   ###   ###   ###   ###   ###   ###   ###   ###   ###   ###   ###   ###   ###   ###


INSERT INTO publishing_houses VALUES 
  (1, 'Зоря', '+380996403171'),
  (2, 'Листопад', '+380996403172'),
  (3, 'Нова книга', '+380996403173'),
  (4, 'Твір', '+380996403174'),
  (5, 'Україна', '+380996403177');
  
INSERT INTO customers VALUES
  (1, 'Світ', 'магазин', 'Київ, вул. Перша, 37'),
  (2, 'Книжний ринок', 'ринок', 'Київ, м. Почайна'),
  (3, 'Школа 57', 'освітній заклад', 'Львів, вул. Бендера, 18'),
  (4, 'Школа 58', 'приватний освітній заклад', 'Львів, вул. Богда Мудрого, 1'),
  (5, 'Дитяча бібліотека ім. Незнайки', 'бібліотека', 'Київ, вул. Вернадьского, 10');
  
INSERT INTO books VALUES
  (1, 1, 'Життєпис людини без думок', 'Історичний роман вісімнадцятого століття', 999, 39900, 20000000, 15.00, '2019-01-05'),
  (2, 1, 'Перший злочин', 'Незвичайна історія людини з досвідом у півстоліття', 499, 38900, 18000000, 16.50, '2018-08-08'),
  (3, 2, 'Справа честі', 'Історична справка роду українських гетьманів', 659, 50000, 16000000, 10.00, '2018-11-21'),
  (4, 3, 'Закон, написаний людьми', 'Автор ділиться з читачем думками та ідеями побудови світу, який побудували наші предки', 370, 41000, 7000000, 10.00, '2018-05-12'),
  (5, 5, 'Наказ', 'Роман про самосвідому особистість та частину великого бюрократичного механізму', 800, 60000, 21000000, 25.00, '2018-01-30');
  
 INSERT INTO supplies VALUES
  (1, 3, '2018-08-30'),
  (2, 2, '2019-01-07'),
  (3, 4, '2018-04-22'),
  (4, 5, '2018-08-24'),
  (5, 1, '2018-03-17');
  
INSERT INTO supplies_books VALUES
  (1, 1, 30),
  (1, 2, 40),
  (1, 3, 25),
  (1, 4, 50),
  (1, 5, 35),
  (2, 3, 80),
  (2, 2, 75),
  (3, 5, 60),
  (3, 4, 100),
  (3, 3, 20),
  (4, 2, 70),
  (4, 3, 120),
  (5, 1, 100),
  (5, 4, 100),
  (5, 5, 100);