class Ball{
  
  float r;
  PVector velocity;
  PVector position;
  PVector acceleration;
  float m;
  float shape;
  int point;
  int clrMode;
  int clr;
  int red;
  int green;
  int blue;
  ArrayList<Ball> crashList;
  
  boolean gravity;
  float g;
  
  Ball(float r, float xpos, float ypos, float zpos){
    this.position = new PVector(xpos, ypos, zpos);
    this.r = r;
    this.velocity = new PVector(0, 0, 0);   
    m = 5;
    shape = 2;
    point = 0;
    clr = 255;
    red = 0;
    green = 0;
    blue = 0;
    clrMode = 0;
    
    gravity = false;
    g = 0;
    
    crashList = new ArrayList<Ball>(0);
  }
  
  void display(){
    //getColor();
    
    //float mapX = map(position.x, 0, width, 0, 255);
    //float mapY = map(position.y, 0, height, 0, 255);
    //float mapZ = map(position.z, 0, width, 0, 255);
    //fill(mapX, mapY, mapZ);
    
    fill(255);
    
    pushMatrix();
    translate(position.x, position.y, position.z);
    lights();
    noStroke();
    sphere(r);
    popMatrix();
    
    //for (int i = 0; i < point; i++){
    //  PVector v = getVector(i);
    //  fill(255);
    //  ellipse(v.x, v.y, r/16, r/16);
    //  PVector a = getVector(i);
    //  PVector b = getVector(i * shape);
    //  stroke(255);
    //  line(a.x, a.y, b.x, b.y);
    //}
  }
  
  void update(){
    if(position.x >= width - r || position.x <= r){
      velocity.x = -velocity.x;
    }
    if(position.z >= width - r || position.z <= r){
      velocity.z = -velocity.z;
    }
    if(position.y >= height - r || position.y <= r){
      velocity.y = -velocity.y - g;
    }
    if(gravity){
      float tmp = velocity.y;
      velocity.y += g;
      if(tmp * velocity.y < 0){
        velocity.y = 0;
      }
    } 
    position.x += velocity.x;
    if(position.x > width - r){
      position.x = width - r;
    } else if (position.x < r){
      position.x = r;
    }
    position.y += velocity.y;
    if(position.y > height - r){
      position.y = height - r;
    } else if (position.y < r){
      position.y = r;
    } 
    position.z += velocity.z;
    if(position.z > width - r){
      position.z = width - r;
    } else if (position.z < r){
      position.z = r;
    }
  } 
 
  PVector getVector(float index){
    float angle = map(index % point, 0, point, 0, TWO_PI);
    angle += PI;
    float x = r * cos(angle);
    float y = r * sin(angle);
    PVector v = new PVector(position.x + x, position.y + y);
    return v;
  }
 
  void setPoint(int point){
    this.point = point;
  }
  
  int getPoint(){
    return point;
  }
  
  void setShape(float shape){
    this.shape = shape;
  }
  
  float getShape(){
    return shape;
  }
 
  void setColor(int clr){
    this.clr = clr;
    this.clrMode = 0;
  }
  
  void setColor(int red, int green, int blue){
    this.red = red;
    this.green = green;
    this.blue = blue;
    this.clrMode = 1;
  }
  
  void getColor(){
    if(this.clrMode == 0){
      fill(clr);
    } else {
      fill(red, green, blue);
    }
  }
  
  void addCrash(Ball b){
    crashList.add(b);
  }
  
  void delCrash(Ball b){
    crashList.remove(b);
  }
  
  ArrayList<Ball> getCrashList(){
    return crashList;
  }
  
  float getKinetic(){
    return getMass() * ( sq(getVelX()) + sq(getVelY()) + sq(getVelZ()) ) / 2;
  }
  
  float getPotential(){
    return getMass() * g * (height - position.y);
  }
  
  float getVelX(){
    return velocity.x;
  }
  
  float getVelY(){
    return velocity.y;
  }
  
  float getVelZ(){
    return velocity.z;
  }
  
  float getPosX(){
    return position.x;
  }
  
  float getPosY(){
    return position.y;
  }
  
  float getPosZ(){
    return position.z;
  }
  
  void setPosX(float p){
    this.position.x = p;
  }
  
  void setPosY(float p){
    this.position.y = p;
  }
  
  void setPosZ(float p){
    this.position.z = p;
  }
  
  float getRadius(){
    return r;
  }
  
  void setGravity(boolean c){
    gravity = c;
  }
  
  void setGravity(boolean c, float g){
    gravity = c;
    this.g = g;
  }
  
  void setSpeed(float vx, float vy, float vz){
    this.velocity.x = vx;
    this.velocity.y = vy;
    this.velocity.z = vz;
  }
  
  void setMass(float m){
    this.m = m;
  }
  
  float getMass(){
    return m;
  }
  
}
