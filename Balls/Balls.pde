ArrayList<Ball> balls;
ArrayList<Boid> boids;
Boid myBoid = new Boid();
int n;
float k;
float g;
float E;
float s;
int timeSteps = 1000;
PImage img;

void setup(){
  size(1000, 720, P3D);
  background(255); 
  n = 0;
  k = 1.0 / timeSteps;
  g = 0.3 / sq(timeSteps);
  E = 0;
  s = 2.5;
  
  img = loadImage("images\\img.png");
  
  boids = new ArrayList<Boid>(0);
  for(int i = 0; i < 100; i ++) 
    boids.add(new Boid());
    
  boids.add(myBoid);
  
  balls = new ArrayList<Ball>(0);
  for(int i = 0; i < n; i++){
    balls.add(new Ball(s*(10 + random(40)), random(width*3/4) + 50, random(height*3/4) + 50, random(width*3/4) + 50));
    balls.get(i).setGravity(true, g);
    balls.get(i).setSpeed(k*(random(10) - 5), k*(random(10) - 5), k*(random(10) - 5));
    balls.get(i).setColor((int)random(255), (int)random(255), (int)random(255));
    balls.get(i).setMass(sq(balls.get(i).getRadius()));
    E += balls.get(i).getKinetic() + balls.get(i).getPotential();
  }
}

void draw(){
  background(255); 
  //lights();
  PVector dummy1 = new PVector(myBoid.position.x, myBoid.position.y, myBoid.position.z);
  dummy1.add(myBoid.velocity.copy().normalize());
  PVector dummy2 = new PVector(myBoid.position.x, myBoid.position.y, myBoid.position.z);
  dummy2.sub(myBoid.velocity.copy().normalize().mult(100));
  camera(dummy2.x, dummy2.y - 50, dummy2.z, dummy1.x, dummy1.y, dummy1.z, 0, 1, 0);
  if(keyPressed)
    camera(0, 0, 0, myBoid.position.x, myBoid.position.y, myBoid.position.z, 0, 1, 0);
  //translate(100, 200, -500);
  //rotateY(PI/2);
  //rotateZ(-PI/4);
  
  
  
  pushMatrix();
  translate(0, 0, 0);
  stroke(255);
  fill(100, 100, 30);
  //rect(0, 0, width, height);
  image(img, 0, 0, width, height);
  popMatrix();
  
  pushMatrix();
  translate(0, 0, 0);
  rotateY(-PI/2);
  stroke(255);
  fill(100, 100, 40);
  //rect(0, 0, width, height);
  image(img, 0, 0, width, height);
  popMatrix();
  
  pushMatrix();
  translate(0, 0, 0);
  rotateY(-PI/2);
  translate(0, 0, -width);
  stroke(255);
  fill(100, 100, 50);
  //rect(0, 0, width, height);
  image(img, 0, 0, width, height);
  popMatrix();
  
  pushMatrix();
  translate(0, 0, 0);
  rotateY(-PI/2);
  translate(0, 0, -width);
  rotateX(PI/2);
  stroke(255);
  fill(100, 100, 60);
  //rect(0, 0, width, width);
  image(img, 0, 0, width, width);
  popMatrix();
  
  pushMatrix();
  translate(0, 0, 0);
  rotateY(-PI/2);
  translate(0, 0, -width);
  rotateX(PI/2);
  translate(0, 0, -height);
  stroke(255);
  fill(100, 100, 70);
  //rect(0, 0, width, width);
  image(img, 0, 0, width, width);
  popMatrix();
  
  pushMatrix();
  translate(0, 0, width);
  stroke(255);
  fill(100, 100, 80);
  //rect(0, 0, width, height);
  image(img, 0, 0, width, height);
  popMatrix();
  
  pushMatrix();
  translate(0, 0, width);
  stroke(255);
  fill(100, 100, 90);
  //rect(0, 0, width, height);
  image(img, 0, 0, width, height);
  popMatrix();

  
  
  for(int j = 0; j < timeSteps; j++){
    for(int i = balls.size() - 1; i >= 0; i--){
      Ball ball = balls.get(i);
      checkCrash(ball);
      ball.update();
      checkEnergy(ball);
      //ball.setPoint(int(map(ball.getKinetic(), 0, E * 0.5, 2, 100)));
      //ball.setShape(map(ball.getKinetic(), 0, E * 0.5, 0, 3));
    }
  }
  for(Boid b : boids){
    b.update(boids, balls);
    b.display();
  }
  for(int i = balls.size() - 1; i >= 0; i--){
    Ball ball = balls.get(i);
    ball.display();
  }
}

void mousePressed(){
  Ball b = new Ball(s*(10 + random(40)), mouseX, mouseY, random(width*3/4) + 50);
  b.setGravity(true, g);
  b.setSpeed(k*(random(10) - 5), k*(random(10) - 5), k*(random(10) - 5));
  b.setColor((int)random(255), (int)random(255), (int)random(255));
  b.setMass(sq(b.getRadius()));
  balls.add(b);
  E += b.getKinetic() + b.getPotential();
}
  
void keyPressed() {
  background(125);
  for(int i = balls.size() - 1; i >= 0; i--){
    balls.remove(balls.get(i));
    Ball b = new Ball(s*(10 + random(40)), random(width*3/4) + 50, random(height*3/4) + 50, random(width*3/4) + 50);
    b.setGravity(true, g);
    b.setSpeed(k*(random(10) - 5), k*(random(10) - 5), k*(random(10) - 5));
    b.setColor((int)random(255), (int)random(255), (int)random(255)); 
    b.setMass(sq(b.getRadius()));
    balls.add(b);
    E += b.getKinetic() + b.getPotential();
  }
}

void checkEnergy(Ball b){
  if (b.getKinetic() + b.getPotential() > E){
    b.setSpeed(b.getVelX() / 2, b.getVelY() / 2, b.getVelZ() / 2);
  }
}
  
void checkCrash(Ball a){
  for(Ball b : balls){
    if(b != a){
       if(sqrt(sq(a.getPosX() - b.getPosX()) + sq(a.getPosY() - b.getPosY()) + sq(a.getPosZ() - b.getPosZ())) <= a.getRadius() + b.getRadius()){
         if(checkCrashList(a, b))
           calculateCrash(a, b);
       //} else {
       //  for(Ball c : a.getCrashList()){
       //     if (c == b){
       //       b.delCrash(a);
       //       a.delCrash(b);
       //       break;
       //     }
       //  }
       }
    }
  }
}

boolean checkCrashList(Ball a, Ball b){
  //for(Ball c : a.getCrashList()){
  //  if (c == b)
  //    return false;
  //}
  //b.addCrash(a);
  //a.addCrash(b);
  return true;
}

void calculateCrash(Ball a, Ball b){
  float vxa, vya, vza, vxb, vyb, vzb, vxa1, vya1, vza1, vxb1, vyb1, vzb1;
  
  vxa = (a.getMass() - b.getMass()) / (a.getMass() + b.getMass()) * a.getVelX();
  vxa1 = 2*b.getMass() / (a.getMass() + b.getMass()) * b.getVelX();
  vxa += vxa1;
  
  vxb = 2*b.getMass() / (a.getMass() + b.getMass()) * a.getVelX();
  vxb1 = (b.getMass() - a.getMass()) / (a.getMass() + b.getMass()) * b.getVelX();
  vxb += vxb1;
  
  vya = (a.getMass() - b.getMass()) / (a.getMass() + b.getMass()) * a.getVelY();
  vya1 = 2*b.getMass() / (a.getMass() + b.getMass()) * b.getVelY();
  vya += vya1;
  
  vyb = 2*b.getMass() / (a.getMass() + b.getMass()) * a.getVelY();
  vyb1 = (b.getMass() - a.getMass()) / (a.getMass() + b.getMass()) * b.getVelY();
  vyb += vyb1;
  
  vza = (a.getMass() - b.getMass()) / (a.getMass() + b.getMass()) * a.getVelZ();
  vza1 = 2*b.getMass() / (a.getMass() + b.getMass()) * b.getVelZ();
  vza += vza1;
  
  vzb = 2*b.getMass() / (a.getMass() + b.getMass()) * a.getVelZ();
  vzb1 = (b.getMass() - a.getMass()) / (a.getMass() + b.getMass()) * b.getVelZ();
  vzb += vzb1;
  
  a.setSpeed(vxa, vya, vza);
  b.setSpeed(vxb, vyb, vzb);
}
