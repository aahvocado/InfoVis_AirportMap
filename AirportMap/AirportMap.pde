PImage titleBar, directions, filters, kids, hotel, pets, transport, wifi;
PShape usa;
boolean wifi_fh = false, hotel_fh = false, kids_fh = false, pets_fh = false, transport_fh = false; //hover over checkboxes
boolean wifi_sel = false, hotel_sel = false, kids_sel = false, pets_sel = false, transport_sel = false; //vars for which filters are selected
boolean wifi_bh = false, hotel_bh = false, kids_bh = false, pets_bh = false, transport_bh = false;
int barX = 760, barY = 311; //next starting location of the bargraphs that appear when you select a filter
int right_align = 760; //pixel placement to align the right side panel
int numOfAirports = 25;
color[] colorList = {color(107, 122, 119), color(121,170,154), color(171, 198, 188), //colorList indices 0-2 wifi
                     color(217, 171, 111), color(250, 206, 158), //colorList indices  3-4 hotel
                     color(164, 100, 106), color(209, 179, 179), //colorList indices 5-6 kids
                     color(102, 92, 143), color(167, 152, 201), //colorList indices 7-8 pets
                     color(217, 200, 107), color(241, 223, 130)}; //colorList indices 9-10 transportation
ArrayList<Airport> airports;
ArrayList<Airport> enabledAirports;
ArrayList<Airport> disabledAirports;
String csv = "airport.csv";
Hotel hVars; 

void setup() {
  size(1000, 560);  

  //load main
  titleBar = loadImage("images/title.png");
  usa = loadShape("map.svg");
  
  //load right-hand panel items
  directions = loadImage("images/directions.png");
  filters = loadImage("images/filters.png"); 
  kids = loadImage("images/kid-zones.png");
  hotel = loadImage("images/onsite-hotel.png");
  pets = loadImage("images/pet-care.png"); 
  transport = loadImage("images/transportation.png");  
  wifi = loadImage("images/wifi-stats.png");
  
  airports = new ArrayList<Airport>();
  enabledAirports = new ArrayList<Airport>();
  disabledAirports = new ArrayList<Airport>();
  loadData(csv);
  
  for(Airport airport: airports){
     if(airport.enabled())
       enabledAirports.add(airport); 
  }
  hVars = new Hotel(10, 15); 
}

void draw() {
  background(250, 247, 237);
  
  //draw main
  image(titleBar, 0, 0, 745, 88);
  shape(usa, 26, 96, 717, 424);
  
  //draw right-hand panel, minus the extra stats
  image(directions, right_align, 70, 190, 116);
  image(filters, right_align, 191, 190, 115); 
  
  //check if hovering over any filters
  checkFH();

  //draw checkboxes and hover effect if mouse is hovering over it
  drawCB(wifi_fh, right_align+2, 215, 8, 8); 
  drawCB(hotel_fh, right_align+2, 231, 8, 8); 
  drawCB(kids_fh, right_align+2, 247, 8, 8); 
  drawCB(pets_fh, right_align+2, 263, 8, 8); 
  drawCB(transport_fh, right_align+2, 279, 8, 8); 

  //draw the X in the checkbox if the filter is selected
  drawCheck(wifi_sel, right_align+2, 215, 7, 7); 
  drawCheck(hotel_sel, right_align+2, 231, 7, 7); 
  drawCheck(kids_sel, right_align+2, 247, 8, 8); 
  drawCheck(pets_sel, right_align+2, 263, 8, 8); 
  drawCheck(transport_sel, right_align+2, 279, 8, 8); 
    
  //if a filter is selected, draw selected bar chart
  drawBar(wifi_sel, wifi, barX, barY, 311, 41); //increment used to be 14
  drawBar(hotel_sel, hotel, barX, barY, 352, 41);
  if(hotel_sel)
    hVars.setY(366); 
  drawBar(kids_sel, kids, barX, barY, 393, 41);
  drawBar(pets_sel, pets, barX, barY, 434, 41);
  drawBar(transport_sel, transport, barX, barY, 475, 41); 
  barY = 311; //resets y value for next draw cycle 
  
  drawAirports2();
  
  loadPixels(); 
  
  checkBH(); 

}

//---------These methods draw stuff to the screen---------//
void drawCB(boolean hover, int x, int y, int w, int h){
  stroke(158, 151, 142, 180); 
 
 if(!hover) { 
   noFill(); 
 } else { 
   fill(255, 255, 255, 180); 
 }

 rect(x, y, w, h);  
}

void drawCheck(boolean checked, int x, int y, int w, int h){
  //if checked draw X in box
  if(checked){
    stroke(158, 151, 142, 180); 
    line(x, y, x+w, y+h); 
    line(x+w, y, x, y+h);  
  }
}

void drawBar(Boolean selected, PImage img, int x, int y, int altY, int increment){
  if(selected){   
     if(y <= altY) {
       image(img, x, y); //draw bar graph
     } else { 
       image(img, x, altY); 
     }
     
     //increment barX, barY for the next one. 
     barY = barY + increment; 
  }
} 

void drawAirports(){
  fill(204, 102, 0);
  for(int i = 0; i<airports.size();i++){
    Airport airport = airports.get(i);
    int radius = Math.round(airport.getPas_2012()/45798809.0*24);
//    text(airport.getName(),airport.getX()-5,airport.getY()-5);

    //if enabled, fill(204, 102, 0); else grey out
    
    ellipse(airport.getX(), airport.getY(),radius, radius);
  } 
}

void drawAirports2(){
  for(int i=0; i<enabledAirports.size(); i++){
    Airport airport = enabledAirports.get(i); 
    int radius = Math.round(airport.getPas_2012()/45798809.0*24);
    fill(204, 102, 0); 
    ellipse(airport.getX(), airport.getY(), radius, radius); 
  }
  
  for(int i=0; i<disabledAirports.size(); i++){
    Airport airport = disabledAirports.get(i); 
    int radius = Math.round(airport.getPas_2012()/45798809.0*24); 
    fill(204, 102, 0, 127);
    ellipse(airport.getX(), airport.getY(), radius, radius);
  }
}

//-------These methods have to do with mouse interaction------//

//check filter checkbox hover
void checkFH(){
  //if mouse within threshold of filters, check hover
  if(mouseX>=right_align && mouseX<=(right_align+186) && mouseY>214 && mouseY<288){
    //check mouse over wifi filter checkbox
    if(mouseY>214 && mouseY<224){ //mouseX>right_align && mouseX<(right_align+36) && 
      wifi_fh = true; 
    } else { 
      wifi_fh = false; 
    }
    
    //check mouse over hotel filter checkbox
    if(mouseY>230 && mouseY<240){ //mouseX>right_align && mouseX<(right_align+92) && 
      hotel_fh = true; 
    } else { 
      hotel_fh = false; 
    }
    
    //check mouse over kids filter checkbox
    if(mouseY>246 && mouseY<256){ //mouseX>right_align && mouseX<(right_align+80) && 
      kids_fh = true; 
    } else { 
      kids_fh = false; 
    }
    
    //check mouse over pet filter checkbox
    if(mouseY>262 && mouseY<272){ //mouseX>right_align && mouseX<(right_align+62) && 
      pets_fh = true; 
    } else { 
      pets_fh = false; 
    }
    
    //check mouse over transport filter checkbox
    if(mouseY>278 && mouseY<288){ //mouseX>right_align && mouseX<(right_align+182) && 
      transport_fh = true; 
    } else { 
      transport_fh = false; 
    }
  } 
}

void checkBH(){
  if (mouseX>=right_align && mouseX<=(right_align+186) && mouseY>311 && mouseY<517) {
    color c = pixels[mouseY*width+mouseX];
    compareColor(c);
    
    if(mouseY>324 && mouseY<341){
       //hoverTooltip
       //draw ring
    } else if(mouseY>366 && mouseY<383){
       //hoverTooltip
       //draw ring
    } else if (mouseY>407 && mouseY<424){
       //hoverTooltip
    } else if (mouseY>448 && mouseY<465){ 
       //hover Tooltip
    } else if(mouseY>489 && mouseY<508){
      //hover Tooltip
    } else{
       //color c = get color under mouse
    }
    
    //compareColor(c);
  }
}

void mousePressed(){
  //if mouse within threshold of filters, check filters clicks
  if(mouseX>=right_align && mouseX<=(right_align+186) && mouseY>214 && mouseY<288){
    if(wifi_fh){
      if(!wifi_sel){
        wifi_sel = true;
      } else { 
        wifi_sel = false;
      }
    } else if(hotel_fh){
      if(!hotel_sel){
        hotel_sel = true;
      } else { 
        hotel_sel = false;
      }
    } else if(kids_fh){ 
      if(!kids_sel){
        kids_sel = true;
      } else { 
        kids_sel = false;
      }
    } else if(pets_fh){
      if(!pets_sel){
        pets_sel = true;
      } else { 
        pets_sel = false;
      }
    } else if(transport_fh){
      if(!transport_sel){
        transport_sel = true;
      } else { 
        transport_sel = false;
      }
    } else{
      return; 
    }
    
   // refreshAirports(); 
  }
}

//------------These methods have to do with important things not pertaining to drawing or mouse interaction---------//

void loadData(String csv){
  String [] lines = loadStrings(csv);
  for(int i = 1; i<lines.length;i++){
    airports.add(new Airport(lines[i]));
  }
}

//compare c with some colors to determine what the mouse is over 
int compareColor(color c){
  float r = red(c); 
  float g = green(c); 
  float b = blue(c); 
  
  float d;
  
  for(int i = 0; i<colorList.length; i++){
    d = dist(r, g, b, red(colorList[i]), green(colorList[i]), blue(colorList[i]));
    
    if(d<10){
      flagBH(i);
      return i;
    }
  }  
  
  return 20; //arbitrary big number
}

void flagBH(int i){
  if(i==3){
    noStroke(); 
    fill(255, 255, 255, 60); 
    rect(hVars.getYX(), hVars.getY(), hVars.getNX()-hVars.getYX(), 17);
  } else if (i==4){
    noStroke(); 
    fill(255, 255, 255, 60); 
    rect(hVars.getNX(), hVars.getY(), 946-hVars.getNX(), 17);
  }
  
   /*if(i<3){
      wifi_bh = true; 
      hotel_bh = false; 
      kids_bh = false; 
      pets_bh = false;
      transport_bh = false;
   } else if (i<5) {
      wifi_bh = false; 
      hotel_bh = true; 
      kids_bh = false; 
      pets_bh = false;
      transport_bh = false;
   } else if (i<7) {
      wifi_bh = false; 
      hotel_bh = false; 
      kids_bh = true; 
      pets_bh = false;
      transport_bh = false;
   } else if (i<9) {
      wifi_bh = false; 
      hotel_bh = false; 
      kids_bh = false; 
      pets_bh = true;
      transport_bh = false;
   } else if (i<11) {
      wifi_bh = false; 
      hotel_bh = false; 
      kids_bh = false; 
      pets_bh = false;
      transport_bh = true;
   } else {
      wifi_bh = false; 
      hotel_bh = false; 
      kids_bh = false; 
      pets_bh = false;
      transport_bh = false;
   } */
}

void refreshAirports(){
  for(Airport airport: enabledAirports){
    if(hotel_sel){
      if(!airport.isHotel()){
        airport.setEnable(false);
        disabledAirports.add(airport); 
        enabledAirports.remove(airport);
      }
    }
  }
}

