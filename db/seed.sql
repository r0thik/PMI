INSERT INTO users (id, username, email, password_hash, balance, is_admin, created_at) VALUES
(2, 'gosha', 'gosha@mail.ru', 'scrypt:32768:8:1$wKLKKkepv50a9Xht$5c773385287a93259b8ae8cc565eb3fb1c6d23cf9af940f52a65a98f37db0b5b382976141c7c5da9bfe2e261e7d5c868b8def58c7404b5a4ba0cb0a0c0ef2c04', 9708.00, true, '2025-12-06 20:05:16.066213+03'),
(1, 'egor', 'popkaegora@mail.ru', 'scrypt:32768:8:1$vqdmsUA1Ivndn0Tc$a5fb825f0fa9f928df73146f220206d7f413b04a9cb5f5dbb07dd2122669aedad16d4d97139ac7b5d4c803b26624bddf50bb8a87d1643a4f74f1bfa6045db682', 501.00, false, '2025-12-06 19:13:45.473651+03');

INSERT INTO products (id, title, description, price, image, stock, created_at, genre) VALUES
(5, 'ARC Raiders', 'хз', 3000.00, 'img/arcraiders.jpg', 5, '2025-12-06 20:30:05.236883+03', NULL),
(1, 'RV There Yet?', 'Кооперативная аркада про путешествие на автодоме.', 292.00, 'img/rv-there-yet.jpg', 9, '2025-12-06 19:06:14.067603+03', NULL),
(6, 'Rematch', 'футбольчек рака мака фо', 1399.00, 'img/rematch.jpg', 23, '2025-12-06 20:30:43.753678+03', 'Спорт'),
(8, 'Dead by Daylight', 'беги от маньякича', 599.00, 'img/dbd.jpg', 52, '2025-12-07 16:10:55.333036+03', 'horror'),
(9, 'PEAK', 'Кооперативная игра про выживание и восхождение', 299.00, 'img/peak.jpg', 15, '2025-12-07 16:17:15.356174+03', 'Кооператив'),
(4, 'Minecraft', 'песочница', 200.00, 'img/minecraft.jpg', 14, '2025-12-06 20:28:34.864069+03', NULL),
(3, 'CS2', 'Шутер', 888.00, 'img/cs2.jpg', 10, '2025-12-06 20:23:21.002814+03', NULL);

INSERT INTO news (id, title, summary, date) VALUES
(1, 'RV There Yet? анонсирован', 'Кооперативная аркада добавлена в каталог.', '2025-10-01'),
(2, 'Добавлена новая игра: PEAK', 'Кооперативная игра про выживание и восхождение', '2025-12-07');

INSERT INTO partners (id, name) VALUES
(1, 'Партнёр 1'),
(2, 'Партнёр 2');

INSERT INTO holidays (id, name, date, note) VALUES
(1, 'День разработчика', '2025-09-13', 'Спецподборка инди-игр');

INSERT INTO price_updates (id, date, text) VALUES
(2, '2025-12-07', 'Изменена цена игры ''PEAK'': была 399.00 ₽, стала 299.00 ₽'),
(3, '2025-12-08', 'Изменена цена игры ''CS2'': была 999.00 ₽, стала 888.00 ₽');

INSERT INTO orders (id, user_id, total, created_at) VALUES
(1, 1, 299.00, '2025-12-06 19:33:59.516548+03'),
(2, 2, 292.00, '2025-12-06 20:50:06.55008+03'),
(3, 1, 200.00, '2025-12-08 19:40:59.135505+03');

INSERT INTO order_items (id, order_id, product_id, unit_price, quantity) VALUES
(1, 1, 1, 299.00, 1),
(2, 2, 1, 292.00, 1),
(3, 3, 4, 200.00, 1);

INSERT INTO license_keys (id, order_id, user_id, product_id, key_value, issued_at) VALUES
(1, 1, 1, 1, 'THCSU-XUM2V-9PDU0-EYMVZ-QIG3U', '2025-12-06 19:33:59.516548+03'),
(2, 2, 2, 1, '20N0S-311U0-VUOXP-C4AIC-IKHZU', '2025-12-06 20:50:06.55008+03'),
(3, 3, 1, 4, 'ESQRU-SVKHR-IX2LV-QYHO8-B4PRL', '2025-12-08 19:40:59.135505+03');

SELECT setval('users_id_seq', (SELECT MAX(id) FROM users));
SELECT setval('products_id_seq', (SELECT MAX(id) FROM products));
SELECT setval('news_id_seq', (SELECT MAX(id) FROM news));
SELECT setval('partners_id_seq', (SELECT MAX(id) FROM partners));
SELECT setval('holidays_id_seq', (SELECT MAX(id) FROM holidays));
SELECT setval('price_updates_id_seq', (SELECT MAX(id) FROM price_updates));
SELECT setval('orders_id_seq', (SELECT MAX(id) FROM orders));
SELECT setval('order_items_id_seq', (SELECT MAX(id) FROM order_items));
SELECT setval('license_keys_id_seq', (SELECT MAX(id) FROM license_keys));