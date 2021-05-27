class Globe {
  PShape shape;
  float xRot = radians(-30);
  float yRot = radians(30);
  boolean paused = false;

  public Globe(PImage texture) {
    shape = createShape(SPHERE, earthRadius); 
    shape.setStroke(false);
    shape.setFill(false);
    shape.setTexture(texture);
  }

  public void display() {
    if (!paused) yRot = (yRot + PI/500) % TWO_PI;

    pushMatrix();

    scale(scaleFactor, scaleFactor, scaleFactor);
    noStroke();
    fill(0, 0, 255);
    box(100, earthRadius*2.5, 100); // axis
    shape(this.shape); // globe

    popMatrix();
  }

  public void rotateX(float y0, float y1) {
    xRot += (y1-y0)*PI/180;
  }

  public void rotateY(float x0, float x1) {
    yRot += (x1-x0)*PI/180;
  }

  public float xRotation() {
    return xRot;
  }

  public float yRotation() {
    return yRot;
  }

  public void togglePause() {
    paused = !paused;
  }
}
