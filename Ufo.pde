class Ufo {

  PVector pos, vel, v0, acc; //position, velocity, velocity(t=0), acceleration
  PVector CenterMass;                //center mass
  PVector radiusToStar;                 //radius
  float magnitudeRadiusToStar;
  float Const = 1000;        //gravity constant

  PVector pos_path;          //copy of vector to draw predicted path
  PVector vel_path;
  PVector acc_path;
  float magnitudeRadiusToStar_path;

  color beamColour;          

  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  Ufo(float X, float Y, float v0x, float v0y, color myColour) {
    pos = new PVector(X, Y);      //initial position
    v0 = new PVector(v0x, v0y);   //initial velocity
    vel = new PVector(v0x, v0y);  //velocity
    acc = new PVector(0, 0);      //acceleration
    CenterMass = new PVector(494, 402);   //set center mass to fit image
    radiusToStar = new PVector(0, 0);        //radius of distance to CenterMass
    beamColour = myColour;
  }

  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  void calc() {        //do the calculations for orbit
    PVector radiusToStar = PVector.sub(pos, CenterMass);
    magnitudeRadiusToStar = radiusToStar.mag();
    acc.x =(Const*cos(radiusToStar.heading()))/pow(magnitudeRadiusToStar, 2);// 1 < cos(r.heading()) < -1
    acc.y =(Const*sin(radiusToStar.heading()))/pow(magnitudeRadiusToStar, 2);
    vel.x -= acc.x;   // v' = a
    pos.x += vel.x;   // pos' = v
    vel.y -= acc.y;   // v' = a
    pos.y += vel.y;   // pos' = v
  }

  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  PVector getPosition() {
    return pos;
  }

  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  void addAcceleration(float a_x, float a_y) {
    vel.x += a_x;
    vel.y += a_y;
  }

  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  void beamforceComets(Comet[] matter) {

    for (int comet_id = 0; comet_id < numberOfComets; comet_id++) {   //go trough comets
      PVector inspectingComet = new PVector(0, 0);          
      inspectingComet = matter[comet_id].getPosition();   //get position

      if ( ((abs(inspectingComet.y - pos.y) < 100) && (inspectingComet.y > pos.y)) && abs(pos.x - inspectingComet.x) < 70) { //true if comet is in beam area (square)
        matter[comet_id].addAcceleration(0, -0.1);
      }
    }
  }

  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  void drawPath() {

    pos_path = new PVector(0, 0);
    vel_path = new PVector(0, 0);
    acc_path = new PVector(0, 0);

    pos_path = pos.copy();
    vel_path = vel.copy();
    acc_path = acc.copy();
    magnitudeRadiusToStar_path = magnitudeRadiusToStar;

    strokeWeight(3);
    for (int i = 0; i<= 600; i++) {       // ufo has 600 points in advance
      PVector r_path = PVector.sub(pos_path, CenterMass);
      magnitudeRadiusToStar_path = r_path.mag();
      acc_path.x =(Const*cos(r_path.heading()))/pow(magnitudeRadiusToStar_path, 2);// 1 < cos(r.heading()) < -1
      acc_path.y =(Const*sin(r_path.heading()))/pow(magnitudeRadiusToStar_path, 2);
      vel_path.x -= acc_path.x;  // same as in calc
      pos_path.x += vel_path.x;
      vel_path.y -= acc_path.y;
      pos_path.y += vel_path.y; 

      stroke(beamColour, 255-i/2);
      point(pos_path.x, pos_path.y);
    }
  }

  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  void display() {

    float positionX = pos.x;
    float positionY = pos.y;

    strokeCap(ROUND);

    int intensity;
    for (int a = 0; a <= 255; a++) {            //beam is made out of 255 lines

      if ((a+moveBeamRings)%20 == 0) {          // every twenty lines intensity will tripple
        intensity = a*3;
      } else {
        intensity = a;
      }

      stroke(beamColour, intensity/3);
      line(positionX-((255-a)/5)-10, positionY+(255-a)/3, positionX+((255-a)/5)+10, positionY+(255-a)/3);  //draw beam
    }

    ellipseMode(CENTER);                            //FROM HERE draw ufo

    noStroke();
    fill(255);
    ellipse(positionX, positionY - 5, 40, 15);

    noStroke();
    fill(150);
    ellipse(positionX, positionY, 70, 10);
  }
}