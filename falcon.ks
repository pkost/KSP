// GUI for telemetry data entry (Height, FuelCap, Thrust)
LOCAL startupGUI IS gui(600, 600).
LOCAL label IS startupGUI:addlabel("FALCON PRE-LAUNCH SETTINGS").
SET label:style:align to "center".
SET label:style:hstretch TO true.

startupGUI:addlabel("LIQUID FUEL CAPACITY [UNITS]").
LOCAL LiquidFuelCap to startupGUI:addtextfield("").
startupGUI:addlabel("AVAILABLE THRUST [kN]").
LOCAL AvailableThrust to startupGUI:addtextfield("").
startupGUI:addlabel("HEIGHT WHEN LANDED [METERS]").
LOCAL HeightOverGround to startupGUI:addtextfield("").
LOCAL confirm to startupGUI:addbutton("CONFIRM SETTINGS").

startupGUI:SHOW().

LOCAL confirmation IS false.
function clickChecker
{
  SET confirmation TO true.
}
SET confirm:onclick to clickChecker@.
WAIT UNTIL confirmation.

PRINT "CONFIRMED SETTINGS.".
WAIT 2.
PRINT "CLOSING GUI.".
startupGUI:HIDE().

// Sets launch course
FUNCTION getInclinationForStage1
{
  PARAMETER alt.
  local result is (100 / ((alt / 20000) + 1.1)).
  IF result > 90
  {
    return 90.
  }
  return result.
}

// Gets amount of fuel left, in percent.
FUNCTION getFuelPercentage
{
  local result is (ship:liquidfuel / LiquidFuelCap:text:toScalar() * 100).
  return result.
}

// Sets "pitch" as Function to be used in navball pitch orientation call.
LOCK pitch to 90 - vectorangle(UP:FOREVECTOR, FACING:FOREVECTOR).

// Sets booster height with deployed landing legs. Needs separate measurement.
SET shipHeight to HeightOverGround:text:toScalar().
LOCK altOverGround to ROUND ((ship:altitude - shipHeight - geoposition:terrainheight), 2).

CLEARSCREEN.

PRINT "F9 STARTUP INITIALIZED.".

FROM {local countdown is 5.} UNTIL countdown = 0 step {SET countdown to countdown - 1.}
DO
{
  PRINT "  t-" + countdown.
  WAIT 1.
}
// Init steering, thrust
LOCK STEERING to HEADING(90, 90).
PRINT "FALCON 9 STAGE 1 IGNITION.".
LOCK THROTTLE to 1.0.
WAIT 0.2.
STAGE.
WAIT 0.5.
PRINT "LIFTOFF.".
GEAR off.

UNTIL ship:apoapsis > 150000
{
  LOCK STEERING to HEADING(90, getInclinationForStage1(SHIP:ALTITUDE)).
}

// Boostback orientation
LOCK THROTTLE to 0.
WAIT 2.
STAGE.
WAIT 5.5.
RCS on.
LOCK STEERING to HEADING(270, 5).
SET STEERINGMANAGER:MAXSTOPPINGTIME TO 4.

UNTIL ship:bearing > 89.5 and ship:bearing < 90.5 and pitch > 4.5 and pitch < 5.5
{
  PRINT "STANDBY.".
}

PRINT "AWAITING MANUAL MECO. PRESS ANY KEY TO CONTINUE.".
LOCK THROTTLE to 1.0.
LOCK STEERING to HEADING(270, 5).
RCS off.

IF terminal:input:getchar()
{
  LOCK THROTTLE to 0.
}

PRINT "BURNBACK COMPLETE.".
WAIT 2.

// Pilot can make adjustments and corrections
PRINT "ENTERING MANUAL CORRECTION MODE. PRESS ANY KEY TO CONTINUE.".
UNLOCK THROTTLE.
UNLOCK STEERING.

UNTIL terminal:input:getchar()
{
  Wait 1.
}

RCS off.
SAS off.
PRINT "INITIALIZING REENTRY PROCEDURE.".
PRINT "UNITS OF FUEL LEFT:" + ship:liquidfuel.
PRINT getFuelPercentage.

UNTIL ship:altitude < 85000
WAIT 1.

UNLOCK STEERING.
SAS on.
RCS on.
WAIT 0.5.
SET SASMODE to "retrograde".
SET NAVMODE to "surface".
AG1 on.

WAIT UNTIL ship:altitude < 35000.

IF ship:altitude < 35000
{
  PRINT "EXECUTING REENTRY BURN.".
  UNTIL getFuelPercentage < 5
  {
    LOCK THROTTLE to 100.
  }

  IF getFuelPercentage < 5
  {
    LOCK THROTTLE to 0.
    PRINT "FUEL AMOUNT NOMINAL.".
  }
}

// After plasma blackout


UNTIL altOverGround < 3000.
{
  WAIT 0.25.
}

GEAR on.
PRINT "DEPLOYING LANDING LEGS.".



// UNLOCK THROTTLE.
// UNLOCK STEERING.

// UNTIL ship:altitude < 1
// {
//   PRINT altOverGround.
//   WAIT 0.5.
// }
