class Config{
  PFont font;
  PImage bar;
  int marginLeft = 20;
  int offset_x, offset_y, w, h;
  Button[] buttons;
  
  Config(){
    font = createFont("SourceCodePro-Medium", 24);
    textFont(font);
    textSize(12);
    bar = loadImage("config-bar-b.png");
    offset_x = 0;
    offset_y = 0;
    w = (int)(width*0.25);
    h = (int)(height*0.5);
    buttons = new Button[9];
    buttons[0] = new Button(20, height-40, 30, 30); // eyedropper, ok
    buttons[1] = new Button(53, height-40, 30, 30); // overlay, ok
    buttons[2] = new Button(103, height-40, 30, 30); // move
    buttons[3] = new Button(136, height-40, 30, 30); // resize
    buttons[4] = new Button(169, height-40, 30, 30); // crop
    buttons[5] = new Button(202, height-40, 30, 30); // mask projection
    buttons[6] = new Button(252, height-40, 30, 30); // filter
    buttons[7] = new Button(302, height-40, 30, 30); // save
    buttons[8] = new Button(352, height-40, 30, 30); // close
  }
  
  void drawMenu(){
    smooth();
    image(bar, 0, height-50, 402, 50);
    for(int i = 0; i < buttons.length; i++){
      buttons[i].drawButton();
    }
  }
  
  int clicked(){
    for(int i = 0; i < buttons.length; i++){
      if(buttons[i].clicked()){
        return i+1;
      }
    }
    return 0;
  }
  
  void deactivateButtons(int except){
    for(int i = 0; i < buttons.length; i++){
      if(i != except){
        buttons[i].active = false;
      }
    }
  }
}
