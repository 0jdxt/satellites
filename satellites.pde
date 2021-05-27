int nStars = 100;
Star[] stars = new Star[nStars];
Satellite[] satellites;
float earthRadius = 6378.0;
float scaleFactor = 1./30;
Globe earth;
float e = exp(1);
boolean mouseDown = false;
float lastY, lastX;
StringSet[] filterData;
Filter[] filters;
ArrayList<Satellite> visibleSats;
int visStart = 0;

void setup() {
  size(1000, 1000, P3D);

  textFont(createFont("Noto Sans", 32));

  earth = new Globe(loadImage("earth.jpg"));
  satellites = loadSatelliteData("data.tsv");

  filters = new Filter[filterData.length];
  for (int i = 0; i < filterData.length; i++) {
    StringSet f = filterData[i];
    filters[i] = new Filter(f.name, f.toArray(), 20, 50*i+20);
  }
  updateFilters();

  for (int i = 0; i < nStars; i++) stars[i] = new Star();
}

void draw() {
  background(0);
  for (Star star : stars) star.display();

  hint(ENABLE_DEPTH_TEST);
  pushMatrix();

  translate(width/2, height/2, 0);
  if (mouseDown) {
    earth.rotateX(lastY, mouseY);
    earth.rotateY(lastX, mouseX);
    lastY = mouseY;
    lastX = mouseX;
  }

  rotateX(earth.xRotation());
  rotateY(earth.yRotation());

  earth.display();

  for (Satellite s : visibleSats) s.display();

  popMatrix();
  hint(DISABLE_DEPTH_TEST);

  textSize(30);
  fill(255);
  textAlign(RIGHT, TOP);
  text("FPS: "+(int)frameRate, width-10, 10);
  text("zoom: "+(int)(scaleFactor*1000)+"%", width-10, 40);
  text("satellites: "+visibleSats.size(), width-10, 70);

  // draw visible after collapsed
  for (Filter f : filters) if (f.collapsed) f.display();
  for (Filter f : filters) if (!f.collapsed) {
    // if multiple open, only show first
    f.display();
    break;
  }

  showVisibleStats();
}

void updateFilters() {
  visStart = 0;
  visibleSats = new ArrayList();
  for (Satellite s : satellites) {
    if (filters[0].filter(s.orbitClass) &&
      filters[1].filter(s.purpose) &&
      filters[2].filter(s.users))
      visibleSats.add(s);
  }
}

void showVisibleStats() {
  fill(255, 255, 255, 220);
  rect(0, height-200, width, 200);
  fill(0);
  textSize(18);
  textAlign(LEFT, TOP);
  for (int i = visStart; i < visibleSats.size() && i < visStart + 9; i++) {
    Satellite s = visibleSats.get(i);
    text((i+1)+": "+s, 20, height-200+22*(i-visStart));
  }
}

void mousePressed() {
  if (mouseButton == RIGHT) return;

  for (Filter f : filters) if (f.clicked(mouseX, mouseY)) {
    updateFilters();
    return;
  }
  mouseDown = true;
  lastY = mouseY;
  lastX = mouseX;
}

void mouseReleased() {
  mouseDown = false;
}

void keyPressed() {
  if (key == 32) earth.togglePause();
}

void mouseWheel(MouseEvent event) {
  // check satellite list first
  if (mouseY > height-200 && mouseY < height) {
    visStart += event.getCount();
    if (visStart < 0) visStart = 0;
    else if (visStart > visibleSats.size() - 8) visStart = visibleSats.size() - 8;
    return;
  }

  scaleFactor -= event.getCount()/1000.;
  if (scaleFactor < .0001) scaleFactor = .0001;
  else if (scaleFactor > .1) scaleFactor = .1;
}
