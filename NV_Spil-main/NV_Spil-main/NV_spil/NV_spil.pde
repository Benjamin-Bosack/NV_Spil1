import de.bezier.data.sql.*;


//Spil delen

ArrayList<Integer> Q = new ArrayList<Integer>(), Z = new ArrayList<Integer>();
int w=30, h=30, blocks=20, direction=2, foodx=15, foody=15, speed = 8, fc1 = 255, fc2 = 255, fc3 = 255; 
int[]x_direction={0, 0, 1, -1}, y_direction={1, -1, 0, 0}; 
boolean DØD=false;
boolean foodEaten = false;

//Undervisnings delen

ArrayList<PImage> myPI = new ArrayList<PImage>();
ArrayList<Integer> myAnswer = new ArrayList<Integer>();
IntList shuffleList = new IntList();
boolean shuffleNow = true;
int counter = 0;
int game, score, highscore, x, y, vertical, wallx[] = new int[2], wally[] =new int[2];;
String gameState;

PImage A;
PImage B;
PImage C;
PImage D;
PImage E;
PImage F;
PImage G;
PImage H;
PImage I;
PImage J;

PImage Start;

DB myDatabase; // = new DB();

PImage forkert, korrekt;

int startHigh = 0;


void setup() {

   myDatabase = new DB();

  myDatabase.getDatabase(this);
  myDatabase.getData();


  startHigh = myDatabase.getHigh();
  
  size(1200,720);
  gameState="START";

game = 1; score = 0; highscore = 0;

  myAnswer.add(1);
  myAnswer.add(2);
  myAnswer.add(4);
  myAnswer.add(3);
  myAnswer.add(2);
  myAnswer.add(1);
  myAnswer.add(3);
  myAnswer.add(4);
  myAnswer.add(1);
  myAnswer.add(2);


  myPI.add(loadImage("A.png"));
  myPI.add(loadImage("B.png"));
  myPI.add(loadImage("C.png"));
  myPI.add(loadImage("D.png"));
  myPI.add(loadImage("E.png"));
  myPI.add(loadImage("F.png"));
  myPI.add(loadImage("G.png"));
  myPI.add(loadImage("H.png"));
  myPI.add(loadImage("I.png"));
  myPI.add(loadImage("J.png"));
  
  //hjemmeskærm=loadImage("hjemmeskærm.jpg");

  
  for (int i = 0; i< myPI.size(); i++) myPI.get(i).resize(1000,800);// shuffleList.append(i);
  for (int i = 0; i< myPI.size(); i++) shuffleList.append(i);
  
   forkert = loadImage("forkert.png");
  korrekt = loadImage("korrekt.png");
   
  //spil delen
  
  Q.add(0); 
  Z.add(15);
  
}

void draw() {

  
  if (gameState == "INNIT") {
    innitGame();
    println("init");
    
    } else if (gameState == "START") {
    startHigh = myDatabase.getHigh();
    startGame();
 //   println("start");
    
  } else if (gameState == "PLAY") {
    playGame();
    println("play");
    count = 0;
    
  } else if (gameState == "WIN") {
    winGame();
    println("win");
    //count = 0;


  } else if (gameState == "LOSE") {
    loseGame();
    println("lose");

  } else if (gameState == "prestage"){
      prestage();

  } else if (gameState == "SNAKE"){
    Snake();
    
  }

}

void innitGame(){
  imageMode(CORNER);
  game = 1; score = 0; highscore = 0; x = -200; vertical = 0; 
  fill(0,0,0);
  textSize(20); 
  gameState="START";
}


void startGame() {
  
  //image(hjemmeskærm, 0,0);
  textAlign(CENTER);
  textSize(50);
  fill(0,0,0);
  text("SNAKE", width/2, height/5);
  textSize(18);
  fill(0, 0, 0);
  text("Dit mål er at vælge de korrekte svar", width/2, height/3);
  text("NV relateret", width/2, height/2.5);
  text("Benyt tasterne 1,2,3 og 4", width/2, height/2);
  text("klik for at starte", width/2, height/1.5);
  
  text("Topscore: " + startHigh, width/2,height/1.25);
  if (mousePressed == true)
   gameState="PLAY";
  
}

void playGame() {
  background(100,100,100);
  if (shuffleNow == true) {
    shuffleList.shuffle();
    shuffleNow = false;
    
    }
    imageMode(CORNER);
  image(myPI.get(shuffleList.get(counter)), 0, 0);
  println(myAnswer.get(shuffleList.get(counter)));
  {
    if (keyPressed) {

      if((Character.getNumericValue(key)) > 0 && (Character.getNumericValue(key)) < 5){
            
        if(myAnswer.get(shuffleList.get(counter)) == (Character.getNumericValue(key))) {
          highscore = max(++score, highscore);
        gameState="WIN"; 
        }
        else gameState="LOSE";
        counter++;
    
     myDatabase.setData(1,counter);
    
      }

    }
  }
}
void winGame() {
  image(korrekt, 0,0);
  textAlign(CENTER);
  textSize(40);
  fill(0,0,0);
  text("KORREKT!", width/2, height/5);
  text("Klik for næste spørgsmål", width/2, height/1.3);
   textSize(25);
    text("Nuværende Score:"+score,200,100);
  
  if (mousePressed == true){
   gameState="PLAY";
   if(score == 1) gameState = "prestage";
  }
}


void loseGame() {
  image(forkert, 0,0);

  if (mousePressed == true)
   gameState="PLAY";
   
   textSize(25);
   fill(0,0,0);
    text("Nuværende Score: "+score,200,100);
}


void prestage(){
  // billede skal indsættes image(x,0,0);
  //flapBack.resize(width, height);
  textSize(55);
  fill(250,250,250);
  text("SNAKE", width/2, height/4.6);
   textSize(35);
   fill(250,250,250);
    text("Tilykke du har svaret korrekt", width/2, height/3);
    text("Du er nu vidre til den sjove del :)", width/2, height/2.7);
    text("Klik for at spille snake", width/2, height/2.3);
    text("GET READY!", width/2, height/1.2);
    if (keyPressed)
    if (key==' ')
   gameState="SNAKE";
}

int count =0;

void Snake(){
  
  background(0);
  fill(0, 255, 0); 
  for (int i = 0; i < Q.size(); i++) {
    rect(Q.get(i)*blocks, Z.get(i)*blocks, blocks, blocks);
    if(i + 1 == Q.size() && foodEaten == true) {
      Q.add(Q.get(i));
      Z.add(Z.get(i));
      foodEaten = false;
    }
  }
  if (!DØD) {  
    fill(fc1, fc2, fc3); 
    ellipse(foodx*blocks+10, foody*blocks+10, blocks, blocks); 
    textAlign(LEFT);
    textSize(25);
    fill(255);
    text("Score: " + Q.size(), 10, 10, width - 20, 50);
    if (frameCount%speed==0) { 
      Q.add(0, Q.get(0) + x_direction[direction]); 
      Z.add(0, Z.get(0) + y_direction[direction]);
      if (Q.get(0) < 0 || Z.get(0) < 0 || Q.get(0) >= w || Z.get(0) >= h) DØD = true; 
      
      for (int i=1; i<Q.size(); i++) if (Q.get(0)==Q.get(i)&&Z.get(0)==Z.get(i)) DØD=true; 
      
      if (Q.get(0)==foodx && Z.get(0)==foody) { 
         if (Q.size() %5==0 && speed>=2) speed-=1;  
          foodx = (int)random(0, w); 
          foody = (int)random(0, h);
          fc1 = (int)random(255); fc2 = (int)random(255); fc3 = (int)random(255); 
          foodEaten = false;
       } else { 
            Q.remove(Q.size()-1);
            Z.remove(Z.size()-1);
       }
    }
  } else {
    fill(200, 200, 0); 
    textSize(30); 
    textAlign(CENTER); 
    text("GAME OVER \n din score blev: "+ Q.size() +"\n tryk ENTER", width/2, height/3);
    if (keyCode == ENTER) { 
      Q.clear(); 
      Z.clear(); 
      Q.add(0);  
      Z.add(15);
      direction = 2;
      speed = 8;
      DØD = false;
      
      if (DØD = true) {
      gameState = "START";
      }
      
    }
  }
}
void keyPressed() { 
  int newdir=keyCode == DOWN? 0:(keyCode == UP?1:(keyCode == RIGHT?2:(keyCode == LEFT?3:-1)));
  if (newdir != -1) direction = newdir;
}

  
