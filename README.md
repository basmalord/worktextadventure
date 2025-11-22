# **WorkTextAdventure**



**Data Structure:**

Uses JSON to store data pertaining to passages. JSON is a dictionary-based coding language that allows for the storing of values under key names. The key names and values for our project, along with a brief description of each, are as follows:



1. passage\_name : a string of text that describes the passage (naming convention tbd)
2. visual\_name : a string of text that describes the visual element of the passage (naming convention tbd)
3. passage\_text : a string of text that will be presented to the player whenever the passage is loaded
4. inputs : the valid inputs the player can input in order to load a new passage, each input is a dictionary which contains a key, "passage\_name" that provides a string of text that describes the passage that will be loaded upon the inputting of the corresponding input.



Note: passage\_name and visual\_name must correspond to the name under which corresponding files are saved, this allows the string data within the JSON file to be used to load the desired passages and visuals.



**Resources:**



JSON beginner's guide (syntax and formatting super simple!): https://stackoverflow.blog/2022/06/02/a-beginners-guide-to-json-the-data-format-for-the-internet/



JSON validator (provides testing for your JSON files to see if they can be read as such, will also highlight where and how syntax errors occur):

https://stackoverflow.blog/2022/06/02/a-beginners-guide-to-json-the-data-format-for-the-internet/
