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
  local result is ((ship:liquidfuel / 24300) * 100).
  return result.
}

// Sets "pitch" as Function to be used in navball pitch orientation call.
LOCK pitch to 90 - vectorangle(UP:FOREVECTOR, FACING:FOREVECTOR).

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
SET STEERINGMANAGER:MAXSTOPPINGTIME TO 7.

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
PRINT "ENTERING MANUAL CORRECTION MODE. PRESS ANY KEY TO CONTINUE".
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
AG1 on.

WAIT UNTIL ship:altitude < 50000.

IF ship:altitude < 50000
{
  RCS off.
  PRINT "EXECUTING REENTRY BURN.".
  UNTIL getFuelPercentage < 8
  {
    LOCK THROTTLE to 100.
  }

  IF getFuelPercentage < 8
  {
    LOCK THROTTLE to 0.
    PRINT "FUEL AMOUNT NOMINAL.".
  }
}
