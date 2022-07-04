class MainMenu {
  XML imgxml, mailxml;
  //PImage title, logo;
  PImage[] bgs;

  PShape title, logo;
  PFont font, fontBold;

  int marginLeft, bgw, bgh;

  boolean saving = false;
  
  /* IMPORTANTE CONFIGURAR */
  String configPath = "../chroma_video/data/";

  Button[] buttons;
  TextBox txtbox;
  int currentBg = 0;
  String[] txt2 = {"Junta Governativa de Pernambuco, em Goiana, 1821", "Johann Moritz Rugendas, 1835", "Biblioteca Digital Curt Nimuendajú / Editora Online"};
  String[] txt1 = {"Sessão de Conselho de Ministros no Rio de Janeiro, 1822", "Georgina de Albuquerque, 1922", "Acervo do Museu Histórico Nacional"};

  MainMenu() {
    title = loadShape("title.svg");
    logo = loadShape("sumbioun-logo.svg");
    bgs = new PImage[2];
    bgs[0] = loadImage("bg-01.png");
    bgs[1] = loadImage("bg-02.png");
    marginLeft = (int)(width*0.10);
    bgw = (int)(width*0.35);
    bgh = (int)(bgw*9/16);

    imgxml = loadXML(configPath+"bg.xml");
    currentBg = imgxml.getChild("image").getInt("current");
    imgxml.getChild("image").setInt("on", 0);
    saveXML(imgxml, configPath+"bg.xml");

    mailxml = loadXML(configPath+"mailqueue.xml");

    buttons = new Button[2];
    buttons[0] = new Button(marginLeft, (height-bgh)/2, bgw, bgh);
    buttons[1] = new Button(width-marginLeft-bgw, (height-bgh)/2, bgw, bgh);

    txt1[0] = txt1[0].toUpperCase();
    txt2[0] = txt2[0].toUpperCase();
    font = createFont("SourceCodePro-Regular", 12);
    fontBold = createFont("SourceCodePro-Bold", 12);
    textSize(12);
    textAlign(CENTER);

    txtbox = new TextBox();

    //buttons[currentBg].active = true;
  }

  void drawMain() {
    smooth();
    pushStyle();
    //fill(0, 91, 158);
    fill(30);
    rect(0, 0, width, height);
    popStyle();
    title.disableStyle();
    //fill(30);
    shape(title, marginLeft-5, 30, width*0.2, (162*width*0.2)/250);
    image(bgs[0], marginLeft, (height-bgh)/2, bgw, bgh);
    image(bgs[1], width-marginLeft-bgw, (height-bgh)/2, bgw, bgh);
    for (int i = 0; i < buttons.length; i++) {
      buttons[i].mouseOv();
      buttons[i].drawButton();
      for (int j = 0; j < txt1.length; j++) {
        if (j == 0) {
          textFont(fontBold);
        } else {
          textFont(font);
        }
        if (buttons[0].active) {
          text(txt1[j], marginLeft+(bgw/2), (height/2)+(bgh/2)+((j+2)*20));
        } else if (buttons[1].active) {
          text(txt2[j], width-marginLeft-(bgw/2), (height/2)+(bgh/2)+((j+2)*20));
        }
      }
    }

    logo.disableStyle();
    shape(logo, width-(width*0.1), height-(width*0.1), width*0.07, width*0.07);
  }

  void checkClick() {
    for (int i = 0; i < buttons.length; i++) {
      if (buttons[i].clicked()) {
        this.resetButtons();
        currentBg = i;
        buttons[i].active = true;
        this.toggleSave(1);
      }
    }
  }

  void toggleSave(int tmp) {
    if (tmp == 0) {
      //println("STOP");
      buttons[0].active = false;
      buttons[1].active = false;
      saving = false;
    } else {
      saving = true;
    }
    imgxml.getChild("image").setInt("current", currentBg);
    imgxml.getChild("image").setInt("on", tmp);
    saveXML(imgxml, configPath+"bg.xml");
  }

  void resetButtons() {
    for (int i = 0; i < buttons.length; i++) {
      buttons[i].reset();
      buttons[i].mouseOver = false;
    }
  }

  void queueMail(String[] paths, String address) {
    //println(paths);
    mailxml = loadXML(configPath+"mailqueue.xml");
    XML newChild = mailxml.addChild("message");
    for (int i = 0; i < paths.length; i++) {
      newChild.setString("attach"+(i+1), paths[i]);
    }
    String timestamp = year() + "" + formatDate(month()) + "" + formatDate(day()) + "-" + formatDate(hour()) + "" + formatDate(minute()) + "" + formatDate(second());
    newChild.setString("timestamp", timestamp);
    newChild.setString("address", address);
    newChild.setString("sent", "0");
    saveXML(mailxml, configPath+"mailqueue.xml");

    // SAVE XML
  }

  void closeMain() {
  }

  void drawSend() {
    txtbox.drawTextBox();
  }

  void hideSend() {
  }

  String formatDate(int dat) {
    if (dat<10) {
      return "0"+dat;
    } else {
      return ""+dat;
    }
  }
}
