CREATE INDEX idx_pub
ON Pub (pub_key, pub_type);

CREATE INDEX idx_field
ON Field (field_name,pub_key);
