PImage titleBar, filters;
PShape usa;
PImage[] infoBoxes;
int displayRank = -1; 

PImage[] AA, DL, SW, UN, US;
PImage[] wifiIcons, hotelIcons, kidsIcons, petsIcons, transIcons; 

boolean[] airlineFilters = {false, false, false, false, false}; 
PVector[] airlineFiltersLocs = {new PVector(793, 118.4), new PVector(826.4, 118.4), new PVector(859.75, 118.4), new PVector(893, 118.4), new PVector(926.4, 118.4)}; 

boolean[] wifiFilters = {false, false, false}; 
float[][] wifiLocs = {{780.0, 156.34, 107.44, 18}, {887.44, 156.34, 31.6, 18}, {919.041, 156.34, 18.96, 18}};

boolean[] hotelFilters = {false, false}; 
float[][] hotelLocs = {{780, 199, 63.2, 18.0}, {843.2, 199, 94.8, 18.0}}; 

boolean[] kidsFilters = {false, false}; 
float[][] kidsLocs = {{780, 243, 88.5, 18.0}, {868.48, 243, 69.5, 18.0}}; 

boolean[] petsFilters = {false, false}; 
float[][] petsLocs = {{780, 286.14, 145.36, 18.0}, {925.36, 286.14, 12.639, 18.0}}; 

boolean[] transFilters = {false, false}; 
float[][] transLocs = {{780, 329.24, 88.48, 18.0}, {868.48, 329.24, 69.521, 18.0}}; 

int right_align = 770; //pixel placement to align the right side panel
int numOfAirports = 25;
color[] colorList = {color(107, 122, 119), color(121,170,154), color(171, 198, 188), //colorList indices 0-2 wifi
                     color(217, 171, 111), color(250, 206, 158), //colorList indices  3-4 hotel
                     color(164, 100, 106), color(209, 179, 179), //colorList indices 5-6 kids
                     color(102, 92, 143), color(167, 152, 201), //colorList indices 7-8 pets
                     color(217, 200, 107), color(241, 223, 130)}; //colorList indices 9-10 transportation
ArrayList<Airport> airports;
ArrayList<Airport> enabledAirports;
ArrayList<Airport> disabledAirports;
Airport selectedAirport = null;

String csv = "airport.csv";

void setup() {
  size(1000, 560);  

  //load main
  titleBar = loadImage("images/title.png");
  usa = loadShape("map.svg");
  
  //load right-hand panel items
  filters = loadImage("images/filters.png"); 

  //load info box images into project
  infoBoxes = new PImage[25];
  for (int i=0; i<infoBoxes.length; i++){
    infoBoxes[i] = loadImage("images/airport/" + (i+1) + ".png"); 
  } 
  
  //load filter icons into project
  wifiIcons = new PImage[3]; 
  hotelIcons = new PImage[2]; 
  kidsIcons = new PImage[2]; 
  petsIcons = new PImage[2]; 
  transIcons = new PImage[2]; 
  
  for (int i=0; i<wifiIcons.length; i++){
    wifiIcons[i] = loadImage("images/wifi/" + i + ".png"); 
    
    if(i<2){
      hotelIcons[i] = loadImage("images/hotel/" + i + ".png");
      kidsIcons[i] = loadImage("images/kids/" + i + ".png"); 
      petsIcons[i] = loadImage("images/pets/" + i + ".png"); 
      transIcons[i] = loadImage("images/transport/" + i + ".png"); 
    }
  }

  //load all airline icons/buttons in an easy to access array
  AA = new PImage[5]; 
  DL = new PImage[5];
  SW = new PImage[5]; 
  UN = new PImage[5]; 
  US = new PImage[5]; 
  for (int i=0; i<AA.length; i++) {
    AA[i] = loadImage("images/AA/" + i + ".png"); 
    DL[i] = loadImage("images/DL/" + i + ".png"); 
    SW[i] = loadImage("images/SW/" + i + ".png"); 
    UN[i] = loadImage("images/UN/" + i + ".png");
    US[i] = loadImage("images/US/" + i + ".png"); 
  }
  
  airports = new ArrayList<Airport>();
  enabledAirports = new ArrayList<Airport>();
  disabledAirports = new ArrayList<Airport>();
  loadData(csv);
  
  for(Airport airport: airports){
     if(airport.enabled())
       enabledAirports.add(airport); 
  }
}

void draw() {
  background(250, 247, 237);
  
  //draw main
  image(titleBar, 23.7, 27.8);
  shape(usa, 26, 96, 717, 424);
  
  //draw filter panel
  image(filters, right_align, 53, 180, 310); 
  image(AA[0], 780, 103, 30, 30); 
  //drawButtons
  drawAirlineButtons(airlineFilters); 
  drawBarFilters(wifiFilters, wifiLocs); 
  drawBarFilters(hotelFilters, hotelLocs); 
  drawBarFilters(kidsFilters, kidsLocs);
  drawBarFilters(petsFilters, petsLocs);
  drawBarFilters(transFilters, transLocs); 

  strokeWeight(1); 
  drawAirports2();
  if(selectedAirport != null){
    drawInfoPanel(selectedAirport);
  }
  
  loadPixels(); 
  mouseUpdate();
  
  stroke(204, 102, 0);
}

//---------These methods draw stuff to the screen---------//
void drawInfoPanel(Airport a){//draw the info
  if(displayRank >= 0){
    image(infoBoxes[displayRank-1], right_align, 381.5, 180, 130);  
   
    //draw icons in row one
    String aa = "" + a.getAa(); 
    String dl = "" + a.getDl(); 
    String sw = "" + a.getWn(); 
    String un = "" + a.getUa(); 
    String us = "" + a.getUs(); 
    
    if(aa.equals("NO")){
      image(AA[2], 776.998, 438.496, 30.5, 30.5); 
    } else if(aa.equals("YES")){
      image(AA[3], 776.998, 438.496, 30.5, 30.5); 
    } else{
      image(AA[4], 776.998, 438.496, 30.5, 30.5); 
    }
    
    if(dl.equals("NO")){
      image(DL[2], 809.998, 438.496, 30.5, 30.5); 
    } else if(dl.equals("YES")){
      image(DL[3], 809.998, 438.496, 30.5, 30.5); 
    } else{
      image(DL[4], 809.998, 438.496, 30.5, 30.5); 
    }
    
    if(sw.equals("NO")){
      image(SW[2], 842.998, 438.496, 30.5, 30.5); 
    } else if(sw.equals("YES")){
      image(SW[3], 842.998, 438.496, 30.5, 30.5); 
    } else{
      image(SW[4], 842.998, 438.496, 30.5, 30.5); 
    }
    
    if(un.equals("NO")){
      image(UN[2], 876.667, 438.496, 30.5, 30.5); 
    } else if(un.equals("YES")){
      image(UN[3], 876.667, 438.496, 30.5, 30.5); 
    } else{
      image(UN[4], 876.667, 438.496, 30.5, 30.5); 
    }
    
    if(us.equals("NO")){
      image(US[2], 910.498, 438.496, 30.5, 30.5); 
    } else if(us.equals("YES")){
      image(US[3], 910.498, 438.496, 30.5, 30.5); 
    } else{
      image(US[4], 910.498, 438.496, 30.5, 30.5); 
    }
    
    //draw icons in row two
    if(a.getWifi().equals("f")){
       image(wifiIcons[0], 779.334, 474.333, 25.667, 25.667); 
    } else if(a.getWifi().equals("p")){
       image(wifiIcons[1], 779.334, 474.333, 25.667, 25.667); 
    } else{
       image(wifiIcons[2], 779.334, 474.333, 25.667, 25.667); 
    }
    
    if(a.isHotel()){
       image(hotelIcons[0], 812.751, 474.333, 25.667, 25.667);  
    } else {
      image(hotelIcons[1], 812.751, 474.333, 25.667, 25.667);  
    }
    
    if(a.isKids()){
       image(kidsIcons[0], 846.167, 474.333, 25.667, 25.667);  
    } else{
       image(kidsIcons[1], 846.167, 474.333, 25.667, 25.667);  
    }
    
    if(a.isPet()){
       image(petsIcons[0], 879.584, 474.333, 25.667, 25.667);  
    } else{
       image(petsIcons[1], 879.584, 474.333, 25.667, 25.667);  
    }
    
    if(a.isTrans()){
       image(transIcons[0], 913.001, 474.333, 25.667, 25.667);  
    } else{
       image(transIcons[1], 913.001, 474.333, 25.667, 25.667);  
    }
  }
}

void drawAirlineButtons(boolean[] arr){
  if (!arr[0]){
    image(AA[0], 780, 103, 30, 30);
  } else{
    image(AA[1], 780, 103, 30, 30); 
  }
  
  if (!arr[1]){
    image(DL[0], 812.6, 103, 30, 30); 
  } else { 
    image(DL[1], 812.6, 103, 30, 30); 
  }
  
  if (!arr[2]){
    image(SW[0], 845, 103, 30, 30); 
  } else { 
    image(SW[1], 845, 103, 30, 30); 
  }
  
  if (!arr[3]){
    image(UN[0], 878.3, 103, 30, 30); 
  } else { 
    image(UN[1], 878.3, 103, 30, 30); 
  }
  
  if (!arr[4]){
    image(US[0], 911.67, 103, 30, 30); 
  } else { 
    image(US[1], 911.67, 103, 30, 30); 
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
    int radius = getAirportSize(airport);
    fill(204, 102, 0); 
    ellipse(airport.getX(), airport.getY(), radius, radius); 
  }
  
  for(int i=0; i<disabledAirports.size(); i++){
    Airport airport = disabledAirports.get(i); 
    int radius = getAirportSize(airport);
    fill(204, 102, 0, 127);
    ellipse(airport.getX(), airport.getY(), radius, radius);
  }
}

//calculates size of airport to draw
int getAirportSize(Airport a){
  int maxSize = 26;
  float maxLargest = 45798809.0;
  int r = Math.round(a.getPas_2012()/maxLargest*maxSize);
  return r;
}

//draws a small tooltip at position p
void drawTooltip(PVector p, String s){
  float strLength = s.length() * 6.0;
  PVector pos = new PVector(p.x, p.y + 20);//center it based on the text
  /*if(p.x < 80){//offset to keep the entire tooltip in screen
    pos.x += 50.0;
  }else if(p.x > 620){
    pos.x -= 50.0;
  }*/
  
  fill(255);
  rect(pos.x , pos.y, strLength, 20);
  fill(55);
  text(""+s, pos.x+5, pos.y+15);
}

void drawBarFilters(boolean[] bools, float[][] locs){ 
  stroke(0, 0, 0, 120); 
  strokeWeight(3); 
  noFill();

  for(int i=0; i<bools.length; i++){
     if(bools[i]){
        rect(locs[i][0]+1, locs[i][1]+2, locs[i][2]-4, locs[i][3]-4); 
     } 
  }
}

//-------These methods have to do with mouse interaction------//

void mouseUpdate(){
  cursor(ARROW);
  //check is mouse clicked an airport
  if(mouseX>26 && mouseX <750 && mouseY>96 && mouseY<520){
    for(Airport a:airports){
      PVector mouse = new PVector(mouseX, mouseY);//mouse position
      PVector aPos = new PVector(a.getX(), a. getY());
      int diameter = getAirportSize(a);
      if(withinCircle(mouse, aPos, diameter/2)){
        PVector drawPos = new PVector(mouseX, mouseY);
        cursor(HAND);//show this is clickable
        drawTooltip(drawPos, ""+a.getName());
        break;
      }
    }
  } else if (mouseX>770 && mouseX<950){
      if(mouseY>102 && mouseY<132){
        for(int i=0; i<airlineFiltersLocs.length; i++){
        PVector mouse = new PVector(mouseX, mouseY); 
        PVector aPos = airlineFiltersLocs[i]; 
                  
          if(withinCircle(mouse, aPos, 15)){
            cursor(HAND); 
            noStroke();
            fill(255,255,255,100); 
            ellipseMode(CENTER); 
            ellipse(aPos.x, aPos.y, 31, 31); 
            //get msg
            PVector drawPos = new PVector(mouseX, mouseY);
            String[] msgs = {"American Airlines", "Delta Airlines", "Southwest Airlines", "United Airlines", "US Airways"};
              
            drawTooltip(drawPos, msgs[i]);  
              
            break;
          }
        }
      } else if (mouseY>155 && mouseY<173){
          for(int i=0; i< wifiLocs.length; i++){
            float x = wifiLocs[i][0]; 
            float y = wifiLocs[i][1]; 
            float w = wifiLocs[i][2]; 
            float h = wifiLocs[i][3]; 
               
            if(withinRectangle(x, y, w, h)){
               cursor(HAND); 
               noStroke(); 
               fill(255,255,255,100); 
               rect(x, y, w, h); 
                   
               String[] msgs = {"Free wifi", "Paid Wifi", "Free Wifi with Restrictions"}; 
               PVector drawPos = new PVector(mouseX, mouseY); 
                   
               drawTooltip(drawPos, msgs[i]); 
               
               break;
            }
         } 
     } else if (mouseY>195 && mouseY<218){
         for(int i=0; i<hotelLocs.length; i++){
           float x = hotelLocs[i][0]; 
           float y = hotelLocs[i][1]; 
           float w = hotelLocs[i][2]; 
           float h = hotelLocs[i][3]; 
               
           if(withinRectangle(x, y, w, h)){
              cursor(HAND); 
              noStroke(); 
              fill(255,255,255,100); 
              rect(x, y, w, h); 
                   
              String[] msgs = {"On-site Hotel Available", "On-site Hotel Unavailable"}; 
              PVector drawPos = new PVector(mouseX, mouseY); 
                   
              drawTooltip(drawPos, msgs[i]); 
               
              break;
            }
         }  
     } else if (mouseY>240 && mouseY<261){
         for(int i=0; i<kidsLocs.length; i++){
           float x = kidsLocs[i][0]; 
           float y = kidsLocs[i][1]; 
           float w = kidsLocs[i][2]; 
           float h = kidsLocs[i][3]; 
               
           if(withinRectangle(x, y, w, h)){
              cursor(HAND); 
              noStroke(); 
              fill(255,255,255,100); 
              rect(x, y, w, h); 
                   
              String[] msgs = {"Play areas available", "No Play areas"}; 
              PVector drawPos = new PVector(mouseX, mouseY); 
                   
              drawTooltip(drawPos, msgs[i]); 
               
              break;
            }
         }  
     } else if (mouseY>285 && mouseY<305){
         for(int i=0; i<petsLocs.length; i++){
           float x = petsLocs[i][0]; 
           float y = petsLocs[i][1]; 
           float w = petsLocs[i][2]; 
           float h = petsLocs[i][3]; 
               
           if(withinRectangle(x, y, w, h)){
              cursor(HAND); 
              noStroke(); 
              fill(255,255,255,100); 
              rect(x, y, w, h); 
                   
              String[] msgs = {"Pet areas available", "No pet friendly zones"}; 
              PVector drawPos = new PVector(mouseX, mouseY); 
                   
              drawTooltip(drawPos, msgs[i]); 
               
              break;
            }
         }  
     } else if (mouseY>327 && mouseY<348){
         for(int i=0; i<transLocs.length; i++){
           float x = transLocs[i][0]; 
           float y = transLocs[i][1]; 
           float w = transLocs[i][2]; 
           float h = transLocs[i][3]; 
               
           if(withinRectangle(x, y, w, h)){
              cursor(HAND); 
              noStroke(); 
              fill(255,255,255,100); 
              rect(x, y, w, h); 
                   
              String[] msgs = {"Transportation to city center available", "Transportation to city center is not available."}; 
              PVector drawPos = new PVector(mouseX, mouseY); 
                   
              drawTooltip(drawPos, msgs[i]); 
               
              break;
            }
         }  
     }
      
  } /*else if (mouseX>770 && mouseX<950 && mouseY>155 && mouseY<173){
      for(int i=0; i< wifiLocs.length; i++){
        float x = wifiLocs[i][0]; 
        float y = wifiLocs[i][1]; 
        float w = wifiLocs[i][2]; 
        float h = wifiLocs[i][3]; 
           
        if(withinRectangle(x, y, w, h)){
           cursor(HAND); 
           noStroke(); 
           fill(255,255,255,100); 
           rect(x, y, w, h); 
               
           String[] msgs = {"Free wifi", "Paid Wifi", "Free Wifi with Restrictions"}; 
           PVector drawPos = new PVector(mouseX, mouseY); 
               
           drawTooltip(drawPos, msgs[i]); 
           
           break;
        }
     } 
  } */
  
  
  
}

void mousePressed(){
  selectedAirport = null;//clear selected airport
  //check is mouse clicked an airport
  if(mouseX>26 && mouseX <750 && mouseY>96 && mouseY<520){
    for(Airport a:airports){
      PVector mouse = new PVector(mouseX, mouseY);//mouse position
      PVector aPos = new PVector(a.getX(), a. getY());
      int diameter = getAirportSize(a);
      if(withinCircle(mouse, aPos, diameter/2)){
        selectedAirport = a;
        drawTooltip(mouse, ""+a.getName());
        
        //if new airport is clicked, change infobox to display; if the airport is already selected, 
        //deselect the airport and unshow the info box
        if(displayRank != a.getRank()){
           displayRank = a.getRank();  
        } else{
           displayRank = -1; 
        }
        
        break;
      }

    }
  } else if (mouseX>770 && mouseX<950){
      if(mouseY>102 && mouseY<132){
         for(int i=0; i<airlineFiltersLocs.length; i++){
          PVector mouse = new PVector(mouseX, mouseY); 
          PVector aPos = airlineFiltersLocs[i]; 
                    
            if(withinCircle(mouse, aPos, 15)){
              cursor(HAND); 
              airlineFilters[i] = !airlineFilters[i]; 
              
              break;
            }
          }
      } else if (mouseY>155 && mouseY<173){
          for(int i=0; i< wifiLocs.length; i++){
            float x = wifiLocs[i][0]; 
            float y = wifiLocs[i][1]; 
            float w = wifiLocs[i][2]; 
            float h = wifiLocs[i][3]; 
                 
            if(withinRectangle(x, y, w, h)){               
               wifiFilters[i] = !wifiFilters[i]; 
               break;
            }
         }
          if(wifiFilters[0] && wifiFilters[1] && wifiFilters[2]){
             wifiFilters[0] = false; 
             wifiFilters[1] = false; 
             wifiFilters[2] = false; 
          } 
       } else if (mouseY>195 && mouseY<218){
           for(int i=0; i<hotelLocs.length; i++){
             float x = hotelLocs[i][0]; 
             float y = hotelLocs[i][1]; 
             float w = hotelLocs[i][2]; 
             float h = hotelLocs[i][3]; 
                 
             if(withinRectangle(x, y, w, h)){               
               hotelFilters[i] = !hotelFilters[i]; 
               break;
            }
           } 
          
           if(hotelFilters[0] && hotelFilters[1]){
             hotelFilters[0] = false; 
             hotelFilters[1] = false; 
           } 
       } else if (mouseY>240 && mouseY<261){
           for(int i=0; i<kidsLocs.length; i++){
             float x = kidsLocs[i][0]; 
             float y = kidsLocs[i][1]; 
             float w = kidsLocs[i][2]; 
             float h = kidsLocs[i][3]; 
                 
             if(withinRectangle(x, y, w, h)){               
               kidsFilters[i] = !kidsFilters[i]; 
               break;
             }
           } 
          
           if(kidsFilters[0] && kidsFilters[1]){
             kidsFilters[0] = false; 
             kidsFilters[1] = false; 
           }
       } else if (mouseY>285 && mouseY<305){
           for(int i=0; i<petsLocs.length; i++){
             float x = petsLocs[i][0]; 
             float y = petsLocs[i][1]; 
             float w = petsLocs[i][2]; 
             float h = petsLocs[i][3]; 
                 
             if(withinRectangle(x, y, w, h)){               
               petsFilters[i] = !petsFilters[i]; 
               break;
             }
           } 
          
           if(petsFilters[0] && petsFilters[1]){
             petsFilters[0] = false; 
             petsFilters[1] = false; 
           }  
       } else if (mouseY>327 && mouseY<348){
           for(int i=0; i<transLocs.length; i++){
             float x = transLocs[i][0]; 
             float y = transLocs[i][1]; 
             float w = transLocs[i][2]; 
             float h = transLocs[i][3]; 
                 
             if(withinRectangle(x, y, w, h)){               
               transFilters[i] = !transFilters[i]; 
               break;
             }
           } 
          
           if(transFilters[0] && transFilters[1]){
             transFilters[0] = false; 
             transFilters[1] = false; 
           }  
       }
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
      //flagBH(i);
      return i;
    }
  }  
  
  return 20; //arbitrary big number
}

//checks if a point is within the circle of center and radius
boolean withinCircle(PVector point, PVector center, int radius){
  PVector a = point;
  PVector b = center;
  float distance = sqrt( pow(b.x-a.x, 2) + pow(b.y-a.y, 2));
  if(distance <= radius){
    return true;
  }else{
    return false;
  }
}

boolean withinRectangle(float x, float y, float w, float h){
  if(mouseX>x && mouseX<x+w && mouseY>y && mouseY<y+h){
    return true; 
  } else{ 
    return false; 
  }
}

//temp method
void refreshAirports(){
  
}

