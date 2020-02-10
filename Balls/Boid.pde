class Boid{
  
  PVector position, velocity, acceleration;
  float maxSpeed = 20;
  float speed = 20;
  float perceptionRadius = 150;
  float force = 0.3;
  
  Boid(){
    this.position = new PVector(random(width), random(height), random(width));
    this.velocity = new PVector(random(2*speed) - speed, random(2*speed) - speed, random(2*speed) - speed);
    this.acceleration = new PVector();
    this.acceleration.mult(0);
  }
  
  Boid(float x, float y, float z){
    this.position = new PVector(x, y, z);
    this.velocity = new PVector(random(2*speed) - speed, random(2*speed) - speed, random(2*speed) - speed);
    this.acceleration = new PVector();
    this.acceleration.mult(0);
  }
  
  void flock(ArrayList<Boid> list, ArrayList<Ball> list2){
    acceleration.mult(0);
    
    acceleration.add(separationWalls());
    
    acceleration.add(separationBalls(list2));
    acceleration.add(cohesionBalls(list2));
    acceleration.add(alignmentBalls(list2));
    
    acceleration.add(separation(list));
    acceleration.add(cohesion(list));
    acceleration.add(alignment(list));
  }
  
  void update(ArrayList<Boid> list, ArrayList<Ball> list2){
    flock(list, list2);
    
    //velocity.add(new PVector(0, 0.3 / sq(1000)));
    velocity.add(acceleration);
    position.add(velocity);
    
    if(position.x > width){
      velocity.x *= -1;
      position.x = width -10;
    }
    if(position.x < 0){
      velocity.x *= -1;
      position.x = 10;
    }
    if(position.y > height){
      velocity.y *= -1;
      position.y = height -10;
    }
    if(position.y < 0){
      velocity.y *= -1;
      position.y = 10;
    }
    if(position.z > width){
      velocity.z *= -1;
      position.z = width -10;
    }
    if(position.z < 0){
      velocity.z *= -1;
      position.z = 10;
    }
  }

  void display(){
    float mapX = map(position.x, 0, width, 0, 255);
    float mapY = map(position.y, 0, height, 0, 255);
    float mapZ = map(position.z, 0, width, 0, 255);
    fill(mapX, mapY, mapZ);
    
    pushMatrix();
    translate(position.x, position.y, position.z);
    lights();
    noStroke();
    sphere(10);
    popMatrix();
  }
  
  PVector separationWalls(){
    int count = 0;
    PVector avg = new PVector();
    avg.mult(0);
    
    PVector d0 = new PVector(position.x, position.y, 0);
    if(position.dist(d0) < perceptionRadius){
        PVector dummy = new PVector(position.x, position.y, position.z);
        avg.add(dummy.sub(d0));
        avg.div(sqrt(sqrt(position.dist(d0))));
        count++;
      }
    PVector d1 = new PVector(position.x, position.y, width);
    if(position.dist(d1) < perceptionRadius){
        PVector dummy = new PVector(position.x, position.y, position.z);
        avg.add(dummy.sub(d1));
        avg.div(sqrt(sqrt(position.dist(d1))));
        count++;
      }
    PVector d2 = new PVector(position.x, 0, position.z);
    if(position.dist(d2) < perceptionRadius){
        PVector dummy = new PVector(position.x, position.y, position.z);
        avg.add(dummy.sub(d2));
        avg.div(sqrt(sqrt(position.dist(d2))));
        count++;
      }
    PVector d3 = new PVector(position.x, height, position.z);
    if(position.dist(d3) < perceptionRadius){
        PVector dummy = new PVector(position.x, position.y, position.z);
        avg.add(dummy.sub(d3));
        avg.div(sqrt(sqrt(position.dist(d3))));
        count++;
      }
    PVector d4 = new PVector(0, position.y, position.z);
    if(position.dist(d4) < perceptionRadius){
        PVector dummy = new PVector(position.x, position.y, position.z);
        avg.add(dummy.sub(d4));
        avg.div(sqrt(sqrt(position.dist(d4))));
        count++;
      }
    PVector d5 = new PVector(width, position.y, position.z); 
    if(position.dist(d5) < perceptionRadius){
        PVector dummy = new PVector(position.x, position.y, position.z);
        avg.add(dummy.sub(d5));
        avg.div(sqrt(sqrt(position.dist(d5))));
        count++;
      }
    
    if(count != 0){
      avg.div(count);
      avg.setMag(this.maxSpeed * 2);
      avg.sub(this.velocity);
      avg.limit(this.force * 3);
    }
    return avg;
    
  }
  
  PVector separationBalls(ArrayList<Ball> list){
    int count = 0;
    PVector avg = new PVector();
    avg.mult(0);
    for(Ball b : list){
      PVector d = new PVector(b.getPosX(), b.getPosY(), b.getPosZ());
      if(position.dist(d) < perceptionRadius + b.getRadius()){
        PVector dummy = new PVector(position.x, position.y, position.z);
        avg.add(dummy.sub(d));
        avg.div(sqrt(position.dist(d)));
        count++;
      }
    }
    if(count != 0){
      avg.div(count);
      avg.setMag(this.maxSpeed * 2);
      avg.sub(this.velocity);
      avg.limit(this.force * 10);
    }
    return avg;
    
  }
  
  PVector cohesionBalls(ArrayList<Ball> list){
    int count = 0;
    PVector avg = new PVector();
    avg.mult(0);
    for(Ball b : list){
      PVector d = new PVector(b.getPosX(), b.getPosY(), b.getPosZ());
      if(position.dist(d) < perceptionRadius + b.getRadius()){
        avg.add(d);
        count++;
      }
    }
    if(count != 0){
      avg.div(count);
      avg.sub(this.position);
      avg.setMag(this.maxSpeed);
      avg.sub(this.velocity);
      avg.limit(this.force * 2);
    }
    return avg;
    
  }
  
  PVector alignmentBalls(ArrayList<Ball> list){
    int count = 0;
    PVector avg = new PVector();
    avg.mult(0);
    for(Ball b : list){
      PVector d = new PVector(b.getVelX(), b.getVelY(), b.getVelZ());
      if(position.dist(d) < perceptionRadius + b.getRadius()){
        avg.add(d);
        count++;
      }
    }
    if(count != 0){
      avg.div(count);
      avg.setMag(this.maxSpeed);
      avg.sub(this.velocity);
      avg.limit(this.force * 2);
    }
    return avg;
  }
  
  PVector alignment(ArrayList<Boid> list){
    int count = 0;
    PVector avg = new PVector();
    avg.mult(0);
    for(Boid b : list){
      if(position.dist(b.position) < perceptionRadius && b != this){
        avg.add(b.velocity);
        count++;
      }
    }
    if(count != 0){
      avg.div(count);
      avg.setMag(this.maxSpeed);
      avg.sub(this.velocity);
      avg.limit(this.force);
    }
    return avg;
  }
  
  PVector cohesion(ArrayList<Boid> list){
    int count = 0;
    PVector avg = new PVector();
    avg.mult(0);
    for(Boid b : list){
      if(position.dist(b.position) < perceptionRadius && b != this){
        avg.add(b.position);
        count++;
      }
    }
    if(count != 0){
      avg.div(count);
      avg.sub(this.position);
      avg.setMag(this.maxSpeed);
      avg.sub(this.velocity);
      avg.limit(this.force);
    }
    return avg;
  }
  
  PVector separation(ArrayList<Boid> list){
    int count = 0;
    PVector avg = new PVector();
    avg.mult(0);
    for(Boid b : list){
      if(position.dist(b.position) < perceptionRadius && b != this){
        PVector dummy = new PVector(position.x, position.y, position.z);
        avg.add(dummy.sub(b.position));
        avg.div(sq(position.dist(b.position)));
        count++;
      }
    }
    if(count != 0){
      avg.div(count);
      avg.setMag(this.maxSpeed);
      avg.sub(this.velocity);
      avg.limit(this.force);
    }
    return avg;
  }
  
}
