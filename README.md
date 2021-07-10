# How to add your own minigame

## 1. Create your own scene

Duplicate **01-droqen/TemplateMinigame.tscn** into your own folder. Give it a new name.

In order to signal to the game that you want to advance to the next scene, emit either the **SubwayStopBoard.gd** node's "player_won" or "player_lost" signal. See the node named "**when empty, win**" for an example.

(!!!) Don't change the script on the root 'NavdiBoard' node or any of its variables, although you may rename it if you like.

## 2. Create a new **MicrogameMetadata** resource in **00-core/metromap/** (OPTIONAL)

You can just duplicate **00-core/metromap/droqen_template_minigame.tres**, but then double-check before editing: are you editing the new resource (the one you just made) or the old existing one?

Drag your scene from the previous step into your new Resource's *Microgame Scene* variable.

## 3. Add your game to the **TrainJamMaster** node in **00-core/coreAll.tscn**

### 3a. Drag-and-drop your scene into 'Test Microgame Scene'**

Note that you should do this *with the scene itself,* not with a MicrogameMetadata resource.

'Test Microgame Scene' is a variable in the aforementioned **TrainJamMaster** node.

If you'd rather play the whole game, clear the 'Test Microgame Scene' variable.

### 3b. If you created a **MicrogameMetadata** resource, add it to 'Microgames'

'Microgames' is a variable (an array) in the **TrainJamMaster** node.

Add a new slot at the end and stick your microgame resource in there.

## 4. Run the project.

(It should run from **00-core/coreAll.tscn**, which is the wrapper for running the entire game.)

## p.s. the 'navdi2' folder

'Navdi' is my (droqen's) personal game-making and prototyping library. Explaining how any of it works is beyond the scope of this README, but you're free to use it as you see fit. If you dare. I've included tips on some classes that you might find useful in your own project:

### NavdiCursorFollower

It's a node that will always be where the mouse is. You can use it like I do (by adding children to it) or you can just externally track its position, leaving the cursor invisible. It's up to you! You can roll your own cursor solution if you like, but this one is reliable and it will be nice to have it standardized across the whole project.

If you do use NavdiCursorFollower, make sure that you set the 'Get Cursor From Group' variable to **SuperCursor**, or it will not work.

## NavdiPinQuickPlayer

A node that provides a customizable and common input solution.

For a commented example use case, see "**01-droqen/player using NavdiPin.gd**", used in **01-droqen/RatPlatformer.tscn** on the **player** node.

*See the 'NavdiPinSetup' node in 00-core/coreAll.tscn*
