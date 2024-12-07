## Note:
meixinchoy's project was expanded to include 2 players, along with a better UI, and new game rules to handle both players.

# 2 Player Snake Game in Assembly
## Features and Functions
#### Game Speed Selection
  * User may choose from three speed levels, level 1 to level 3, level 3 being the slowest.
  * Each of the speed levels have a 40ms difference.
#### Random Generation of coin
  * A coin is generated randomly at the start of every game or when either snake eats the previous coin.
  * A checking function is also created to make sure that the random coin doesn't generate on the coordinates of either snake. 
  * A new coin is regenerated if the current one is generated at an invalid coordinate.
#### Accepting keyboard input
  * After the coin is generated, a loop will be initiated to detect for input and jump to specific functions according to the input.
  * If no key is entered, the program will keep looping and waiting for an input. 
  * If the snake is moving and a valid input is not entered, the function will continuously loop and snake will continuously move in the current direction.
  * If the user enters a new input that moves the snake in a different direction, the program will jump to a function that changes the function of the snake.
  * A check is made to ensure the snake cannot go opposite to its current direction (e.g. moving right and player attempts moving directly left).
  * This fully supports both players, with appropriate iteration applied to ensure smooth updates on both snakes.
#### Move Snake
  * The head of both snakes will be moved according to each user's last known input. 
  * The body of the snakes will be moved to the coordinate of the unit before it (eg: the 3rd unit of the body will move to the coordinates of the 2nd unit of the body)
#### Coin Detection
  * When either snake moves, the coordinate of the head is compared with the coordinate of the coin to check whether the snake eats a coin.
  * If so, appropriate score is updated and a new coin is generated.
#### Eat Coin
  * When a coin is eaten, a new unit is added to the snake's body to lengthen the snake.
  * The new tail is at the position of the old tail, a new tail is added according to the direction of the old tail.
#### Self Collision Detection 
  * When either snake moves, the coordinate of the head is compared with the coordinate of the body to check whether the snake collides with itself.
  * Player dies when it collides with itself, and the other player is always the winner.
  * A function loops through the coordinates of the body of the snake and compares with the head position to check if they collide.
#### Wall Collision Detection
  * When either snake moves, the coordinate of the head is compared with the coordinate of the wall to check whether the snake collides with the wall.
  * For smoother gameplay, any snake colliding with a wall is teleported to an adjacent wall (e.g. entering right wall teleports snake to left wall).
#### Player-to-Player Collision Detection
  * When either snake is detected to collide with the other, a few outcomes are determined as per the game rules.
#### Game Rules
  If a snake's head
  * hits self: Always lose. 
  * hits body of other snake: Always lose.
  * hits head of other snake: Longer snake will win, if both players are of equal length game is declared a tie.
#### Scoreboard/Winner
  * When the game is over, the winning player is displayed along with a scoreboard.
  * The scoreboard shows both players' accumulated scores.
  * The user can also choose to exit the game or restart the game.
#### Input Validation
  * Input Validation is set to detect any invalid input and prompts the user to reenter the input if so.

## Controls
| Keys              | Actions                               |
| ----------------- | ------------------------------------- |
| w                 | Player 1: Move up                     |
| a                 | Player 1: Move left                   |
| s                 | Player 1: Move down                   |
| d                 | Player 1: Move right                  |
| i                 | Player 2: Move up                     |
| j                 | Player 2: Move left                   |
| k                 | Player 2: Move down                   |
| l                 | Player 2: Move right                  |
| x                 | Quits the game at any time            |
| enter             | Pause, (Move to unpause)              |

(make sure that your capslock is disabled, and language is set to English)

## Screenshots
Game:
![image](https://github.com/user-attachments/assets/ba224041-7113-43d1-a40f-619dbb0473a7)

Results screen:

![image](https://github.com/user-attachments/assets/4eb1eaf5-e7c2-4a68-9007-6a578d02ebc7)
![image](https://github.com/user-attachments/assets/1368d809-843a-4943-8598-d6269e067d6d)
![image](https://github.com/user-attachments/assets/4c200fcb-9aec-464b-8471-f8ec6e0a3ca7)

## Installation
To start the game you will need to install the following items:
1. Visual Studio (Make sure to assemble as x86)  (can be installed [here](https://visualstudio.microsoft.com/downloads/)) 
2. Irvine32 library (can be downloaded [here](https://github.com/meixinchoy/Irvine-library))
3. Configure asm file, paste code in and run program

## Credit
Yousef
