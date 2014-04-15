PImage titleBar, directions, filters, kids, hotel, pets, transport, wifi;
PShape usa;
boolean wifi_fh = false, hotel_fh = false, kids_fh = false, pets_fh = false, transport_fh = false; //hover over checkboxes
boolean wifi_sel = false, hotel_sel = false, kids_sel = false, pets_sel = false, transport_sel = false; //vars for which filters are selected
int barX = 750, barY = 354; //next starting location of the bargraphs that appear when you select a filter

void setup() {
  size(1000, 600);  

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
  
}

void draw() {
  background(250, 247, 237);
  
  //draw main
  image(titleBar, 0, 0, 715, 88);
  shape(usa, 0, 88, 717, 512);
  
  //draw right-hand panel, minus the extra stats
  image(directions, 747, 70, 198, 170);
  image(filters, 747, 240, 198, 114); 
  
  //check if hovering over any filters
  checkFH();

  //draw checkboxes
  drawCB(wifi_fh, 750, 265, 8, 8); //wifi checkbox
  drawCB(hotel_fh, 750, 281, 8, 8); //on-site hotel checkbox
  drawCB(kids_fh, 750, 296, 8, 8); //kids zone checkbox
  drawCB(pets_fh, 750, 312, 8, 8); //pet care checkbox
  drawCB(transport_fh, 750, 327, 8, 8); //transportation checkbox
  
  //draw the X in the checkbox if the filter is selected
  drawCheck(wifi_sel, 750, 265, 8, 8); 
  drawCheck(hotel_sel, 750, 281, 8, 8); 
  drawCheck(kids_sel, 750, 296, 8, 8); 
  drawCheck(pets_sel, 750, 312, 8, 8); 
  drawCheck(transport_sel, 750, 327, 8, 8); 
  
  //if a filter is selected, draw selected bar chart
  drawBar(wifi_sel, wifi, barX, barY, 354, 41);
  drawBar(hotel_sel, hotel, barX, barY, 395, 41);
  drawBar(kids_sel, kids, barX, barY, 436, 41);
  drawBar(pets_sel, pets, barX, barY, 477, 41);
  drawBar(transport_sel, transport, barX, barY, 518, 0); 
  barY = 354; 
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

//-------These methods have to do with mouse interaction------//

//check filter checkbox hover
void checkFH(){
  //check mouse over wifi filter checkbox
  if(mouseX>750 && mouseX < 786 && mouseY>265 && mouseY<273){
    wifi_fh = true; 
  } else { 
    wifi_fh = false; 
  }
  
  //check mouse over hotel filter checkbox
  if(mouseX>750 && mouseX < 842 && mouseY>281 && mouseY<289){
    hotel_fh = true; 
  } else { 
    hotel_fh = false; 
  }
  
  //check mouse over kids filter checkbox
  if(mouseX>750 && mouseX < 830 && mouseY>297 && mouseY<305){
    kids_fh = true; 
  } else { 
    kids_fh = false; 
  }
  
  //check mouse over pet filter checkbox
  if(mouseX>750 && mouseX < 812 && mouseY>312 && mouseY<320){
    pets_fh = true; 
  } else { 
    pets_fh = false; 
  }
  
  //check mouse over transport filter checkbox
  if(mouseX>750 && mouseX < 932 && mouseY>327 && mouseY<335){
    transport_fh = true; 
  } else { 
    transport_fh = false; 
  }
}

void mousePressed(){
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
}
