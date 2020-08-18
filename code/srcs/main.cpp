#include <fstream>
#include "HelloWorld.hpp"

using namespace std;

int main(){
  ios_base::sync_with_stdio(0);cin.tie(0);

  std::ofstream texto("texto.txt");

  texto << HelloWorld::imprimirHelloWorld();

  return 0;
}