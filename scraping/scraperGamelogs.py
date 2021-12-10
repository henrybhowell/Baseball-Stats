import requests
from bs4 import BeautifulSoup
import random
import re
import pandas as pd
from datetime import datetime
import glob
import csv

# batterIDs = {}
# with open("stathead_batter_data.csv", 'r') as f: 
#     reader = csv.DictReader(f)
#     for row in reader: 
#         splitFirst = row['Player'].split()
#         firstname = splitFirst[0]
#         if len(splitFirst) == 3:
#             splitLast = splitFirst[2].split("\\")
#             lastname = splitFirst[1] + splitLast[0]
#             id = splitLast[1]
#         elif len(splitFirst) == 4:
#             splitLast = splitFirst[3].split("\\")
#             lastname = splitFirst[1] + splitFirst[2] + splitLast[0]
#             id = splitLast[1]
#         else:
#             splitLast = splitFirst[1].split("\\")
#             lastname = splitLast[0]
#             id = splitLast[1]
#         batterIDs[(firstname, lastname)] = id

# pitcherIDs = {}

# with open("stathead_pitcher_data.csv", 'r') as f: 
#     reader = csv.DictReader(f)
#     for row in reader: 
#         splitFirst = row['Player'].split()
#         firstname = splitFirst[0]
#         if len(splitFirst) == 3:
#             splitLast = splitFirst[2].split("\\")
#             lastname = splitFirst[1] + splitLast[0]
#             id = splitLast[1]
#         elif len(splitFirst) == 4:
#             splitLast = splitFirst[3].split("\\")
#             lastname = splitFirst[1] + splitFirst[2] + splitLast[0]
#             id = splitLast[1]
#         else:
#             splitLast = splitFirst[1].split("\\")
#             lastname = splitLast[0]
#             id = splitLast[1]
#         pitcherIDs[(firstname, lastname)] = id

def convertName(firstname, lastname, type): 
    # if lastname == "Gurriel": 
    #     return "gourryu01"
    # if firstname == "Tommy" and lastname == "Pham": 
    #     return "phamth01"
    # if firstname == "J.D." and lastname == "Martinez": 
    #     return "martijd02"
    # if firstname == "Yolmer" and lastname == "Sanchez":
    #     return "sanchca01"

    # lastname = lastname.split()[0] 
    
    # if len(lastname) >= 5: 
    #     lastname = lastname[:5].lower()
    # else: 
    #     lastname = lastname.lower()
    # firstname = firstname[:2].lower()

    # if lastname in ["cruz", "black", "braun", "brant", "rojas", "herna", "donal", "garci", "abreu"]:
    #     return lastname + firstname + "02"
    # elif lastname in ['harpe']:
    #     return lastname + firstname + "03"
    # else:
    #     return lastname + firstname + "01"
    if type == "batter": 
        if (firstname, lastname) in batterIDs:
            id = batterIDs[(firstname, lastname)]
        else: 
            if lastname == "Bradley":
                return "bradlja02"
            if lastname == "Guerrero Jr.":
                return "guerrvl02"
            
            lastname = lastname.split()[0] 
            
            if len(lastname) >= 5: 
                lastname = lastname[:5].lower()
            else: 
                lastname = lastname.lower()

            firstname = firstname[:2].lower()
            if firstname == "b.":
                firstname = "bj"
            if lastname in ['tatis', 'taylo', "garci"]:
                id = lastname + firstname + "02"
            elif lastname in ['ramir']:
                id = lastname + firstname + "03"
            else:
                
                id = lastname + firstname + "01"
    else: 
        if (firstname, lastname) in pitcherIDs:
            id = pitcherIDs[(firstname, lastname)]
        else: 
            if lastname == "De La Cruz":
                return "delacjo01"
            lastname = lastname.split()[0] 
            
            if len(lastname) >= 5: 
                lastname = lastname[:5].lower()
            else: 
                lastname = lastname.lower()
            if lastname == "alani":
                return "alanirj01"
            if firstname == "Thomas" and lastname == "hatch":
                return "hatchto01"
            if lastname == "o'fla": 
                return "oflaher01"
            firstname = firstname[:2].lower()
            if firstname == "c.":
                return "riefecj01"
            if lastname in ["reyno", "rober", "brown", "edwar", "russe", "johns"]:
                id = lastname + firstname + "02"
            elif lastname in ["harri", "valde"]:
                id = lastname + firstname + "03"
            elif lastname in ['taylo']:
                id = lastname + firstname + "10"
            else:
                id = lastname + firstname + "01"
    return id

def scrapePitcher(firstname, lastname, year):
    player = convertName(firstname, lastname, "pitcher")
    #url = "https://www.baseball-reference.com/register/player.fcgi?id=martin003raf"

    url = "https://www.baseball-reference.com/players/gl.fcgi?id=" + player + "&t=p&year=" + str(year)
    #run through all the players in the year and hten move on to the next year
    reqs = requests.get(url)
    data = BeautifulSoup(reqs.content, features="html.parser")

    pitcher_stat_index = ["date_game", "team_ID", "opp_ID", "game_result", "days_rest", "IP", "H", "R", "ER", "BB", "SO", "HR", "HBP", "earned_run_avg", "batters_faced",
    "pitches", "strikes_total", "strikes_looking", "strikes_swinging", "inplay_gb_total", "inplay_fb_total", "inplay_ld", "inplay_pu", "inplay_unk", "game_score", "inherited_runners", 
    "inherited_score",	"SB", "CS", "pickoffs", "AB", "2B", "3B", "IBB", "GIDP", "SF", "ROE", "leverage_index_avg", "wpa_def", "cwpa_def", "re24_def"]
    
    pitcher_stats = data.find('table',{'id': 'pitching_gamelogs'})
    pitcher_stats_line = pitcher_stats.find("tbody")
    pitcher_stats_rows = pitcher_stats_line.findAll('tr', {'id':re.compile(r'pitching_gamelogs.\d')})
    
    pitcher_stat_table = pd.DataFrame(columns=pitcher_stat_index)

    for row in pitcher_stats_rows:
        current_stat = {}
        month_day = row.find('td', {'data-stat': "date_game"}).get_text(strip=True)
        month = month_day[:3]
        day = re.findall('[0-9]+', month_day)[0]
        date = datetime.strptime(str(year) + month + day, "%Y%b%d")
        date = str(date)[:10]
        current_stat["date_game"] = date

        for f in pitcher_stat_index[1:]:
            
            current_stat[f] = row.find('td', {'data-stat': f}).get_text(strip=True)
            
        pitcher_stat_table = pitcher_stat_table.append(current_stat, ignore_index=True)
    
    return pitcher_stat_table

def scrapeHitter(firstname, lastname, year): 
    player = convertName(firstname, lastname, "batter")
    url = "https://www.baseball-reference.com/players/gl.fcgi?id=" + player + "&t=b&year=" + str(year)
   
    reqs = requests.get(url)
    data = BeautifulSoup(reqs.content, features="html.parser")

    hitter_stats = data.find('table',{'id': 'batting_gamelogs'})
    hitter_stats_line = hitter_stats.find("tbody")
    hitter_stats_rows = hitter_stats_line.findAll('tr', {'id':re.compile(r'batting_gamelogs.\d')})
    

    hitter_stat_index = ["date_game", "team_ID", "opp_ID", "game_result", "PA", "AB", "R", "H", "2B", "3B", "HR", "RBI", "BB", "IBB", "SO", "HBP", "SH", "SF", "ROE", "GIDP", "SB", "CS", 
    "batting_avg", "onbase_perc", "slugging_perc", "onbase_plus_slugging", "batting_order_position", "leverage_index_avg", "wpa_bat", "cli_avg", "cwpa_bat", "re24_bat", "pos_game"]
    
    hitter_stat_table = pd.DataFrame(columns=hitter_stat_index)

    for row in hitter_stats_rows:
        current_stat = {}
        month_day = row.find('td', {'data-stat': "date_game"}).get_text(strip=True)
        month = month_day[:3]
        day = re.findall('[0-9]+', month_day)[0]
        date = datetime.strptime(str(year) + month + day, "%Y%b%d")
        date = str(date)[:10]
        current_stat["date_game"] = date

        for f in hitter_stat_index[1:]:
            current_stat[f] = row.find('td', {'data-stat': f}).get_text(strip=True)
        
        hitter_stat_table = hitter_stat_table.append(current_stat, ignore_index=True)
    
    return hitter_stat_table

def scrapeHitterUpdate(id, year): 
    
    url = "https://www.baseball-reference.com/players/gl.fcgi?id=" + id + "&t=b&year=" + str(year)
   
    reqs = requests.get(url)
    data = BeautifulSoup(reqs.content, features="html.parser")

    hitter_stats = data.find('table',{'id': 'batting_gamelogs'})
    hitter_stats_line = hitter_stats.find("tbody")
    hitter_stats_rows = hitter_stats_line.findAll('tr', {'id':re.compile(r'batting_gamelogs.\d')})
    

    hitter_stat_index = ["date_game", "team_ID", "opp_ID", "game_result", "PA", "AB", "R", "H", "2B", "3B", "HR", "RBI", "BB", "IBB", "SO", "HBP", "SH", "SF", "ROE", "GIDP", "SB", "CS", 
    "batting_avg", "onbase_perc", "slugging_perc", "onbase_plus_slugging", "batting_order_position", "leverage_index_avg", "wpa_bat", "cli_avg", "cwpa_bat", "re24_bat", "pos_game"]
    
    hitter_stat_table = pd.DataFrame(columns=hitter_stat_index)

    for row in hitter_stats_rows:
        current_stat = {}
        month_day = row.find('td', {'data-stat': "date_game"}).get_text(strip=True)
        month = month_day[:3]
        day = re.findall('[0-9]+', month_day)[0]
        date = datetime.strptime(str(year) + month + day, "%Y%b%d")
        date = str(date)[:10]
        current_stat["date_game"] = date

        for f in hitter_stat_index[1:]:
            current_stat[f] = row.find('td', {'data-stat': f}).get_text(strip=True)
        
        hitter_stat_table = hitter_stat_table.append(current_stat, ignore_index=True)
    
    return hitter_stat_table

def readHitterNames():
    hittersSeen = set()
    files = glob.glob("savant_data/hitter_stats/*")
    
    players = {}
    for file in files: 
        with open(file, 'r') as f: 
            reader = csv.DictReader(f)
            for row in reader: 
                last_name = row['\ufefflast_name']
                first_name = row[' first_name'][1:]
                player_id = row['player_id']
                year = row['year']
                if player_id not in hittersSeen: 
                    players[(first_name, last_name)] = [year]
                    hittersSeen.add(player_id)
                else:
                    players[(first_name, last_name)].append(year)
    
    return players

def readHitterNamesUpdate():
    hittersSeen = set()
    file = ("/Users/dominicflocco/Desktop/CSC353_finalProject/data/player_info_NEW.csv")
    
    players = {}
    
    with open(file, 'r') as f: 
        reader = csv.DictReader(f)
        for row in reader: 
            last_name = row['last_name']
            first_name = row['first_name']
            player_id = row['bsbref_id']
            seasons = row['seasons']
            if player_id not in hittersSeen: 
                players[(first_name, last_name, player_id)] = seasons.split(',')
                hittersSeen.add(player_id)
    
    return players
    
    
def readPitcherNames():
    pitchersSeen = set()
    files = glob.glob("savant_data/pitcher_stats/*")
    players = {}
    for file in files: 
        with open(file, 'r') as f: 
            reader = csv.DictReader(f)
            for row in reader: 
                last_name = row['\ufefflast_name']
                first_name = row[' first_name'][1:]
                player_id = row['player_id']
                year = row['year']
                if player_id not in pitchersSeen: 
                    players[(first_name, last_name)] = [year]
                    pitchersSeen.add(player_id)
                else:
                    players[(first_name, last_name)].append(year)
    players[("Ryan", "O'Rourke")] = [2015, 2016, 2019]
    return players

def resumeCheckpoint(players):
    files = glob.glob("bsb_reference_data/batter_gamelogs_NEW/*") 
    print(len(files))
    for file in files: 
        fileList = file.split("/")
        fileList = fileList[-1].split("_")
        firstname = fileList[0]
        lastname = fileList[1]
        tup = (firstname, lastname)
        if tup in players:
            players.pop(tup)

    return players

def main():
    
    batters = readHitterNamesUpdate()
    # pitchers = readPitcherNames()
    batters = resumeCheckpoint(batters)
    # pitchers = resumeCheckpoint(pitchers)

    for batter in batters: 
        dfs = []
        firstname = batter[0]
        lastname = batter[1]
        id = batter[2]
        seasons = batters[batter]
        for year in seasons:
            dfs.append(scrapeHitterUpdate(id, year))
        batter_df = pd.concat(dfs)
        filename = firstname + "_" + lastname + "_gamelogs.csv"
        batter_df.to_csv("/Users/dominicflocco/Desktop/CSC353_finalProject/data/bsb_reference_data/batter_gamelogs_NEW" + filename, index=False)

    # for pitcher in pitchers: 
    #     dfs = []
    #     firstname = pitcher[0]
    #     lastname = pitcher[1]
    #     for year in pitchers[pitcher]:
    #         dfs.append(scrapePitcher(firstname, lastname, year))
    #     batter_df = pd.concat(dfs)
    #     filename = firstname + "_" + lastname + "_gamelogs.csv"
        
    #     batter_df.to_csv("bsb_reference_data/pitcher_gamelogs/" + filename, index=False)
   
if __name__ == "__main__":
    main()