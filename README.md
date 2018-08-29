## IMPORTANT
1) You will need a valid Unity pro license to use this image
2) Your Unity account must not use Google oAuth. You account must have been created directly on the Unity website.
3) You will need to rebuild the image to use any other components than WebGL
4) You will need to use the --memory flag to build the image. You can limit it to 3gb. Otherwise it will max out your ram and crash all your docker instances.
5) When you run the image make sure you are using the same hostname everytime because all unity subscriptions have a limited number of activation. Using the same hostname will trick the activation into thinking you are using the same computer.

## How to run
# Via docker
`docker run -v ./:/app --hostname=sameHostnameEverytime -e UNITY_USERNAME=myusename -e UNITY_PASSWORD=mypassword -e UNITY_SERIAL=myserial -e BUILD_TARGET=WebGL -e METHOD_FULLPATH=MyBuilder.build trespetitlegume:unity`

# ENV variables
- UNITY_USERNAME -> Do not use any quotes
- UNITY_PASSWORD -> Do not use any quotes
- UNITY_SERIAL -> The serial associated with your account or as Unity calls it, your seat.
- BUILD_TARGET -> WebGL, Android, etc
- ADDITIONAL_OPTIONS -> You can pass any additionnal options to the cli here
- METHOD_FULLPATH -> This is the method you want the cli to run. It must include the namespace, the class and the method

## How to build and add new components

# BUILD_ARG variables
- UNITY_COMPONENTS -> If you want more components/module such as Android, IOS, etc, you can do so by rebuilding the image and by using UNITY_COMPONENTS. Each component need to be separated by a comma.
`docker build --build-arg UNITY_COMPONENTS=webgl,android`

*The dependencies installed are currently only those for WebGL. You will need to add the required dependencies depending on your components. The dependencies are specified at https://forum.unity.com/threads/unity-on-linux-release-notes-and-known-issues.350256/

- UNITY_DOWNLOAD_LINK -> downgrade/upgrade the version of unity
`docker build --build-arg UNITY_DOWNLOAD_LINK=https://beta.unity3d.com/download/88f43da96871/UnitySetup-2018.2.5f1 .`
