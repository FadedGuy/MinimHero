import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song; //Usada para el analisis
AudioPlayer song1;  //Usada para escuchar la musica
FFT fft;

//Spectrum frequencies
float specDeep = 0.01024;
float specLow = 0.02048;
float specLowMid = 0.04096;
float specLowHi = 0.0768;
float specMidLow = 0.1536;
float specMid = 0.3072;
float specMidHi = 0.6144;

float scoreDeep = 0;
float scoreLow = 0;
float scoreLowMid = 0;
float scoreLowHi = 0;
float scoreMidLow = 0;
float scoreMid = 0;
float scoreMidHi = 0;

int[] R = {255, 255, 255, 255, 158, 23, 1, 0};
int[] G = {234, 108, 18, 0, 0, 0, 239, 255};
int[] B = {43, 0, 0, 184, 255, 255, 255, 40};
//Keyboard touches
int[] asciiGive = {65,83,68,70,74,75,76,59}; //A, S, D, F, ,J, K ,L , ;
int[] xPos = {100, 200, 300, 400, 500, 600, 700, 800};

int[] count = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
int index = 0;
int difficulty = 30, difficultyBase = 30;

float timeInit = 0; 
boolean pas = false;
float timeDelay;
int hola=0;
boolean letPlay = true;
boolean gameStart = false;
boolean menus = true;

String score = "Score: ";
int scoreInt = 0;

qBit[] cubos;
int alante = 0, atras = 0;
String audioPlay = ""; //Current audio file
String[] songBank = {""}; //List of all audio files in the same folder

void setup(){
  minim = new Minim(this);
  //song = minim.loadFile("song.mp3", 1024);
  //song1 = minim.loadFile("song.mp3", 1024);
  
  //fft = new FFT(song.bufferSize(), song.sampleRate());
  
  cubos = new qBit[120000];
  for(int i = 0; i < 120000; i++){
    cubos[i] = new qBit(0,0,0,0,0);
  }
  
  fullScreen();
  background(0);
}

void draw(){
  timeDelay = millis()-timeInit;
  if(gameStart){
    gameOn();
  }else if(menus){
    menu();
  }else{
    cancion();
  }
  
  
}

void keyPressed(){
  if(keyCode == 32){
    if(letPlay){ 
      letPlay = false;
      song1.pause();
      song.pause();
    }
    else{
      letPlay=true;
      song1.play();
      song.play();
    }
  }
  if(keyCode == cubos[atras].ascii && (cubos[atras].yPos >= height-200 && cubos[atras].yPos <= height-80) && cubos[atras].press == true){ 
    scoreInt++;
    atras++;
  }
  else if(keyCode != cubos[atras].ascii || cubos[atras].yPos < height-200){
    scoreInt--;
    cubos[atras].press = false;
  }
}

void gameOn(){
  if(timeDelay >= 500 && pas == false){
    pas = true;
    song1.play(0);
    timeInit = millis();
  }
  if(timeDelay <= song1.length()+timeInit && letPlay == true){
    background(0);
    fft.forward(song.mix);
    
    scoreDeep = 0;  scoreLow = 0;  scoreLowMid = 0;  scoreLowHi = 0;  scoreMidLow = 0;
    scoreMid = 0;  scoreMidHi = 0;
   
    for(int i = 0; i < int(fft.specSize()*specDeep); i++){
      scoreDeep += fft.getBand(i);
    }
    for(int i = int(fft.specSize()*specDeep); i < int(fft.specSize()*specLow); i++){
      scoreLow += fft.getBand(i);
    }
    for(int i = int(fft.specSize()*specLow); i < int(fft.specSize()*specLowMid); i++){
      scoreLowMid += fft.getBand(i);
    }
    for(int i = int(fft.specSize()*specLowMid); i < int(fft.specSize()*specLowHi); i++){
      scoreLowHi += fft.getBand(i);
    }
    for(int i = int(fft.specSize()*specLowHi); i < int(fft.specSize()*specMidLow); i++){
      scoreMidLow += fft.getBand(i);
    }
    for(int i = int(fft.specSize()*specMidLow); i < int(fft.specSize()*specMid); i++){
      scoreMid += fft.getBand(i);
    }
    for(int i = int(fft.specSize()*specMid); i < int(fft.specSize()*specMidHi); i++){
      scoreMidHi += fft.getBand(i);
    }
    
    if(scoreDeep >= scoreLow && scoreDeep >= scoreLowMid && scoreDeep >= scoreLowHi &&
        scoreDeep >= scoreMidLow && scoreDeep >= scoreMid && scoreDeep >= scoreMidHi){
      count[8]++;
    }else if(scoreLow >= scoreLowMid && scoreLow >= scoreLowHi && 
              scoreLow >= scoreMidLow && scoreLow >= scoreMid && 
              scoreLow >= scoreMidHi){
      count[9]++;
    }else if(scoreLowMid >= scoreLowHi && scoreLowMid >= scoreMidLow && 
              scoreLowMid >= scoreMid && scoreLowMid >= scoreMidHi){
      count[10]++;
    }else if(scoreLowHi >= scoreMidLow && scoreLowHi >= scoreMid && 
            scoreLowHi >= scoreMidHi){
      count[11]++;
    }else if(scoreMidLow >= scoreMid && 
            scoreMidLow >= scoreMidHi){
      count[12]++;
    }else if(scoreMid >= scoreMidHi){
      count[13]++;
    }else if(scoreMidHi > scoreDeep){
      count[14]++;
    }
    else{
      count[15]++;
    }
    
  /////////////////////////////////////////////////////////
  
    noStroke(); 
    fill(50);
    rect(0,height-200,1200,120);
    
    difficulty =   int(random(difficultyBase-10, difficultyBase+10));
    if(index >= difficulty){
      int hola = 0;
      for(int i = 8; i <= 15; i++){
        if(hola < count[i]){
          hola = count[i];
        }
      }
      for(int i = 8; i <= 15; i++){
        if(hola == count[i]){
          count[i] = 0;
          cubos[alante++] = new qBit(xPos[i-8], R[i-8], G[i-8], B[i-8], asciiGive[i-8]);
        }
        else{
          count[i] = 0;
        }
        
      }
      index = 0;
    }
    index++;
    
    for(int i = atras; i < alante; i++){ 
      cubos[i].yPos += height/70;
      
      fill(cubos[i].red, cubos[i].green, cubos[i].blue);
      rect(cubos[i].xPos, cubos[i].yPos, 50, 50);
      fill(255);
      text(char(cubos[i].ascii), cubos[i].xPos, cubos[i].yPos);
  
      if(cubos[i].yPos > height + 50){
        atras++;
        scoreInt--;
      }
    }
   
    fill(255);
    textSize(24);
    text(score + scoreInt, 1200,50);
  }
  else if(!letPlay && timeDelay <= song1.length()+timeInit){
    noStroke();
    fill(255,1);
    rect(0,0, width, height);
    song.pause();
    song1.pause();
    fill(0,0,0);
    textSize(45);
    text("PAUSA", width/2,height/2);
  }
  else{
    background(220);
    song.pause();
    song1.pause();
    float posicionX = 0, posicionY = 0;
    for(int i = 0; i < alante; i++){
      fill(cubos[i].red, cubos[i].green, cubos[i].blue);
      rect(posicionX, posicionY, 10,10);
      posicionX+=11;
      if(posicionX > width-10){
        posicionY += 11;
        posicionX = 0;
      }
    }
    fill(0);
    textSize(24);
    text("Presiona ESC para salir", 200, height-50);
    
  }
}

void menu(){
  background(0);
  
  fill(255);
  textSize(72);
  text("Bienvenidos a Doc Tops", 300,75);

  textSize(32);
  text("Cancion Seleccionada: " + audioPlay, 300,120);
  
  rect(300,200,700,200);
  fill(0);
  textSize(48);
  text("Jugar", 300,250);
  
  fill(255);
  rect(300,500,700,200);
  fill(0);
  textSize(48);
  text("Cambio de Cancion", 300,550);
}

void cancion(){
  background(0);
  fill(255);
  textSize(32);
  text("Presiona la tecla de la cancion que quieras", 50, 30);
  int y = 70;
  
  textSize(24);
  for(int i = 0; i < 10; i++){
    text(i + ". " + songBank[i], 50, y);
    y += 30;
  }
  
  if(keyPressed){
    audioPlay = songBank[int(key) - 48];
    menus = true;
  }
}

void mouseClicked(){
  if((mouseX >= 300 && mouseX <= 1000) && (mouseY >= 200 && mouseY <= 400) && menus){
    song = minim.loadFile(audioPlay, 1024);
    song1 = minim.loadFile(audioPlay, 1024);
  
    fft = new FFT(song.bufferSize(), song.sampleRate());
    
    song.play(0);
    song.mute();
    scoreInt = 0;
    
    background(0);
    gameStart = true;
    pas = false;
  }else if((mouseX >= 300 && mouseX <= 1000) && (mouseY >= 500 && mouseY <= 700) && menus){
    menus = false;
  }
}

class qBit{
  float xPos, yPos;
  int red, green, blue;
  int ascii;
  boolean press;
  
  qBit(float x, int r, int g, int b, int asqui){
    xPos = x;
    yPos = -20;
    red = r;
    green = g;
    blue = b;
    ascii = asqui;
    press = true;
  }
}
