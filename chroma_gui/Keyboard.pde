class Keyboard {
  String[][] rows = {{"1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "+", "Delete"},
    {"q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "_", "~"},
    {"a", "s", "d", "f", "g", "h", "j", "k", "l", "@", "Enter"},
    {"z", "x", "c", "v", "b", "n", "m", ".", ".com", ".br"}}; // {"Space"}

  int spacing = 10;
  int size = 60;

  int offsetX = 100;
  int offsetY = 200;

  PFont keyFont;
  
  Keys[] keys;

  Keyboard() {
    size = (int)(width*0.05);
    spacing = (int)(width*0.007);
    offsetX = (int)((width-(rows[0].length*size)-(spacing*(rows[0].length-1)))/2);
    //println(rows[0].length*size);
    offsetY = (int)((height-((rows.length*size)+(spacing*(rows.length-1))))-(height*0.22));
    
    keyFont = createFont("SourceCodePro-Regular", 32);
    textFont(keyFont);
    textSize(28);
    textAlign(CENTER);
    
    //rectMode(CENTER);
    keys = new Keys[46];
    this.createKeyboard();
  }
  
  void createKeyboard(){
    int index = 0;
    for (int i = 0; i < rows.length; i++) {
      for (int j = 0; j < rows[i].length; j++) {
        keys[index] = new Keys(rows[i][j], index);
        
        //fill(255);
        int sizey = size;
        int sizex = size;
        int posx = spacing+(j*size)+(j*spacing);
        int posy = spacing+(i*size)+(i*spacing);
        posx += ((size/2)*i) + offsetX;
        posy += offsetY;
        if (rows[i][j] == "Delete" || rows[i][j] == "Enter") {
          sizex*=1.6;
          //rect(posx, posy, size*1.6, size, size/6);
          //fill(0);
          //text(rows[i][j], posx+((size*1.6)/2), posy+(size/2)+7);
        }
        else if (rows[i][j] == "Space") {
          posx += (size*1.8);
          sizex *= 6;
          keys[index].disableText();
          //rect(posx, posy, size*6, size, size/6);
          //fill(0);
        }
        else {
          //rect(posx, posy, size, size, size/6);
          //fill(0);
          //text(rows[i][j], posx+(size/2), posy+(size/2)+7);
        }
        
        keys[index].setPosition(posx, posy);
        keys[index].setSize(sizex, sizey);
        index++;
      }
    }
  }

  void showKeyboard() {
    for(int i = 0; i < keys.length; i++){
      keys[i].showKey();
    }
    this.checkHover();
    //for (int i = 0; i < rows.length; i++) {
    //  for (int j = 0; j < rows[i].length; j++) {
    //    fill(255);
    //    int posx = spacing+(j*size)+(j*spacing);
    //    int posy = spacing+(i*size)+(i*spacing);
    //    posx += ((size/2)*i) + offsetX;
    //    posy += offsetY;
    //    if (rows[i][j] == "Delete" || rows[i][j] == "Enter") {
    //      rect(posx, posy, size*1.6, size, size/6);
    //      fill(0);
    //      text(rows[i][j], posx+((size*1.6)/2), posy+(size/2)+7);
    //    }
    //    else if (rows[i][j] == "Space") {
    //      posx += (size*1.8);
    //      rect(posx, posy, size*6, size, size/6);
    //      fill(0);
    //    }
    //    else {
    //      rect(posx, posy, size, size, size/6);
    //      fill(0);
    //      text(rows[i][j], posx+(size/2), posy+(size/2)+7);
    //    }
    //  }
    //}
  }
  
  void checkHover(){
    for(int i = 0; i < keys.length; i++){
      keys[i].hover();
    }
  }
  
  String checkClick(){
    String clickedKey = "";
    for(int i = 0; i < keys.length; i++){
      if(keys[i].click()){
        clickedKey = keys[i].text;
      }
    }
    return clickedKey;
  }

  void hideKeyboard() {
  }
}
