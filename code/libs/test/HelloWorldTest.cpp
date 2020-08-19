#include <gtest/gtest.h>
#include "code/libs/HelloWorld.hpp"

TEST(HelloTest, GetGreet) {
  std::string actual = HelloWorld::returnHelloWorld();
  std::string expected = "Hello world!\n";
  
  EXPECT_TRUE(true);
  
  EXPECT_EQ(actual, expected);
}