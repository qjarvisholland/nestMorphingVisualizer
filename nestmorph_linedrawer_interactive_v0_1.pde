//


// interact via MOUSE POSITION , MOUSE CLICK TO CHANGE COLOR , UP KEY (it's buggy) to add vectors, down key to remove vectors
float maxRadious = 200;
float minVel = 0.5;
float maxVel = 1.0;

ArrayList<Particle> particles;
;

color[] colors = 
  { 
  #dd89b3, 
  #19b4a0, 
  #61e1e1, 
  #c9c96b, 
  #7c90d6, 
  #aeeaea, 
  #bada55, 
  #6dbb47, 
  #0497cb, 
  #add2c9, 
  #9BBDA4, 
  #999999, 
  #a9347e, 
  #9c1b2c, 
  #FF007C, 
  #f59563, 
  #fff8dc, 
};

color smoothColor;
color colorPick;
color prevColorPick;
float prevSaturation;

void setup() {
  smooth();
  // size(500, 500, P2D);
  size(1400, 900, P2D);
  frameRate(30);

  colorMode(RGB);
  blendMode(BLEND);

  particles = new ArrayList<Particle>();
  for (int i = 0; i < 5; i++) {
    particles.add(new Particle());
  }
}

void keyPressed() {

  if (keyCode == UP) {
    particles.add(new Particle());
  }




  //     for (int i = particles.size(); i >= 1; i--) {


  if  (keyCode == DOWN) {
    if (particles.size() > 2) {
      particles.remove(1);
    }
  }

  //  }
}

void mousePressed() {

  //                if (mousePressed == true) {
  colorPick = colors[int(random(0, 16))];
  //   }
}




void draw() {
  blendMode(BLEND);

  //fading out timer
  if (frameCount % 100 == 0) {
    fill(200, 1);
    rect(0, 0, width, height);
  }


  // timer added particles
  if (frameCount % 200 == 0) {
  colorPick = colors[int(random(0, 16))];
    }









  smoothColor = lerpColor(prevColorPick, colorPick, 0.01);

  fill(smoothColor, 10 );
  prevColorPick = smoothColor;
  translate(width / 2, height / 2);
  scale(3, 2.6);

  for (int i = 0; i < particles.size() - 1; i++) {
    Particle p1 = particles.get(i);
    for (int j = i + 1; j < particles.size(); j++) {
      Particle p2 = particles.get(j);
      Particle p3 = particles.get(int(i/j));
      float saturation = 0.5 * lerp((p1.saturation + p2.saturation) / 2.0, prevSaturation, 0.01);
      stroke(0, saturation, 85, 5);
      prevSaturation = saturation;
      blendMode(ADD);
      stroke(smoothColor, 1);

      line(p3.pos.x / sin(j), p3.pos.y / cos(j), p2.pos.x, p2.pos.y);

      stroke(0, saturation, 85, 5);
      blendMode(BLEND);
      curve((p1.pos.x), sin(p1.pos.y), p2.pos.x, p2.pos.y, p3.pos.x, p3.pos.y, 100*(mouseX/width)*sin(p3.pos.x), 100*(mouseY/height)*sin(p1.pos.y));
      //       curve((mouseX), mouseY, p2.pos.x, p2.pos.y, p3.pos.x , p3.pos.y , 10*sin(p3.pos.x), 10*sin(p1.pos.y));
    }
    //   -(mouseY/height)    - (mouseX/width)
  }


  for (int i = 3; i < particles.size() - 1; i++) {
    Particle p3 = particles.get(i);
    for (int j = i + 4; j < particles.size(); j++) {
      blendMode(BLEND);
      Particle p4 = particles.get(j);
      Particle p5 = particles.get(int(i/j));
      float saturation = lerp((p4.saturation + p5.saturation) / 2.0, prevSaturation, 0.01);
      stroke(0, saturation, 85, saturation);
      prevSaturation = saturation;
      line(p3.pos.x / sin(j), p3.pos.y / cos(j), p4.pos.x, p4.pos.y);
      //  scale(1.04);
      pushMatrix();
      //blendMode(LIGHTEST);
      scale(0.3);
      fill(smoothColor, 1);
      //translate(-width/2,-height/2);
      translate(p3.pos.x, p3.pos.x);
      curve(p3.pos.x, (p3.pos.y), (p4.pos.x), p4.pos.x, p3.pos.x / cos(p4.pos.x), cos(p4.pos.y), (p5.pos.x), (p5.pos.y));
      rotate(100);
      popMatrix();
      curve((mouseX), mouseY, p4.pos.x, p4.pos.y, p3.pos.x, p3.pos.y, (p5.pos.x), (p5.pos.y));
      // scale(1);
    }
  }




  for (Particle p : particles) {
    p.update();
  }
}

class Particle {

  PVector pos, vel;
  float saturation;

  Particle() {
    float posAng = random(TWO_PI);
    float posSize = random(maxRadious);
    pos = new PVector(posSize * cos(posAng), posSize * sin(posAng));
    float velAng = random(TWO_PI);
    float velSize = random(minVel, maxVel);
    vel = new PVector(velSize * cos(velAng), velSize * sin(velAng));
    saturation = random(85);
  }
  int limitCounter;
  void update() {

    pos.add(vel);
    if (pos.mag() > maxRadious) {
      limitCounter++;





      pos.limit(maxRadious);
      float posAng = atan2(pos.y, pos.x);
      float velAng = atan2(vel.y, vel.x);
      float velSize = vel.mag();
      vel.x = velSize * cos(2 * posAng - velAng - PI);
      vel.y = velSize * sin(2 * posAng - velAng - PI);
    }
  }
}
