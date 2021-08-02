extends KinematicBody2D
#character mover built up over a couple project
#jank factor is extremely high rn, but it sort of works

#uses raycasts for everything bc
#rays should extend just beyond character
#left-low, and left-high raycasts are used for climbing
#probably a better way to do this

var canBeHurt = true

export var moveSpeedMax :float = 90
export var moveSpeedAccel : float = 4.5
export var moveSpeedGroundDrag : float = .55

var movingPlatform : KinematicBody2D

var moveSpeedCurrent : float = 0

export var gravityRise : float = 20
export var gravityFall : float = 15
export var fallSpeedMax = 300

var extraJumps : int = 0


export var climbAccel : float = 12
export var climbEdgeBoostAccel : float = 15

var climbExtraHoldTimeMax = .15
var climbExtraHoldTime = 0

var lastFrameInput
var jumpedThisFrame : bool = false
var jumpReleasedThisFrame : bool = false
var frameInput : Vector2

#time after leaving ground that a jump will trigger
export var graceJumpTimeMax = .18
var graceJumpTime = graceJumpTimeMax

#time before landing that a jump input will trigger upon landing
export var jumpBufferTimeMax = .08
var jumpBufferTime = -1

#how much upwards velocity falls off after jumping
export var jumpReleaseFallOff : float = 0.35



var positionLastFrame : Vector2 = Vector2.ZERO

#jump can be applied over time for some reason
#set this to very low if you dont want the floatiness

export var applyJumpTimeMax = .01
var applyJumpTime = 0
export var applyJumpPower = 120
export var initialJumpBoostMultiplier = 0.5

#used for double jumps
export var extraJumpPower = 90
export var iniitalExtraJumpBoosMultiplier = 0.5

#quick turn around is nice is you have low drag
export var fastTurnAroundMultiplierGround = 2
export var fastTurnAroundMultiplierAir = 1.5

#wall jumps use seperate vars from regular jumping
#tune the applyWallJumpPower if you dont want ppl to be able to
#wall jump up a wall
export var applyWallJumpTimeMax = .01
var applyWallJumpTime = 0 
export var applyWallJumpPower : Vector2 = Vector2(200,30)
export var initialWallJumpBoostMultiplier = 0.5

#super hack, provides small upwards force when push against a wall
#can give a nice sliding down a wall slowly thing
#but also gives super jumps when pushed against a wall :/

export var wallSlideUpwardForce : float = 3
export var wallSlideMaxFallSpeed = 100

export var wallSlideInitialSpeedMultiplier = 0.5
var wallTouchesMax : int = 2
var wallTouches : int = 2

export var hBumpThresholdMultiplier = 0.76
export var hBumpSlowDownMultiplier = 0.5

enum MOVESTATES {WALK, RUN, SLOWED, AIR}
var currentState = 0

#tracks last frames state, mostly use for animation stuff
var onGround : bool = false
var onGroundLastFrame : bool = false
var onWallLeft : bool = false
var onWallLeftLastFrame : bool = false
var onWallLeftLow : bool = false
var onWallLeftLowLastFrame : bool = false
var onWallRightLow : bool = false
var onWallRightLowLastFrame : bool = false
var onWallRight : bool = false
var onWallRightLastFrame : bool = false
var onWall : bool = false
var onWallLastFrame : bool = false

var facing : int = 1

var velocity : Vector2 = Vector2.ZERO
var velocityLastFrame : Vector2 = Vector2.ZERO
var velocityDelta : Vector2 = Vector2.ZERO


onready var floorCastLeft : RayCast2D = $Rays/FloorCastLeft
onready var floorCastRight : RayCast2D = $Rays/FloorCastRight
onready var rightCast : RayCast2D = $Rays/RightCast
onready var rightCastLow : RayCast2D = $Rays/RightCastLow
onready var leftCast : RayCast2D = $Rays/LeftCast
onready var leftCastLow : RayCast2D = $Rays/LeftCastLow


onready var gfx = $GFX
#onready var squishAnimator = $GFX/SquishAnimator

var isCrouch : bool = false


var isPaused : bool = false

var startPos : Vector2 = Vector2.ZERO

func _ready():
	SetState(MOVESTATES.WALK)
	var _err

	
#	var level = get_parent()
#	level.connect("ENTITY_PAUSE_ON",self,"PauseOn")
#	level.connect("ENTITY_PAUSE_OFF",self,"PauseOff")

	
	isPaused = false



func SetState(newState : int):
	currentState = newState


func PauseOn():
	isPaused = true

func PauseOff():
	isPaused = false


func _physics_process(delta):
	if isPaused: 
		return

	velocityDelta = Vector2.ZERO

	GetInputs()
	onGround = CheckOnGround()
	onWallLeft = leftCast.is_colliding()
	onWallLeftLow = leftCastLow.is_colliding()
	onWallRight = rightCast.is_colliding()
	onWallRightLow = rightCastLow.is_colliding()
	onWall = onWallLeft || onWallRight || onWallLeftLow || onWallRightLow
	ProcessGraceJump(delta)
	ProcessJumpBuffer(delta)
	
	
	velocityDelta.x = (frameInput.x * moveSpeedAccel)

	

	if frameInput.x == 0:
		velocity.x = velocity.x * moveSpeedGroundDrag

	if !onGround:
		if velocity.y < 0:	
			velocity.y += gravityRise
		else:
			velocity.y += gravityFall
	else:
		velocity.y = 0

	var isJumping = Jump(delta)

	WallJump(delta)
	EarlyFall()
	FastTurnAround()
	HBumpSlowDown()
	WallSlideInitialSlowDown()
	
	WallSlide()
	var isClimb = WallClimb(delta)
	if !isClimb:
		Crouch()
	
	
	ExtraJumps()
	

	velocity += velocityDelta #this is weird but dont touch it
	
	ClampSpeeds()

	var snap = Vector2(0,1)
	if isJumping:
		snap = Vector2.ZERO
	
	
	var _linVel = move_and_slide_with_snap(velocity,snap, Vector2.UP)
	
	gfx.SetAnim(frameInput,onGround,isClimb,isJumping, isCrouch)
		
		


	EndProcess()

func ClampSpeeds():
	velocity.x = clamp(velocity.x,-moveSpeedMax, moveSpeedMax)

	if velocity.y > (fallSpeedMax):
		velocity.y = fallSpeedMax

func EndProcess():
	#squishAnimator.SquishAnimate(velocity)
	#squishAnimator.SquishLand(onGround, onGroundLastFrame, velocityLastFrame)
	#squishAnimator.SquishRight(onWallRight, onWallRightLastFrame, velocityLastFrame)
	#squishAnimator.SquishLeft(onWallLeft, onWallLeftLastFrame, velocityLastFrame)

	gfx.SetFacing(frameInput.x)
	SetFacing()
	lastFrameInput = frameInput
	onGroundLastFrame = onGround
	onWallLastFrame = onWall
	onWallLeftLastFrame = onWallLeft
	onWallRightLastFrame = onWallRight
	velocityLastFrame = velocity
	positionLastFrame = global_position

	
	

func SetFacing():
	if frameInput.x != 0:
		facing = frameInput.x

func GetInputs():
	jumpedThisFrame = $GabeKeyboardInput.GetJumpInput()
	jumpReleasedThisFrame = $GabeKeyboardInput.GetJumpReleaseInput()
	frameInput = $GabeKeyboardInput.GetDirectionalInputs()

	



func WallClimb(delta):
	
	if onGround && frameInput.y > -1:
		#if on ground, must press up to begin climb
		return 
	
	#returns tru if climbing, false if not
	#also handles all the climbing stuff
	climbExtraHoldTime -= delta
	
	var left = onWallLeft && onWallLeftLow
	var right = onWallRight && onWallRightLow
	
	var leftLowOnly = !onWallLeft && onWallLeftLow
	var rightLowOnly = !onWallRight && onWallRightLow
	
	
	
	#normal climbing
	if (left && frameInput.x == -1) || (right && frameInput.x == 1):
		climbExtraHoldTime = climbExtraHoldTimeMax
		#stop if falling
		if velocity.y > 0:
			velocity.y = 0
		
		velocity.x = 0
		#velocity.y += (frameInput.y * climbAccel)
		velocity.y = (frameInput.y * climbAccel)
		
		return true
		
	#top edge climbing (final push)
	elif (leftLowOnly && frameInput.x == -1) || (rightLowOnly && frameInput.x == 1):
		climbExtraHoldTime = climbExtraHoldTimeMax
		if velocity.y > 0:
			velocity.y = 0
		
		velocity.x = 0
		velocity.y += (frameInput.y * climbEdgeBoostAccel) 
		
		
		return true
		
	elif climbExtraHoldTime > 0:
		if velocity.y > 0:
			velocity.y = 0
		
		
		velocity.y += (frameInput.y * climbAccel)
		return true
		
	#early drop
	if !left && !right && frameInput.y == 1:
		climbExtraHoldTime = 0
		
	return false



func HBumpSlowDown():
	if velocity.x >= (moveSpeedMax * hBumpThresholdMultiplier):

		if (frameInput.x == 1 && onWallRight) || (frameInput.x == -1 && onWallLeft):
			velocity.x = velocity.x * hBumpSlowDownMultiplier
			velocity.y = velocity.y * hBumpSlowDownMultiplier
		

func CheckOnGround():
	return (floorCastLeft.is_colliding() || floorCastRight.is_colliding() )

func ProcessJumpBuffer(delta):
	if jumpedThisFrame:
		jumpBufferTime = jumpBufferTimeMax
	else:
		jumpBufferTime -= delta

func ProcessGraceJump(delta):
	
	if onGround:
		graceJumpTime = graceJumpTimeMax
	else:
		graceJumpTime -= delta


func Jump(delta):
	var isJump = false
	if (graceJumpTime > 0) && (jumpBufferTime > 0):
		applyJumpTime = applyJumpTimeMax
		velocity.y = applyJumpPower * -1 * initialJumpBoostMultiplier
		isJump = true


	if applyJumpTime > 0:
		velocity.y -= applyJumpPower
		applyJumpTime -= delta
		isJump = true
		#$PlayerSFX.PlayJumpSound()
		
	

	return isJump

func ExtraJumps():
	var _isJump = false
	if onGround == false && onWall == false && jumpedThisFrame && extraJumps > 0:
		applyJumpTime = applyJumpTimeMax
		velocity.y = extraJumpPower * -1 * iniitalExtraJumpBoosMultiplier
		_isJump = true
		
		ChangeExtraJumps(-1)
		
func ChangeExtraJumps(val):
	extraJumps += val


func WallJump(delta):
	if onGround || onGroundLastFrame:
		return
		
	if (graceJumpTime < 0) && onWall && (jumpBufferTime > 0):
		velocity.y = applyWallJumpPower.y * initialWallJumpBoostMultiplier
		velocity.x = 0
		applyWallJumpTime = applyWallJumpTimeMax
		
		climbExtraHoldTime = 0

		#$PlayerSFX.PlayDoubleJumpSound()
		

	if applyWallJumpTime > 0:
		
		velocity.y -= applyWallJumpPower.y
		
		if onWallLeft:
			velocityDelta.x += applyWallJumpPower.x * 1

		if onWallRight:
			velocityDelta.x += applyWallJumpPower.x * -1

		applyWallJumpTime -= delta



func EarlyFall():
	if jumpReleasedThisFrame && velocity.y < 0:
		velocity.y = velocity.y * jumpReleaseFallOff

		applyJumpTime = 0
		applyWallJumpTime = 0


func FastTurnAround():
	if frameInput.x != 0:

		if sign(velocity.x) != frameInput.x:
			if onGround:
				velocityDelta.x = velocityDelta.x * fastTurnAroundMultiplierGround
			if !onGround:
				velocityDelta.x = velocityDelta.x * fastTurnAroundMultiplierAir
			
func WallSlide():
	if onGround:
		return

	if (onWallLeft && frameInput.x == - 1) || (onWallRight && frameInput.x ==  1):
		velocity.y -= wallSlideUpwardForce
		if velocity.y > wallSlideMaxFallSpeed:
			velocity.y = wallSlideMaxFallSpeed


func SpikeTouched(_area):
	if canBeHurt:
		pass
			
		

func WallSlideInitialSlowDown():
	if onGround:
		wallTouches = wallTouchesMax

	if wallTouches <= 0:
		return	

	if (!onWallLeftLastFrame && onWallLeft && frameInput.x == - 1) || (!onWallRightLastFrame && onWallRight && frameInput.x ==  1):
		if !jumpedThisFrame:
			velocity.y = velocity.y * wallSlideInitialSpeedMultiplier
			wallTouches -=1
	
	
func Crouch():
	if onGround == false:
		return
	
	if frameInput.y == 1:
		velocity = Vector2.ZERO
		isCrouch = true
	else:
		isCrouch = false

