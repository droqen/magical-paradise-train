# How to add your own minigame

## 1. Create your own scene

Duplicate **01-droqen/TemplateMinigame.tscn** into your own folder. Give it a new name.

In order to signal to the game that you want to advance to the next scene, emit either the **SubwayStopBoard.gd** node's "player_won" or "player_lost" signal. See the node named **when empty, win** for an example.

(!!!) Don't change the script on the root 'NavdiBoard' node or any of its variables, although you may rename it if you like.

## 2. Create a new **MicrogameMetadata** resource in **00-core/metromap/**

You can just duplicate **00-core/metromap/droqen_template_minigame.tres**, but then double-check before editing: are you editing the new resource (the one you just made) or the old existing one?

Drag your scene from the previous step into your new Resource's *Microgame Scene* variable.

## 3. Add your game to the *Microgames* array in **00-core/coreAll.tscn**

The array lives in the Script Variables of the TrainJamMaster node (near the Viewport Slide vars)

Just overwrite whatever's in the first slot of the array. Microgames are loaded in a linear order for now.

## 4. Run the project.

(It should run from **00-core/coreAll.tscn**, which is the wrapper for running the entire game.)

## p.s. the 'navdi2' folder

'Navdi' is my (droqen's) personal game-making and prototyping library. Explaining how any of it works is beyond the scope of this README, but you're free to use it as you see fit. If you dare.

## p.s. use 'NavdiCursorFollower'

It's a node that will always be where the mouse is. You can use it like I do (by adding children to it) or you can just externally track its position, leaving the cursor invisible. It's up to you! You can roll your own cursor solution if you like, but this one is reliable and it will be nice to have it standardized across the whole project.
