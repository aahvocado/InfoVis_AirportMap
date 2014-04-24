PImage titleBar, filters, intro;
PShape usa;
PImage[] infoBoxes;
int displayRank = -1; 

PImage[] AA, DL, SW, UN, US, airlineTooltips;
PImage[] wifiIcons, hotelIcons, kidsIcons, petsIcons, transIcons; 

boolean[] airlineFilters = {false, false, false, false, false}; 
PVector[] airlineFiltersLocs = {new PVector(800.667, 115.167), new PVector(835, 115.167), new PVector(869.333, 115.167), new PVector(903.667, 115.167), new PVector(938, 115.167)}; 

boolean[] wifiFilters = {false, false, false}; 
float[][] wifiLocs = {{784, 154.84, 115.6, 18.0}, {899, 154.84, 33.5, 18.0}, {932, 154.84, 20.398, 18.0}};
PImage[] wifiTT;

boolean[] hotelFilters = {false, false}; 
float[][] hotelLocs = {{784.0, 197.439, 68, 18.0}, {851.5, 197.439, 102.0, 18.0}}; 
PImage[] hotelTT; 

boolean[] kidsFilters = {false, false}; 
float[][] kidsLocs = {{784.0, 241, 95, 18.3}, {878.5, 241, 74.801, 16.512, 19}}; 
PImage[] kidsTT; 

boolean[] petsFilters = {false, false}; 
float[][] petsLocs = {{784.0, 283, 156, 18.0}, {939, 283, 13.599, 18.0}}; 
PImage[] petsTT; 

boolean[] transFilters = {false, false}; 
float[][] transLocs = {{784.0, 326, 95, 18.0}, {878.5, 326, 74.801, 18.0}}; 
PImage[] transTT; 

int right_align = 775; //pixel placement to align the right side panel
int numOfAirports = 25;
color[] colorList = {color(107, 122, 119), color(121,170,154), color(171, 198, 188), //colorList indices 0-2 wifi
                     color(217, 171, 111), color(250, 206, 158), //colorList indices  3-4 hotel
                     color(164, 100, 106), color(209, 179, 179), //colorList indices 5-6 kids
                     color(102, 92, 143), color(167, 152, 201), //colorList indices 7-8 pets
                     color(217, 200, 107), color(241, 223, 130)}; //colorList indices 9-10 transportation
ArrayList<Airport> airports;
Airport selectedAirport = null;

String csv = "airport.csv";

void setup() {
  size(1000, 650);  

  //load main
  titleBar = loadImage("images/title.png");
  usa = loadShape("map.svg");
  intro = loadImage("images/intro.png"); 
  
  //load right-hand panel items
  filters = loadImage("images/filters.png"); 

  //load info box images into project
  infoBoxes = new PImage[25];
  for (int i=0; i<infoBoxes.length; i++){
    infoBoxes[i] = loadImage("images/airport/" + (i+1) + ".png"); 
  } 
  
  //load filter icons into project
  wifiIcons = new PImage[6]; 
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
  
  wifiTT = new PImage[3];
  hotelTT = new PImage[2];
  kidsTT = new PImage[2];
  petsTT = new PImage[2];
  transTT = new PImage[2];
  
  for(int i=0; i<wifiTT.length; i++){
     wifiTT[i] = loadImage("images/wifi/TT/" + i + ".png"); 
     
     if(i<2){
        hotelTT[i] = loadImage("images/hotel/TT/" + i + ".png"); 
        kidsTT[i] = loadImage("images/kids/TT/" + i + ".png"); 
        petsTT[i] = loadImage("images/pets/TT/" + i + ".png"); 
        transTT[i] = loadImage("images/transport/TT/" + i + ".png");  
     }
  }
  
  airlineTooltips = new PImage[5]; 
  airlineTooltips[0] = loadImage("images/AA/5.png"); 
  airlineTooltips[1] = loadImage("images/DL/5.png"); 
  airlineTooltips[2] = loadImage("images/SW/5.png"); 
  airlineTooltips[3] = loadImage("images/UN/5.png"); 
  airlineTooltips[4] = loadImage("images/US/5.png"); 
  
  airports = new ArrayList<Airport>();
  loadData(csv);
 }

void draw() {
  background(250, 247, 237);
  
  //draw main
  image(titleBar, 0, 0);
  shape(usa, 26, 96, 717, 424);
  image(intro, 0, 511); 
  
  //draw filter panel
  image(filters, right_align, 50.5, 190, 310); 

  //drawButtons
  drawAirlineButtons(airlineFilters); 
  drawBarFilters(wifiFilters, wifiLocs); 
  drawBarFilters(hotelFilters, hotelLocs); 
  drawBarFilters(kidsFilters, kidsLocs);
  drawBarFilters(petsFilters, petsLocs);
  drawBarFilters(transFilters, transLocs); 

  strokeWeight(1);
  processFilters(); 
  drawAirports();
  if(selectedAirport != null){
    drawInfoPanel(selectedAirport);
  }
  
  loadPixels(); 
  mouseUpdate();
  
  stroke(204, 102, 0);
}

// Debugging method
void printFlags(){
  print("Flags:\n\n");
  print("Airlines:\n");
  print(arrayToString(airlineFilters));
  print("Wifi:\n");
  print(arrayToString(wifiFilters));
  print("Hotels:\n");
  print(arrayToString(hotelFilters));
  print("Kids:\n");
  print(arrayToString(kidsFilters));
  print("Pets:\n");
  print(arrayToString(petsFilters));
  print("Transport:\n");
  print(arrayToString(transFilters));
  print("\n\n");
  
}

// Debugging method
String arrayToString(boolean[] array){
  String text = "";
  for(boolean item:array){ 
    text = text + item + ", ";
  } 
  return text+"\n";
}

void processFilters(){
  for(Airport airport:airports){
    boolean included = true;
    //if(airlineFilters[0] == airlineFilters[1] && airlineFilters[1] == airlineFilters[2] && airlineFilters[2] == airlineFilters[3] && airlineFilters[3] == airlineFilters[4]){

    //}
    if(!airlineFilters[0] && !airlineFilters[1] && !airlineFilters[2] && !airlineFilters[3] && !airlineFilters[4]){
        //if aa = dl and dl = sw and 
    }
    else{
      if(airlineFilters[0] == true && airport.getAa() == Airport.Presence.NO){
        included = false;
      }
      if(airlineFilters[1] == true && airport.getDl() == Airport.Presence.NO){
        included = false;
      }
      if(airlineFilters[2] == true && airport.getWn() == Airport.Presence.NO){
        included = false;
      }
      if(airlineFilters[3] == true && airport.getUa() == Airport.Presence.NO){
        included = false;
      }
      if(airlineFilters[4] == true && airport.getUs() == Airport.Presence.NO){
        included = false;
      }
    }
    
    if(wifiFilters[0] == wifiFilters[1] && wifiFilters[1] == wifiFilters[2]){
      
    }
    else{
      boolean matches = false;
      if(wifiFilters[0] == true && airport.getWifi().equals("f")){
        matches = true;
      }
      if(wifiFilters[2] == true && airport.getWifi().equals("r")){
        matches = true;
      }
      if(wifiFilters[1] == true && airport.getWifi().contains("/")){
        matches = true;
      }
      
      included = included && matches;
    }
    
    if(hotelFilters[0] == hotelFilters[1]){
      
    }
    else{
      if(hotelFilters[0] == true && !airport.isHotel()){
        included = false;
      }
      if(hotelFilters[1] == true && airport.isHotel()){
        included = false;
      }
    }
    
    if(kidsFilters[0] == kidsFilters[1]){
      
    }
    else{
      if(kidsFilters[0] == true && !airport.isKids()){
        included = false;
      }
      if(kidsFilters[1] == true && airport.isKids()){
        included = false;
      }
      
    }
    
    if(petsFilters[0] == petsFilters[1]){
      
    }
    else{
      if(petsFilters[0] == true && !airport.isPet()){
        included = false;
      }
      if(petsFilters[1] == true && airport.isPet()){
        included = false;
      }
      
    }
    if(transFilters[0] == transFilters[1]){
      
    }
    else{
      if(transFilters[0] == true && !airport.isTrans()){
        included = false;
      }
      if(transFilters[1] == true && airport.isTrans()){
        included = false;
      }
      
    }
    
    airport.setEnable(included);
  }
}

//---------These methods draw stuff to the screen---------//
void drawInfoPanel(Airport a){//draw the info
  if(displayRank >= 0){
    image(infoBoxes[displayRank-1], right_align, 379.5, 190, 225.973);  
   
    //draw icons in row one
    String aa = "" + a.getAa(); 
    String dl = "" + a.getDl(); 
    String sw = "" + a.getWn(); 
    String un = "" + a.getUa(); 
    String us = "" + a.getUs(); 
    
    if(aa.equals("NO")){
      image(AA[2], 786.004, 454.155, 30, 30); 
    } else if(aa.equals("YES")){
      image(AA[3], 786.004, 454.155, 30, 30); 
    } else{
      image(AA[4], 786.004, 454.155, 30, 30); 
    }
    
    if(dl.equals("NO")){
      image(DL[2], 820.961, 454.155, 30, 30); 
    } else if(dl.equals("YES")){
      image(DL[3], 820.961, 454.155, 30, 30); 
    } else{
      image(DL[4], 820.961, 454.155, 30, 30); 
    }
    
    if(sw.equals("NO")){
      image(SW[2], 855.918, 454.155, 30, 30); 
    } else if(sw.equals("YES")){
      image(SW[3], 855.918, 454.155, 30, 30); 
    } else{
      image(SW[4], 855.918, 454.155, 30, 30); 
    }
    
    if(un.equals("NO")){
      image(UN[2], 890.875, 454.155, 30, 30); 
    } else if(un.equals("YES")){
      image(UN[3], 890.875, 454.155, 30, 30); 
    } else{
      image(UN[4], 890.875, 454.155, 30, 30); 
    }
    
    if(us.equals("NO")){
      image(US[2], 925.832, 454.155, 30, 30); 
    } else if(us.equals("YES")){
      image(US[3], 925.832, 454.155, 30, 30); 
    } else{
      image(US[4], 925.832, 454.155, 30, 30); 
    }
    //draw icons in row two
    if(a.getWifi().equals("f")){
       image(wifiIcons[0], 781.552, 545.685, 36.088, 53.817); 
    } else if(a.getWifi().equals("r")){
       image(wifiIcons[2], 781.552, 545.685, 36.088, 53.817); 
    } else{
       image(wifiIcons[1], 781.552, 545.685, 36.088, 53.817); 
       
       if(displayRank==1){
         image(wifiIcons[3], 781.552, 545.685, 36.088, 53.817); 
       } else if(displayRank==2){
         image(wifiIcons[4], 781.552, 545.685, 36.088, 53.817); 
       } else{
         image(wifiIcons[5], 781.552, 545.685, 36.088, 53.817);  
       }
    }
    
    if(a.isHotel()){
       image(hotelIcons[0], 816.327, 545.685, 36.088, 53.817);  
    } else {
      image(hotelIcons[1], 816.327, 545.685, 36.088, 53.817);  
    }
    
    if(a.isKids()){
       image(kidsIcons[0], 851.826, 545.685, 36.088, 53.817);  
    } else{
       image(kidsIcons[1], 851.826, 545.685, 36.088, 53.817);  
    }
    
    if(a.isPet()){
       image(petsIcons[0], 888.082, 545.685, 36.088, 53.817);  
    } else{
       image(petsIcons[1], 888.082, 545.685, 36.088, 53.817);  
    }
    
    if(a.isTrans()){
       image(transIcons[0], 923.789, 545.685, 36.088, 53.817);  
    } else{
       image(transIcons[1], 923.789, 545.685, 36.088, 53.817);  
    }
  }
}

void drawAirlineButtons(boolean[] arr){
  if (!arr[0]){
    image(AA[0], 784.588, 98.831, 31.523, 31.523);
  } else{
    image(AA[1], 784.588, 98.831, 31.523, 31.523); 
  }
  
  if (!arr[1]){
    image(DL[0], 818.918, 98.831, 31.523, 31.523); 
  } else { 
    image(DL[1], 818.918, 98.831, 31.523, 31.523); 
  }
  
  if (!arr[2]){
    image(SW[0], 853.278, 98.831, 31.523, 31.523); 
  } else { 
    image(SW[1], 853.278, 98.831, 31.523, 31.523); 
  }
  
  if (!arr[3]){
    image(UN[0], 887.638, 98.831, 31.523, 31.523); 
  } else { 
    image(UN[1], 887.638, 98.831, 31.523, 31.523); 
  }
  
  if (!arr[4]){
    image(US[0], 921.998, 98.831, 31.523, 31.523); 
  } else { 
    image(US[1], 921.998, 98.831, 31.523, 31.523); 
  }
}

void drawAirports(){
  for(int i = 0; i<airports.size();i++){
    Airport airport = airports.get(i);
    int radius = getAirportSize(airport);
//    int radius = Math.round(airport.getPas_2012()/45798809.0*24);
//    text(airport.getName(),airport.getX()-5,airport.getY()-5);
//    if enabled, fill(204, 102, 0); else grey out

    if(airport.enabled()){
      stroke(20, 20, 20); 
      fill(164, 135, 96);
      ellipse(airport.getX(), airport.getY(),radius, radius);
    }
    else{
      stroke(150, 150, 150); 
      fill(204, 204, 204, 200);
      ellipse(airport.getX(), airport.getY(),radius, radius);
    }
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
  stroke(0, 0, 0, 110); 
  strokeWeight(3); 
  noFill();

  for(int i=0; i<bools.length; i++){
     if(bools[i]){
        rect(locs[i][0]+2, locs[i][1]+2, locs[i][2]-4, locs[i][3]-5); 
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
        
        noStroke();
        fill(255,255,255,100); 
        ellipseMode(CENTER); 
        ellipse(aPos.x, aPos.y, diameter, diameter); 
        
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
            ellipse(aPos.x, aPos.y, 32, 32); 
            //get msg
            //PVector drawPos = new PVector(mouseX, mouseY);
            //String[] msgs = {"American Airlines", "Delta Airlines", "Southwest Airlines", "United Airlines", "US Airways"};
              
            //drawTooltip(drawPos, msgs[i]);  
            
            PVector[] drawPos = {new PVector(773, 61), new PVector(807, 61), new PVector(841, 61), new PVector(875, 61), new PVector(910, 61)};
            image(airlineTooltips[i], drawPos[i].x, drawPos[i].y);             
            
              
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
                   
               //String[] msgs = {"Free wifi: 68%", "Paid Wifi, 20%", "Free Limited Access Wifi, 12%"}; 
               //PVector drawPos = new PVector(mouseX, mouseY); 
                   
               //drawTooltip(drawPos, msgs[i]); 
               
               PVector[] drawPos = {new PVector(796, 116), new PVector(871, 116), new PVector(897, 116)}; 
               image(wifiTT[i], drawPos[i].x, drawPos[i].y); 
               
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
                   
             // String[] msgs = {"On-site Hotel Available, 40%", "No On-site Hotel, 60%"}; 
              //PVector drawPos = new PVector(mouseX, mouseY); 
                   
              //drawTooltip(drawPos, msgs[i]); 
              
              PVector[] drawPos = {new PVector(773, 159), new PVector(857, 159)}; 
              image(hotelTT[i], drawPos[i].x, drawPos[i].y); 
               
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
                   
              //String[] msgs = {"Play areas available, 56%", "No Play areas, 44%"}; 
              //PVector drawPos = new PVector(mouseX, mouseY); 
                   
              //drawTooltip(drawPos, msgs[i]); 
              
              PVector[] drawPos = {new PVector(786, 204), new PVector(869, 204)}; 
              image(kidsTT[i], drawPos[i].x, drawPos[i].y); 
               
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
                   
              //String[] msgs = {"Pet areas available, 92%", "No pet friendly zones, 8%"}; 
              //PVector drawPos = new PVector(mouseX, mouseY); 
                   
              //drawTooltip(drawPos, msgs[i]); 
               
              PVector[] drawPos = {new PVector(815, 246), new PVector(902, 246)}; 
              image(petsTT[i], drawPos[i].x, drawPos[i].y);  
               
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
                   
              //String[] msgs = {"Public transport to city center available, 56%", "No Public Transport to City Center, 44%"}; 
              //PVector drawPos = new PVector(mouseX, mouseY); 
                   
              //drawTooltip(drawPos, msgs[i]); 
              
              PVector[] drawPos = {new PVector(782, 287), new PVector(869, 287)}; 
              image(transTT[i], drawPos[i].x, drawPos[i].y); 
               
              break;
            }
         }  
     }
      
  } 
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
          int temp = 0;
          
          for(int i=0; i< wifiLocs.length; i++){
            float x = wifiLocs[i][0]; 
            float y = wifiLocs[i][1]; 
            float w = wifiLocs[i][2]; 
            float h = wifiLocs[i][3]; 
                 
            if(withinRectangle(x, y, w, h)){    
               temp = i;            
               wifiFilters[i] = !wifiFilters[i]; 
               break;
            }
         }
          if(wifiFilters[0] && wifiFilters[1] && wifiFilters[2]){
             wifiFilters[0] = false; 
             wifiFilters[1] = false; 
             wifiFilters[2] = false; 
             wifiFilters[temp] = true;
          } 
       } else if (mouseY>195 && mouseY<218){
           int temp = 0; 
           
           for(int i=0; i<hotelLocs.length; i++){
             float x = hotelLocs[i][0]; 
             float y = hotelLocs[i][1]; 
             float w = hotelLocs[i][2]; 
             float h = hotelLocs[i][3]; 
                 
             if(withinRectangle(x, y, w, h)){      
               temp = i;          
               hotelFilters[i] = !hotelFilters[i]; 
               break;
            }
           } 
          
           if(hotelFilters[0] && hotelFilters[1]){
             hotelFilters[0] = false; 
             hotelFilters[1] = false; 
             hotelFilters[temp] = true; 
           } 
       } else if (mouseY>240 && mouseY<261){
           int temp = 0; 
           
           for(int i=0; i<kidsLocs.length; i++){
             float x = kidsLocs[i][0]; 
             float y = kidsLocs[i][1]; 
             float w = kidsLocs[i][2]; 
             float h = kidsLocs[i][3]; 
                 
             if(withinRectangle(x, y, w, h)){  
               temp = i;              
               kidsFilters[i] = !kidsFilters[i]; 
               break;
             }
           } 
          
           if(kidsFilters[0] && kidsFilters[1]){
             kidsFilters[0] = false; 
             kidsFilters[1] = false; 
             kidsFilters[temp] = true;
           }
       } else if (mouseY>285 && mouseY<305){
           int temp = 0; 
         
           for(int i=0; i<petsLocs.length; i++){
             float x = petsLocs[i][0]; 
             float y = petsLocs[i][1]; 
             float w = petsLocs[i][2]; 
             float h = petsLocs[i][3]; 
                 
             if(withinRectangle(x, y, w, h)){    
               temp = i;            
               petsFilters[i] = !petsFilters[i]; 
               break;
             }
           } 
          
           if(petsFilters[0] && petsFilters[1]){
             petsFilters[0] = false; 
             petsFilters[1] = false; 
             petsFilters[temp] = true;
           }  
       } else if (mouseY>327 && mouseY<348){
           int temp = 0; 
           
           for(int i=0; i<transLocs.length; i++){
             float x = transLocs[i][0]; 
             float y = transLocs[i][1]; 
             float w = transLocs[i][2]; 
             float h = transLocs[i][3]; 
                 
             if(withinRectangle(x, y, w, h)){     
               temp = i;           
               transFilters[i] = !transFilters[i]; 
               break;
             }
           } 
          
           if(transFilters[0] && transFilters[1]){
             transFilters[0] = false; 
             transFilters[1] = false; 
             transFilters[temp] = true;
           }  
       }
  }
    printFlags();
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

