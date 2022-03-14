class Spot {
  int i;
  int j;
  int neighbors;
  boolean bombed;
  boolean revealed;
  boolean marked;

  Spot (int i, int j, boolean bombed) {
    this.i = i;
    this.j = j;
    this.bombed = bombed;
    this.revealed = false;
    this.marked = false;
  }


  void show() {
    stroke(0);
    strokeWeight(2);
    if (this.revealed) {
      fill(255);
      rect(i*scale, j*scale, scale, scale);
      if (this.bombed) {
        fill(0);
        circle(i*scale + scale/2, j*scale + scale/2, scale/2);
      } else if (this.neighbors > 0) {
        fill(0);
        textAlign(CENTER, CENTER);
        textSize(scale);
        text(neighbors, (i+0.5)*scale, (j+0.35)*scale);
      }
    } else {
      fill(211);
      rect(i*scale, j*scale, scale, scale);
      if (this.marked) {
        fill(255, 0, 0);
        triangle((i+0.1)*scale, (j+0.1)*scale, (i+0.1)*scale, (j+0.9)*scale, (i+0.9)*scale, (j+0.5)*scale);
      }
    }
  }
}
