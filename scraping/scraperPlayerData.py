import requests
from bs4 import BeautifulSoup, NavigableString
import random
import re
import pandas as pd
from datetime import datetime
import glob
import csv

allIDs = {}
batterIDs = {}
urlseen = set()
with open("/Users/dominicflocco/Desktop/CSC353_finalProject/stathead_data/stathead_batter_data.csv", 'r') as f: 
    reader = csv.DictReader(f)
    for row in reader: 
        splitFirst = row['Player'].split()
        firstname = splitFirst[0]
        if len(splitFirst) == 3:
            splitLast = splitFirst[2].split("\\")
            lastname = splitFirst[1] + " " + splitLast[0]
            id = splitLast[1]
        elif len(splitFirst) == 4:
            splitLast = splitFirst[3].split("\\")
            lastname = splitFirst[1] + " " + splitFirst[2] + " " + splitLast[0]
            id = splitLast[1]
        else:
            splitLast = splitFirst[1].split("\\")
            lastname = splitLast[0]
            id = splitLast[1]
        
        if id not in urlseen:
            batterIDs[(firstname, lastname)] = id
            allIDs[(firstname, lastname)] = id
            urlseen.add(id)
        

with open('/Users/dominicflocco/Desktop/CSC353_finalProject/data/player_info.csv', 'r') as f: 
    reader = csv.DictReader(f)
    for row in reader: 
        firstname = row['first_name']
        lastname = row['last_name']
        id = row['bsbref_id']
        allIDs[(firstname, lastname)] = id

print(len(allIDs))

# with open("/Users/dominicflocco/Desktop/CSC353_finalProject/stathead_data/stathead_pitcher_data.csv", 'r') as f: 
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

#         if id not in urlseen:
#             pitcherIDs[(firstname, lastname)] = id
#             allIDs[(firstname, lastname)] = id
#             urlseen.add(id)

def convertAllNames(firstname, lastname): 
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
    # if type == "batter": 
    #     if (firstname, lastname) in batterIDs:
    #         id = batterIDs[(firstname, lastname)]
    #     else: 
    #         if lastname == "Bradley":
    #             return "bradlja02"
    #         if lastname == "Guerrero Jr.":
    #             return "guerrvl02"
            
    #         lastname = lastname.split()[0] 
            
    #         if len(lastname) >= 5: 
    #             lastname = lastname[:5].lower()
    #         else: 
    #             lastname = lastname.lower()

    #         firstname = firstname[:2].lower()
    #         if firstname == "b.":
    #             firstname = "bj"
    #         if lastname in ['tatis', 'taylo', "garci"]:
    #             id = lastname + firstname + "02"
    #         elif lastname in ['ramir']:
    #             id = lastname + firstname + "03"
    #         else:
                
    #             id = lastname + firstname + "01"
    # else: 
    #     if (firstname, lastname) in pitcherIDs:
    #         id = pitcherIDs[(firstname, lastname)]
    #     else: 
    #         if lastname == "De La Cruz":
    #             return "delacjo01"
    #         lastname = lastname.split()[0] 
            
    #         if len(lastname) >= 5: 
    #             lastname = lastname[:5].lower()
    #         else: 
    #             lastname = lastname.lower()
    #         if lastname == "alani":
    #             return "alanirj01"
    #         if firstname == "Thomas" and lastname == "hatch":
    #             return "hatchto01"
    #         if lastname == "o'fla": 
    #             return "oflaher01"
    #         firstname = firstname[:2].lower()
    #         if firstname == "c.":
    #             return "riefecj01"
    #         if lastname in ["reyno", "rober", "brown", "edwar", "russe", "johns"]:
    #             id = lastname + firstname + "02"
    #         elif lastname in ["harri", "valde"]:
    #             id = lastname + firstname + "03"
    #         elif lastname in ['taylo']:
    #             id = lastname + firstname + "10"
    #         else:
    #             id = lastname + firstname + "01"

    if (firstname, lastname) in allIDs:
        id = allIDs[(firstname, lastname)]
    else: 
        num = "01"
        if lastname == "Cruz Jr.":
            return "cruzne02"
        if lastname == "Gurriel":
            return "gourryu01"
        if lastname == "Voit III":
            lastname ="voit"
        if firstname == "Tommy":
            firstname = "th"
        if lastname == "De Jesus Jr.":
            return 'dejesiv02'
        if "Jr." in lastname: 
            lastname = lastname.split()[0]
        lastname = ''.join(filter(str.isalnum, lastname))
        firstname = ''.join(filter(str.isalnum, firstname))
        lastname = lastname.lower()
        firstname = firstname.lower()
        if len(lastname) >= 5: 
            lastname = lastname[:5]
        firstname = firstname[:2]

        id =  lastname + firstname + num 
    return id

def scrapePlayerInfo(firstname, lastname):

    player = convertAllNames(firstname, lastname)
    url = "https://www.baseball-reference.com/players/"+ player[0] +"/" + player + ".shtml"
    #url = https://www.baseball-reference.com/players/t/troutmi01.html
    reqs = requests.get(url)
    data = BeautifulSoup(reqs.content, features="html.parser")
    player_info = data.find('div', {'id': 'meta'} )
    player_info_rows = list(player_info.findAll('p'))
    playerData = {}
    bodyInfo = player_info_rows[2].get_text(strip=True).split(",")
    # playerData['height'] = bodyInfo[0]
    # playerData['weight'] = bodyInfo[1][:3]
    for row in player_info_rows: 
        if not isinstance(row, NavigableString):
            value = row.get_text(strip=True)
            info = value.split(":")
            if "Position" in value: 
                playerData["position"] = info[1]
            elif "Bats" in value and "Joey" not in value: 
                playerData['bats'] = info[1].split("\n")[0]
                playerData['throws'] = info[2]
            elif "Team" in value and "National" not in value: 
                team = info[1].split("(")[0] 
                playerData['cur_team'] = team
            elif "lb" in value and "kg" in value: 
                height = value.split(",")[0]
                weight = value.split(",")[1][:3]
                playerData["height"] = height
                playerData["weight"] = weight 
            elif "Born" in value:
                try: 
                    date = info[1].split()
                    month = date[0]
                    day = date[1].split(",")[0]
                    year = date[1].split(",")[1][:4]
                    dob = datetime.strptime(year + month + day, "%Y%B%d")
                    dob = str(dob)[:10]
                except: 
                    dob = ""
                playerData['dob'] = dob
    
            elif "Debut" in value: 
                try:
                    date = info[1].split()
                    month = date[0]
                    day = date[1][:-1]
                    year = date[2][:4]
                    debut = datetime.strptime(year + month + day, "%Y%B%d")
                    debut = str(debut)[:10]
                except: 
                    debut = ""
                
                playerData['debut'] = debut
    playerData['first_name'] = firstname 
    playerData['last_name'] = lastname 
    playerData['bsbref_id'] = player   
    return playerData
        

def readHitterNames():
    hittersSeen = set()
    files = glob.glob("/Users/dominicflocco/Desktop/CSC353_finalProject/data/savant_data/hitter_stats_FULL/*")
    
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


def main():
    
    batters = readHitterNames()
    #pitchers = readPitcherNames()
    
    column_names = ['first_name', 'last_name', 'bsbref_id', "position", "bats", "throws", "height", "weight",
                    "cur_team", "dob",  "debut"]

    df = pd.DataFrame(columns=column_names)
    for player in batters: 
        player_info = scrapePlayerInfo(player[0], player[1])
        seasons = ','.join(batters[player])
        player_info['seasons'] = seasons
        df = df.append(player_info, ignore_index=True)
        if len(df)%100==0:
            print(len(df))
 
    #df.to_csv("batter_info.csv")
    # for player in pitchers: 
    #     player_info = scrapePlayerInfo(player[0], player[1])
    #     df = df.append(player_info, ignore_index=True)
    #     print(len(df))
    df.to_csv("player_info_NEW.csv")

if __name__ == "__main__":
    main()