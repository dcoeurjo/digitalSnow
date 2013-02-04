#include <cmath>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <cstring>
#include<locale>
using namespace std;

//Verifie que la somme de l'energie est < 1

int main(int argc, char *argv[]){


  if (argc < 1) {cout <<" syntax is < command > inputBRDF.txt"; return 0;}
  
  
  /*  ifstream fichierEntree(argv[1]);
  locale mylocale("C");  
  fichierEntree.imbue(mylocale);
  */
  float thetai,phii,theta,phi,photon,energy;
  std::cout<<"Reading..."<<std::endl;


  //fichierEntree.seekg(0,ios::beg);
  string a,ligne;
  char b;

  FILE *f;

  f=fopen(argv[1], "r");
  

  //on elimine les lignes de commentaires en tete de fichier
  /*while (true)
    {	
      fichierEntree >> a ;
      if (isdigit(a.c_str()[0])) break;
      else if (a.c_str()[0]=='#')
	{
	  fichierEntree.get(b);
	  if (b!='\n') getline(fichierEntree,ligne);
	}
    }
  */
  
  while (true)
    {	
      b = fgetc(f);
      if (b == '#')
	while (fgetc(f) != '\n');
      else
	{fseek(f, -1 , SEEK_CUR);break;}
    }
  
  
  int cpt=0;
  energy = 0.0;
  //on remplit gain avec le reste du fichier
  while (!feof(f))
    {
      fscanf(f,"%f %f %f %f %f\n", &thetai,&phii,&theta,&phi, &photon);
      /*fichierEntree >> thetai;
      fichierEntree >> phii;
      fichierEntree >> theta;
      fichierEntree >> phi;
      fichierEntree >> photon;*/
      energy  += photon;
      //std::cout << theta<<"  "<<phi<<"  "<<photon<<" "<<std::endl;;
      cpt++;
    }

  //fichierEntree.close();
  
  std::cout << "Energy ="<<energy<<"  cpt="<<cpt<<std::endl;
  
  return (energy<=1);

}
