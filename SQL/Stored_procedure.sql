use hsdb;
drop procedure if exists createdeck;
delimiter //
create procedure createdeck (IN deck_id int(5), IN deck_name varchar(100))
begin
	
insert into decks (deck_id,deck_name)
values (deck_id,deck_name);

end //
delimiter ;


use hsdb;
drop procedure if exists addcard;
delimiter //
create procedure addcard (IN deck_id varchar(100), IN card_name varchar(100), IN card_count int(2))
begin
	select c.card_id from card c
    where c.card_name like card_name into @new_card_id;
    
    select d.deck_id from decks d
    where d.deck_name like deck_id into @deck_id;
    
insert into decklist (decklist_id,decklist_card_id,card_count)
values (@deck_id,@new_card_id,card_count);

end //
delimiter ;

use hsdb;
drop procedure if exists showdeck;
delimiter //
create procedure showdeck (IN deck_name varchar(100))
begin
select d.deck_id from decks d
    where d.deck_name like deck_id into @deck_id;

select *
from
(
select  c.card_name,dl.card_count
from decks d
join decklist dl
on dl.decklist_id=d.deck_id
join card c
on c.card_id=dl.decklist_card_id
where d.deck_id=@deck_id)v1
;


end //
delimiter ;

use hsdb;
drop procedure if exists showcard;
delimiter //
create procedure showcard (IN test1 varchar(100))
begin
	
select *
from
(
select c.card_name, a.att_name, ca.catt_value
from card c
join card_attribute ca
on catt_card_id=c.card_id
join attributes a
on att_id=catt_att_id
join list_class lc
on lc.class_id = ca.catt_att_id
join list_expansion le
on le.exp_id= ca.catt_att_id
join list_rarity lr
on lr.rarity_id=ca.catt_att_id
where card_name like 'Frostbolt' )v1;


end //
delimiter ;

