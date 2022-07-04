class Keys {
  String text;
  int id;

  int x, y, w, h;

  boolean active = false;
  boolean clicked = false;
  boolean showText = true;
  
  int rgb = 255;

  Keys(String txt, int in_id) {
    text = txt;
    id = in_id;
  }

  void setPosition(int in_x, int in_y) {
    x = in_x;
    y = in_y;
  }

  void setSize(int in_w, int in_h) {
    w = in_w;
    h = in_h;
  }

  void disableText() {
    showText = false;
  }

  void showKey() {
    textSize(20);
    textAlign(CENTER);
    fill(rgb);
    rect(x, y, w, h, h/6);
    if (showText) {
      fill(0);
      text(text.toUpperCase(), x+(w/2), y+(h/2)+6);
    }
  }
  
  void hover(){
    if(mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h){
      rgb = 127;
      //return true;
    }
    else{
      rgb = 255;
    }
  }
  
  boolean click(){
    if(mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h){
      return true;
    }
    else{
      return false;
    }
  }
}
