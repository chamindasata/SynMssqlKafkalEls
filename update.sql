use testDB
GO
--insert new record
INSERT INTO customers(first_name,last_name,email)
  VALUES ('Oliver','Connor','oliver.connor@acme.com');
GO
-- update record
update customers setemail='oliver.connor@gmail.com' where id=1005
GO
-- delete record
delete customers where id=1005
GO