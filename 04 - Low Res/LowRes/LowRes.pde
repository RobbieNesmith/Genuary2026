void settings() {
  size(280, 160);
  noSmooth();
}

void setup() {
  noLoop();
}

void draw() {
  background(0);
  
  int[] bayer = {0, 8, 2, 10, 12, 4, 14, 6, 3, 11, 1, 9, 15, 7, 13, 5};
  
  PVector lightVector = PVector.random3D();
  
  float ambient = 1.0 / 16.0;
  
  float ringXScale = width / 3;
  float ringYScale = height / 8;
  
  // Draw back of ring
  for (int scaleAdd = 0; scaleAdd < 16; scaleAdd += 2) {
  drawRing(PI, TWO_PI, PI / 32, ringXScale - scaleAdd, ringYScale - scaleAdd / 2);
  }

  // Draw planet
  
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      
      float scaledX = (float)(x - width / 2) / (height / 4);
      float scaledY = (float)(y - height / 2) / (height / 4);
      
      if (scaledX * scaledX + scaledY * scaledY < 1) {
        float z = 1 - (scaledX * scaledX + scaledY * scaledY);
        
        float dot = max(lightVector.x * scaledX + lightVector.y * scaledY + lightVector.z * z, 0);
        
        int xMod = x % 4;
        int yMod = y % 4;
        
        if ((dot + ambient) * 16 > bayer[xMod + yMod * 4]) {
          stroke(255);
        } else {
          stroke(0);
        }
      
      point(x,y);
      }
    }
  }

  // Draw front of ring
  
  for (int scaleAdd = 0; scaleAdd < 16; scaleAdd += 2) {
    drawRing(0, PI, PI / 32, ringXScale - scaleAdd, ringYScale - scaleAdd / 2);
  }
  
}

void mousePressed() {
  redraw();
}


void drawRing(float startAngle, float endAngle, float step, float xScale, float yScale) {
  for (float angle = startAngle; angle < endAngle; angle += step) {
    float lastAngle = angle - step;
    PVector lastPos = new PVector(cos(lastAngle) * xScale + width / 2, sin(lastAngle) * yScale + height / 2);
    PVector pos = new PVector(cos(angle) * xScale + width / 2, sin(angle) * yScale + height / 2);
    stroke(255);
    line(lastPos.x, lastPos.y, pos.x, pos.y);
  }
}
