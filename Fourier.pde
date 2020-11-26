PGraphics pg;

float step = 0.0001; //step used when calculating coefficients
int numvectors = 25;
float[][] coefficients = new float[2*numvectors + 1][];

float t = 0.0;
float playstep = 0.003; //step used when playing animation

float[] prevloc = {0.0, 0.0};

public void setup(){
  size(1000, 1000);
  background(255);
  
  for(int i = -numvectors; i <= numvectors; i++){
    println(i + ": " + findcoef(i)[0] + ", " + findcoef(i)[1]);
    coefficients[i + numvectors] = findcoef(i);
  }
  fill(255, 255, 0);
  //stroke(150);
  strokeWeight(2);
  
  pg = createGraphics(width, height);
  pg.beginDraw();
  pg.stroke(0, 0, 170);
  pg.strokeWeight(2);
  pg.background(255);
  pg.endDraw();
}

public void draw(){
  //background(255);
  image(pg, 0, 0);
  t = (t+playstep)%1.0;
  
  float[] currentloc = {0.0, 0.0};
  float[] nextloc = {0.0, 0.0};
  nextloc = coefficients[numvectors];  
  line(currentloc[0]+width/2, currentloc[1]+height/2, nextloc[0]+width/2, nextloc[1]+height/2);
  currentloc=nextloc;
  for(int i = 1; i<=numvectors; i++){
    nextloc = add(currentloc, mult(coefficients[numvectors+i], euler(i*2*PI*t)));
    line(currentloc[0]+width/2, currentloc[1]+height/2, nextloc[0]+width/2, nextloc[1]+height/2);
    currentloc=nextloc;
    nextloc = add(currentloc, mult(coefficients[numvectors-i], euler(-i*2*PI*t)));
    line(currentloc[0]+width/2, currentloc[1]+height/2, nextloc[0]+width/2, nextloc[1]+height/2);
    currentloc=nextloc;
  }
  
  circle(currentloc[0]+width/2, currentloc[1]+height/2, 7);
  
  if(frameCount > 1){
    pg.beginDraw();
    pg.line(prevloc[0]+width/2, prevloc[1]+height/2, currentloc[0]+width/2, currentloc[1]+height/2);
    pg.endDraw();
  }
  prevloc = currentloc;
}

float[] findcoef(float n){
  float[] sum = {0.0, 0.0};
  for(float i = 0.0; i < 1.0; i += step){
    float[] value = mult(f(i), euler(-n*2*PI*i));
    value[0] = value[0] * step;
    value[1] = value[1] * step;
    sum = add(sum, value);
  }
  return sum;
}

float[] f(float x){
  float[] output = {0.0, 0.0};
  
  if(x <= 0.25){
    output[0] = 200;
    output[1] = 1600*x-200;
  }
  
  else if(x<=0.5){
    output[0] = -1600*(x-0.25)+200.0;
    output[1] = 200;
  }
  
  else if(x<=0.75){
    output[0] = -200.0;
    output[1] = -1600*(x-0.5)+200;
  }
  
  else{
    output[0] = 1600*(x-0.75)-200.0;
    output[1] = -200;    
  }  
  
  
  //if(x <= 0.33){
  //  output[0] = 200;
  //  output[1] = 1212.12*x-200;
  //}
  
  //else if(x <= 0.66){
  //  output[0] = -1212.12*(x-0.33)+200;
  //  output[1] = 200;
  //}
  
  //else{
  //  output[0] = 1212.12*(x-0.66)-200;
  //  output[1] = -1212.12*(x-0.66)+200;
  //}
  
  return output;
}

float[] euler(float x){
  float[] output = {cos(x), sin(x)};
  return output;
}

float[] add(float[] a, float[] b){
  float[] output = {a[0] + b[0], a[1] + b[1]};
  return output;
}

float[] mult(float[] a, float[] b){
  float[] output = {a[0]*b[0] - a[1]*b[1], a[0]*b[1] + a[1]*b[0]};
  return output;
}
