public class Airport {
   private String name,code,city,state,longi,lat,wifi;
   private boolean hotel,kids,pet,trans;
   private enum Presence {YES, HUB, NO};
   private Presence aa, dl, wn, ua, us;
   private int rank,pas_2012,pas_2011,pas_2010,pas_2009,pas_2008,x,y;
   private boolean enabled = true; //by default, all airports are enabled initially.
  
  public  Airport(String dataString){
      String[] data = dataString.split(",");
      rank = Integer.parseInt(data[0]);
      name = data[1];
      code = data[2];
      city = data[3];
      state = data[4];
      aa = parsePresence(data[5]);
      dl = parsePresence(data[6]);
      wn = parsePresence(data[7]);
      ua = parsePresence(data[8]);
      us = parsePresence(data[9]);
      pas_2012 = Integer.parseInt(data[10]);
      pas_2011 = Integer.parseInt(data[11]);
      pas_2010 = Integer.parseInt(data[12]);
      pas_2009 = Integer.parseInt(data[13]);
      pas_2008 = Integer.parseInt(data[14]);
      longi = data[15];
      lat = data[16];
      wifi = data[17];
      hotel = Boolean.parseBoolean(data[18]);
      kids = Boolean.parseBoolean(data[19]);
      pet = Boolean.parseBoolean(data[20]);
      trans = Boolean.parseBoolean(data[21]);
      x = Integer.parseInt(data[22]);
      y = Integer.parseInt(data[23]);
      
     }
     
  private Presence parsePresence(String presenceData){
    if(presenceData.contains("*")){
      return Presence.HUB;
    }
    else if(presenceData.contains("N")){
      return Presence.NO;
    }
    else{
      return Presence.YES;
    }
  }

  public String getName() {
    return name;
  }
  public void setName(String name) {
    this.name = name;
  }

  public String getCode() {
    return code;
  }
  public void setCode(String code) {
    this.code = code;
  }

  public String getCity() {
    return city;
  }
  public void setCity(String city) {
    this.city = city;
  }

  public String getState() {
    return state;
  }
  public void setState(String state) {
    this.state = state;
  }

  public String getLongi() {
    return longi;
  }
  public void setLongi(String longi) {
    this.longi = longi;
  }

  public String getLat() {
    return lat;
  }
  public void setLat(String lat) {
    this.lat = lat;
  }

  public String getWifi() {
    return wifi;
  }
  public void setWifi(String wifi) {
    this.wifi = wifi;
  }

  public boolean isHotel() {
    return hotel;
  }
  public void setHotel(boolean hotel) {
    this.hotel = hotel;
  }

  public boolean isKids() {
    return kids;
  }
  public void setKids(boolean kids) {
    this.kids = kids;
  }
  public boolean isPet() {
    return pet;
  }
  public void setPet(boolean pet) {
    this.pet = pet;
  }

  public boolean isTrans() {
    return trans;
  }
  public void setTrans(boolean trans) {
    this.trans = trans;
  }

  public Presence getAa() {
    return aa;
  }
  public void setAa(Presence aa) {
    this.aa = aa;
  }

  public Presence getDl() {
    return dl;
  }
  public void setDl(Presence dl) {
    this.dl = dl;
  }

  public Presence getWn() {
    return wn;
  }
  public void setWn(Presence wn) {
    this.wn = wn;
  }

  public Presence getUa() {
    return ua;
  }
  public void setUa(Presence ua) {
    this.ua = ua;
  }

  public Presence getUs() {
    return us;
  }
  public void setUs(Presence us) {
    this.us = us;
  }

  public int getRank() {
    return rank;
  }
  public void setRank(int rank) {
    this.rank = rank;
  }

  public int getPas_2012() {
    return pas_2012;
  }
  public void setPas_2012(int pas_2012) {
    this.pas_2012 = pas_2012;
  }

  public int getPas_2011() {
    return pas_2011;
  }
  public void setPas_2011(int pas_2011) {
    this.pas_2011 = pas_2011;
  }

  public int getPas_2010() {
    return pas_2010;
  }
  public void setPas_2010(int pas_2010) {
    this.pas_2010 = pas_2010;
  }

  public int getPas_2009() {
    return pas_2009;
  }
  public void setPas_2009(int pas_2009) {
    this.pas_2009 = pas_2009;
  }

  public int getPas_2008() {
    return pas_2008;
  }
  public void setPas_2008(int pas_2008) {
    this.pas_2008 = pas_2008;
  }

  public int getX() {
    return x;
  }
  public void setX(int x) {
    this.x = x;
  }

  public int getY() {
    return y;
  }
  public void setY(int y) {
    this.y = y;
  }
  
  public void setEnable(boolean val){
    this.enabled = val; 
  }
  public boolean enabled(){
    return enabled;  
  }
}
