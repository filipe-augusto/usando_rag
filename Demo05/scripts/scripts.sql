
CREATE EXTENSION IF NOT EXISTS vector;
CREATE TABLE recomendations (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  category TEXT NOT NULL,
  embedding vector(1024) NOT NULL
);

CREATE INDEX idx_recomendations ON recomendations USING HNSW (embedding vector_l2_ops);

CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  category TEXT NOT NULL,
  summary TEXT NOT NULL,
  description TEXT NOT NULL
);





INSERT INTO products (id, title, category, summary, description) VALUES
  (15, 'Guatemalan Huehuetenango', 'arabic', 'A complex coffee with chocolate and fruit notes', 'Guatemalan Huehuetenango coffee is grown at high altitudes, offering a rich body with bright acidity and subtle winey tones.'),
  (16, 'Colombian Supremo', 'arabic', 'A balanced and smooth classic coffee', 'Colombian Supremo features a rich flavor profile with hints of caramel, nuttiness, and a pleasant medium acidity.'),
  (17, 'Costa Rican Tarrazu', 'arabic', 'A crisp coffee with citrus undertones', 'Costa Rican Tarrazu is renowned for its lively acidity, full body, and clean finish with distinct grapefruit notes.'),
  (18, 'Sumatra Mandheling', 'arabic', 'An earthy and full-bodied dark roast classic', 'Sumatra Mandheling offers a smooth, syrupy texture with low acidity, herbal aromas, and deep cocoa undertones.'),
  (19, 'Kenyan AA', 'arabic', 'A bold and juicy coffee with berry notes', 'Kenyan AA is famous for its bright acidity, full body, and intense flavors ranging from blackcurrant to citrus.'),
  (20, 'Hawaiian Kona', 'arabic', 'A rare and delicate coffee with smooth finish', 'Hawaiian Kona coffee provides a butter-smooth taste, delicate aroma, and subtle nutty nuances grown in rich volcanic soil.'),
  (21, 'Jamaican Blue Mountain', 'arabic', 'A prestigious coffee with exceptional mildness', 'Jamaican Blue Mountain is prized worldwide for its complete lack of bitterness, mild flavor, and sweet botanical notes.'),
  (22, 'Panama Geisha', 'arabic', 'An exquisite floral coffee with jasmine notes', 'Panama Geisha is celebrated for its highly aromatic profile, elegant tea-like body, and sweet bergamot undertones.'),
  (23, 'Ethiopian Yirgacheffe', 'arabic', 'A bright and floral washed coffee', 'Ethiopian Yirgacheffe offers a light to medium body with delicate floral aromas, lemongrass notes, and a clean finish.'),
  (24, 'Brazilian Santos', 'arabic', 'A smooth and low-acidity daily drinker', 'Brazilian Santos coffee features a pleasantly sweet, nutty flavor with hints of chocolate and a subtle velvety finish.'),
  (25, 'Rwanda Bourbon', 'arabic', 'A sweet coffee with vibrant red fruit notes', 'Rwanda Bourbon coffee brings a silk-like mouthfeel with tasting notes of cherry, caramel, and bright malic acidity.'),
  (26, 'Mexican Chiapas', 'arabic', 'A light-bodied coffee with crisp nuttiness', 'Mexican Chiapas is known for its mild flavor profile, gentle cocoa nuances, and clean, refreshing finish.'),
  (27, 'Nicaraguan Maragogype', 'arabic', 'A large-bean coffee with subtle wood and spice tones', 'Nicaraguan Maragogype delivers a mellow cup with balanced acidity, soft chocolate notes, and a smooth body.'),
  (28, 'Indian Mysore Malabar', 'arabic', 'A unique monsooned coffee with earthy richness', 'Indian Mysore undergoes a monsooning process that reduces acidity, yielding a heavy-bodied cup with spicy, earthy flavors.'),
  (29, 'Honduras Marcala', 'arabic', 'A well-rounded coffee with sweet caramel notes', 'Honduras Marcala provides a velvety texture combined with vibrant peach acidity, brown sugar sweetness, and cocoa finish.');