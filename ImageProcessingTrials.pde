PImage g_Image;


IPainter g_Painter;

void setup()
{
   g_Image = loadImage("Image1.jpg");
   size(800, 800);
   background(0);
   g_Painter = new StrokePainter();
}

void draw()
{
  g_Painter.draw();
}
