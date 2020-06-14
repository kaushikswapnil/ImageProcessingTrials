interface IPainter
{
 public void draw();
}

class StrokePainter implements IPainter
{
  float m_StrokeLength = 5.0f;
  float m_StrokeWeight = 5.0f;
  int m_StrokeAlpha = 50;
  
  int m_NumStrokesPerFrame = 1000;
  
  float m_FlowX = 0.0f;
  float m_FlowY = 0.0f;
  float m_FlowZ = 0.0f;
  
  float m_FlowDX = 0.008f;
  float m_FlowDY = 0.01f;
  float m_FlowDZ = 0.005f;
  
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
     
     color c = g_Image.get((int)x, (int)y);
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
