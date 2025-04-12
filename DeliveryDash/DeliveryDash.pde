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
PImage vehicleSpriteSheet; // Add sprite sheet variable

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
 * Setup function - initialize the game
*/
void setup() {
  size(1024, 1024);
  loadResources();
  backgroundMusic.loop();
  game = new Game();
  gameState = MENU; // Start in menu mode
}

/**
 * Loads all necessary resources for the game
*/
void loadResources() {
  // Load images
  backgroundImg = loadImage("images/background.png");
  bg = new Background();
  
  // Load vehicle sprite sheet
  vehicleSpriteSheet = loadImage("images/2D Top down 180 pixel vehicles/2D Top Down 180 Vehicles ( size x2 ).png");
  
  // Load different player car images from sprite sheet
  playerCarImgs = new PImage[3];
  // Extract car images from sprite sheet (you may need to adjust these coordinates based on the actual sprite sheet layout)
  playerCarImgs[0] = vehicleSpriteSheet.get(0, 0, 180, 180); // Standard car
  playerCarImgs[1] = vehicleSpriteSheet.get(180, 0, 180, 180); // Super car
  playerCarImgs[2] = vehicleSpriteSheet.get(360, 0, 180, 180); // Sport car
  
  policeCarImg = vehicleSpriteSheet.get(540, 0, 180, 180); // Police car
  npcCarImg = loadImage("images/NPC_Blue.png");
  npcTruckImg = vehicleSpriteSheet.get(720, 0, 180, 180); // Truck
  donutImg = loadImage("images/donut.jpg");
  
  // Load sounds
  backgroundMusic = new SoundFile(this, "sounds/background_music.mp3");
  carHitSound = new SoundFile(this, "sounds/explosion.mp3"); // Using explosion sound for car hit
  speedIncreaseSound = new SoundFile(this, "sounds/speed_increase.mp3");
  speedDecreaseSound = new SoundFile(this, "sounds/speed_decrease.mp3");
  maxSpeedSound = new SoundFile(this, "sounds/speed_increase.mp3"); // Using speed increase sound for max speed
  deathSound = new SoundFile(this, "sounds/explosion.mp3");
  policeSirenSound = new SoundFile(this, "sounds/police_siren.mp3");
  tiresScreechSound = new SoundFile(this, "sounds/tires_screech.mp3");
}

/**
 * Draw function - handles the game's visual rednering based on current state
 */
void draw() {
  background(0);
  switch(gameState) {
    case MENU:
      drawMenu();
      break;
    case GAME_REGULAR:
      if (game != null) {
        game.update();
        game.display();
      } else {
        println("Error: Game is null in GAME_REGULAR state!");
        gameState = MENU;
      }
      break;
    case GAME_SUDDEN_DEATH:
      if (game != null) {
        game.update();
        game.display();
      } else {
        println("Error: Game is null in GAME_SUDDEN_DEATH state!");
        gameState = MENU;
      }
      break;
    case GAME_OVER:
      if (game != null) {
        game.display();
      }
      fill(255, 0, 0);
      textSize(48);
      textAlign(CENTER);
      text("GAME OVER", width/2, height/2);
      textSize(24);
      text("Press ENTER to return to menu", width/2, height/2 + 50);
      break;
    case GAME_WIN:
      if (game != null) {
        game.display();
      }
      fill(0, 255, 0);
      textSize(48);
      textAlign(CENTER);
      text("YOU WIN!", width/2, height/2);
      textSize(24);
      text("Press ENTER to return to menu", width/2, height/2 + 50);
      break;
  }
}

/**
 * Draws the main menu of the game
 */
void drawMenu() {
  background(0);
  
  // Update and display background with a slow scroll speed
  bg.scrollSpeed = 1; // Set a slow scroll speed for menu
  bg.update(1); // Pass a small value to update
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
 * Handles keyboard input for car movement
 */
void keyPressed() {
  // Only print state changes
  if (keyCode == ENTER && (gameState == MENU || gameState == GAME_OVER || gameState == GAME_WIN)) {
    println("Game state changing from: " + gameState);
  }
  
  // Only handle movement if in game states
  if (gameState == GAME_REGULAR || gameState == GAME_SUDDEN_DEATH) {
    if (game != null && game.player != null) {
      // Acceleration controls
      if (key == 'w' || key == 'W' || keyCode == UP) {
        game.player.isAccelerating = true;
      }
      if (key == 's' || key == 'S' || keyCode == DOWN) {
        game.player.decelerate(); // Call decelerate directly
      }
      
      // Turning controls
      if (key == 'a' || key == 'A' || keyCode == LEFT) {
        game.player.turnLeft();
      }
      if (key == 'd' || key == 'D' || keyCode == RIGHT) {
        game.player.turnRight();
      }
      
      // Car type selection (for testing)
      if (key == '1') {
        game.player.setCarType(CarType.STANDARD);
      }
      if (key == '2') {
        game.player.setCarType(CarType.SUPER);
      }
      if (key == '3') {
        game.player.setCarType(CarType.SPORT);
      }
    } else {
      println("Error: Game or player is null!");
    }
  }
  
  // Game state controls
  if (keyCode == ENTER) {
    if (gameState == MENU) {
      if (game == null) {
        game = new Game();
      }
      game.setupRegularMode();
      gameState = GAME_REGULAR;
      println("Starting game in regular mode");
    } else if (gameState == GAME_OVER || gameState == GAME_WIN) {
      gameState = MENU;
      println("Returning to menu");
    }
  }
}

void keyReleased() {
  // Only handle movement if in game states
  if (gameState == GAME_REGULAR || gameState == GAME_SUDDEN_DEATH) {
    if (game != null && game.player != null) {
      // Stop acceleration when key is released
      if (key == 'w' || key == 'W' || keyCode == UP) {
        game.player.isAccelerating = false;
      }
      if (key == 's' || key == 'S' || keyCode == DOWN) {
        // Stop active braking when brake key is released
        game.player.isAccelerating = false;
      }
    }
  }
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
  float minSpeed;
  float acceleration;
  boolean isAccelerating;  // Track if accelerator is pressed
  int health;
  boolean hasDonut;
  CarType carType;
  int carIndex;
  String carName;
  float direction;
  float turnSpeed;
  
  /**
   * Constructor for the PlayerCar class
   */
  PlayerCar(float x, float y) {
    this.x = x;
    this.y = height * 0.8f;
    this.minSpeed = 30;
    this.speed = this.minSpeed;
    this.isAccelerating = false;
    this.health = 3;
    this.hasDonut = false;
    this.direction = -PI/2;
    this.turnSpeed = 0.1;
    
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
        this.acceleration = 0.5;
        this.carIndex = 0;
        this.carName = "Standard";
        break;
      case SUPER:
        this.topSpeed = 200;
        this.acceleration = 0.7;
        this.carIndex = 1;
        this.carName = "Super";
        break;
      case SPORT:
        this.topSpeed = 180;
        this.acceleration = 0.8;
        this.carIndex = 2;
        this.carName = "Sport";
        break;
    }
  }
  
  /**
   * Updates the position and state of the player's car
   */
  void update() {
    // Handle acceleration/deceleration
    if (isAccelerating) {
      speed = min(speed + acceleration, topSpeed);
      if (speed >= topSpeed && !maxSpeedSound.isPlaying()) {
        maxSpeedSound.play();
      }
    } else {
      // Natural deceleration when not accelerating
      speed = max(speed - 0.1, minSpeed); // Very gradual natural deceleration
    }
    
    // Calculate horizontal movement based on direction
    float moveAmount = speed * 0.3;
    x += moveAmount * cos(direction);
    
    // Keep car within horizontal bounds and handle edge collision
    if (x < 30) {
      x = 30;
      direction = -PI/2;
    } else if (x > width - 30) {
      x = width - 30;
      direction = -PI/2;
    }
    
    // Keep y position fixed
    y = height * 0.8f;
  }
  
  /**
   * Displays the player's car on screen
   */
  void display() {
    pushMatrix();
    translate(x, y);
    rotate(direction + PI/2);
    
    // Draw car image
    imageMode(CENTER);
    image(playerCarImgs[carIndex], 0, 0, 60, 60);
    
    // Draw health indicators (rotate them to always face up)
    rotate(-(direction + PI/2));
    for (int i = 0; i < health; i++) {
      fill(255, 0, 0);
      ellipse(-20 + i * 10, -30, 5, 5);
    }
    
    // Draw donut indicator if active
    if (hasDonut) {
      fill(255, 255, 0);
      ellipse(20, -30, 8, 8);
    }
    
    popMatrix();
  }
  
  /**
   * Increases the car's speed
   */
  void accelerate() {
    isAccelerating = true;
    if (!speedIncreaseSound.isPlaying() && speed < topSpeed) {
      speedIncreaseSound.play();
    }
  }
   
  /**
   * Decrease the car's speed
   */
  void decelerate() {
    // Active braking when S/DOWN is pressed - much more aggressive
    speed = max(speed - 2.0, minSpeed); // Much more aggressive braking
    if (!speedDecreaseSound.isPlaying()) {
      speedDecreaseSound.play();
    }
  }
  
  /**
   * Turns the car left
   */
  void turnLeft() {
    direction = constrain(direction - turnSpeed, -PI, 0); // Limit turning range
  }
  
  /**
   * Turns the car right
   */
  void turnRight() {
    direction = constrain(direction + turnSpeed, -PI, 0); // Limit turning range
  }
  
  /**
   * Handles collision with other vehicles
   * @return boolean True if the player is still alive, false if dead
   */
  boolean handleCollision() {
    this.health--;
    carHitSound.play();
    speed = max(speed * 0.5, minSpeed);
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
    // Display police car image
    imageMode(CENTER);
    image(policeCarImg, x, y, 60, 60);
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
    // Move NPCs upward based on player speed
    y += playerSpeed * 0.5;
    
    // Reset position when off screen
    if (y > height + height) {
      y = -height;
      x = random(width);
    }
  }
  
  /**
   * Displays the NPC vehicle on screen
   * To be implemented in future stages
   */
  void display() {
    // Will display vehicle image
    imageMode(CENTER);
    image(vehicleImage, x, y, width, height);
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
  
  /**
   * Constructor with custom image
   */
  NPCCar(float x, float y, PImage customImage) {
    super(x, y, customImage, 60, 40);
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
  float y1, y2;
  float scrollSpeed;
  PImage bgImg;
  
  /**
   * Constructor for the Background class
   */
  Background() {
    this.y1 = 0;
    this.y2 = -height;
    this.scrollSpeed = 0;
    this.bgImg = backgroundImg;
  }
  
  /**
   * Updates the background's positions based on player speed
   */
  void update(float playerSpeed) {
    // Scroll speed is directly based on player speed
    scrollSpeed = playerSpeed * 0.8;  // Increased multiplier significantly for faster scrolling
    
    // Update both background positions
    y1 += scrollSpeed;
    y2 += scrollSpeed;
    
    // Reset positions when backgrounds move off screen
    if (y1 >= height) {
      y1 = y2 - height;
    }
    if (y2 >= height) {
      y2 = y1 - height;
    }
  }
  
  /**
   * Displays the scrolling background
   */
  void display() {
    imageMode(CORNER);
    image(bgImg, 0, y1, width, height);
    image(bgImg, 0, y2, width, height);
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
  PImage[] npcCarImages;  // Array to store NPC car images
  
  float timeLimit;
  float startTime;
  float distanceTraveled;
  float totalDistance;
  float speedLimit;
  boolean winFlag;
  
  /**
   * Constructor for the Game class
   */
  Game() {
    this.player = new PlayerCar(width/2, height * 0.8f); // Position player at bottom center
    this.policeCar = new PoliceCar(-50, 50);
    this.npcCars = new ArrayList<NPCCar>();
    this.npcTrucks = new ArrayList<NPCTruck>();
    this.background = new Background();
    
    // Load NPC car images
    this.npcCarImages = NPCCar.loadNPCCarImages();
    
    // Initialize game parameters
    this.timeLimit = 60; // 60 seconds
    this.startTime = millis();
    this.distanceTraveled = 0;
    this.totalDistance = 1000; // Units to travel
    this.speedLimit = 55; // Speed limit
    this.winFlag = false;
  }
  
  /**
   * Updates the game state
   */
  void update() {
    if (player == null) return;
    
    // Update player car first
    player.update();
    
    // Update background based on player speed
    background.update(player.speed);
    
    // Update police car
    policeCar.update(player.speed);
    
    // Update NPC vehicles
    for (NPCCar car : npcCars) {
      car.update(player.speed);
    }
    for (NPCTruck truck : npcTrucks) {
      truck.update(player.speed);
    }
    
    // Update game time and distance
    float currentTime = (millis() - startTime) / 1000.0; // Convert to seconds
    if (player.speed > 0) {
      distanceTraveled += player.speed * (1.0/60.0); // Assuming 60 FPS
    }
    
    // Check for game over conditions
    if (currentTime >= timeLimit) {
      gameState = GAME_OVER;
    }
    
    // Check for win condition
    if (distanceTraveled >= totalDistance) {
      gameState = GAME_WIN;
      winFlag = true;
    }
    
    // Check for collisions with NPC vehicles
    for (NPCCar car : npcCars) {
      if (car.checkCollision(player.x, player.y, 60, 60)) {
        if (!player.handleCollision()) {
          gameState = GAME_OVER;
        }
      }
    }
    for (NPCTruck truck : npcTrucks) {
      if (truck.checkCollision(player.x, player.y, 60, 60)) {
        if (!player.handleCollision()) {
          gameState = GAME_OVER;
        }
      }
    }
    
    // Check for police speed enforcement
    if (policeCar.isCatchingSpeeder(player.speed, speedLimit, player.hasDonut)) {
      if (!player.handleCollision()) {
        gameState = GAME_OVER;
      }
    }
  }
  
  /**
   * Displays the game elements
   */
  void display() {
    // Display background
    background.display();
    
    // Display player car
    if (player != null) {
      player.display();
    }
    
    // Display police car
    policeCar.display();
    
    // Display NPC vehicles
    for (NPCCar car : npcCars) {
      car.display();
    }
    for (NPCTruck truck : npcTrucks) {
      truck.display();
    }
    
    // Display HUD
    displayHUD();
  }
  
  void displayHUD() {
    float currentTime = (millis() - startTime) / 1000.0;
    float timeRemaining = max(0, timeLimit - currentTime);
    
    fill(255);
    textSize(24);
    textAlign(LEFT);
    text("Time: " + nf(timeRemaining, 0, 1) + "s", 20, 40);
    text("Distance: " + nf(distanceTraveled, 0, 1) + "/" + nf(totalDistance, 0, 1), 20, 70);
    if (player != null) {
      text("Speed: " + player.speed, 20, 100);
      text("Accelerating: " + player.isAccelerating, 20, 130);
      text("Top Speed: " + player.topSpeed, 20, 160);
    }
    text("Health: " + (player != null ? player.health : 0), 20, 190);
    
    // Display speed limit when police car is nearby
    if (policeCar.x > -100 && policeCar.x < width + 100) {
      textAlign(CENTER);
      text("Speed Limit: " + nf(speedLimit, 0, 0), width/2, 40);
    }
  }
  
  /**
   * Sets up game for regular mode
   */
  void setupRegularMode() {
    // Reset game parameters
    timeLimit = 60;
    startTime = millis();
    distanceTraveled = 0;
    totalDistance = 1000;
    speedLimit = 55;
    winFlag = false;
    
    // Reset player
    player = new PlayerCar(width/2, height * 0.8f);
    
    // Reset police car
    policeCar = new PoliceCar(-50, 50);
    
    // Clear and reset NPC vehicles
    npcCars.clear();
    npcTrucks.clear();
    
    // Add initial NPC vehicles with random images
    for (int i = 0; i < 5; i++) {
      float x = random(width);
      float y = random(-height, 0); // Start off-screen
      PImage randomImage = npcCarImages[(int)random(npcCarImages.length)];
      npcCars.add(new NPCCar(x, y, randomImage));
    }
    for (int i = 0; i < 2; i++) {
      npcTrucks.add(new NPCTruck(random(width), random(height)));
    }
  }
  
  /**
   * Sets up the game for sudden death mode
   */
  void setupSuddenDeathMode() {
    // Set up parameters for sudden death mode
    timeLimit = 30; // Shorter time limit
    startTime = millis();
    distanceTraveled = 0;
    totalDistance = 1500; // Longer distance
    speedLimit = 45; // Lower speed limit
    winFlag = false;
    
    // Reset player with 1 health
    player = new PlayerCar(100, height/2);
    player.health = 1;
    
    // Reset police car
    policeCar = new PoliceCar(-50, 50);
    
    // Clear and reset NPC vehicles with more vehicles
    npcCars.clear();
    npcTrucks.clear();
    
    // Add more NPC vehicles for increased difficulty
    for (int i = 0; i < 8; i++) {
      npcCars.add(new NPCCar(random(width), random(height)));
    }
    for (int i = 0; i < 4; i++) {
      npcTrucks.add(new NPCTruck(random(width), random(height)));
    }
  }
}
