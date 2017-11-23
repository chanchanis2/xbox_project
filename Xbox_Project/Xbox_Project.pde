import net.java.games.input.*;
import org.gamecontrolplus.*;
import org.gamecontrolplus.gui.*;
import g4p_controls.*;
import processing.sound.*;
SoundFile song;
ControlIO control;
Configuration config;
ControlDevice gpad;
PVector pos = new PVector(400, 400);
int Count = 100;
int Color = 0;
float [] Xs = new float [Count];
float [] Ys = new float [Count];
float [] YSpeed = new float [Count];
float x;
float Player;
int Score;
float Time;
boolean isGameOver = false;

void setup()
{
  noStroke();
  colorMode(HSB);
  textAlign(CENTER);
  size(800, 800);
  control = ControlIO.getInstance(this);
  gpad = control.getMatchedDevice("XBOX CONFIGURATION");
  if (gpad == null) {
    println("No suitable device configured");
    System.exit(-1); // End the program NOW!
  }
  for (int i=0; i<Count; i++)
  {
    Xs[i] = random(width);
    Ys[i] = random(-1000, 0);
    YSpeed[i] = random(3, 4);
  }
   song = new SoundFile(this, "Forever Bound - Stereo Madness.mp3");
  song.play();
}




void GamePad()
{
  float Speed = 3;
  float RT = gpad.getSlider("RT").getValue();
  float LT = gpad.getSlider("LT").getValue();
  float LSY = gpad.getSlider("LSY").getValue();
  float LSX = gpad.getSlider("LSX").getValue();
  boolean A = gpad.getButton("A").pressed();
  boolean B = gpad.getButton("B").pressed();


  if (A)
  {
    background(0);
  }
  println(LSY);

  pos.y += LSY*Speed;
  pos.x += LSX*Speed;

  if (RT>.5)
  {
    Player+=2;
    Player+=2;
  }

  if (LT>.5)
  {
    Player-=2;
    Player-=2;
  }

  if (Player<1)
  {
    Player = 11;
  }
}

void draw()
{
  if (isGameOver == false)
  {
    background(0);
    loadRects();
    GamePad();
    ellipse(pos.x, pos.y, Player, Player);
    if (millis() - Time > 1000)
    {
      Time = millis();
      Score = Score + (int)Player;
    }
    
    
  } 
  else
  {
    GameOver();
  }
  text(Score, 100, 100);
}




void loadRects()
{
  for (int i=0; i<Count; i++)
  {
    fill(Color, 255, 255);
    ellipse(Xs[i], Ys[i], 15, 15);
   
    Ys[i]+= YSpeed[i];

    if (Ys[i]>height)
    {
      Ys[i]=0;
    }
    Color++;
    if (Color > 255)
    {
      Color=0;
    }  
    if (dist(Xs[i], Ys[i], pos.x, pos.y) < 7.5 + Player/2)
    {
      isGameOver = true;
    }
  }
}
void GameOver()
{
  background(255);
  textSize(100);
  text("GAME OVER", width/2, height/2);
  textSize(60);
  text("Press A to restart", width/2, height/2 + 100);


  if (gpad.getButton("A").pressed())
  {
    isGameOver = false;
    Player = 11;
    for (int i=0; i<Count; i++)
    {
      Xs[i] = random(width);
      Ys[i] = random(-1000, 0);
      Score = 0;
    }
  }
}