drop schema hearthstone;
create schema hearthstone;
	use hearthstone;

	create table teams(
		team_id int(5) primary key,
		team_name varchar(25),
		team_country varchar(25),
		team_manager_fname varchar(25),
		team_manager_lname varchar(25),
		team_website varchar(50),
		team_email varchar(50),
		team_creation_date datetime
		)engine=innodb;
	
	create table pros(
		pro_id int(5) primary key,
		pro_fname varchar(25),	
		pro_lname varchar(25),
		pro_age int(2),
		pro_earnings float(9,2),
		pro_rank int(10),
		pro_team_id int(5),
		pro_start_date datetime,
		pro_end_date datetime,
		pro_tournament_wins int(2),
		foreign key (pro_team_id) references teams(team_id)
		)engine=innodb;
	
	create table tournaments(
		tournament_id int(5) primary key,
		tournament_name varchar(30),
		tournament_date datetime,
		tournament_winner int(5),
		tournament_prizepool float(9,2),
		tournament_location varchar(50),
		tournement_participants int(4),
		tournament_organizer varchar(20),
		foreign key (tournament_winner) references pros(pro_id)
	)Engine=InnoDB;

	create table participants(
		participant_id int(5),
		tournament_id int(5), 
		participant_rank int(5),
		foreign key (tournament_id) references tournaments(tournament_id),
		foreign key (participant_id) references pros(pro_id)
	)Engine=InnoDB;

	create table employees(
		employee_id int(5) primary key,
		employee_fname varchar(20),
		employee_lname varchar(20),
		employee_email varchar(50),
		employee_title varchar(20),
		employee_reports_to int(10),
		employee_twitter varchar(20)
	)Engine=InnoDB;

	create table tavern_brawl(
		tavern_id int(5) primary key,
		tavern_startdate datetime,
		tavern_name varchar(40),
		tavern_enddate datetime,
		tavern_rules varchar(50)
	)Engine=InnoDB;

	create table streamers(
		streamer_id int(5) primary key,
		streamer_fname varchar(25),
		streamer_lname varchar(25),
		streamer_twitch_name varchar(25),
		streamer_start_date varchar(25),
		streamer_stream_days varchar(25),
		streamer_most_played varchar(15),
		streamer_followers int(6),
		streamer_views int(10)
		)engine=innodb;

	create table type_table(
		type_id int(5) primary key,
		type_name varchar(10)
	)engine=innodb;

	create table attributes(
		att_id int(5) primary key,
		att_name varchar(15),
		att_type_id int(5),
		foreign key (att_type_id) references type_table(type_id)
	)engine=innodb;

	create table list_expansion(
		exp_id int(5) primary key,
		exp_name varchar(25)
	)engine=innodb;

	create table list_class(
		class_id int(5) primary key,
		class_name varchar(25)
	)engine=innodb;

	create table list_rarity(
		rarity_id int(5) primary key,
		rarity_name varchar(25)
	)engine=innodb;

	create table card(
		card_id int(5) primary key,
		card_name varchar(25),
		card_type_id int (5),
		foreign key (card_type_id) references type_table(type_id),
		card_expansion_id int(5),
		foreign key (card_expansion_id) references list_expansion(exp_id),
		card_rarity_id int(5),
		foreign key (card_rarity_id) references list_rarity(rarity_id),
		card_class_id int(5),
		foreign key (card_class_id) references list_class(class_id)
	)engine=innodb;

	create table card_attribute(
		catt_card_id int(5),
		foreign key (catt_card_id) references card(card_id),
		catt_att_id int(5),
		foreign key (catt_att_id) references attributes(att_id),
		catt_value text
	)engine=innodb;

	create table decks(
		deck_id int(5) primary key,
		deck_name varchar(20)
	)Engine=InnoDB;

	create table decklist(
		decklist_id int(5),  
		foreign key (decklist_id) references decks(deck_id),
		decklist_card_id int(5),
		foreign key (decklist_card_id) references card(card_id),
		card_count int(2)
	)Engine=InnoDB;


	create table pro_decklist(
		pro_id int(5),
		deck_id int(5),
		foreign key (deck_id) references decks(deck_id),
		foreign key (pro_id) references pros(pro_id)
	)Engine=InnoDB;

	create table streamer_decklist(
		streamer_id int(5),
		deck_id int(5),
		foreign key (deck_id) references decks(deck_id),
		foreign key (streamer_id) references streamers(streamer_id)
	)Engine=InnoDB;

	create table tavernbrawl_decklist(
		tavern_id int(5),
		deck_id int(5),
		foreign key (tavern_id) references tavern_brawl(tavern_id),
		foreign key (deck_id) references decks(deck_id)
	)Engine=InnoDB;