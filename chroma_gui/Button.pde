class Button {
  PFont font;
  String type = "default";
  boolean pressed = false;
  int x, y, w, h;
  String label = "";
  boolean mouseOver = false;
  boolean active = false;

  Button(int in_x, int in_y, int in_w, int in_h) {
    //type = typ;
    //if (in_label != null) {
    //  label = in_label;
    //}
    x = in_x;
    y = in_y;
    w = in_w;
    h = in_h;
    //font = createFont("SourceCodePro-Medium", 24);
    //textFont(font);
    //textSize(12);
  }

  void reset() {
    active = false;
    pressed = false;
  }

  void drawButton() {
    pushStyle();
    noStroke();
    if (mouseOver) {
      fill(255, 127);
    } else if (active) {
      stroke(255);
      strokeWeight(2);
      noFill();
      //fill(255, 255, 255, 127);
    } else {
      noFill();
      //fill(255, 0, 0, 127);
    }
    rect(x, y, w, h);
    //if (type == "default") {
    //  if (label != null) {
    //    fill(255);
    //    text("TESTE", x, y);
    //  }
    //}
    popStyle();
  }

  void mouseOv() {
    if (!active) {
      if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h) {
        mouseOver = true;
        //cursor(HAND);
      } else {
        mouseOver = false;
        //cursor(ARROW);
      }
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
