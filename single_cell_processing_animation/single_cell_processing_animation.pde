int sign(float x) {
  return x >= 0? 1 : -1; 
}

void arrow(PVector p1, PVector p2) {
  float x1 = p1.x;
  float y1 = p1.y;
  float x2 = p2.x;
  float y2 = p2.y;
  
  line(x1, y1, x2, y2);
  pushMatrix();
  translate(x2, y2);
  float a = atan2(x1-x2, y2-y1);
  rotate(a);
  line(0, 0, -5, -5);
  line(0, 0, 5, -5);
  popMatrix();
} 

class Body {
  PVector pos;
  PVector attractor;
  PVector vel;
  PVector acc;
  float mass;
  float init_vel = 100;
  
  Body(PVector initPos, PVector inAttractor) {
    pos = initPos.copy();
    attractor = inAttractor.copy();
    acc = PVector.sub(attractor,pos).mult(0.1);
    vel = new PVector(-acc.y,acc.x);
    acc = new PVector(0,0);
    mass = random(0,10);
    draw();
  }
  float r = 0.0001; //r is a combination of density, cross section area, and coefficient
  void update(float dt) {

    // acceleration from attractor
    // linear
    float d = attractor.dist(pos);
    acc = PVector.sub(attractor,pos).div(mass).mult(dt).limit(100);

    
    vel.add(acc).limit(10).mult(0.95).add(random(0,1)*0.0001,random(0,1)*0.0001);
    pos.add(vel);
    
    if(d<1) {
      pos = attractor;
      acc.set(0,0);
      vel.set(0,0);
    }
  }
  
  String toString() {
    return "("+pos.toString()+","+attractor.toString()+","+vel+","+acc+")";
  }
  
  void draw() {  
    stroke(255);
    ellipse(pos.x, pos.y,1,1);    
    //arrow(pos,PVector.add(pos,vel.copy().setMag(10)));
  }
}

PVector randomVectorInBox(float bound) {
   return new PVector(random(-bound,bound),random(-bound,bound));
}
PVector randomVectorOnRadius(float r) {
 float theta = random(0,2*PI);
 return new PVector(r*sin(theta),r*cos(theta));
}
Body body = null;
int num_bodies = 23000;
Body[] bodies;

Body[] createBodies(int num_bodies) {
  Body[] bodies = new Body[num_bodies];
  for(int i = 0; i <  num_bodies; i++) {
    bodies[i] = new Body(randomVectorOnRadius(1500),randomVectorInBox(500));
  }
  return bodies;
}

void setup() {
  size(1920,1440);
  background(0);
  bodies = createBodies(num_bodies);
  randomSeed(0);
  noiseSeed(0);
}


float dt = 0.005;

void draw() {

  float num_stable = 0;

  background(0);
  translate(width/2,height/2);
  stroke(255);
  ellipse(0,0,5,5);
  
  for(Body body: bodies) {
    //println(body);
    if(body.pos == body.attractor) {
      num_stable += 1;
    } else {
      body.update(dt);
    }
    body.draw();
  }
  
  if(num_stable == num_bodies) {
    bodies = createBodies(num_bodies);
  }
  //delay(1000);
}
