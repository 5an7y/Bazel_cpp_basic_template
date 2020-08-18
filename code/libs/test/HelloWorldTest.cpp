#include "gtest/gtest.h"
#include "code/libs/HelloWorld.hpp"

TEST(HelloTest, GetGreet) {
  std::string actual = HelloWorld::imprimirHelloWorld();
  std::string expected = "Hola mundo!\n";
  
  EXPECT_TRUE(true);
  
  EXPECT_EQ(actual, expected);
}