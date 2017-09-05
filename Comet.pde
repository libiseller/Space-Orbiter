class Comet {

  PVector pos, vel, v0, acc;   
  PVector CenterMass;      //center mass (sun)
  PVector radiusToStar;    //radius
  float magnitudeRadiusToStar;
  float diameter;
  static final float Const = 1000;

  PVector pos_path;
  PVector vel_path;
  PVector acc_path;
  float magnitudeRadiusToStar_path;

  color soilColour;

  boolean isVisible = true;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  Comet(float X, float Y, float v0x, float v0y, color myColour, float diameter_assigned) {  //constructor
    pos = new PVector(X, Y);      //initial position
    v0 = new PVector(v0x, v0y);   //initial velocity
    vel = new PVector(v0x, v0y);  //velocity
    acc = new PVector(0, 0);
    CenterMass = new PVector(494, 402);   //set center mass to fit image
    radiusToStar = new PVector(0, 0);        //radius of distance to CM
    soilColour = myColour;        
    diameter = diameter_assigned;
  }
  
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  PVector getPosition() {
    return pos;
  }
  
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  float getDirection(){
    float dir = vel.heading();
    return dir;
  }
  
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  void addAcceleration(float a_x, float a_y) {
    vel.x += a_x;  //x direction
    vel.y += a_y;  //y direction
  }
  
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  void calc() {   //calculations for orbit
    PVector radiusToStar = PVector.sub(pos, CenterMass);
    magnitudeRadiusToStar = radiusToStar.mag();
    acc.x =(Const*cos(radiusToStar.heading()))/pow(magnitudeRadiusToStar, 2);   // 1 < cos(r.heading()) < -1
    acc.y =(Const*sin(radiusToStar.heading()))/pow(magnitudeRadiusToStar, 2);
    vel.x -= acc.x;   // v' = a
    pos.x += vel.x;   // pos' = v
    vel.y -= acc.y;
    pos.y += vel.y;
  }
  
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  boolean getIsVisible() {
    return isVisible;
  }
  
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  void setIsVisible(boolean value) {
    isVisible = value;
  }

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  void drawPath() {

    pos_path = new PVector(0, 0);
    vel_path = new PVector(0, 0);
    acc_path = new PVector(0, 0);

    pos_path = pos.copy();   //VERY IMPORTANT to use copy
    vel_path = vel.copy();
    acc_path = acc.copy();
    magnitudeRadiusToStar_path = magnitudeRadiusToStar;

    strokeWeight(3);
    for (int i = 0; i<= 100; i++)        // draw 100 points of estimated path
    {
      PVector radiusToStar_path = PVector.sub(pos_path, CenterMass);
      magnitudeRadiusToStar_path = radiusToStar_path.mag();
      acc_path.x =(Const*cos(radiusToStar_path.heading()))/pow(magnitudeRadiusToStar_path, 2);// 1 < cos(r.heading()) < -1
      acc_path.y =(Const*sin(radiusToStar_path.heading()))/pow(magnitudeRadiusToStar_path, 2);
      vel_path.x -= acc_path.x;   //same as in calc 
      pos_path.x += vel_path.x;
      vel_path.y -= acc_path.y;
      pos_path.y += vel_path.y; 

      stroke(soilColour, 255-(i*2.55));  // set colour and fade out 
      point(pos_path.x, pos_path.y);
    }
  }
  
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  void explosion(){      //draw one frame of explosion
    
    fill(#FFF73A, 100);
    ellipse(pos.x, pos.y, 40, 40);
    fill(#BE7D22, 150);
    ellipse(pos.x, pos.y, 30, 30);
    fill(#FF0000, 220);
    ellipse(pos.x, pos.y, 10, 10);

  }

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  void display() {   //display comet

    float positionX = pos.x;
    float positionY = pos.y;

    strokeCap(ROUND);

    noStroke();
    fill(170);
    
    ellipse(positionX, positionY, diameter, diameter);
  }
}