# Bazel cpp basic template

Having troubles making libraries and linking them? Just want to make libraries, code and used it not worrying to much about linking and build all to make sense? You're probably looking for a **build system**. There are many build system existing tool, one of them is *bazel* which is an open-source released of "blaze", the system that uses Google.

Having some complications understanding bazel and just want to code simple projects for cpp files? This template is for you!

## Requirements

- For using a bazel template, as you may expected, you need to [install bazel](https://docs.bazel.build/versions/master/install.html)

## How to use this template

Suppose you want to build your project under `folder/`. Then just download the files on this repository and place them under the folder. Your code project should be under the `code/` folder. Is recommended but not necessary that your libraries are under the `code/libs/` folder (DON'T ERASE THIS FOLDER), and your binaries under `code/srcs/`.

Let's go over an example to see how to make a library, binary and a test.

### Build a library

In this template is the example created, but let's go over how to do this. The first thing you want to do is create a library. On this example lets make a HelloWorld library which has a function that returns a "Hello world!" string. Implementation:

**Header**
```cpp
// code/libs/HelloWorld.hpp
#pragma once

#include <string>

namespace HelloWorld {
  std::string returnHelloWorld();
}
```

**Source**

```cpp
// code/libs/HelloWorld.cpp
#include "HelloWorld.hpp"

std::string HelloWorld::returnHelloWorld() {
  std::string hello = "Hello World!";
  return hello;
}
```

Then wherever (mostly) you have code, you'll need a BUILD file. This is a file named BUILD without extension. To make the library on the BUILD file you should write something like:

```Starlark
load("//macros:cppGenerators.bzl", "cpp_library")

cpp_library(
  name = "hello_world_lib",
  source = ["HelloWorld.cpp"],
  header = ["HelloWorld.hpp"],
)
```

- `load()`: with this load you are able to put cpp_library. If you're writing multiple libraries you only need to include this load once.
- `name`: how you want to call your library.
- `source`: a list of the source files for this library.
- `header`: the header file of this library.
- `dependencies`: if your library depends on other libraries created then you should list them here.

For compiling this library you should use run the command: (on the `folder/` path)

```Shell
bazel build code/libs:hello_world_lib
```

This command compiles and creates the library, that why we use `build` and the third argument is the path were the BUILD file is and then the name of the target you want to build. You can also run this commando under `folder/code` and just pass `libs:hello_world_lib`. This means that the path is relative of where you are at.

### Build a binary that uses a library

Now we want to use this library on a binary. Like said before the binaries are recommended to be on the srcs file. For this we create a `main.cpp` like the following:

```cpp
// code/srcs/main.cpp
#include <iostream>
#include "HelloWorld.hpp"

using namespace std;

int main() {

  std::cout << HelloWorld::returnHelloWorld();

  return 0;
}
```

Your include path could be relative to the libs folder or relative to the `folder/` path. So you could also included as "code/libs/HelloWorld.hpp"

And the corresponding BUILD file under codes/srcs/BUILD:

```Starlark
load("//macros:cppGenerators.bzl", "cpp_binary")

cpp_binary(
  name = "hello_world",
  source = ["main.cpp"],
  dependencies = [
    "//code/libs:hello_world_lib",
  ],
)
```

- `load()`: This is the corresponding load for the cpp_binary. If creating multiple binaries, just use one of this.
- `name`: name of the target for this binary.
- `source`: a list of sources for this binary.
- `dependencies`: targets in which this binary depends on. The path should relative to the `folder/` and it start with //

To build this we do something similar as in the library, under `folder`:

```Shell
bazel build code/srcs:hello_world
```

If you want to run it use the run command

```Shell
bazel run code/srcs:hello_world
```

You should see the message on your command line.

### Creaste test 

Test are mostly written to see if your code is working as expected, this test are usually write before the binary. On this template we use [google test](https://github.com/google/googletest) for our test files.

Lets create test for the HelloWorld library. For that we create a folder named `test/` under the libs folder (this folder is not required but useful for documentation). And we make a filed named `HelloWorldTest.cpp` which contains:

```cpp
// code/libs/test
#include <gtest/gtest.h>
#include "code/libs/HelloWorld.hpp"

TEST(HelloTest, GetGreet) {
  std::string actual = HelloWorld::imprimirHelloWorld();
  std::string expected = "Hello world!\n";
  
  EXPECT_EQ(actual, expected);
}
```

- `Gtest` is the google test library, you can learn how to use it on the link of the repo given before or searching on the web.

And as usual we create a build file for this test that will look like:

```Starlark
load("//macros:cppGenerators.bzl", "cpp_test")

cpp_test(
    name = "hello_test",
    source = ["HelloWorldTest.cpp"],
    dependencies = [
      "//code/libs:hello_world_lib"
    ],
)
```

Now to test it just simply run

```Shell
bazel test code/libs/test:hello_test
```

Also we if a test fail we can see were is failing and why. Lets change the .cpp file

```cpp
// code/libs/test
#include <gtest/gtest.h>
#include "code/libs/HelloWorld.hpp"

TEST(HelloTest, GetGreet) {
  std::string actual = HelloWorld::imprimirHelloWorld();
  std::string expected = "Hello what!\n";
  
  EXPECT_EQ(actual, expected);
}
```

And if you run test as before you will that fails, bazel generate an output file were you can see the logs, but if to prefer to see that file on the console you can run:

```Shell
bazel test code/libs/test:hello_test --test_output=errors
```

This flags tells bazel that you want to see the errors log when a test fails. Also you can see the output no mather if it fails if you set `all` instead if `errors`.