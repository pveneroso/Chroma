import processing.video.*;

XML xml, bgxml;
Capture movie;
Chroma chroma;
Config config;

boolean cmd = false;
boolean enableConfig = false;
boolean enableEyedropper = false;
boolean enableMask = false;
int changeMask = 0;
boolean enableCrop = false;
int changeCrop = 0;
boolean enableScale = false;
boolean enableReposition = false;
boolean check = false;

int file_counter = 0;
String filename_current;
String folder;

String imagesPath = "";
String thumbsPath = "";

PVector[] maskCoordinates;
PShape mask;

int currentImage;
int shouldSave = 0;
int interval = 10;

void setup() {
  size(1280, 720);
  //fullScreen(1);
  String[] cameras = Capture.list();
  //printArray(cameras);
  movie = new Capture(this, width, height, cameras[0]);
  movie.start();
  smooth();
  chroma = new Chroma(movie);
  config = new Config();
  xml = loadXML("config.xml");
  setupConfig();
  filename_current = "itinerarios-";
  folder = year()+""+formatDate(month())+""+formatDate(day());
  checkFolder();
  file_counter = get_filecounter();
}

void captureEvent(Capture video) {
  video.read();
}

void draw() {
  //println(frameRate);
  if (enableConfig) {
    chroma.processChroma();
    drawMask();
    config.drawMenu();
    for (int i = 0; i < config.buttons.length; i++) {
      config.buttons[i].mouseOv();
    }
    if (enableEyedropper) {
      pushMatrix();
      translate(mouseX, mouseY);
      if(chroma.getStelle() >=0 && chroma.getStelle() < chroma.frame.pixels.length){
        fill(chroma.frame.pixels[chroma.getStelle()]);
      }
      ellipse(0, 0, 30, 30);
      popMatrix();
      pushMatrix();
      fill(chroma.r_key, chroma.g_key, chroma.b_key);
      rect(10, 10, 100, 100);
      popMatrix();
    }
  } else {
    chroma.processChroma();
    if (second()%interval == 0 && check) {
      // se a sala tiver movimento
      if(shouldSave == 1){
        save("../Imagens/"+folder+"/itinerarios-"+(file_counter+1)+".jpg");
        file_counter++;
      }
      check = false;

      // FLASH WHITE
      pushStyle();
      fill(255);
      rectMode(CORNER);
      rect(0, 0, width, height);
      popStyle();
    } else if(second()%interval == 5 && check){
      checkBackground();
      check=false;
    } else if (second()%interval != 0) {
      check=true;
    }
    drawMask();
  }
}

void mousePressed() {
  if (enableConfig) {
    if (enableEyedropper) {
      if (mouseX > 0 && mouseX < 402 && mouseY<height && mouseY > height-50) {
        // nothing
      } else {
        if(chroma.getStelle() >=0 && chroma.getStelle() < chroma.frame.pixels.length){
          chroma.updateReference();
        }
      }
    }

    int click = config.clicked();

    if (click == 1) { // EYEDROPPER
      disableButtons();
      enableEyedropper = !enableEyedropper;
    } else if (click == 2) { // OVERLAY
      disableButtons();
      if (!chroma.toggleMaintenance) {
        chroma.toggleMaintenance();
        chroma.toggleMaintenance = true;
      } else {
        chroma.loadBackground();
        chroma.toggleMaintenance = false;
      }
    } else if (click == 3) { // MOVE
      boolean tmp = !enableReposition;
      disableButtons();
      enableReposition = tmp;
    } else if (click == 4) { // RESIZE
      boolean tmp = !enableScale;
      disableButtons();
      enableScale = tmp;
    } else if (click == 5) { // CROP
      boolean tmp = !enableCrop;
      disableButtons();
      enableCrop = tmp;
    } else if (click == 6) { // MASK
      boolean tmp = !enableMask;
      disableButtons();
      enableMask = tmp;
    } else if (click == 8) { // SAVE
      saveConfig();
      closeConfig();
    } else if (click == 9) { // CLOSE
      closeConfig();
    } else if (enableMask) {
      if (changeMask > 0) {
        maskCoordinates[changeMask+3].x = mouseX-(width/2);
        maskCoordinates[changeMask+3].y = mouseY-(height/2);
      }
    } else if (enableCrop) {
      //println(changeCrop);
      if (changeCrop == 1) { // LEFT
        chroma.cutLeft[chroma.currentImage] = mouseX;
      } else if (changeCrop == 2) { // RIGHT
        chroma.cutRight[chroma.currentImage] = width-mouseX;
      } else if (changeCrop == 3) {
        chroma.cutTop[chroma.currentImage] = mouseY; // TOP
      } else if (changeCrop == 4) {
        chroma.cutBottom[chroma.currentImage] = height-mouseY; // BOTTOM
      }
    }
  }
}

void disableButtons() {
  enableMask = false;
  changeMask = 0;
  enableCrop = false;
  changeCrop = 0;
  enableScale = false;
  enableReposition = false;
}

void keyPressed() {
  // Ativação de interface de configuração

  if (keyCode == CONTROL) {
    cmd = true;
  }
  if (cmd == true) {
    if (keyCode == 67) {
      enableConfig = !enableConfig;
      if (enableConfig) {
        //chroma.toggleMaintenance();
      } else {
        closeConfig();
      }
    }
  }
}

void keyReleased() {
  //println(keyCode);
  if (keyCode == CONTROL) {
    cmd = false;
  }
  if (enableMask) {
    if (key == '1') {
      changeMask = 1;
    } else if (key == '2') {
      changeMask = 2;
    } else if (key == '3') {
      changeMask = 3;
    } else if (key == '4') {
      changeMask = 4;
    } else if (keyCode == ENTER || keyCode == RETURN) {
      disableButtons();
      config.buttons[5].active = false;
    }
  } else if (enableCrop) {
    if (key == '1') {
      changeCrop = 1;
    } else if (key == '2') {
      changeCrop = 2;
    } else if (key == '3') {
      changeCrop = 3;
    } else if (key == '4') {
      changeCrop = 4;
    } else if (changeCrop > 0 && key == 'x') {
      if (changeCrop == 1) {
        chroma.cutLeft[chroma.currentImage] = 0;
      } else if (changeCrop == 2) {
        chroma.cutRight[chroma.currentImage] = 0;
      } else if (changeCrop == 3) {
        chroma.cutTop[chroma.currentImage] = 0;
      } else if (changeCrop == 4) {
        chroma.cutBottom[chroma.currentImage] = 0;
      }
    } else if (keyCode == ENTER || keyCode == RETURN) {
      disableButtons();
      config.buttons[4].active = false;
    }
  } else if (enableEyedropper) {
    if (key == 'x') {
      chroma.r_key = 0;
      chroma.g_key = 255;
      chroma.b_key = 0;
      chroma.convertReferenceColor();
    }
  } else if (enableReposition) {
    if (key == 'd') {
      chroma.offsetX[chroma.currentImage] += 10;
    } else if (key == 'a') {
      chroma.offsetX[chroma.currentImage] -= 10;
    } else if (key == 'w') {
      chroma.offsetY[chroma.currentImage] -= 10;
    } else if (key == 's') {
      chroma.offsetY[chroma.currentImage] += 10;
    } else if (keyCode == 39) {
      chroma.offsetX[chroma.currentImage] += 1;
    } else if (keyCode == 37) {
      chroma.offsetX[chroma.currentImage] -= 1;
    } else if (keyCode == 38) {
      chroma.offsetY[chroma.currentImage] -= 1;
    } else if (keyCode == 40) {
      chroma.offsetY[chroma.currentImage] += 1;
    } else if (key == 'x') {
      chroma.offsetX[chroma.currentImage] = 0;
      chroma.offsetY[chroma.currentImage] = 0;
    } else if (keyCode == ENTER || keyCode == RETURN) {
      disableButtons();
      config.buttons[2].active = false;
    }
  } else if (enableScale) {
    if (key == 'm') {
      chroma.sizeX[chroma.currentImage] += 16;
      chroma.sizeY[chroma.currentImage] += 9;
    } else if (key == 'n') {
      chroma.sizeX[chroma.currentImage] -= 16;
      chroma.sizeY[chroma.currentImage] -= 9;
    } else if (key == 'x') {
      chroma.sizeX[chroma.currentImage] = width;
      chroma.sizeY[chroma.currentImage] = height;
    } else if (keyCode == ENTER || keyCode == RETURN) {
      disableButtons();
      config.buttons[3].active = false;
    }
  }
}

// CONFIGURATION & XML

void closeConfig() {
  disableButtons();
  enableConfig = false;
  enableEyedropper = false;
  enableMask = false;
  chroma.toggleMaintenance = false;
  chroma.loadBackground();
  resetButtons();
}

void resetButtons() {
  for (int i = 0; i < config.buttons.length; i++) {
    config.buttons[i].reset();
  }
}

void setupConfig() {
  chroma.r_key = xml.getChild("color").getInt("r");
  chroma.g_key = xml.getChild("color").getInt("g");
  chroma.b_key = xml.getChild("color").getInt("b");
  chroma.tola = xml.getChild("tol").getInt("a");
  chroma.tolb = xml.getChild("tol").getInt("b");
  chroma.cutLeft[0] = (int)(xml.getChild("firstimage").getFloat("cutl")*width);
  chroma.cutRight[0] = (int)(xml.getChild("firstimage").getFloat("cutr")*width);
  chroma.cutTop[0] = (int)(xml.getChild("firstimage").getFloat("cutt")*height);
  chroma.cutBottom[0] = (int)(xml.getChild("firstimage").getFloat("cutb")*height);
  chroma.offsetX[0] = xml.getChild("firstimage").getInt("offx");
  chroma.offsetY[0] = xml.getChild("firstimage").getInt("offy");
  chroma.sizeX[0] = xml.getChild("firstimage").getInt("sizex");
  chroma.sizeY[0] = xml.getChild("firstimage").getInt("sizey");
  chroma.cutLeft[1] = (int)(xml.getChild("secondimage").getFloat("cutl")*width);
  chroma.cutRight[1] = (int)(xml.getChild("secondimage").getFloat("cutr")*width);
  chroma.cutTop[1] = (int)(xml.getChild("secondimage").getFloat("cutt")*height);
  chroma.cutBottom[1] = (int)(xml.getChild("secondimage").getFloat("cutb")*height);
  chroma.sizeX[1] = xml.getChild("secondimage").getInt("sizex");
  chroma.sizeY[1] = xml.getChild("secondimage").getInt("sizey");
  chroma.offsetX[1] = xml.getChild("secondimage").getInt("offx");
  chroma.offsetY[1] = xml.getChild("secondimage").getInt("offy");
  imagesPath = xml.getChild("imagepath").getContent();
  thumbsPath = xml.getChild("thumbpath").getContent();
  createMask();
  chroma.convertReferenceColor();
}

void saveConfig() {
  xml.getChild("color").setInt("r", chroma.r_key);
  xml.getChild("color").setInt("g", chroma.g_key);
  xml.getChild("color").setInt("b", chroma.b_key);
  xml.getChild("tol").setInt("a", chroma.tola);
  xml.getChild("tol").setInt("b", chroma.tolb);
  xml.getChild("firstimage").setFloat("cutl", (float)(chroma.cutLeft[0])/width);
  xml.getChild("firstimage").setFloat("cutr", (float)(chroma.cutRight[0])/width);
  xml.getChild("firstimage").setFloat("cutt", (float)(chroma.cutTop[0])/height);
  xml.getChild("firstimage").setFloat("cutb", (float)(chroma.cutBottom[0])/height);
  xml.getChild("firstimage").setInt("offx", chroma.offsetX[0]);
  xml.getChild("firstimage").setInt("offy", chroma.offsetY[0]);
  xml.getChild("firstimage").setInt("sizex", chroma.sizeX[0]);
  xml.getChild("firstimage").setInt("sizey", chroma.sizeY[0]);

  xml.getChild("secondimage").setFloat("cutl", (float)(chroma.cutLeft[1])/width);
  xml.getChild("secondimage").setFloat("cutr", (float)(chroma.cutRight[1])/width);
  xml.getChild("secondimage").setFloat("cutt", (float)(chroma.cutTop[1])/height);
  xml.getChild("secondimage").setFloat("cutb", (float)(chroma.cutBottom[1])/height);
  xml.getChild("secondimage").setInt("offx", chroma.offsetX[1]);
  xml.getChild("secondimage").setInt("offy", chroma.offsetY[1]);
  xml.getChild("secondimage").setInt("sizex", chroma.sizeX[1]);
  xml.getChild("secondimage").setInt("sizey", chroma.sizeY[1]);

  xml.getChild("mask").setFloat("x1", maskCoordinates[4].x/width);
  xml.getChild("mask").setFloat("y1", maskCoordinates[4].y/height);
  xml.getChild("mask").setFloat("x2", maskCoordinates[5].x/width);
  xml.getChild("mask").setFloat("y2", maskCoordinates[5].y/height);
  xml.getChild("mask").setFloat("x3", maskCoordinates[6].x/width);
  xml.getChild("mask").setFloat("y3", maskCoordinates[6].y/height);
  xml.getChild("mask").setFloat("x4", maskCoordinates[7].x/width);
  xml.getChild("mask").setFloat("y4", maskCoordinates[7].y/height);

  saveXML(xml, "data/config.xml");
  println("saved sucessfully");
}

void checkBackground() {
  bgxml = loadXML("bg.xml");
  shouldSave = bgxml.getChild("image").getInt("on");
  if (bgxml.getChild("image").getInt("current") != chroma.currentImage) {
    chroma.currentImage = bgxml.getChild("image").getInt("current");
    chroma.loadBackground();
  }
}

// FILE AND FOLDER FUNCTIONS

int get_filecounter() {
  //String filename = "";
  //String folder = year()+""+formatDate(month())+""+formatDate(day());
  //println(folder);
  File dir = new File(imagesPath+folder);
  String[] list = dir.list();

  int count_files = 0;
  if (list.length > 0) {
    for (int i =0; i < list.length; i++) {
      String[] match = match(list[i], filename_current);
      if (match!=null) {
        count_files++;
      }
    }
  }
  //filename = "teste/"+folder+"/"+filename_current+count_files+".tif";
  return count_files;
}

String formatDate(int dat) {
  if (dat<10) {
    return "0"+dat;
  } else {
    return ""+dat;
  }
}

void checkFolder() {
  //println(imagesPath+folder);
  File f = new File(imagesPath+folder);
  if (!f.exists()) {
    f.mkdirs();
  }

  File ft = new File(thumbsPath+folder);
  if (!ft.exists()) {
    ft.mkdirs();
  }
}

// MASK FUNCTIONS

void createMask() {
  maskCoordinates = new PVector[8];
  maskCoordinates[0] = new PVector(-(width/2), -(height/2));
  maskCoordinates[1] = new PVector((width/2), -(height/2));
  maskCoordinates[2] = new PVector(width/2, (height/2));
  maskCoordinates[3] = new PVector(-(width/2), (height/2));
  maskCoordinates[4] = new PVector(xml.getChild("mask").getFloat("x1")*width, xml.getChild("mask").getFloat("y1")*height);
  maskCoordinates[5] = new PVector(xml.getChild("mask").getFloat("x2")*width, xml.getChild("mask").getFloat("y2")*height);
  maskCoordinates[6] = new PVector(xml.getChild("mask").getFloat("x3")*width, xml.getChild("mask").getFloat("y3")*height);
  maskCoordinates[7] = new PVector(xml.getChild("mask").getFloat("x4")*width, xml.getChild("mask").getFloat("y4")*height);
}

void drawMask() {
  pushMatrix();
  translate(width/2, height/2);
  beginShape();
  fill(0);
  noStroke();

  // Exterior part of shape
  vertex(maskCoordinates[0].x, maskCoordinates[0].y);
  vertex(maskCoordinates[1].x, maskCoordinates[1].y);
  vertex(maskCoordinates[2].x, maskCoordinates[2].y);
  vertex(maskCoordinates[3].x, maskCoordinates[3].y);

  // Interior part of shape
  beginContour();
  vertex(maskCoordinates[4].x, maskCoordinates[4].y);
  vertex(maskCoordinates[5].x, maskCoordinates[5].y);
  vertex(maskCoordinates[6].x, maskCoordinates[6].y);
  vertex(maskCoordinates[7].x, maskCoordinates[7].y);
  endContour();

  // Finishing off shape
  endShape(CLOSE);
  translate(-width/2, -height/2);
  popMatrix();
}
