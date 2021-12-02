import mysql.connector
import os
import csv
import datetime

# CSC 353 Homework 3


def insertPlayers(cursor, player_id, last_name, first_name, position, hand):
    insert_str = """INSERT INTO Players 
    (player_id, last_name, first_name, hand, ioc) 
    VALUES (%s, %s, %s, %s)"""

    try:
        cursor.execute(
    insert_str,
    (player_id, last_name, first_name, hand))
    except mysql.connector.IntegrityError:
        pass
    except mysql.connector.Error as error_descriptor:
        print("Failed inserting tuple: {}".format(error_descriptor))
        exit(1)


def insertGames(cursor, game_id, date_game, home_team_ID, away_team_ID, home_score, away_score):
    insert_str = """INSERT INTO Game 
    (cursor, game_id, date_game, home_team_ID, away_team_ID, home_score, away_score)
    VALUES (%s, %s, %s, %s, %s, %s)"""

    try:
        cursor.execute(
    insert_str,
    (cursor, game_id, date_game, home_team_ID, away_team_ID, home_score, away_score))
    except mysql.connector.IntegrityError:
        pass
    except mysql.connector.Error as error_descriptor:
        print("Failed inserting tuple: {}".format(error_descriptor))
        exit(1)
        

def insertPitcherStats(cursor, player_id, season, G, IP, PA, AB, H, Single, Double, Triple, HR, K, BB, K_percent, BB_percent, BAA, SLG, OBP, OPS, ER, R, SV, BS, W, L, ERA, xBA, xSLG, wOBA, xwOBA, xOBP, xISO, exit_velocity_avg, launch_angle_avg, sweet_spot_percent, barrel_batted_rate, Pitches, four_seam_percent, four_seam_avg_mph, four_seam_avg_spin, slider_percent, slider_avg_mph, slider_avg_spin, changeup_percent, changeup_avg_mph, changeup_avg_spin, curveball_percent, curveball_avg_mph, curveball_avg_spin, sinker_percent, sinker_avg_mph, sinker_avg_spin, cutter_percent, cutter_avg_mph, cutter_avg_spin, splitter_percent, splitter_avg_mph, splitter_avg_spin, knuckle_percent, knuckle_avg_mph, knuckle_avg_spin):
    insert_str = """INSERT INTO PitcherSeasonStats 
    (player_id, season, G, IP, PA, AB, H, Single, Double, Triple, HR, K, BB, K_percent, BB_percent, BAA, SLG, OBP, OPS, ER, R, SV, BS, W, L, ERA, xBA, xSLG, wOBA, xwOBA, xOBP, xISO, exit_velocity_avg, launch_angle_avg, sweet_spot_percent, barrel_batted_rate, Pitches, four_seam_percent, four_seam_avg_mph, four_seam_avg_spin, slider_percent, slider_avg_mph, slider_avg_spin, changeup_percent, changeup_avg_mph, changeup_avg_spin, curveball_percent, curveball_avg_mph, curveball_avg_spin, sinker_percent, sinker_avg_mph, sinker_avg_spin, cutter_percent, cutter_avg_mph, cutter_avg_spin, splitter_percent, splitter_avg_mph, splitter_avg_spin, knuckle_percent, knuckle_avg_mph, knuckle_avg_spin) 
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""

    try:
        cursor.execute(
    insert_str,
    (player_id, season, G, IP, PA, AB, H, Single, Double, Triple, HR, K, BB, K_percent, BB_percent, BAA, SLG, OBP, OPS, ER, R, SV, BS, W, L, ERA, xBA, xSLG, wOBA, xwOBA, xOBP, xISO, exit_velocity_avg, launch_angle_avg, sweet_spot_percent, barrel_batted_rate, Pitches, four_seam_percent, four_seam_avg_mph, four_seam_avg_spin, slider_percent, slider_avg_mph, slider_avg_spin, changeup_percent, changeup_avg_mph, changeup_avg_spin, curveball_percent, curveball_avg_mph, curveball_avg_spin, sinker_percent, sinker_avg_mph, sinker_avg_spin, cutter_percent, cutter_avg_mph, cutter_avg_spin, splitter_percent, splitter_avg_mph, splitter_avg_spin, knuckle_percent, knuckle_avg_mph, knuckle_avg_spin))
    except mysql.connector.Error as error_descriptor:
        print("Failed inserting tuple: {}".format(error_descriptor))
        exit(1)


def insertHitterStats(cursor, player_id, season, G, PA, AB, H, Single, Double, Triple, HR, K, BB, K_percent, BB_percent, Average, SLG, OBP, OPS, RBI, SB, HBP, R, SB_percent, xBA, xSLG, wOBA, xwOBA, xOBP, xISO, exit_velocity_avg, launch_angle_avg, sweet_spot_percent, barrel_batted_rate, groundballs_percent, flyballs_percent, linedrives_percent, popups_percent, sprint_speed):
    insert_str = """INSERT INTO HitterSeasonStats  
    (player_id, season, G, PA, AB, H, Single, Double, Triple, HR, K, BB, K_percent, BB_percent, Average, SLG, OBP, OPS, RBI, SB, HBP, R, SB_percent, xBA, xSLG, wOBA, xwOBA, xOBP, xISO, exit_velocity_avg, launch_angle_avg, sweet_spot_percent, barrel_batted_rate, groundballs_percent, flyballs_percent, linedrives_percent, popups_percent, sprint_speed) 
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""

    try:
        cursor.execute(
    insert_str,
    (player_id, season, G, PA, AB, H, Single, Double, Triple, HR, K, BB, K_percent, BB_percent, Average, SLG, OBP, OPS, RBI, SB, HBP, R, SB_percent, xBA, xSLG, wOBA, xwOBA, xOBP, xISO, exit_velocity_avg, launch_angle_avg, sweet_spot_percent, barrel_batted_rate, groundballs_percent, flyballs_percent, linedrives_percent, popups_percent, sprint_speed))
    except mysql.connector.Error as error_descriptor:
        print("Failed inserting tuple: {}".format(error_descriptor))
        exit(1)


def insertPitcherPlaysInGame(cursor, player_id, game_id, decision, IP, H, R, ER, BB, HBP, K, BF, AB, pitches, strikes, ERA):
    insert_str = """INSERT INTO PitcherPlaysInGame 
    (player_id, game_id, decision, IP, H, R, ER, BB, HBP, K, BF, AB, pitches, strikes, ERA) 
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""
    
    try:
        cursor.execute(
    insert_str,
    (player_id, game_id, decision, IP, H, R, ER, BB, HBP, K, BF, AB, pitches, strikes, ERA))
    except mysql.connector.IntegrityError:
        pass
    except mysql.connector.Error as error_descriptor:
        print("Failed inserting tuple: {}".format(error_descriptor))


def insertHitterPlaysInGame(cursor, player_id, game_id, PA, AB, H, Singe, Double, Triple, HR, K, BB, HBP, R, RBI, SB, AVG, OBP, SLG, OPS):
    insert_str = """INSERT INTO HitterPlaysInGame 
    (player_id, game_id, PA, AB, H, Singe, Double, Triple, HR, K, BB, HBP, R, RBI, SB, AVG, OBP, SLG, OPS) 
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""
    
    try:
        cursor.execute(
    insert_str,
    (player_id, game_id, PA, AB, H, Singe, Double, Triple, HR, K, BB, HBP, R, RBI, SB, AVG, OBP, SLG, OPS))
    except mysql.connector.IntegrityError:
        pass
    except mysql.connector.Error as error_descriptor:
        print("Failed inserting tuple: {}".format(error_descriptor))


# This converts the date obtained from the XML files into a SQL date string. 
def convertDate(date):
    day = date[6:]+ " "
    month = date[4:6]+ " "
    year = date[:4] 
    
    return datetime.datetime.strptime(month + day + year, '%m %d %Y').strftime('%Y-%m-%d')

# Read the 'Schema.sql' file into the 'schema_string' variable
# See 'Schema.sql' for comments on what that file should contain
with open("BaseballSchema.sql", "r") as in_file:
    schema_string = in_file.read()

# Connect to MySQL
connection = mysql.connector.connect(
    user='root',
    password='123456',
    host='localhost')

# Run the contents of 'Schema.sql', creating a schema (deleting previous incarnations),
# and creating the three relations mentioned in the handout.
cursor = connection.cursor()

databaseName = "BaseballSchema"

try:
    results = cursor.execute(schema_string, multi=True)
    for r in results:
        pass
except mysql.connector.Error as error_descriptor:
    if error_descriptor.errno == mysql.connector.errorcode.ER_TABLE_EXISTS_ERROR:
        print("Table already exists: {}".format(error_descriptor))
    else:
        print("Failed creating schema: {}".format(error_descriptor))

cursor.close()

# create new cursor
cursor = connection.cursor()

# After running the contents of 'Schema.sql', you have to do again
# a USE SenatorVotes in your connection before adding the tuples.
try:
    cursor.execute("USE {}".format(databaseName))
except mysql.connector.Error as error_descriptor:
    print("Failed using database: {}".format(error_descriptor))


tourney_id = 1
match_id = 1
file_count = 0

# run through csv files
directory = os.path.join("c:\\","/Users/izzymoody/Desktop/Classes/CSC353/Baseball Savant Stats/Pitcher Stats")
for root,dirs,files in os.walk(directory):
    for file in files:
        row_count = -1
        if file.endswith(".csv"):
            with open(file) as csv_file:
                csv_reader = csv.reader(csv_file, delimiter = ',')
                file_count = file_count + 1
                for row in csv_reader:
                    row_count = row_count + 1
                    if row_count > 0:

                        # Player data
                        last_name = row[0]
                        first_name = row[1]

                        #get the rest from scraped data
                        # Hitter stats
                        season = row[3]
                        AB = row[5]
                        PA = row[6]
                        H = row[7]
                        Single = row[8]
                        Double = row[9]
                        Triple = row[10]
                        HR = row[11]
                        K = row[12]
                        BB = row[13]
                        K_percent = row[14]
                        BB_percent = row[15]
                        Average = row[16]
                        SLG = row[17]
                        OBP = row[18]
                        OPS = [19]
                        RBI = [20]
                        SB = row[21]
                        G = row[22]
                        HBP = row[23]
                        R = row[24]
                        SB_percent = row[27]
                        xBA = row[28]
                        xSLG = row[29]
                        wOBA = row[30]
                        xwOBA = row[31]
                        xOBP = row[32]
                        xISO = row[33]
                        exit_velocity_avg = row[34]
                        launch_angle_avg = row[35]
                        sweet_spot_percent = row[36]
                        barrel_rate = row[37]
                        groundballs_percent = row[38]
                        flyballs_percent = row[39]
                        linedrives_percent = row[40]
                        popups_percent = row[41]
                        sprint_speed = row[42]
                        player_id = cursor.lastrowid
                        insertHitterStats(cursor, player_id, season, G, PA, AB, H, Single, Double, Triple, HR, K, BB, K_percent, BB_percent, Average, SLG, OBP, OPS, RBI, SB, HBP, R, SB_percent, xBA, xSLG, wOBA, xwOBA, xOBP, xISO, exit_velocity_avg, launch_angle_avg, sweet_spot_percent, barrel_rate, groundballs_percent, flyballs_percent, linedrives_percent, popups_percent, sprint_speed)
                    

# run through csv files for pitcher season stats
directory = os.path.join("c:\\","/Users/izzymoody/Desktop/Classes/CSC353/Baseball Savant Stats/Pitcher Stats")
for root,dirs,files in os.walk(directory):
    for file in files:
        row_count = -1
        if file.endswith(".csv"):
            with open(file) as csv_file:
                csv_reader = csv.reader(csv_file, delimiter = ',')
                file_count = file_count + 1
                for row in csv_reader:
                    row_count = row_count + 1
                    if row_count > 0:

                        # Player data
                        last_name = row[0]
                        first_name = row[1]
                        #get the rest from scraped data

                        # Pitcher stats
                        season = row[3]
                        G = row[5]
                        IP = row[6]
                        PA = row[7]
                        AB = row[8]
                        H = row[9]
                        Single = row[10]
                        Double = row[11]
                        Triple = row[12]
                        HR = row[13]
                        K = row[14]
                        BB = row[15]
                        K_percent = row[16]
                        BB_percent = row[17]
                        BAA = row[18]
                        SLG = row[19]
                        OBP = row[20]
                        OPS = row[21]
                        ER = row[22]
                        R = row[23]
                        SV = row[24]
                        BS = row[25]
                        W = row[26]
                        L = row[27]
                        ERA = row[28]
                        xBA = row[30]
                        xSLG = row[31]
                        wOBA = row[32]
                        xwOBA = row[33]
                        xOBP = row[34]
                        xISO = row[35]
                        exit_velocity_avg = row[36]
                        launch_angle_avg = row[37]
                        sweet_spot_percent = row[38]
                        barrel_batted_rate = row[39]
                        Pitches = row[40]
                        four_seam_percent = row[41]
                        four_seam_avg_mph = row[42]
                        four_seam_avg_spin = row[43]
                        slider_percent = row[44]
                        slider_avg_speed = row[45]
                        slider_avg_spin = row[46]
                        changeup_percent = row[47]
                        changeup_avg_speed = row[48]
                        changeup_avg_spin = row[49]
                        curveball_percent = row[50]
                        curveball_avg_speed = row[51]
                        curveball_avg_spin = row[52]
                        sinker_percent = row[53]
                        sinker_avg_speed = row[54]
                        sinker_avg_spin = row[55]
                        cutter_percent = row[56]
                        cutter_avg_speed = row[57]
                        cutter_avg_spin = row[58]
                        splitter_percent = row[59]
                        splitter_avg_speed = row[60]
                        splitter_avg_spin = row[61]
                        knuckle_percent = row[62]
                        knuckle_avg_speed = row[63]
                        knuckle_avg_spin = row[64] 

                        insertPitcherStats(cursor, player_id, season, G, IP, PA, AB, H, Single, Double, Triple, HR, K, BB, K_percent, BB_percent, BAA, SLG, OBP, OPS, ER, R, SV, BS, W, L, ERA, xBA, xSLG, wOBA, xwOBA, xOBP, xISO, exit_velocity_avg, launch_angle_avg, sweet_spot_percent, barrel_batted_rate, Pitches, four_seam_percent, four_seam_avg_mph, four_seam_avg_spin, slider_percent, slider_avg_speed, slider_avg_spin, changeup_percent, changeup_avg_speed, changeup_avg_spin, curveball_percent, curveball_avg_speed, curveball_avg_spin, sinker_percent, sinker_avg_speed, sinker_avg_spin, cutter_percent, cutter_avg_speed, cutter_avg_spin, splitter_percent, splitter_avg_speed, splitter_avg_spin, knuckle_percent, knuckle_avg_speed, knuckle_avg_spin)    
 

# commit and close connections
connection.commit()
cursor.close()
connection.close()
