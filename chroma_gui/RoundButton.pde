class RoundButton {
  PFont font;
  String type = "default";
  boolean pressed = false;
  int x, y, w, h;
  String label = "";
  boolean mouseOver = false;
  boolean active = false;

  PShape icon;

  RoundButton(int in_x, int in_y, int in_w, int in_h, String in_img) {
    x = in_x;
    y = in_y;
    w = in_w;
    h = in_h;
    icon = loadShape(in_img);
    //icon.setFill(225);
    icon.disableStyle();
  }

  void reset() {
    active = false;
    pressed = false;
  }

  void drawButton() {
    this.mouseOv();
    pushStyle();
    noStroke();
    if (mouseOver) {
      fill(255, 127);
    } else if (active) {
      stroke(30);
      strokeWeight(2);
      noFill();
    } else {
      fill(0, 149, 218);
    }
    ellipse(x, y, w, h);
    fill(30);
    shape(icon, x -(w*0.2), y-(h*0.2), w*0.4, h*0.4);
    popStyle();
  }

  void mouseOv() {
    if (!active) {
      if (dist(mouseX, mouseY, x, y) < w/2) {
        //println("go");
        mouseOver = true;
        //cursor(HAND);
      } else {
        mouseOver = false;
        //cursor(ARROW);
      }
    }
  }

  boolean clicked() {
    if (dist(mouseX, mouseY, x, y) < w/2) {
      //active = !active;
      return true;
    } else {
      return false;
    }
  }
}
