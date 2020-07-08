interface IPainter
{
 public void draw();
}

class PatchPainter implements IPainter
{
 float m_PatchSize = 12.0f;
 int m_PatchAlpha = 120;
 
 int m_NumPatchesPerFrame = 1000;
 
 void draw()
 {
   noStroke();
   for (int iter = 0; iter < m_NumPatchesPerFrame; ++iter)
   {
     int x = (int)random(width);
     int y = (int)random(height);
   
     color c = g_Image.pixels[x + (y * width)];
     fill(c, m_PatchAlpha);
     ellipse(x, y, m_PatchSize, m_PatchSize);
   }
   
 }
}

class StrokePainter implements IPainter
{
  float m_StrokeLength = 7.0f;
  float m_StrokeWeight = 3.0f;
  int m_StrokeAlpha = 120;
  
  int m_NumStrokesPerFrame = 200;
  
  float m_FlowX = 0.0f;
  float m_FlowY = 0.0f;
  float m_FlowZ = 0.0f;
  
  float m_FlowDX = 0.008f;
  float m_FlowDY = 0.001f;
  float m_FlowDZ = 0.0005f;
  
  public void draw()
  {
    m_FlowX += m_FlowDX;
    m_FlowY += m_FlowDY;
    m_FlowZ += m_FlowDZ;

    strokeWeight(m_StrokeWeight);
    for (int iter = 0; iter < m_NumStrokesPerFrame; ++iter)
    {
     int x = (int)random(width);
     int y = (int)random(height);
     
     color c = g_Image.pixels[(int)(y*width) + x];//g_Image.get((int)x, (int)y);
     stroke(c, m_StrokeAlpha);
     float angle = map(noise((x/width) + m_FlowX, (y/height) + m_FlowY, m_FlowZ), 0.0, 1.0, 0, TWO_PI);
     
     pushMatrix();
     translate(x, y);
     rotate(angle);
     line(0, 0, m_StrokeLength, 0);
     popMatrix();
    } 
  }
}

class VanGoghPainter implements IPainter
{ 
 float m_ParticleSize = 6.0f;
 float m_FlowX = 0.0f;
  float m_FlowY = 0.0f;
  float m_FlowZ = 0.0f;
  
  float m_FlowDX = 0.00f;//8f;
  float m_FlowDY = 0.0f;//1f;
  float m_FlowDZ = 0.00005f;
  
  float skyRatio = 0.4f;
 
 class Particle
 {
   PVector m_Pos;
   color m_Color;
   
   Particle(PVector pos, color c)
   {
     m_Pos = pos.copy();
     m_Color = c;
   }
   
   void Update()
   {
     boolean isSkyZone = (m_Pos.y / height) < 0.4f;
     
     float noiseVal;
     if (isSkyZone)
     {
       float skyZoneMultiplier = 7.0f;
       noiseVal = noise((skyZoneMultiplier * m_Pos.x/width) + m_FlowX, (skyZoneMultiplier * m_Pos.y/height), m_FlowZ);
     }
     else
     {
       noiseVal = noise((m_Pos.x/width) + m_FlowX, (m_Pos.y/height) + m_FlowY, m_FlowZ);
     }
     
     float theta = map(noiseVal, 0.0f, 1.0f, 0.0f, TWO_PI);
     PVector vel = PVector.fromAngle(theta);
     vel.mult(random(0.5f, isSkyZone ? 1.3f : 1.0f));
     m_Pos.add(vel);
   }
   
   void Display()
   {
     fill(m_Color);
     float particleSize = m_ParticleSize * map(frameCount % m_ParticleUpdateCycle, 0, m_ParticleUpdateCycle, 1.0f, 0.7f);
     ellipse(m_Pos.x, m_Pos.y, particleSize, particleSize);
   }
   
   boolean IsOutOfScreenDimensions()
   {
     return (int)m_Pos.x < 0 || (int)m_Pos.x >= width || (int)m_Pos.y < 0 || (int)m_Pos.y >= height;
   }
 }
 
 ArrayList<Particle> m_Particles;
 int m_ParticleCount = 800;
 int m_ParticleUpdateCycle = 30;
 
 VanGoghPainter()
 {
   m_Particles = new ArrayList<Particle>();
 }
 
 void draw()
 {
   //colorMode(HSB, 360);
   
    m_FlowX += m_FlowDX;
    m_FlowY += m_FlowDY;
    m_FlowZ += m_FlowDZ;
   
   if (frameCount % m_ParticleUpdateCycle == 0)
   {
    CreateParticles(); 
   }
   
   noStroke();
   for (int iter = m_Particles.size()-1; iter >=0; --iter)
   {
     Particle p = m_Particles.get(iter);
     p.Display();
     p.Update();
     
     if (p.IsOutOfScreenDimensions())
     {
       m_Particles.remove(iter);
     }
   }
 }
 
 void CreateParticles()
 {
  m_Particles = new ArrayList<Particle>();
  
  for (int iter = 0; iter < m_ParticleCount; ++iter)
  {
   PVector particlePos = new PVector(random(width), random(height));
   color particleColor = g_Image.pixels[(int)particlePos.x + ((int)(particlePos.y)*width)];
   if (particleColor < #E6E6E6)
   {
     int maxHueNoise = 5;
     color noiseColor = color(random(-maxHueNoise, maxHueNoise), random(-maxHueNoise, maxHueNoise), random(-maxHueNoise, maxHueNoise));
     particleColor += noiseColor; 
   }
   
   m_Particles.add(new Particle(particlePos, particleColor)); 
  }
 }
}

class ThreeDPainter implements IPainter
{
  final int CENTER_DIST = 0;
  final int BRIGHTNESS = 1;
  int m_DrawMode;
  long m_FrameCount;
  
  class Particle
  {
   PVector m_ImgPos;
   color m_ImgCol;
   
   Particle(PVector imgPos, color imgCol)  
   {
     m_ImgPos = imgPos.copy();
     m_ImgCol = imgCol;
   }
  }
  ArrayList<Particle> m_Particles;
  
  ThreeDPainter()
  {
    m_FrameCount = 0;
    m_Particles = new ArrayList<Particle>();
    m_DrawMode = BRIGHTNESS;
    
    for (int y = 0; y < g_Image.height; ++y)
    {
     for (int x = 0; x < g_Image.width; ++x)
     {
       m_Particles.add(new Particle(new PVector(x, y), g_Image.pixels[x + (y * g_Image.width)]));
     }
    }
  }
  
  void draw()
  {
    background(#dddddd);   
    noStroke();
    
    float spreadFactor = map(sin(radians(m_FrameCount++)), -1.0f, 1.0f, -2.0f, 2.0f);
    //float spreadFactor = map(constrain(mouseX, 0, width), 0, width, -2.0f, 2.0f);
    float spreadDist = 1000;
    float camZ = (height/2.0) / tan(PI*30.0 / 180.0);
    if (spreadFactor > 0.0f)
    {
      camZ += spreadFactor * spreadDist*cos(PI/4);//maxDist/tan(PI*30.0 / 180.0);
    }
    
    camera(width/2, height/2, camZ, width/2, height/2, 0, 0, 1, 0); 
    
    switch(m_DrawMode)
    {
     case CENTER_DIST:
     DrawCenterDistStyle(spreadFactor, spreadDist);
     break;
     
     case BRIGHTNESS:
     DrawBrightnessStyle(spreadFactor, spreadDist);
     break;
    }
  }
  
  void DrawBrightnessStyle(float spreadFactor, float spreadDist)
  {
    float maxSpreadDist = spreadFactor * spreadDist;
    for (Particle p : m_Particles)
    {
      float brightness = brightness(p.m_ImgCol); 
      float z = map(brightness, 0.0f, 255.0f, 0.0f, maxSpreadDist);
      pushMatrix();
      translate(p.m_ImgPos.x, p.m_ImgPos.y, z);
      fill(p.m_ImgCol);
      ellipse(0, 0, 2.0f, 2.0f);
      popMatrix();
    }
  }
  
  void DrawCenterDistStyle(float spreadFactor, float spreadDist)
  {
    float spreadConstant = spreadDist * spreadFactor;
    PVector imgCenter = new PVector(g_Image.width/2, g_Image.height/2);
    float maxDistSq = (sq((g_Image.width/2)) + sq((g_Image.height/2)));
    float maxDist = sqrt(maxDistSq);

    for (Particle p : m_Particles)
    {
      pushMatrix();
      PVector toCenter = PVector.sub(imgCenter, p.m_ImgPos);
      float z = spreadConstant * toCenter.mag() * toCenter.mag() / maxDistSq;
      translate(p.m_ImgPos.x, p.m_ImgPos.y, z);
      fill(p.m_ImgCol);
      ellipse(0, 0, 2.0f, 2.0f);
      popMatrix();
    }
  }
}
