use testDB
GO
--insert new record
insert INTO orders ('2022-01-23',1001,105,10)
GO
-- update record
update products_on_hand set quantity=15 where product_id=105
GO
-- delete record
delete products_on_hand where product_id=105
GO