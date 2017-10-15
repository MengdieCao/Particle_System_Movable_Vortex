//I wrote the music one based on this one, 
//all comments are on the music one.


//elasticity, fritction, and gravity
float cr=1;
float cf=0.3;
PVector gravity;


//array of particles (I know I was not suppose to 
//do this.) However, it does not affect the performance
//that much. And I kept getting weird bugs if I allocate
//memory first, and add to fixed size array.
ArrayList<Particle>particles;
//The array for the polygons
Plane[]planes;
//where particles come out
PVector nozzle;
//acceleration other than gravity
PVector acceleration;

float radius = 80;
float l = 200;
PVector xV ;
PVector vNorm = new PVector(0, -1, 0);

Vortex vortex;

void setup() {
  size(1280, 720, P3D);
  //use colorMode to generate different colors
  colorMode(HSB, 360, 100, 100);
  gravity=new PVector(0, 0.01, 0);
  nozzle=new PVector(120, 60, 0);


  particles=new ArrayList<Particle>();

  planes=new Plane[2];

  //planes[0]=new Plane(500, -100, 0, 6, 80, PI/2);
  //planes[1]=new Plane(200, 300, 0, 3, 80, PI/9);  
  //planes[0]=new Plane(1140, 260, 0, 6, 150, PI/2);
  //planes[1]=new Plane(880, 640, 0, 3, 150, PI/9);    

  planes[0]=new Plane(550, 195, 0, 6, 150, PI/4); //hexagon
  planes[1]=new Plane(705, 640, 0, 3, 150, PI/6); //triangle  

  //vortex=new Vortex(new PVector(920,550,20),new PVector(950,420,0),60);
}



void draw() {

  background(0);
  text(particles.size(), 20, 20);
  //translate(width/2, height/2);
  //rotateY(map(mouseX, 0, width, 0, TWO_PI));
  //rotateY(map(mouseX, 0, width, -HALF_PI, HALF_PI));


  for (Particle one : particles) {

    if (keyPressed && key == 32) {
      one.rewind();
      one.display();
    }/*else if (mousePressed){
     xV = new PVector(mouseX,mouseY,0);
     //one.update();
     one.vortex();
     one.display();
     }*/
    else {
      one.update();    
      one.display();
    }
  }

  for (int i=particles.size()-1; i>=0; i--) {
    if (particles.get(i).isDead()) {
      particles.remove(i);
    }
  }

  for (int i=0; i<15; i++) {
    particles.add(new Particle(nozzle, new PVector(random(2, 3), randomGaussian()*0.1, randomGaussian()*0.1)));
  }
  for (int i=0; i<planes.length; i++) {
    planes[i].display();
  }
  //this is the only difference between two version
  if (mousePressed) {
    vortex = new Vortex(new PVector(mouseX, mouseY, 20), new PVector(mouseX+30, mouseY -130, 0), 60);
    vortex.display();
  } else {
    vortex = null;
  }
  //saveFrame("frames/####.png");
}

void keyPressed() {
  if (key==32) {

    acceleration = new PVector(0, -0.02, 0);
  }

  if (key=='a') {
    particles.add(new Particle(nozzle, new PVector(random(2, 3), randomGaussian()*0.1, randomGaussian()*0.1)));
  }
}
