class Filter {
  String name;

  int flags;
  int allFlag;

  String[] options;
  Checkbox allBox;
  Checkbox[] boxes;

  int cRad = 5;
  float x, y, w, h;
  float fullHeight;
  float smallHeight;
  boolean collapsed = true;

  public Filter(String name, String[] options, float x, float y) {
    this.name = name;
    this.options = options;
    this.x = x;
    this.y = y;

    boxes = new Checkbox[options.length];
    for (int i = 0; i < options.length; i++) {
      boxes[i] = new Checkbox(this, options[i], x+10, y+70+i*30, false);
    }

    allBox = new Checkbox(this, "All", x+10, y+40, true);
    allFlag = (int)pow(2, options.length);
    flags = allFlag;

    this.w = 300;
    this.fullHeight = 30*options.length+70;
    this.smallHeight = 35;
    this.h = smallHeight;
  }

  public void display() {
    noStroke();
    fill(255, 255, 255, 220);
    rect(x, y, w, h, cRad, cRad, cRad, cRad);
    textAlign(LEFT, TOP);
    textSize(25);

    if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h) {
      fill(0);
    } else fill(80);

    text(name, x+10, y);
    if (!collapsed) {
      allBox.display();
      for (Checkbox c : boxes) c.display();
    }
  }

  public boolean filter(String[] l) {
    for (String s : l) if (filter(s)) return true;
    return false;
  }

  // returns wether s passes the filter or not
  public boolean filter(String s) {
    // prioritise flag states w/o calculations
    if (flags == allFlag) return true;
    if (flags == 0) return false;

    // Find if bit is set and value s passes the filter
    for (int i = 0; i < options.length; i++) {
      if (((flags >> i) & 1) == 1 && s.equals(options[i])) {
        return true;
      }
    }
    return false;
  }

  public void addFilter(String o) {
    println("add: ", this.name, o);
    // If "All", set flag and uncheck boxes
    if (o.equals("All")) {
      flags = allFlag;
      for (Checkbox c : boxes) c.ensureOff();
      return;
    }

    // reset flags if "All" is already selected
    if (flags == allFlag) flags = 0;

    // Set flag bit for corresponding filter, if found
    for (int i = 0; i < options.length; i++) if (o.equals(options[i])) {
      flags |= (int)pow(2, i);
      return;
    }
    println("WARN: Filter not found - ", name, o);
  }

  public void removeFilter(String o) {
    println("rm: ", this.name, o);
    // If "All" is unset, reset flags
    if (o.equals("All")) {
      flags = 0;
      return;
    }

    // Unset flag bit for corresponding filter, if found
    for (int i = 0; i < options.length; i++) if (o.equals(options[i])) {
      flags ^= (int)pow(2, i);
      return;
    }
    println("WARN: Filter not found - ", name, o);
  }

  public boolean isInside() {
    float x = mouseX;
    float y = mouseY;
    return x > this.x && x < this.x + this.w && y > this.y && y < this.y + this.h;
  }

  public boolean clicked(float x, float y) {
    // Check for collapse toggle
    if (collapsed) if (isInside()) {
      collapsed = false;
      this.h = fullHeight;
      return true;
    } else {
      return false;
    }

    // if box clicked, toggle and make sure "All" is off
    for (Checkbox c : boxes) if (c.checkClick(x, y)) {
      allBox.ensureOff();
      return true;
    }

    // No boxes clicked, check "All"
    if (allBox.checkClick(x, y)) return true;

    // clicked but not in box => collapse
    if (isInside()) {
      collapsed = true;
      this.h = smallHeight;
      return true;
    }

    return false;
  }

  public boolean collapsed() {
    return this.collapsed;
  }
}

class Checkbox {
  String name;
  boolean checked;
  int size = 20;
  float x, y;
  Filter parent;

  public Checkbox(Filter f, String name, float x, float y, boolean b) {
    this.name = name;
    this.x = x;
    this.y = y;
    this.checked = b;
    this.parent = f;
    if (b) parent.addFilter(name);
  }

  public void display() {
    stroke(0);
    strokeWeight(2);
    if (mouseX > this.x && mouseX < this.x+size && mouseY > this.y && mouseY < this.y+size) {
      fill(220);
    } else fill(255);

    rect(x, y, size, size, 2, 2, 2, 2);
    fill(0);
    if (checked) {
      line(x, y, x+size, y+size);
      line(x, y+size, x+size, y);
    }
    textSize(size);
    textAlign(LEFT, CENTER);
    text(name, x+size+10, y+size/3);
  }

  public boolean checkClick(float x, float y) {
    // if checkbox clicked, toggle and add/remove filter as appropriate
    if (x > this.x && x < this.x+size && y > this.y && y < this.y+size) {
      this.checked = !this.checked;
      if (this.checked) parent.addFilter(this.name);
      else parent.removeFilter(this.name);
      return true;
    }
    return false;
  }

  public void ensureOff() {
    this.checked = false;
  }
}
