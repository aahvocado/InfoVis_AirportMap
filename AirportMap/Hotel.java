public class Hotel {
   private boolean f_hover, f_select, by_hover, by_select, bn_hover, bn_select;
   private boolean barDisplay; 
   private int yes, no; 
   private int yX, nX, y; 
   
  public Hotel(int y, int n){
    yes = y; 
    no =  n;
    
    yX = 760;
    nX = 834;
    
    barDisplay = false; 
    
    f_hover = false; 
    f_select = false; 
    by_hover = false; 
    by_select = false; 
    bn_hover = false; 
    bn_select = false;
  }

  public boolean getFH() {
    return f_hover;
  }
  public void setFH(boolean val) {
    this.f_hover = val;
  }

  public boolean getFS() {
    return f_select;
  }
  public void setFS(boolean val) {
    this.f_select = val;
  }
  
  public boolean getBYH() {
    return by_hover;
  }
  public void setBYH(boolean val) {
    this.by_hover = val;
  }
  
  public boolean getBYS() {
    return by_select;
  }
  public void setBYS(boolean val) {
    this.by_select = val;
  }
  
  public boolean getBNH() {
    return bn_hover;
  }
  public void setBNH(boolean val) {
    this.bn_hover = val;
  }
  
  public boolean getBNS() {
    return bn_select;
  }
  
  public void setY(int val) {
    this.y = val; 
  }
  public int getY(){
    return y;
  }
  
  public int getYX(){
    return yX;
  }
  
  public int getNX(){
    return nX;
  }
}
