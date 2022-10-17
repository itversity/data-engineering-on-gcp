CREATE SCHEMA sms_db;

DROP TABLE IF EXISTS sms_db.users;

CREATE TABLE IF NOT EXISTS sms_db.users (
  user_id INTEGER,
  user_first_name STRING,
  user_last_name STRING,
  is_active BOOLEAN
);

INSERT INTO sms_db.users
  (user_id, user_first_name, user_last_name)
VALUES
  (1, 'Scott', 'Tiger'),
  (2, 'Donald', 'Duck');

SELECT * FROM sms_db.users;

UPDATE `sms_db.users`
SET is_active = TRUE
WHERE user_id = 1;

SELECT * FROM sms_db.users;

CREATE TABLE IF NOT EXISTS sms_db.users_stg (
  user_id INTEGER,
  user_first_name STRING,
  user_last_name STRING,
  is_active BOOLEAN
);

INSERT INTO sms_db.users_stg
  (user_id, user_first_name, user_last_name, is_active)
VALUES
  (2, 'Donald', 'Duck', TRUE),
  (3, 'Mickey', 'Mouse', FALSE);

MERGE INTO sms_db.users AS u
USING sms_db.users_stg AS ustg
ON u.user_id = ustg.user_id
WHEN MATCHED THEN
	UPDATE SET u.user_first_name = ustg.user_first_name,
    u.user_last_name = ustg.user_last_name,
    u.is_active = ustg.is_active
WHEN NOT MATCHED THEN
	INSERT (user_id, user_first_name, user_last_name, is_active)
  VALUES (ustg.user_id, ustg.user_first_name, ustg.user_last_name, ustg.is_active);

SELECT * FROM sms_db.users;