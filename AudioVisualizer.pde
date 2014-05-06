import java.awt.event.KeyEvent;
import java.awt.event.MouseWheelEvent;
import java.awt.event.MouseWheelListener;

boolean[] keys = new boolean[526];
Maxim maxim;
AudioPlayer player;
float t = 0;
float c1 = 90;
float c2 = 90;
float c3 = 90;
float camZ;
float posX, posY;

void setup(){
  size(800, 800, P3D);
  camZ = height/2 / tan(PI/12);
  addMouseWheelListener(new MouseWheelListener() {
    public void mouseWheelMoved(MouseWheelEvent mwe) {
      mouseWheel(mwe.getWheelRotation());
    }});  
  maxim = new Maxim(this);
  player = maxim.loadFile("Throwing Fire.wav");
  player.setLooping(false);
  player.setAnalysing(true);
  player.cue(0);
  player.play();
  frameRate(20);
  smooth();
}

void draw(){
  background(0);
  strokeWeight(1);
  stroke(70, 70, 70, 70);
  pushMatrix();
  translate(width/2, height/2, (float) Math.sqrt(width/2*width/2+height/2*height/2));
  pointLight(255, 255, 255, 0, 0, 0);
  line(-width, 0, 0, width, 0, 0);
  line(0, -width, 0, 0, width, 0);
  line(0, 0, -width, 0, 0, width);
  popMatrix();  
  if(mousePressed)
    camera((posX - width/2) * 5, (posY - height/2) * 5, camZ, width/2 + (mouseX-posX), height/2 + (mouseY-posY), (float) Math.sqrt(width/2*width/2+height/2*height/2), 0, 1, 0);
  else{
    camera((mouseX - width/2) * 5, (mouseY - height/2) * 5, camZ, width/2, height/2, (float) Math.sqrt(width/2*width/2+height/2*height/2), 0, 1, 0);
    posX = mouseX;
    posY = mouseY;
  }
  if(t == 360)
      t = 0;
  c1 += 11 * (checkKey("W") ? 1 : 0);
  c1 -= 11 * (checkKey("S") ? 1 : 0);
  c2 += 11 * (checkKey("D") ? 1 : 0);
  c2 -= 11 * (checkKey("A") ? 1 : 0);
  c3 += 11 * (checkKey("E") ? 1 : 0);
  c3 -= 11 * (checkKey("Q") ? 1 : 0);
  c1 %= 360;
  c2 %= 360;
  c3 %= 360;
  if(checkKey("Space")){
    c1 = 90;
    c2 = 90;
    c3 = 90;
  }
  if(checkKey("Z"))
    c1 = 90;
  if(checkKey("X"))
    c2 = 90;
  if(checkKey("C"))
    c3 = 90;
  t += 0.5;
  float pow = player.getAveragePower();
  float[] spectrum = player.getPowerSpectrum();
  for(int i = 0; i < spectrum.length; i++){
    float a = map(spectrum[i], 0, 1, 0, 255)*2;
    float r = map(i, 0, spectrum.length, 0, 255);
    float g = map((float) Math.sin(radians(map(i, 0, spectrum.length, 0, 360))), 0, 1, 0, 255);
    float b = map((float) Math.cos(radians(map(i, 0, spectrum.length, 0, 360))), 0, 1, 0, 255);
    colorMode(RGB);
    stroke(r, g, b, a);
    noFill();
    pushMatrix();
    translate(width/2, height/2, (float) Math.sqrt(width/2*width/2+height/2*height/2));
    rotateX(radians(c1*i+t));
    rotateY(radians(c2*i+t));    
    rotateZ(radians(c3*i+t));
    translate(map(spectrum[i]*pow*pow*pow, 0, 1, 0, 40*width), 0, 0);
    strokeWeight((float) Math.pow(spectrum[i],0.5)*width/125);
    point(0,0,0);
    popMatrix();
  }
  saveFrame("frames/####.tif");
}

void mouseWheel(int delta) {
  if(delta < 0 ? camZ > (height/2) / tan(PI/4) : true)
    camZ += delta * 150;
}

boolean checkKey(String k)
{
  for(int i = 0; i < keys.length; i++)
    if(KeyEvent.getKeyText(i).toLowerCase().equals(k.toLowerCase())) return keys[i];  
  return false;
}

void keyPressed()
{ 
  keys[keyCode] = true;
  println(KeyEvent.getKeyText(keyCode));
}

void keyReleased()
{ 
  keys[keyCode] = false; 
}
