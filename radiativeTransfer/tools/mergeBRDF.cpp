#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <iostream>
#include <boost/lexical_cast.hpp>


#define Theta 360
#define Phi 90
#define L 30


float *BRDF;
using namespace std;

int LAMBDA[30]={400,410,420,430,440,450,460,470,480,490,
		500,510,520,530,540,550,560,570,580,590,
		600,610,620,630,640,650,660,670,680,690};

/** 
 * clear the partial BRDF table
 * 
 */
void clear()
{
  for(unsigned int i=0; i<Theta*Phi*L; ++i)
    BRDF[i] = 0.0;
}

long int PosOf(int t, int p, int l)
{
  return t*Phi*L + p*L + l;
}


void processFile(string basename, unsigned int thetai, unsigned int phii, unsigned int lambda)
{
  FILE *f;
  char b;
  
  std::string title = basename + "_"+boost::lexical_cast<std::string>(thetai )+"-"
    +boost::lexical_cast<std::string>(phii )+"-Photon_"
    +boost::lexical_cast<std::string>(LAMBDA[lambda] )+ "_"
    +boost::lexical_cast<std::string>(thetai )+"_"+boost::lexical_cast<std::string>(phii )+"_brdf.txt" ;

  cerr<< "Filename= "<<title<<std::endl;
  
  f=fopen(title.c_str(), "r+t");
  while (true)
    {	
      b = fgetc(f);
      if (b == '#')
	while (fgetc(f) != '\n');
      else
	{fseek(f, -1 , SEEK_CUR);break;}
    }
  

  int tii, pii, theta,phi;
  float photon;
  int cpt=0;
  //on remplit gain avec le reste du fichier
  while (!feof(f))
    {
      fscanf(f,"%d %d %d %d %f\n", &tii,&pii,&theta,&phi, &photon);
      
      BRDF[PosOf(theta,phi,lambda)] = photon;
    }  
  fclose(f); 
}


/** 
 * Output the partial BRDF for the given (thetai,phii) incidence
 * angles.
 * 
 * @param thetai 
 * @param phii 
 */
void flush( unsigned int thetai, unsigned int phii)
{
  for(unsigned int theta= 0 ;theta < 360; ++theta)
    for(unsigned int phi= 0 ;phi < 90; ++phi)
      {     
	cout << thetai << " " <<phii<<" "<<theta << " "<<phi ;
	  for(unsigned int l=0; l<L; ++l)
	    cout << " " << BRDF[PosOf(theta,phi,l)];
	cout << std::endl;
      }
}


void processAll(string basename)
{
  for(unsigned int thetai= 0 ;thetai < 1; ++thetai)
    for(unsigned int phii= 0 ;phii < 9; ++phii)
      //  for(unsigned int thetai= 0 ;thetai < 360; ++thetai)
      //for(unsigned int phii= 0 ;phii < 90; ++phii)
      {
	//Cleanup 
	//clear();
	for(unsigned int lambda=0; lambda< L ; ++lambda)
	  {
	    processFile(basename, thetai, phii*10, lambda);
	  }
	flush(thetai,phii);
      } 
}


int main(int argc, char **argv)
{
  
  BRDF = (float*)malloc(Theta*Phi*L*sizeof(float));
  if (!BRDF)
    {
      cerr<< "Malloc error"<<std::endl;
      exit(1);
    }
  
  //For each thetai,lambdai
  //  -clear
  //  -for all lambda values
  //  -  store the energy for the reflexion angles
  //  - flush the partial BRDF
  

  string basename = "Data/I01isonew_256/temp";
  
  processAll(basename);
  
  return 0;

}
