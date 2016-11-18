Audioguide data extraction in Rstats.
=====================================

[![DOI](https://zenodo.org/badge/72210075.svg)](https://zenodo.org/badge/latestdoi/72210075)

This set of scripts allows one to extract data from the contentful API, and the MySQL backend to create a 
set of csv files of data drawn from the entries created by the audioguide's users. 

To use
======

There are two (2) active scripts in this project:

 * audioGuide.R - a script to get the list of stops from Contentful.
 * audioGuideMySQLExtractor.R - a script to get the entries in raw csv from the MySQL database.

The second script will generate personal data, you *MUST* not store this on Github.

To get these scripts to work, you will need to clone this repo to your machine:

````
    $ git clone https://github.com/BritishMuseum/audioGuideExtractorInRstats.git 
````

Change directory to the folder and then rename keys.json.dist to keys.json. You will then need to change the
values for the keys. 

````
    $ cd audioGuideExtractorInRstats
````

You will need to set the working directory to where ever you will be working and storing data. To do this, edit
line 9 in the audioGuide.R file and line 10 in audioGuideMySQLextractor

````
    $ nano audioGuide.R
````

Output
======

Each script creates a csv file when run in R. 

Author
======

Daniel Pett <dpett @ britishmuseum dot org>

License
=======

This work is under an MIT license.
