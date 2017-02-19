#Benjamin Ramirez
#December 3 2016

import sys
import json
import csv

f = open('card_data.json')
card_json = json.load(f)

new_file = open('parsed.csv')
f.close()
csv_file = csv.writer(new_file)
unwanted_sets = ["Debug", "Credits", "Missions", "Promo", "Reward", "System", "Tavern Brawl", "Hero Skins"]


for i in range(4):
	print i
for cardSet in card_json:
	#the cardSet
	for i in range(len(card_json[cardSet])):
		print card_json[cardSet][i]["name"]
		new_file.write
		# csv_file.writerow([card_json[i]["name"]])
							# card_json[i]["cardSet"],
							# card_json[i]["playerClass"],
							# card_json[i]["rarity"]])


	# for i in len(card_json[cardSet]):
		# print i
