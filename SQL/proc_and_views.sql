use hsdb;

-- creating procedure which retrieves a teams earnings from all of its pros
drop procedure if exists get_team_earnings;
delimiter //
create procedure get_team_earnings(in team_name varchar(50))

begin 
	select sum(p.pro_earnings),
		t.team_name as "Name",
        t.team_region as "Region"
	from pros p 
    join teams t on p.pro_team_id = t.team_id
    where t.team_name like team_name
    group by t.team_id;

end //
delimiter ;

call get_team_earnings('cloud 9');

-- Query to get the earnings of all the pros on a given team_name

drop procedure if exists get_pro_earnings;
delimiter //
create procedure get_pro_earnings(in team_name varchar(50))
begin
	select t.team_name,
		p.pro_fname as "First Name",
		p.pro_lname as "Last Name",
        p.pro_ign as "In game Name",
        p.pro_earnings as "Earnings"
	from pros p
    join teams t on p.pro_team_id = t.team_id
    where t.team_name like team_name;
end //
delimiter ;
call get_pro_earnings('cloud 9');

-- a stored view that ranks all the pros based off of earnings
drop view if exists pro_earnings;
create view pro_earnings as
select p.pro_id as "ID",
	p.pro_fname as "First Name",
    p.pro_lname as "Last Name",
    p.pro_earnings as "Earnings",
    t.team_name as "Team"
from pros p
join teams t on p.pro_team_id = t.team_id
order by p.pro_earnings desc;

select * from pro_earnings;

-- creating a procedure that gets the most popular decks the pros play
drop view if exists popular_pro_decks;
create view popular_pro_decks as
select d.deck_id as "ID",
	d.deck_name as "Deck Name",
    count(*) as "Num_pros"
from decks d
join pro_decklist pd on d.deck_id = pd.deck_id
group by d.deck_id;

select * from pro_earnings;


-- creating a procedure to assign a deck to a pro

drop procedure if exists add_pro_deck;
delimiter //
create procedure add_pro_deck(in pro_id int(5), in deck_id int(5))
begin
	insert into pro_decklist(pro_id, deck_id)
    values (pro_id, deck_id);
end //
delimiter ;

-- creating procedure for adding pros to tournaments
drop procedure if exists add_participant;
delimiter //
create procedure add_participant(in pro_id int(5), in tr_id int(5), in rank int(5))
begin
	insert into participants( participant_id, tournament_id, participant_rank)
    values (pro_id, tr_id, rank);
end //
delimiter ;

-- similar to add_pro_deck, making an add_streamer deck to add decks to streamers;
drop procedure if exists add_streamer_deck;
delimiter //
create procedure add_streamer_deck(in streamer_id int(5), in deck_id int(5))
begin
	insert into streamer_decklist(streamer_id, deck_id)
    values (streamer_id, deck_id);
end //
delimiter ;



-- creating a view that displays the most popular decks among the pros
drop view if exists popular_pro_decks;
create view popular_pro_decks as
select d.deck_id as "Deck ID",
	d.deck_name as "Deck Name",
    count(*) as num_pros
from decks d
join pro_decklist pd on d.deck_id = pd.deck_id
group by d.deck_id
order by num_pros desc;

select * from popular_pro_decks;


-- view for displaying the most popular streamer decks
drop view if exists popular_streamer_decks;
create view popular_streamer_decks as
select d.deck_id as "Deck ID",
	d.deck_name as "Deck Name",
    count(*) as num_streamers
from decks d
join streamer_decklist sd on d.deck_id = sd.deck_id
group by d.deck_id
order by num_streamers desc;

select * from popular_streamer_decks;

-- view for displaying the most popular streamers 
drop view if exists popular_streamers;
create view popular_streamers as
select s.streamer_id as "Streamer ID",
	s.streamer_ign as "In Game Name",
    s.streamer_twitch_name as "Twitch Name",
    s.streamer_followers as "Followers",
    s.streamer_views as "Views"
from streamers s order by s.streamer_followers desc;

select * from popular_streamers;


drop procedure if exists get_tournament_ranks;
delimiter //
create procedure get_tournament_ranks(in tournament_name varchar(50))
begin
select tr.tournament_name as "Tournament Name",
	p.pro_fname as "First Name",
    p.pro_lname as "Last Name",
    t.team_name as "Team Name",
    par.participant_rank as "Rank"
from tournaments tr
join participants par on par.tournament_id = tr.tournament_id
join pros p on p.pro_id = par.participant_id
join teams t on t.team_id = p.pro_team_id
where tr.tournament_name like tournament_name
order by par.participant_rank asc;

end//
delimiter ;

call get_tournament_ranks('The Pinnacle 1');


drop view if exists tournament_info;
create view tournament_info as
select t.tournament_name as "NAME",
	t.tournament_start_date as "start date",
    t.tournament_end_date as "end date",
    concat('$',t.tournament_prizepool) as "Prizepool",
    t.tournament_type as "Type",
    t.tournament_organizer as "Organizer"
    from tournaments t;
    
select * from tournament_info;
    
	
