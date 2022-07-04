class Grid {
  XML xml;
  Cell[] cells;
  int w, h, spacing;
  int col = 4;
  int row = 3;
  int offsetY = 0;
  float margins = 0.1;

  int currentPage = 0;
  int imageCount = 0;
  int totalPages = 0;

  String imagesPath = "";
  String thumbsPath = "";

  PImage[] currentThumbs;
  String[] imgPath;
  String[] sendPaths;
  IntList selectedImages;
  
  /* IMPORTANTE CONFIGURAR */
  String configPath = "../chroma_video/data/";

  RoundButton[] arrows;

  String folder = year()+""+this.formatDate(month())+""+this.formatDate(day());

  Grid() {
    xml = loadXML(configPath+"config.xml");
    this.setupConfig();
    this.checkFolder();

    arrows = new RoundButton[2];
    arrows[0] = new RoundButton((int)(width*0.8), (int)(height*0.88), (int)(width*0.08), (int)(width*0.08), "arrow-left-long.svg");
    arrows[1] = new RoundButton((int)(width*0.9), (int)(height*0.88), (int)(width*0.08), (int)(width*0.08), "arrow-right-long.svg");

    spacing = 20;
    w = (int)((width-((col+1)*spacing)-((margins*width)*2))/col);
    h = (int)(w*9)/16;
    offsetY = (int)(0.15*height);

    selectedImages = new IntList();
    this.updateCounter();
    this.resetGrid();

    cells =  new Cell[row*col];
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        int index = (i*col)+j;
        int posx = (int)((margins*width)+((j+1)*spacing)+(j*w));
        int posy = (int)(offsetY+((i+1)*spacing)+(i*h));
        cells[index] = new Cell(posx, posy, w, h);
      }
    }
  }

  void showGrid() {
    if (currentPage > totalPages-3 && currentPage > 0) {
      arrows[0].drawButton();
    }
    if (currentPage+1 < totalPages) {
      arrows[1].drawButton();
    }
    for (int i = 0; i < currentThumbs.length; i++) {
      image(currentThumbs[i], cells[i].x, cells[i].y);
      cells[i].monitor();
    }
  }

  void checkClick() {
    if (arrows[0].clicked()) {
      this.previousPage();
    } else if (arrows[1].clicked()) {
      this.nextPage();
    }
    for (int i = 0; i < cells.length; i++) {
      cells[i].clicked();
      if (cells[i].clicked) {
        cells[i].clicked = false;
        if (cells[i].selected) {
          selectedImages.append(i);
          if (selectedImages.size() > 3) {
            cells[selectedImages.get(0)].selected = false;
            selectedImages.remove(0);
          }
        } else {
          for (int j = 0; j < selectedImages.size(); j++) {
            if (selectedImages.get(j) == i) {
              selectedImages.remove(j);
            }
          }
        }
        //println(selectedImages);
        //if(selectedImages.size() > 3){
        //  cells[selectedImages.get(0)].selected = false;
        //  selectedImages.remove(0);
        //}
      }
    }
  }

  void resetGrid() {
    selectedImages.clear();
    currentPage = totalPages-1;
    this.loadPage();
  }

  void resetSelection() {
    selectedImages.clear();
    for (int i = 0; i < cells.length; i++) {
      cells[i].selected = false;
      cells[i].clicked = false;
    }
  }

  void loadPage() {
    if (imageCount <= row*col) {
      currentThumbs = new PImage[imageCount];
      for (int i = 0; i < imageCount; i++) {
        currentThumbs[i] = loadImage(thumbsPath+folder+"/thumb-"+(i+1)+".jpg");
      }
    } else if (currentPage == 0) {
      currentThumbs = new PImage[imageCount%(row*col)];
      for (int i = 0; i < imageCount%(row*col); i++) {
        currentThumbs[i] = loadImage(thumbsPath+folder+"/thumb-"+(i+1)+".jpg");
      }
    } else {
      currentThumbs = new PImage[row*col];
      imgPath = new String[currentThumbs.length];
      for (int i = 0; i < currentThumbs.length; i++) {
        int index = imageCount%(row*col)+((currentPage-1)*(row*col))+(i+1);
        imgPath[i] = thumbsPath+folder+"/thumb-"+index+".jpg";
        currentThumbs[i] = loadImage(imgPath[i]);
      }
    }
  }

  void nextPage() {
    if (currentPage+1 < totalPages) {
      currentPage++;
      this.loadPage();
      this.resetSelection();
    }
  }

  void previousPage() {
    if (currentPage > totalPages-3) { //if (currentPage-1 >= totalPages) {
      currentPage--;
      this.loadPage();
      this.resetSelection();
    }
  }

  void checkFolder() {
    File f = new File(imagesPath+folder);
    if (!f.exists()) {
      f.mkdirs();
    }

    File ft = new File(thumbsPath+folder);
    if (!ft.exists()) {
      ft.mkdirs();
    }
  }

  void updateCounter() {
    int lastCount = imageCount;
    imageCount = this.getFilecounter("itinerarios-", imagesPath);
    totalPages = ceil((float)(imageCount) / (row*col));
    if (imageCount > lastCount) {
      this.createThumbnails();
    }
    this.loadPage();
  }

  void createThumbnails() {
    int thumbsCount = this.getFilecounter("thumb-", thumbsPath);
    for (int i = thumbsCount; i < imageCount; i++) {
      PImage img = loadImage(imagesPath+folder+"/itinerarios-"+(i+1)+".jpg");
      img.resize(w, h);
      img.save(thumbsPath+folder+"/thumb-"+(i+1)+".jpg");
    }
  }

  int getFilecounter(String fl, String path) {
    //String filename = "itinerarios-";
    File dir = new File(path+folder);
    String[] list = dir.list();

    int count_files = 0;
    if (list.length > 0) {
      for (int i =0; i < list.length; i++) {
        String[] match = match(list[i], fl);
        if (match!=null) {
          count_files++;
        }
      }
    }

    return count_files;
  }

  String formatDate(int dat) {
    if (dat<10) {
      return "0"+dat;
    } else {
      return ""+dat;
    }
  }

  void setupConfig() {
    imagesPath = xml.getChild("imagepath").getContent();
    thumbsPath = xml.getChild("thumbpath").getContent();
  }
}
