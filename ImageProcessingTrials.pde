PImage g_Image;

boolean g_Active = true;

IPainter g_Painter;

void setup()
{
   //g_Image = loadImage("Image1.jpg");
   //size(1000, 667);
   //g_Image = loadImage("Image2.jpg");
   //size(675, 450);
   //g_Image = loadImage("Image3.jpg");
   //size(1000, 667);
   g_Image = loadImage("Image4.jpg");
   size(1200, 900, P3D);
   background(0);
   
   g_Image.loadPixels();
   
   //g_Painter = new StrokePainter();
   //g_Painter = new VanGoghPainter();
   //g_Painter = new PatchPainter();
   g_Painter = new ThreeDPainter();
}

void draw()
{
  if (g_Active)
  {
   g_Painter.draw(); 
  }
}

void keyPressed()
{
 if (key == ' ')
 {
  g_Active = !g_Active; 
 }
}
