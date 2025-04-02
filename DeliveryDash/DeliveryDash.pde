/**
 * DeliveryDash - A car driving game
 * This game challenges players to reach a destination within a time limit while
 * avoiding collisions with other vehicles and staying within the speed limit
 * when polic cars are present.
 * 
 * Team Members: Braulio, Edwyn, Ethan, Carson
*/

// Image variables
PImage backgroundImg;
PImage[] playerCarImgs; // Array of different car images
PImage policeCarImg;
PImage npcCarImg;
PImage npcTruckImg;
PImage donutImg;

// Sound variable
import processing.sound.*;
SoundFile backgroundMusic;
SoundFile carHitSound;
SoundFile speedIncreaseSound;
SoundFile speedDecreasesSound;
SoundFile maxSpeedSound;
SoundFile deathSound;
SoundFile policSirenSound;
SoundFile tiresScreechSound;

// Game state constants
final int MENU = 0;
final int GAME_REGULAR = 1;
final int GAME_SUDDEN_DEATH = 2;
final int GAME_OVER = 3;
final int GAME_WIN = 4;
int gameState = MENU;

// Game instance
Game game;

/**
 * Setup funcrion - initilize the game
*/
void setup() {
  size(800, 600);
  loadResources();
  game = new Game();
}

/**
 * Loads all necessary resources for the game
*/
void loadResources() {
  // Load images
  backgroundImg = loadImage("images/background.png");
  
  // Load different player car images
  playerCarImgs = new PImage[3];
  playerCarImgs[0] = loadImage("images/player_car_standard.png"); // Balanced car
  playerCarImgs[1] = loadImage("images/player_car_super.png"); // Fast car with high top speed
  playerCarImgs[2] = loadImage("images/player_car_sport.png"); // Agile car with high acceleration
  
  policeCarImg = loadImage("images/police_car.png");
  npcCarImg = loadImage("images/npc_car.png");
  npcTruckImg = loadImage("images/npc_truck.png");
  donutImg = loadImage("images/donut.png");
  
  // Load sounds
  backgroundMusic = new SoundFile(this, "sounds/background_music.mp3");
  carHitSound = new SoundFile(this, "sounds/car_hit.mp3");
  speedIncreaseSound = new SoundFile(this, "sounds/speed_incease.mp3");
  speedDecreaseSound = new SoundFile(this, "sounds/speed_decrease.mp3");
  maxSpeedSound = new SoundFile(this, "sounds/max_speed.mp3");
  deathSound = new SoundFile(this, "sounds/explosion.mp3");
  policeSirenSound = new SoundFile(this, "sounds/police_siren.mp3");
  tiresScreechSound = new SoundFile(this, "sounds/tires_screech.mp3");
}

/**
 * Draw function - handles the game's visual rednering based on current state
 */
 void draw() {
   switch(gameState) {
     case MENU:
       drawMenu();
       break;
     case GAME_REGULAR:
     case GAME_SUDDEN_DEATH:
       game.update();
       game.display();
       break;
     case GAME_OVER:
       drawGameOver();
       break;
     case GAME_WIN:
       drawWin();
       break;
   }
 }
 
 /**
 * Draws the main menu of the game
 */
 void drawMenu() {
   background(0);
   // Menu implementation to be added
   // Should include buttons for:
   // - Car selection (Standard, Super (High Top Speed), Sport (Hight acceleration))
   // - Regular mode
   // - Sudden Death mode
   // - Exit game
 
   fill(255);
   textSize(48);
   textAlign(CENTER);
   text("DELIVERY DASH", width/2, 100);
   
   // Placeholder for car selection
   textSize(24);
   
   // Car selection buttons would go here
   // Each button would call game.player.setCarType() with the appropriate type
   
   // Game mode selection
   textSize(24);
   text("Select Game Mode:", width/2, 350);
   
   // Mode buttons would go here
 }
 
 /**
  * Draws the game over screen
  */
void drawGameOver() {
  background(0);
  fill(255, 0, 0);
  textSize(48);
  textAlign(CENTER);
  text("GAME OVER", width/2, height/2);
  // Add restart and menu buttons
}

/**
 * Draws the win screen
 */
void drawWin() {
  background(0);
  fill(0, 255, 0);
  textSize(48);
  textAlign(CENTER);
  text("YOU WIN", width/2, height/2);
  // Add restart and menu buttons
}

/**
 * Handles keyboard input
 */
void keyPressed() {
  if (gameState == GAME_REGULAR || gameState == GAME_SUDDEN_DEATH) {
    game.handleKeyPress(key);
  }
}

/**
 * Handles key release
 */
void keyReleased() {
  if (gameState == GAME_REGULAR || gameState == GAME_SUDDEN_DEATH) {
    game.handleKeyRelease(key);
  }
}

/**
 * Handles mouse clicks for menu navigation
 */
void mousePressed() {
  if (gameState == MENU) {
    // handle menu button clicks
  } else if (gameState == GAME_OVER || gameState == GAME_WIN) {
    // Handle restart or menu buttons
  }
}

/**
 * CarType enum - defines different types of cars player can choose
 */
enum CarType {
  STANDARD, // Balance performance
  SUPER, // High top speed, low acceleration
  SPORT // Low top speed, high acceleration
}

/**
 * PlayerCar class - represents the player's vehicle
 */ 
class PlayerCar {
  float x, y;
  float speed;
  float topSpeed;
  float acceleration;
  int health;
  boolean hasDonut;
  CarType carType;
  int carIndex;
  String carName;
  
  /**
   * Constructor for the PlayerCar class
   */
  PlayerCar(float x, float y) {
    this.x = x;
    this.y = y;
    this.speed = 0;
    this.health = 3;
    this.hasDonut = false;
    
    // Default to standard car
    setCarType(CarType.STANDARD);
  }
  
  /**
   * Sets the car type and adjusts performance characteristics
   * @param type The type of the car to use
   */
  void setCarType(CarType type) {
    this.carType = type;
    
    switch(type) {
      case STANDARD:
        this.topSpeed = 150;
        this.acceleration = 10;
        this.carIndex = 0;
        this.carName = "Standar";
        break;
      case SUPER:
        this.topSpeed = 250;
        this.acceleration = 10;
        this.carIndex = 1;
        this.carName = "Super";
        break;
      case SPORT:
        this.topSpeed = 150;
        this.acceleration = 20;
        this.carIndex = 2;
        this.carName = "Sport";
        break;
    }
  }
  
  /**
   * Updates the position and state of the player's car
   */
  void update() {
    // Update car position based on speed
    // This doesn't move the car on screen but affects distance traveled
  }
  
  /**
   * Displays the player's car on screen
   */
  void display() {
    image(playerCarImgs[carIndex], x, y);
    
    // Display health and donut status
    fill(255);
    textSize(16);
    text("Health: " + health, 20, 30);
    text("Car: " + carName, 150, 30);
    
    if (hasDonut) {
      image(donutImg, 240, 20, 30, 30);
    }
  }
  
  /**
   * Increases the car's speed
   */
   void accelerate() {
     speed = min(speed + acceleration, topSpeed);
     if (speed == topSpeed) {
       maxSpeedSound.play();
     } else {
       speedIncreaseSound.play();
     }
   }
   
   /**
    * Decrease the car's speed
    */
    void decelerate() {
      speed = max(speed - acceleration 0);
      speedDcreaseSound.play();
    }
    
    /**
     * Handles collision with other vehicles
     * @return boolean True if the player is still alicve, false if dead
     */
    boolean handleCollision() {
      this.health--;
      carHitSound.play();
      return this.health > 0;
    }
}
