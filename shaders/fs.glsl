#version 330 core
out vec4 FragColor;
  
in vec4 vertexColor;

uniform vec4 our_color;

void main()
{
    FragColor = our_color;
} 