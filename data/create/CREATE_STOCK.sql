INSERT INTO landing.stock (articleid, count) SELECT id, floor(random() * 10) FROM landing.articles;