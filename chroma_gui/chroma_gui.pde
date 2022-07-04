/*
  Configurar paths em GRID e MAINMENU
*/

MainMenu main;
Grid grid;
Keyboard keyboard;
RoundButton showGrid, showSend, showMain, showMail;

boolean menuOpened = true;
boolean sendOpened = false;
boolean gridOpened = false;
boolean keyboardOpened = false;

boolean runTimed = false;

int lastSecond = second();
int timer = 0;
int timeLimit = 15;
int sessionTimer = 0;
int sessionLimit = 30;
boolean ongoingSession = false;

void setup() {
  size(1280, 720);
  //fullScreen(2);
  smooth();
  main = new MainMenu();
  grid = new Grid();
  keyboard = new Keyboard();
  noStroke();
  fill(235);
  rect(0, 0, width, height);
  showGrid = new RoundButton(width/2, (int)(height*0.85), (int)(width*0.08), (int)(width*0.08), "images.svg");
  showSend = new RoundButton((int)(width*0.2), (int)(height*0.88), (int)(width*0.08), (int)(width*0.08), "paper-plane.svg");
  showMain = new RoundButton((int)(width*0.1), (int)(height*0.88), (int)(width*0.08), (int)(width*0.08), "house-chimney.svg");
  showMail = new RoundButton((int)(width-(width*0.1)), (int)(height*0.88), (int)(width*0.08), (int)(width*0.08), "envelope.svg");
}

void draw() {
  //println(sessionTimer);
  if (main.saving) {
    ongoingSession = true;
  } else {
    ongoingSession = false;
  }
  //println(frameRate);
  fill(235);
  rect(0, 0, width, height);
  if (menuOpened) {
    main.drawMain();
    showGrid.drawButton();
  } else if (sendOpened) {
    main.drawSend();
    if (keyboardOpened) {
      keyboard.showKeyboard();
    }
    showMain.drawButton();
    showMail.drawButton();
  } else if (gridOpened) {
    grid.showGrid();
    showMain.drawButton();
    if(grid.selectedImages.size()>0){
      showSend.drawButton();
    }
  }

  if (second()%5 == 0 && runTimed) {
    //grid.updateCounter();
    runTimed = false;
  } else if (second()%5 != 0) {
    runTimed = true;
  }

  if (second() != lastSecond) {
    lastSecond = second();
    timer++;
    if (ongoingSession) {
      //println("ongoing " + second());
      sessionTimer++;
    }
    //println(timer);
  }
  if (timer >= timeLimit) {
    timer = 0;
    if(gridOpened){
      resetInterface();
    } else if(menuOpened){
      resetInterface();
    } else if(sendOpened){
      resetInterface();
    }
  }
  if (sessionTimer > sessionLimit) {
    sessionTimer = 0;
    stopSave();
    // finish session
  }
}

void stopSave() {
  resetGrid();
  main.toggleSave(0);
  sessionTimer = 0;
  grid.updateCounter();
}

void resetGrid() {
  // reset interface when idle for 60 seconds
  grid.resetGrid();
  gridOpened = true;
  menuOpened = false;
  sendOpened = false;
  keyboardOpened = false;
}

void resetInterface() {
  grid.resetGrid();
  gridOpened = false;
  menuOpened = true;
  sendOpened = false;
  keyboardOpened = false;
}

void resetSend() {
  grid.resetGrid();
  gridOpened = false;
  menuOpened = false;
  sendOpened = true;
  keyboardOpened = true;
}

void mousePressed() {
  timer = 0;
  if (keyboardOpened) {
    String k = keyboard.checkClick();
    if(k == "Delete"){
      main.txtbox.removeChar();
    } else if(k == "Space"){
      //main.txtbox.addChar(" ");
    } else if(k == "Enter"){
      //main.txtbox.addChar(" ");
      // = clique
    } else{
      main.txtbox.addChar(k);
    }
    
  }
  if (gridOpened) {
    grid.checkClick();
    if (showMain.clicked()) {
      grid.resetSelection();
      resetInterface();
      //stopSave();
    } else if (showSend.clicked()) {
      grid.sendPaths = new String[grid.selectedImages.size()];
      println(grid.sendPaths.length + " : " + grid.selectedImages.size());
      println(grid.imgPath);
      for(int i = 0; i < grid.selectedImages.size(); i++){
        grid.sendPaths[i] = grid.imgPath[grid.selectedImages.get(i)];
      }
      grid.resetSelection();
      resetSend();
      //resetInterface();
      //stopSave();
    }
  } else if (menuOpened) {
    main.checkClick();
    if (showGrid.clicked()) {
      resetGrid();
      stopSave();
    }
  } else if (sendOpened) {
    if (showMain.clicked()) {
      main.txtbox.content = "";
      resetInterface();
    } else if (showMail.clicked()) {
      if(main.txtbox.content != main.txtbox.defaultTxt && main.txtbox.content.length() > 8){
        main.queueMail(grid.sendPaths, main.txtbox.content);
      }
      main.txtbox.content = "";
      resetInterface();
      
      //SENT OR ERROR ANIMATION
    }
  }
}

void mouseMoved() {
  timer = 0;
}

void keyPressed() {
  //println(keyCode);
  //if (keyCode == 39) {
  //  grid.nextPage();
  //} else if (keyCode == 37) {
  //  grid.previousPage();
  //}
}
