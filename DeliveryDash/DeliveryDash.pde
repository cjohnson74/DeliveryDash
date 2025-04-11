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
Background bg;
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
SoundFile speedDecreaseSound;
SoundFile maxSpeedSound;
SoundFile deathSound;
SoundFile policeSirenSound;
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
  size(1024, 1024);
  loadResources();
  game = new Game();
}

/**
 * Loads all necessary resources for the game
*/
void loadResources() {
  // Load images
  backgroundImg = loadImage("images/background.png");
  bg = new Background();
  
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
       // Will be implemented in future stages
       break;
     case GAME_OVER:
     case GAME_WIN:
       // Will be implemented in future stages
       break;
   }
 }
 
 /**
 * Draws the main menu of the game
 */
 void drawMenu() {
   background(0);
   bg.display();
   // Menu design includes:
   // - Car selection (Standard, Super (High Top Speed), Sport (Hight acceleration))
   // - Regular mode
   // - Sudden Death mode
   // - Exit game
   
   // Placeholder text for design
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
 * Handles keyboard input
 * To be implemented in future stages
 */
void keyPressed() {
  // Will handle WASD and/or arrow keys for driving
}

/**
 * Handles mouse clicks for menu navigation
 * To be implemented in future stages
 */
void mousePressed() {
  // Will handle menu button clicks
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
 * This class is partially implemented as required for Stage 1
 */ 
class PlayerCar {
  float x, y;
  float speed;
  float topSpeed;
  float acceleration;
  int health;
  boolean hasDonut; // Invincibility against cops
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
    // Will display car image and stats
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
      speed = max(speed - acceleration, 0);
      speedDecreaseSound.play();
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

/** 
 * PoliceCar class - represents police vehicles that enfore speed limits
 */
class PoliceCar {
  float x, y;
  float speed;
  
  /**
   * Constructor for the PoliceCar class
   */
  PoliceCar(float x, float y) {
    this.x = x;
    this.y = y;
    this.speed = 0; // Will be set to -PlayerSpeed
  }
  
  /**
   * Updates the police car's position
   * To be implemented in future stages
   */
  void update(float playerSpeed) {
    // Will update position based on player speed
  }
  
  /**
   * Displays the police car on screen
   * To be implemeneted in future stages
   */
  void display() {
    // Sill displa police car image
  }
  
  /**
   * Checks if the player is speeding when near the police
   * To be implemented in future stages
   */
  boolean isCatchingSpeeder(float playerSpeed, float speedLimit, boolean hasDonut) {
    // Will check for speed violations
    return false;
  }
}

/**
 * NPCVehicle class - base class for non-player vehicles
 */
class NPCVehicle {
  float x, y;
  float speed;
  PImage vehicleImage;
  float width, height;
  
  /**
   * Constructor for the NPCVehicle class
   */
  NPCVehicle(float x, float y, PImage vehicleImage, float w, float h) {
    this.x = x;
    this.y = y;
    this.speed = 0;
    this.vehicleImage = vehicleImage;
    this.width = w;
    this.height = h;
  }
  
  /**
   * Updaets the NPC vehicle's position
   * To be implemented in future stages
   */
  void update(float playerSpeed) {
    // Will update position based on player speed
  }
  
  /**
   * Displays the NPC vehicle on screen
   * To be implemented in future stages
   */
  void display() {
    // Will display vehicle image
  }
  
  /**
   * Checks for collision withh the player's car
   * To be implmented in future stages
   */
  boolean checkCollision(float playerX, float playerY, float playerWidth, float playerHeight) {
    // Will check for collisions
    return false;
  }
}

/**
 * NPCCar class - represnets civilian cars on road
 */
class NPCCar extends NPCVehicle {
  /**
   * Constructor for the NPCCar class
   */
  NPCCar(float x, float y) {
    super(x, y, npcCarImg, 60, 40);
  }
}

/**
 * NPCTruck class - represents trucks on the road
 */
class NPCTruck extends NPCVehicle {
  /**
   * Constrictor for the NPCTruck class
   */
  NPCTruck(float x, float y) {
    super(x, y, npcTruckImg, 100, 50);
  }
}

/**
 * Background class - represents the scrolling background
 */
class Background {
  float x;
  float y;
  float speed;
  PImage bgImg;
  
  /**
   * Constructor for the Background class
   */
  Background() {
    this.x = 0;
    this.y = 0;
    this.speed = 2;
    this.bgImg = backgroundImg;
  }
  
  /**
   * Updates the background's positions
   * To be implemented in future stages
   */
  void update(float playerSpeed) {
    // Will update background position based on player speed
  }
  
  /**
   * Displays the scrolling background
   * To be implemented in future stages
   */
  void display() {
    // Will display scrolling background
    y+= speed;
    if(y >= bgImg.height) {
      y = 0;
    }
    image(bgImg, 0, y - bgImg.height);
    image(bgImg, 0, y);
  }
}

/**
 * Game class - manages the overall game state and logic
 */
class Game {
  PlayerCar player;
  PoliceCar policeCar;
  ArrayList<NPCCar> npcCars;
  ArrayList<NPCTruck> npcTrucks;
  Background background;
  
  float timeLimit;
  float timePassed;
  float distanceTraveled;
  float totalDistance;
  float speedLimit;
  boolean winFlag;
  
  /**
   * Constructor for the Game class
   */
  Game() {
    this.player = new PlayerCar(100, height/2);
    this.policeCar = new PoliceCar(-50, 50);
    this.npcCars = new ArrayList<NPCCar>();
    this.npcTrucks = new ArrayList<NPCTruck>();
    this.background = new Background();
    
    // Initialize game parameters
    this.timeLimit = 60; // 60 seconds
    this.timePassed = 0;
    this.distanceTraveled = 0;
    this.totalDistance = 1000; // Units to travel
    this.speedLimit = 7; // Speed limit
    this.winFlag = false;
  }
  
  /**
   * Updates the game state
   * To be implemented in future stages
   */
  void update() {
    // Will update all game elements
  }
  
  /**
   * Displays the game elements
   * To be implemented in future stages
   */
  void display() {
    // Will display all game elements
  }
  
  /**
   * Sets up game for regular mode
   * To be implemented in future stages
   */
  void setupRegularMode() {
    // Will set up parameters for regular mode
  }
  
  /**
   * Sets up the game for sudden death mode
   * To be implemented in future stages
   */
  void setupSuddenDeathMode() {
    // Will set up parameters for sudden death mode
  }
}
