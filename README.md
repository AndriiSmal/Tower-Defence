# Tower-Defence
  
## Description
The project consists in creation of a video game of Tower Defense genre, developed entirely using the Processing programming language. In this type of game, the player must strategically place defensive towers along a path to prevent enemies from passing through.  

## Main objectives
* Create intuitive and dynamic interface.
* Implement a system of enemy spawning and with progressive difficulty.
* Include economical system with possibility of buying new towers and upgrading them.  
  
## Principal functionality
### Start with placing towers
Player starts with certain amount of cash with whom it may buy towers (or upgrade them). To place a new tower, the player needs to press '1' or '2' key and position it with 'left mouse button' anywhere except the road segments or map borders. For enhancing game speed use 'R' key.

### The Road
The road is the path that enemies will follow in order to reach the end point. If the enemies reach the end point your life will decrease! You must be careful, because if the health points of your base drops to 0 - the game is over!  

### Enemies and waves
In this game, are present the waves of enemies with different characteristics (higher speed, magior durability, ecc.). But its not like you was not prepared! Enemies are getting stronger each wave progressively!  

### Towers
There are 2 types of towers to choose for total elimination of circles! The first, is the basic one that costs less and shoots fast. And the other is the sniper, with more range and damage.
You may also upgrade them for better battle-efficiency or sale when they got no use for you!

### Hall of fame
Top 5 best scores are placed in file 'scores.txt'. You can see it also at 'game over' section each time.

### UML

![TowerDefence](https://assets/images/TowerDefence.png)

## Instruments used
* Processing (4.3.3)
* Visual Studio Code
