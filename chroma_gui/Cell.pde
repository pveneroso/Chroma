class Cell {
  int x, y, w, h;

  boolean clicked = false;
  boolean selected = false;
  //boolean hover = false;

  int id;
  String filename;

  Cell(int in_x, int in_y, int in_w, int in_h) {
    w = in_w;
    h = in_h;
    x = in_x;
    y = in_y;
  }

  void updateInfo(int in_id, String in_filename) {
    id = in_id;
    filename = in_filename;
  }

  void monitor() {
    if (hover() && !selected) {
      fill(255, 72);
      rect(x, y, w, h);
    }
    else if(selected){
      pushStyle();
      noFill();
      strokeWeight(2);
      stroke(0);
      //fill(255, 0, 0, 72);
      rect(x, y, w, h);
      popStyle();
    }
  }

  boolean hover() {
    if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h) {
      return true;
      //return true;
    } else {
      return false;
    }
  }
  
  void clicked() {
    if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h) {
      selected = !selected;
      clicked = true;
    }
  }
}
