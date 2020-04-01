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
  color col;
  
  Body(PVector initPos, PVector inAttractor, color c) {
    pos = initPos.copy();
    attractor = inAttractor.copy();
    acc = PVector.sub(attractor,pos).mult(0.1);
    vel = new PVector(-acc.y,acc.x);
    acc = new PVector(0,0);
    mass = random(0,10);
    col = c;
    draw();
  }
  void update(float dt) {

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
    noStroke();
    fill(col);
    ellipse(pos.x, pos.y,2,2);    
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
int num_bodies = 2000;
ArrayList<Body> bodies;

Body[] createBodies(int num_bodies, int r, int b) {
  Body[] bodies = new Body[num_bodies];
  for(int i = 0; i <  num_bodies; i++) {
    bodies[i] = new Body(randomVectorOnRadius(r),randomVectorInBox(b),color(10));
  }
  return bodies;
}

ArrayList<Body> loadBodies(String jsonFn, String colorKey) {
  JSONArray values = loadJSONArray(jsonFn);
  int num_cells = values.size();
  ArrayList<Body> bodies = new ArrayList<Body>();
  float scaleFactor = 10;
  for (int i = 0; i < values.size(); i++) {
    JSONObject cell = values.getJSONObject(i);
    color c;
    if(colorKey.equals("none")) {
      c = color(10);
    } else {    
      int cInt = Integer.parseInt(cell.getString(colorKey),16);
      c = color(red(cInt),green(cInt),blue(cInt));
    }
    bodies.add(
      new Body(
        randomVectorOnRadius(max(width,height)),
        new PVector(
          cell.getFloat("tsne_1")*scaleFactor,
          cell.getFloat("tsne_2")*scaleFactor
         ),
         c
      )
    );
    if(i == num_cells-1) { break; }
  }
  println("bodies loaded:"+values.size());
  return bodies;
}

String[] orgs = {"human","mouse"};
String org = "mouse";

String[] colorKeys = {"none","cluster_color","region_color","class_color"};
String colorKey = "none";

void setup() {
  size(1280,960);
  background(255);
  //bodies = createBodies(num_bodies,max(width,height),min(width,height)/2);
  bodies = loadBodies(org+"/processing_data.json",colorKey);
  randomSeed(0);
  noiseSeed(0);
}


float dt = 0.005;
int frames = 0;

void draw() {
  
  float num_stable = 0;

  background(255);
  translate(width/2,height/2);
  //scale(5);
  
  //stroke(10);
  //ellipse(0,0,5,5);
  
  for(Body body: bodies) {
    //println(body);
    if(body.pos == body.attractor) {
      num_stable += 1;
    } else {
      body.update(dt);
      //println(body);
    }

    body.draw();
  }
  
  saveFrame(org+"/"+colorKey+"/"+colorKey+"-####.png");
  frames += 1;
  if(num_stable == bodies.size() || frames == 1000) {
    println("done");
    exit();
  }

  //if(num_stable == num_bodies) {
  //  bodies = createBodies(num_bodies,max(width,height),min(width,height)/2);
  //}
  //delay(1000);
}
