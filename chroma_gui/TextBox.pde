class TextBox{
  String content;
  String defaultTxt = "DIGITE SEU E-MAIL";
  PFont font;
  
  float x, y, w, h;
  
  TextBox(){
    content = "";
    font = createFont("SourceCodePro-Bold", 16);
    textFont(font);
    //textSize(32);
    textAlign(CENTER);
    w = width*0.5;
    h = height*0.07;
    x = (width-w)/2;
    y = height*0.22;
  }
  
  void drawTextBox(){
    pushStyle();
    fill(30);
    rect(x, y, w, h, 6);
    fill(255);
    textSize(16);
    if(content == ""){
      content = defaultTxt;
    }
    text(content, (width/2), y+(height*0.045));
    popStyle();
  }
  
  void addChar(String ch){
    if(content == defaultTxt){
      content = ch; 
    } else{
      content += ch;
    }
    
  }
  
  void removeChar(){
    if(content.length() > 0 && content != defaultTxt){
      content = content.substring(0, content.length()-1);
    }
  }
}
