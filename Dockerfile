
Search Docs
Ctrl K

Rails
Theme
Writing custom Dockerfiles

Writing a Dockerfile
Writing a Dockerfile for your app
A Dockerfile is a text document that contains all the instructions required to build your app's source code into a Docker image. Cloud 66 uses the Docker image format, and thus all code must be built into images before it can be used.

The "build" process uses the set of instructions in the Dockerfile to build up a container image (in much the same way as a shell file executes a series of Linux tasks). Because Cloud 66 handles the entire container lifecycle on your behalf, a Dockerfile is an absolute requirement.

If you don't have a Dockerfile in your repo, we will analyze your code and suggest a Dockerfile for your app. If that file is unsuitable, use one of the guides below to write your own.

Adding a Dockerfile to your repo
A Dockerfile is essentially a plaintext file that you add to the root of your repository. You can adapt the Dockerfile we automatically generate for you during initial analysis by copying its contents from the Dashboard and creating a file named Dockerfile.cloud66 in the root of your application’s repo.

If for some reason you can’t have it in the root, you can specify this in your Cloud 66service config.

How-To Guides by framework
Click on the link for your app's language or framework for a detailed guide on writing your own Dockerfile:

Writing a custom Dockerfile for Ruby
Writing a custom Dockerfile for Node
Writing a custom Dockerfile for PHP
Important Dockerfile principles
When images are built from Dockerfiles, each line of instructions is laid down as a layer in the image, and each line that comes after it is a separate layer built "on top" of it. These layers are immutable - once they have been laid down they do not change. This has some important consequences:

If you COPY or ADD files to an early layer, you can remove or delete those files from a later layer, but they will still exist in the previous layer. This can lead to sensitive information like API keys or other secrets being unintentionally left in a layer despite being hashed or removed in a later layer.
If you add a file system to an earlier layer and then add things to that file system, you will invalidate the cache for that layer (see below for more details). This also applies to changing any commands in a Dockerfile - any change to a line will invalidate the cache for that layer (and those "above" it).
A corollary to the principle above is to try to put the least volatile and most time consuming tasks as early as possible in the Dockerfile.
Debugging Dockerfiles and Docker builds
If your Cloud 66 builds are failing with the message Sorry, Failed to build the image from the DockerFile, then there is an issue with the content or structure of your Dockerfile. There are some excellent guides online that will help you debug the issue with your Dockerfile and get it building properly. We’ve listed a few of the better ones below.

In order to find and fix the issue, it’s helpful to understand some of the basics of the build process. This simple little guide walks through the basics of how a build works, a very simple debugging technique.
Having multiple angles from which to attack the issue is always helpful. This handy guide explains a whole range of commands and methods useful for finding errors
This more advanced Docker debugging guide walks through some more complex but more powerful methods for finding and fixing issues.
If you’re truly stuck you can always reach out to our support team by logging a ticket.

Caching & build speed
When they are built, Docker images are cached by layer. If, when the image is rebuilt, any of the layers have changed, all of the layers above are also rebuilt from scratch.

This is why our default Dockerfiles tend to add the source code to the image as late as possible (i.e. in the "highest" possible layer) - because that layer is likely to change the most often. This means that only the last few layers need to be rebuilt each time you deploy. This can save a lot of time over hundreds (or thousands) of build cycles.

Putting a Dockerfile in a sub-directory
If for some reason you need to put a Dockerfile in a sub-directory - for example you have multiple services in a single repo - you can specify this in your app's service configuration (i.e. the service.yml file).

For example, this service.yml configures two services ("buyer" & "seller"), each with their own Dockerfiles:

services:
 seller:
  git_url: https://github.com/cloud66-samples/acme.git
  git_branch: master
  dockerfile_path: "./Dockerfile"
  build_root: seller
 buyer:
  git_url: https://github.com/cloud66-samples/acme.git
  git_branch: master
  dockerfile_path: "./Dockerfile"
  build_root: buyer
