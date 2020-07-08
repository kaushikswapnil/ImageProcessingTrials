PImage g_Image;

boolean g_Active = false;

IPainter g_Painter;

void setup()
{
   //g_Image = loadImage("Image1.jpg");
   //size(1000, 667);//, P3D);
   //g_Image = loadImage("Image2.jpg");
   //size(675, 450);//, P3D);
   //g_Image = loadImage("Image3.jpg");
   //size(1000, 667);//, P3D);
   //g_Image = loadImage("Image4.jpg");
   //size(900, 600);//, P3D);
   //g_Image = loadImage("Image5.jpg");
   //size(862, 575, P3D);
   g_Image = loadImage("Image6.jpg");
   size(862, 647);//, P3D);
   //g_Image = loadImage("Image7.jpg");
   //size(862, 647, P3D);
   //g_Image = loadImage("Image8.jpg");
   //size(1023, 682, P3D);
   //g_Image = loadImage("Image9.jpg");
   //size(1024, 680, P3D);
   background(0);
   
   g_Image.loadPixels();
   
   //g_Painter = new StrokePainter();
   //g_Painter = new VanGoghPainter();
   g_Painter = new PatchPainter();
   //g_Painter = new ThreeDPainter();
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
