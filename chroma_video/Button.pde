class Button {
  PFont font;
  String type = "default";
  boolean pressed = false;
  int x, y, w, h;
  String label = "";
  boolean mouseOver = false;
  boolean active = false;

  Button(int in_x, int in_y, int in_w, int in_h) {
    x = in_x;
    y = in_y;
    w = in_w;
    h = in_h;
    rectMode(CENTER);
  }
  
  void reset(){
    active = false;
    pressed = false;
  }

  void drawButton() {
    noStroke();
    if(mouseOver){
      fill(255, 0, 0, 127);
    }
    else if(active){
      stroke(255);
      strokeWeight(2);
      fill(255, 255, 255, 127);
    }
    else{
      noFill();
    }
    rect(x+15, y+15, w, h, 6);
  }
  
  void mouseOv(){
    if(mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h){
      mouseOver = true;
    }
    else{
      mouseOver = false;
    }
  }

  boolean clicked() {
    if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h) {
      active = !active;
      return true;
    } else {
      return false;
    }
  }
}
