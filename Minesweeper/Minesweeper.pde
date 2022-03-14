int scale; //<>// //<>// //<>//
int bombsCount;
boolean diffChoosed = false;
boolean lost = false;
int difficulty = -1; // 0 = EASY, 1 = MEDIUM, 2 = HARD
int pgSize = -1; // 0 = SMALL, 1 = MEDIUM, 2 = LARGE
boolean won = false;
boolean firstPressed = false;
ArrayList<Spot> spots = new ArrayList<>();

int menu(String upperText, String button0, String button1, String button2) {
  int result = -1;
  background(108, 128, 154);
  strokeWeight(8);
  textAlign(CENTER, BOTTOM);
  fill(0);
  textSize(height/12);
  text(upperText, width/3, height/3 - height/3 - 20, width/3, height/3  );
  for (int i = 0; i < 3; i++) {
    if ( (mouseX > width/3) && (mouseX < 2*width/3) && (mouseY > height/3 + i*height/6 + i*20) && (mouseY < height/3 + (i+1)*height/6 + i*20)) {
      fill(86, 65, 56);
      if ( (mousePressed) && (mouseButton == LEFT) )
        result = i;
    } else
      fill(234, 210, 172);
    rect(width/3, height/3 + i*height/6 + i*20, width/3, height/6, 15);
    fill(0);
    textAlign(CENTER, CENTER);
    switch(i) {
    case 0:
      text(button0, width/3, height/3 + i*height/6 + i*20, width/3, height/6  );
      break;
    case 1:
      text(button1, width/3, height/3 + i*height/6 + i*20, width/3, height/6  );
      break;
    case 2:
      text(button2, width/3, height/3 + i*height/6 + i*20, width/3, height/6  );
      break;
    }
  }
  return result;
}

int gcd(int n1, int n2) {
  if (n2 == 0)
    return n1;
  return gcd(n2, n1 % n2);
}

boolean winCond (ArrayList<Spot> spots) {
  for (Spot spot : spots) {
    if ( ((!spot.revealed) && (!spot.bombed)) || ((spot.revealed) && (spot.bombed)) )
      return false;
  }
  return true;
}

int indexTransform(int i, int j) {
  return i*height/scale + j;
}

int countNeighbors(int i, int j, ArrayList<Spot> spots) {
  int result = 0;
  if (spots.get(indexTransform(i, j)).bombed)
    return -1;
  for (int k = i-1; k < i+2; k++) {
    for (int z = j-1; z < j+2; z++) {
      if ( (k < 0) || (k > width/scale - 1) || (z < 0) || (z > height/scale - 1) )
        continue;
      if (spots.get(indexTransform(k, z)).bombed)
        result += 1;
    }
  }
  return result;
}

void revealZero(int i, int j, ArrayList<Spot> spots) {
  for (int k = i-1; k < i+2; k++) {
    for (int z = j-1; z < j+2; z++) {
      if ( (k < 0) || (k > width/scale - 1) || (z < 0) || (z > height/scale - 1) )
        continue;
      if ( (spots.get(indexTransform(k, z)).neighbors > -1) && (!spots.get(indexTransform(k, z)).revealed) ) {
        spots.get(indexTransform(k, z)).revealed = true;
        if (spots.get(indexTransform(k, z)).neighbors == 0)
          revealZero(k, z, spots);
      }
    }
  }
}

void setup() {
  fullScreen();
  frameRate(60);
}

void draw() {
  if (difficulty == -1)
    difficulty = menu("Choose difficulty", "EASY", "MEDIUM", "HARD");
  else if (pgSize == -1 && diffChoosed) {
    pgSize = menu("Choose playground size", "SMALL", "MEDIUM", "LARGE");
    if (pgSize > -1) {
      switch (pgSize)
      {
      case 0:
        scale = gcd(int(width), int(height));
        break;
      case 1:
        scale = gcd(int(width), int(height)) / 2;
        break;
      case 2:
        scale = gcd(int(width), int(height)) / 4;
      }
      for (int i = 0; i < width/scale; i++) {
        for (int j = 0; j < height/scale; j++) {
          spots.add(new Spot(i, j, false));
        }
      }
      switch (difficulty) {
      case 0:
        bombsCount = width/scale*height/scale/10;
        break;
      case 1:
        bombsCount = round(width/scale*height/scale/7.5);
        break;
      case 2:
        bombsCount = width/scale*height/scale/5;
        break;
      }
    }
  } else {
    for (Spot spot : spots) {
      spot.show();
    }
    if (won) {
      fill(255, 0, 0);
      textAlign(CENTER, CENTER);
      textSize(height*0.2);
      text("YOU WON", width*0.5, height*0.5 - scale*0.5);
    }
    if (lost) {
      fill(255, 0, 0);
      textSize(height*0.2);
      text("YOU LOST", width*0.5, height*0.5 - scale*0.5);
    }
  }
}

void mousePressed() {
  if (pgSize > -1) {
    if ( (mouseButton == LEFT) && (!spots.get(indexTransform(mouseX / scale, mouseY / scale)).marked) ) {
      if (!firstPressed) {
        firstPressed = true;
        while (bombsCount > 0) {
          int i = floor(random(0, width/scale));
          int j = floor(random(0, height/scale));
          if ( (!spots.get(indexTransform(i, j)).bombed) && (i != mouseX / scale) && (j != mouseY / scale) ) {
            spots.get(indexTransform(i, j)).bombed = true;
            bombsCount -= 1;
          }
        }
        for (Spot spot : spots) {
          spot.neighbors = countNeighbors(spot.i, spot.j, spots);
        }
      }
      spots.get(indexTransform(mouseX / scale, mouseY / scale)).revealed = true;
      if (spots.get(indexTransform(mouseX / scale, mouseY / scale)).neighbors == 0)
        revealZero(spots.get(indexTransform(mouseX / scale, mouseY / scale)).i, spots.get(indexTransform(mouseX / scale, mouseY / scale)).j, spots);
      else if (spots.get(indexTransform(mouseX / scale, mouseY / scale)).bombed) {
        for (Spot spot : spots) {
          spot.revealed = true;
        }
        lost = true;
      }
      if (winCond(spots)) {
        for (Spot spot : spots) {
          spot.revealed = true;
        }
        won = true;
      }
    } else if (mouseButton == RIGHT) {
      if (!spots.get(indexTransform(mouseX / scale, mouseY / scale)).revealed)
        spots.get(indexTransform(mouseX / scale, mouseY / scale)).marked = !spots.get(indexTransform(mouseX / scale, mouseY / scale)).marked;
    }
  }
}

void mouseReleased() {
  if (difficulty > -1)
    diffChoosed = true;
}
