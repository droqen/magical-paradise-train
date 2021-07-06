# How to add your own minigame

## 1. Create your own *NavdiBoard* scene

Create a scene with a 'NavdiBoard' at its root, OR duplicate *01-droqen/TestPlatformer.tscn*

Set the *Board View Size* variable to the size you'd like your game to display at (e.g. 160x144 or 80x80) and click *Force Setup* to change the size of the NavdiBoard.

This doesn't do much that's very visible, so I recommend enabling *Show Outline*. Then hide & show the NavdiBoard node to force it to redraw. It will indicate the area that will be visible in the larger scene.

## 2. Add it to the *gameboard_paths* array in *00-core/TrainJamMaster.gd*

var gameboard_paths = [

  **"res://02-YourFolderName/YourSceneName.tscn",**
  
  "res://01-droqen/TestPlatformer2.tscn",
  
  "res://01-droqen/TestPlatformer.tscn"
  
]

## 3. Run the project.

It should run from *00-core/coreAll.tscn*, which is the wrapper for running the entire game.

## p.s. the 'navdi2' folder

'Navdi' is my (droqen's) personal game-making and prototyping library. Explaining how any of it works is beyond the scope of this README, but you're free to use it as you see fit. If you dare.
