class Star {
  float x, y, vx, vy;
  float radius, alpha;

  public Star () {
    this.x = random(1);
    this.y = random(1);
    this.radius = random(4)+1;
    this.vx = random(-.5, .5)/radius/2;
    this.vy = random(-.5, .5)/radius/2;
    this.alpha = random(255);
  }

  public void display() {
    this.x += this.vx/width;
    this.y += this.vy/height;

    this.x %= 1;
    this.y %= 1;

    this.alpha += (int)random(-10, 10);
    this.alpha %= 255;
    if (this.alpha < 50) this.alpha = 50;

    noStroke();
    fill(255, 255, 255, this.alpha);
    circle(this.x*width, this.y*height, this.radius);
  }
}
