Satellite[] loadSatelliteData(String file) {
  filterData = new StringSet[3];
  StringSet orbitInfo = new StringSet("Orbit class");
  StringSet userInfo = new StringSet("Users");
  StringSet purposeInfo = new StringSet("Purpose");

  Table table = loadTable(file, "tsv");
  int nRows = table.getRowCount() - 1;
  Satellite[] out = new Satellite[nRows];
  for (int i = 0; i < nRows; i++) {
    out[i] = new Satellite(table.getRow(i+1));

    orbitInfo.add(out[i].orbitClass);
    userInfo.add(out[i].users);
    purposeInfo.add(out[i].purpose);
  }

  filterData[0] = orbitInfo;
  filterData[1] = purposeInfo;
  filterData[2] = userInfo;
  println(orbitInfo, userInfo, purposeInfo);
  return out;
}

class Satellite {
  // raw data
  public String name;
  public String country;
  public String[] ownerCountry;
  public String owner;
  public String[] users;
  public String[] purpose;
  public String purposeLong;
  public String orbitClass;
  public String orbitType;
  public float orbitLongitude;
  public float perigee;
  public float apogee;
  public float eccentricity;
  public float inclination;
  public float period;
  public float launchMass;
  public float dryMass;
  public float power;
  public String launchDate;
  public int lifetime;
  public String contractor;
  public String contractorCountry;
  public String launchSite;
  public String launchVehicle;
  public String COSPAR;
  public String NORAD;
  public String comments;
  public String[] sources = new String[6];

  // calculated
  public float aRadius;
  public float pRadius;
  public float sMajAxis;
  public float sMinAxis;
  public float focusOffset;
  float angle;
  float angleInc;
  public String launchYear;

  public Satellite(TableRow row) {
    name = row.getString(0);
    country = row.getString(1);
    ownerCountry = split(row.getString(2), "/");
    owner = row.getString(3);
    users = split(row.getString(4), "/");
    purpose = split(row.getString(5), "/");
    purposeLong = row.getString(6);
    orbitClass = row.getString(7);
    orbitType = row.getString(8);
    orbitLongitude = row.getFloat(9); // deg, only if orbit is GEO
    perigee = row.getFloat(10); // km
    apogee = row.getFloat(11); // km
    eccentricity = row.getFloat(12);
    inclination = row.getFloat(13); // deg
    period = row.getFloat(14)*60; // secs
    launchMass = row.getFloat(15); // kg
    dryMass = row.getFloat(16); // kg
    power = row.getFloat(17); // W
    launchDate = row.getString(18); // dd/mm/yyyy
    lifetime = row.getInt(19); // yrs
    contractor = row.getString(20);
    contractorCountry = row.getString(21);
    launchSite = row.getString(22);
    launchVehicle = row.getString(23);
    COSPAR = row.getString(24);
    NORAD = row.getString(25);
    comments = row.getString(26);
    for (int i = 0; i < 6; i++) sources[i] = row.getString(i+27);

    String[] sDate = split(launchDate, "/");
    launchYear = sDate[2];
    if (launchYear.length() < 4) println(launchYear);

    pRadius = 6378 + perigee;
    aRadius = 6378 + apogee;
    sMajAxis = (aRadius + pRadius) / 2;
    sMinAxis = sqrt(aRadius*pRadius);
    focusOffset = sMajAxis - pRadius;
    angle = PI;
    angleInc = 50*TWO_PI/this.period;
  }

  public void display() {
    pushMatrix();
    angle += angleInc;
    angle %= TWO_PI;

    if (orbitClass.equals("GEO")) rotateY(-orbitLongitude);
    rotateX(radians(90+inclination));

    noFill();
    stroke(255, 255, 255, 50);
    strokeWeight(1);

    pushMatrix();
    // use scale and ratios to easily draw ellipse and postiion of satellite
    // w/o calculating orbital position
    float xScale = sMinAxis/aRadius;
    float yScale = sMajAxis/pRadius;
    scale(xScale, yScale);
    // move ellipse so earth is at one of the foci
    if (orbitClass.equals("Elliptical")) translate(0, focusOffset*scaleFactor);
    circle(0, 0, sMajAxis*scaleFactor*2);

    rotateZ(-angle);
    translate(0, sMajAxis*scaleFactor);
    stroke(0, 255, 0, 50);
    strokeWeight(100*scaleFactor);
    fill(255, 0, 0);
    box(scaleFactor*3000/xScale, scaleFactor*1000/yScale, scaleFactor*1000);
    popMatrix();

    popMatrix();
  }

  public String toString() {
    return join(new String[]{
      this.name, 
      this.launchDate, 
      this.owner
      }, " - ");
  }
}
