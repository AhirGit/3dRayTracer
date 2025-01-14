//3d coordinates
final float N = 16;
final float L = -10;
final float R = 10;
final float B = -10;
final float T = 10;

//colour constants
// A, D, S colors
final float[] BACKGROUND_COLOUR = {0.0f, 0.0f, 0.0f};
final float[][] BLUE = {{0.0f, 0.0f, 1.0f}, {0.0f, 0.0f, 1.0f}, {1f, 1f, 1f}};
final float[][] RED = {{1.0f, 0.0f, 0.0f},{1.0f, 0.0f, 0.0f}, {1f, 1f, 1f}};
final float[][] PINK = {{1.0f, 0.5f, 0.7f}, {1.0f, 0.5f, 0.7f}, {1f, 1f, 1f}};
final float[][] VIOLET = {{0.5f, 0.0f, 1.0f}, {0.5f, 0.0f, 1.0f}, {1f, 1f, 1f}};
final float[][] YELLOW = {{1.0f, 1.0f, 0.0f}, {1.0f, 1.0f, 0.0f}, {1f, 1f, 1f}};
final float[][] ORANGE = {{1.0f, 0.5f, 0.0f}, {1.0f, 0.5f, 0.0f}, {1f, 1f, 1f}};
final float[][] GREEN = {{0.0f, 1.0f, 0.0f}, {0.0f, 1.0f, 0.0f}, {1f, 1f, 1f}};

final int NUM_COLOR_CHANNELS = 3;

//NAMED CONSTANTS to access the entries
final int A = 0; ///Ambient
final int D = 1; //Diffuse
final int S = 2; //Specular
final int NUM_LIGHT_COMPONENTS = 3;

//positon of eye in 3d space
final PVector EYE = new PVector(0,0,0);

// Phong lighting parameters
PVector LIGHT = new PVector(20, 20, -10); // location of the light source
final float[] MATERIAL = {0.3, 0.3, 0.5}; // A, D, S
final float PHONG_SHININESS = 60; // exponent

final float SPECULAR_CUTOFF = 0.01;
final float SPECULAR_FLOOR = (float)Math.pow(SPECULAR_CUTOFF, 1/PHONG_SHININESS);

//colour the following pixel in the raster
void setPixelColour(int col, int row, float[] colour) {
    // Ensure the pixel position is valid
    if (row < 0 || row >= height || col < 0 || col >= width) {
        return; // Out of bounds, do nothing
    }

    // Calculate the 1D index for the pixel array
    int index = row*width + col;

    // Convert the colour array (R, G, B) into a single color value
    color pixelColor = color(colour[0]*250, colour[1]*250, colour[2]*250);

    // Set the pixel color in the pixels[] array
    pixels[index] = pixelColor;
}

//find the position of the pixel center in 3d space
PVector pixelCenter3D(int i, int j) {
  // Compute the x, y, z coordinates of the pixel center in 3D space
  float x = L + ((R - L) / width) * (i + 0.5);
  float y = B + ((T - B) / height) * (j + 0.5);
  float z = N; //Positon of raster

  // Return the 3D position as a PVector
  //-y to prevent/fix flipped image
  return new PVector(x, -y, z);
}

//phong lighting model from Assignment 1
float[] phong(PVector p, PVector n, PVector eye, PVector light,
  float[] material, float[][] fillColor, float shininess) {
  
  //result for calculating the phong colour
  float[] lightResult = new float[NUM_COLOR_CHANNELS];
  
  //normalize all vectors make sure the magnitude doesn't affect the light 
  PVector L = directionVector(p, light).normalize();
  PVector V = directionVector(p, eye).normalize();
  PVector R = reflectionVector(L, n);
  
  float NdotL = max(n.dot(L), 0); //(N.L) > 0
  float RdotV = max(V.dot(R), SPECULAR_FLOOR); //(R.V) > SPECULAR_FLOOR
  float specFactor = pow(RdotV, shininess);
  
  //Ambient
  float[] ambient = new float[NUM_COLOR_CHANNELS];
  float[] diffuse = new float[NUM_COLOR_CHANNELS];
  float[] specular = new float[NUM_COLOR_CHANNELS];
  
  for(int j = 0; j < NUM_COLOR_CHANNELS; j++){
    ambient[j] = material[A] * fillColor[A][j];
    diffuse[j] = material[D] * fillColor[D][j] * NdotL;
    specular[j] = material[S] * fillColor[S][j] * specFactor;
    
    lightResult[j] = ambient[j] + diffuse[j] + specular[j];
  }
  
  return lightResult;
}
