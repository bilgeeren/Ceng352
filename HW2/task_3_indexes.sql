CREATE INDEX if not exists idx_pub
ON Pub (pub_key, pub_type);

CREATE INDEX if not exists idx_field
ON Field (field_name,pub_key);

CREATE INDEX idx_Author
ON Author (author_id,name);

CREATE INDEX idx_Authored
ON Authored (author_id,pub_id);


CREATE INDEX idx_publication
ON Publication (pub_id,year) ;