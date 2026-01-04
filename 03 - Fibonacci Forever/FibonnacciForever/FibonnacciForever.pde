PVector center = new PVector();
PVector dimensions = new PVector();

int a = 0;
int b = 1;
int n = 0;
int newOffset = width / 2;

float imageScale = 20;

void settings() {
 size(512, 512);
}

void setup() {
  rectMode(CENTER);
  colorMode(HSB);
}

void draw() {
  background(200);
  center.x = 0;
  center.y = 0;
  dimensions.x = 0;
  dimensions.y = 1;
  a = 0;
  b = 1;
  
  imageScale = lerp(imageScale, 20 / (n + 1.0), 0.01);
 
  pushMatrix();
  translate(width / 2, height / 2);
  rotate(millis() / 2000.0);
  scale(imageScale);
  strokeWeight((n + 1.0) / 20);
  for(int i = 0; i < n; i++) {
    
    // draw square of size b
    // direction 0 = right 1 = bottom 2 = left 3 = top
    
    fill((b * 10) % 360, 80, 240);
    if (i % 4 == 0) {
      // new square's center is (center.x + dimensions.x / 2 + b/2, center.y)
      rect(center.x + (dimensions.x + b) / 2.0, center.y, b, b);
      center.x += b / 2.0;
      dimensions.x += b;
    } else if (i % 4 == 1) {
      // new square's center is (center.x, center.y + dimensions.y / 2 + b / 2)
      rect(center.x, center.y + (dimensions.y + b) / 2.0, b, b);
      center.y += b / 2.0;
      dimensions.y += b;
    } else if (i % 4 == 2) {
      // new square's center is (center.x - dimensions.x / 2 - b/2, center.y)
      rect(center.x - (dimensions.x + b) / 2.0, center.y, b, b);
      center.x -= b / 2.0;
      dimensions.x += b;
    } else if (i % 4 == 3) {
      // new square's center is (center.x, center.y - dimensions.y / 2 - b / 2)
      rect(center.x, center.y - (dimensions.y + b) / 2.0, b, b);
      center.y -= b / 2.0;
      dimensions.y += b;
    }
    
    int temp = a;
    a = b;
    b = temp + a;
  }
  
  fill((b * 10) % 360, 80, 255);
  
  if (n % 4 == 0) {
    rect(center.x + (dimensions.x + b) / 2.0 + newOffset, center.y, b, b);
  } else if (n % 4 == 1) {
    rect(center.x, center.y + (dimensions.y + b) / 2.0 + newOffset, b, b);
  } else if (n % 4 == 2) {
      rect(center.x - (dimensions.x + b) / 2.0 - newOffset, center.y, b, b);
  } else if (n % 4 == 3) {
      rect(center.x, center.y - (dimensions.y + b) / 2.0 - newOffset, b, b);
  }
  
  newOffset--;
  
  if (newOffset == 0) {
    newOffset = width / 2;
    n++;
    
    if (n == 20) {
      n = 0;
    }
  }
  
  popMatrix();
}
