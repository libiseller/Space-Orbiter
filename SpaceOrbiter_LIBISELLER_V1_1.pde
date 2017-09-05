/*
 Stefan Libiseller, s1853988
 Creative Technology, Programming for We Create Identity (P4WCI)
 10/2016
 
 Version 1.1
 */

static final int numberOfUfos = 1;
static final int numberOfComets = 20;
static final int pointsForWin = 10;
Ufo[] spaceAlliance = new Ufo[numberOfUfos];
Comet[] rock = new Comet[numberOfComets];

PImage background;
int points;    //catched comets
int life;      //life remaining
int fuel;      //fuel level
PFont font24;  //size 24
PFont font20;  //size 20
PFont font14;  //size 14
float moveBeamRings = 0;   //animation counter



boolean intro = true;  //true if intro should be displayed
boolean play = false;  //true when in gaming mode
boolean win = false;   //true if won
boolean gameOver = false;  //true if game over

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

void setup() {
  size(1000, 750);    //set screensize
  smooth();           //use anti-aliasing
  background = loadImage("star.jpg");

  frameRate(60);    //set frame rate

  intro = true;     //set gaming mode
  play = false;
  win = false;
  gameOver = false;
  life = 3;         //set life
  fuel = 1000;      //set fuel
  points = 0;       //set points

  font24 = loadFont("AvenirNext-Regular-24.vlw");    //load fonts
  font20 = loadFont("AvenirNext-Regular-20.vlw");
  font14 = loadFont("AvenirNext-Regular-14.vlw");



  for (int ufo_id = 0; ufo_id < numberOfUfos; ufo_id++) {     //create numberofUfos many ufos
    color myColor = color(int(random(0, 256)), int(random(0, 256)), int(random(0, 256)));
    spaceAlliance[ufo_id] = new Ufo(random(700, 500), random(100, 200), random(1, 1.6), random(0, 0.5), myColor);
  }


  for (int comet_id = 0; comet_id < numberOfComets; comet_id++) {   //create numberofComets many comets                                        
    color myColor = color(int(random(0, 256)), int(random(0, 256)), int(random(0, 256)));
    rock[comet_id] = new Comet(random(300, 500), random(100, 200), random(1, 1.6), random(0, 0.5), myColor, 10);
  }
}

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

void keyPressed()           
{
  if (key == ' ' && intro) {   //if in intro and space is pressed enter play, end intro
    intro = false;
    play = true;
  }

  if (key == ' ' && (gameOver || win)) {  //if game over oder winning screen space to reset
    setup();
  }

  if (key == 'l') {      //cheat for testing gameOver
    life--;
  }


  if (key == CODED && fuel > 0) {     //control Ufo
    if (keyCode == UP) {
      spaceAlliance[0].addAcceleration(0, -0.1);
      fuel = fuel - 10;
    } else if (keyCode == DOWN) {
      spaceAlliance[0].addAcceleration(0, 0.1);
      fuel = fuel - 10;
    } else if (keyCode == LEFT) {
      spaceAlliance[0].addAcceleration(-0.1, 0);
      fuel = fuel - 10;
    } else if (keyCode == RIGHT) {
      spaceAlliance[0].addAcceleration(0.1, 0);
      fuel = fuel - 10;
    }
  }
}

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

void draw() {

  background(background);   //draw background

  if (intro) {
    intro();     // Message + Reset Ufos
  } else if (play) {
    play();     //play
  } else if (win) { 
    win();   //display mission complete
  } else if (gameOver) { 
    gameOver();  //display game over
  }
}

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

void intro() {    //display intro
  fill(255);    
  textFont(font20, 20);
  text("Hello Spacepilot, here is your mission:", 200, 140);
  textFont(font14, 14);
  text("Mine 10 out of " + numberOfComets + " comets orbiting the local star. You automatically attract them with the beam.", 200, 180);
  text("Avoid asteroids from above. Your board AI will project their estimated path to help you.", 200, 200);
  text("Use the arrow keys to give your space vehicle thrust.", 200, 220);
  text("For this mission you get permission to use 1000 units of your fuel.", 200, 240);
  text("Press space to continue.", 200, 260);
}

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

void play() { 
  if (moveBeamRings < 20) {      //make beam rings move
    moveBeamRings++;
  } else
  {
    moveBeamRings = 0;
  } 


  for (int ufo_id = 0; ufo_id < numberOfUfos; ufo_id++) {
    spaceAlliance[ufo_id].calc();       //calculate next position of ufo
    spaceAlliance[ufo_id].drawPath();   // draw the estimated path
    spaceAlliance[ufo_id].display();    // draw the ufo
    spaceAlliance[ufo_id].beamforceComets(rock);   //influence comets with beam
  }

  for (int comet_id = 0; comet_id < numberOfComets; comet_id++) {
    if (rock[comet_id].getIsVisible()) {
      rock[comet_id].calc();      //calculate next position of comet
      rock[comet_id].drawPath();  // draw estimated path
      rock[comet_id].display();   // draw comet
    }
  }

  checkCollision(spaceAlliance, rock);  //check for collision between ufo and comets. (score and hit!) 

  if (life == 0) {   //set gameover if life = 0
    play = false;
    gameOver = true;
  }

  if (fuel <= 0) {
    play = false;
    gameOver = true;
  }

  if (points >= pointsForWin) {   //check if won
    play = false;
    win = true;
  } 

  textFont(font14, 14);   //display the status
  fill(255);                         
  text("Fuel: " + fuel +"   Life: "+ life + "   Points: " + points, 750, 30);
}

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

void win() {    //display winning message
  textFont(font24, 24);
  fill(255); 
  text("MISSION COMPLETE", 360, 300);
  text("Press space to continue.", 340, 600);
}



//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

void gameOver() {  //display game over message

  textFont(font24, 24);
  fill(255); 
  if (life == 0) {
    text("GAME OVER", 420, 300);
  } else if (fuel == 0) {
    text("Orbiting is falling with style. Mission failed.", 270, 300);
  }

  textFont(font20, 20);
  text("Mission report: " + points + " out of " + numberOfComets + " comets.", 340, 600);
  text("Press space to continue.", 390, 630);
}

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

void checkCollision(Ufo vehicle[], Comet rock[])
{
  for (int ufo_id = 0; ufo_id < numberOfUfos; ufo_id++) {

    PVector ufo = new PVector(0, 0);
    ufo = vehicle[ufo_id].getPosition();

    for (int comet_id = 0; comet_id < numberOfComets; comet_id++) {

      PVector comet = new PVector(0, 0);
      comet = rock[comet_id].getPosition();


      if (abs(ufo.y - comet.y) < 10 && abs(ufo.x - comet.x) < 40 && rock[comet_id].getIsVisible()) {  //wrong
        rock[comet_id].setIsVisible(false);

        if (ufo.y < comet.y)         //if the comet is under the ufo
        {
          points = points + 1;     //count as catched
        } else {                       //if not => hit
          life--;
          rock[comet_id].explosion();
        }
      }
    }
  }
}