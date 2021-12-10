README

CSC353 Final Project 
Authors: Izzy Moody, Henry Howell, Dominic Flocco, Gabe Levy

This project implements a full-stack application that creates and maintains a working webpage
of season- and game-level baseball data. Data is scraped from various online sources, stores this data
into a local mySQL database, creates procedures to aggregate and query the data usefully, and implements
a front-end user interface for users to explore the database. 

Data is scraped from baseball-reference.com and baseballsavant.mlb.com and reflects game and season level 
statistics for pitchers and batters in Maljor League Baseball (MLB) from 2015 through the 2021 season. 

Here is a brief description of how the repository is organized, and how it can be executed: 
Folders:

data -> contains BSB reference data, savant data, stathead data, game results, and player info
Scraping -> includes 3 python data scrapers
WebPage -> folder which contains:
	index.php -> homepage for main website
	assets -> folder which holds css style sheet, an image and 7 php pages
Files:
BaseballDataImporter.py -> imports the data, takes about 20 minutes to run
BaseballSchema.sql -> schema with 6 tables
procedures.sql -> includes 8 sql procedures



