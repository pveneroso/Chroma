// alpha1

class Chroma {
  PImage bg, fg;
  //PImage frame;
  int tola = 10;
  int tolb = 60;

  int b_key, g_key, r_key, cb_key, cr_key;
  int a = 255<<24;

  boolean toggleMaintenance = false;

  int[] cutLeft = {0, 0};
  int[] cutRight = {0, 0};
  int[] cutBottom = {0, 0};
  int[] cutTop = {0, 0};
  int[] offsetX = {0, 0};
  int[] offsetY = {0, 0};
  int[] sizeX = {0, 0};
  int[] sizeY = {0, 0};

  int currentImage = 0;
  
  PImage frame;
  PImage[] bgref;
  PImage[] fgref;

  Capture movie;
  Chroma(Capture mov) {
    bgref = new PImage[2];
    bgref[0] = loadImage("01-fundo-"+width+".png");
    bgref[1] = loadImage("02-fundo-"+width+".png");
      
    fgref = new PImage[2];
    fgref[0] = loadImage("01-frente-"+width+".png");
    fgref[1] = loadImage("02-frente-"+width+".png");
    
    movie = mov;
    //frame = new PImage(width, height);
    this.loadBackground();
  }

  void loadBackground() {
    if (currentImage == 0) {
      bg = bgref[0];
      fg = fgref[0];
    } else {
      bg = bgref[1];
      fg = fgref[1];
    }
    fg.loadPixels();
    bg.loadPixels();
  }

  void toggleMaintenance() {
    for (int i = 0; i < bg.pixels.length; i++) {
      int tr = 255<<16;
      int tg = 0<<8;
      int tb = 0;
      color trgb = a | tr | tg | tb;
      bg.pixels[i] = trgb;
    }
  }

  void updateReference() {
    if(this.checkPosition(mouseX, mouseY)){
      int stelle = (sizeX[currentImage]-mouseX+offsetX[currentImage])+((mouseY-offsetY[currentImage])*sizeX[currentImage]);
      r_key = parseInt(red(frame.pixels[stelle]));
      g_key = parseInt(green(frame.pixels[stelle]));
      b_key = parseInt(blue(frame.pixels[stelle]));
      this.convertReferenceColor();
    }
  }
  
  int getStelle(){
    if(this.checkPosition(mouseX, mouseY)){
      return (sizeX[currentImage]-mouseX+offsetX[currentImage])+((mouseY-offsetY[currentImage])*sizeX[currentImage]);
    }
    else{
      return -1;
    }
  }

  void convertReferenceColor() {
    cb_key = this.rgb2cb(r_key, g_key, b_key);
    cr_key = this.rgb2cr(r_key, g_key, b_key);
  }

  void processChroma() {
    loadPixels();
    //frame.loadPixels();
    //movie.loadPixels();
    frame = new PImage(movie.width, movie.height);
    frame.pixels = movie.pixels;
    //println(frame.width);
    //if((int)(sizeX[currentImage]) != movie.width){
      frame.resize((int)(sizeX[currentImage]), (int)(sizeY[currentImage]));
    //}
    frame.loadPixels();

    int b, g, r, cb, cr, r_bg, g_bg, b_bg;
    double mask;

    for (int j=0; j<height; j++) {
      for (int i=0; i<width; i++) {
        int stelle = i+(j*width);
        int webcam_stelle = (width-i)+(j*width);
        if (i < cutLeft[currentImage] || i > width-cutRight[currentImage] || j < cutTop[currentImage] || j > height-cutBottom[currentImage]) {
          pixels[stelle] = bg.pixels[stelle];
        } else {
          //int rgb_fr = movie.pixels[stelle];
          //r = (rgb_fr >> 16) & 0xFF;
          //g = (rgb_fr >> 8) & 0xFF;
          //b = rgb_fr & 0xFF;
          //int rgb_bg = bg.pixels[stelle];
          //r_bg = (rgb_bg >> 16) & 0xFF;
          //g_bg = (rgb_bg >> 8) & 0xFF;
          //b_bg = rgb_bg & 0xFF;

          //CHECK IF OUT OF CANVAS
          // not optmized
          if (this.checkPosition(i, j)) {
            webcam_stelle = (sizeX[currentImage]-i+offsetX[currentImage])+((j-offsetY[currentImage])*sizeX[currentImage]);
            //b = parseInt(blue(frame.pixels[webcam_stelle]));
            //g = parseInt(green(frame.pixels[webcam_stelle]));
            //r = parseInt(red(frame.pixels[webcam_stelle]));
            r = frame.pixels[webcam_stelle] >> 16 & 0xFF;
            g = frame.pixels[webcam_stelle] >> 8 & 0xFF;
            b = frame.pixels[webcam_stelle] & 0xFF;
            
            r_bg = bg.pixels[stelle] >> 16 & 0xFF;
            g_bg = bg.pixels[stelle] >> 8 & 0xFF;
            b_bg = bg.pixels[stelle] & 0xFF;

            //b_bg = parseInt(blue(bg.pixels[stelle]));
            //g_bg = parseInt(green(bg.pixels[stelle]));
            //r_bg = parseInt(red(bg.pixels[stelle]));

            cb = this.rgb2cb(r, g, b);
            cr = this.rgb2cr(r, g, b);
            mask = this.colorclose(cb, cr, cb_key, cr_key, tola, tolb);
            mask = 1 - mask;
            int passr = (int)(r - mask*r_key);
            int passg = (int)(g - mask*g_key);
            int passb = (int)(b - mask*b_key);
            r = (int)(this.maxim(passr, 0) + mask*r_bg);
            g = (int)(this.maxim(passg, 0) + mask*g_bg);
            b = (int)(this.maxim(passb, 0) + mask*b_bg);

            //int putr = r << 16;
            //int putg = g << 8;
            //int putb = b << 0;
            //int puta = a << 24;
            //println(binary(a) + " : " + a);
            //color putColor = puta| putr | putg | putb;
            //color putColor = color(r, g, b);
            //pixels[stelle] = putColor;

            // not optimized
            pixels[stelle] = color(r, g, b);
          } else {
            pixels[stelle] = bg.pixels[stelle];
            //b=parseInt(blue(bg.pixels[stelle]));
            //r=parseInt(red(bg.pixels[stelle]));
            //g=parseInt(green(bg.pixels[stelle]));
          }
        }
      }
    }
    updatePixels();
    image(fg, 0, 0);
  }

  boolean checkPosition(int i, int j) {
    if (i > offsetX[currentImage] && i < offsetX[currentImage]+sizeX[currentImage]
      && j > offsetY[currentImage] && j < offsetY[currentImage]+sizeY[currentImage]) {
      return true;
    } else {
      return false;
    }
  }

  int maxim(int a, int b) {
    if (a>b) {
      return (a);
    }
    return (b);
  }

  int rgb2y (int r, int g, int b)
  {
    /*a utility function to convert colors in RGB into YCbCr*/
    int y;
    y = (int) round(0.299*r + 0.587*g + 0.114*b);
    return (y);
  }

  int rgb2cb (int r, int g, int b)
  {
    /*a utility function to convert colors in RGB into YCbCr*/
    int cb;
    cb = (int) round(128 + -0.168736*r - 0.331264*g + 0.5*b);
    return (cb);
  }

  int rgb2cr (int r, int g, int b)
  {
    /*a utility function to convert colors in RGB into YCbCr*/
    int cr;
    cr = (int) round(128 + 0.5*r - 0.418688*g - 0.081312*b);
    return (cr);
  }

  double colorclose(int Cb_p, int Cr_p, int Cb_key, int Cr_key, int tola, int tolb)
  {
    /*decides if a color is close to the specified hue*/
    double temp = sqrt((Cb_key-Cb_p)*(Cb_key-Cb_p)+(Cr_key-Cr_p)*(Cr_key-Cr_p));
    if (temp < tola) {
      return (0.0);
    }
    if (temp < tolb) {
      return ((temp-tola)/(tolb-tola));
    }
    return (1.0);
  }
}
