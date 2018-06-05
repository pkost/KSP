FUNCTION getInclinationForStage1
{
  PARAMETER alt.
  PRINT alt.
  local result is (100 / ((alt / 20000) + 1.1)).
  IF result > 90
  {
    return 90.
  }
  PRINT result.
  return result.
}


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

//Boostback burn initialisation
LOCK THROTTLE to 0.
WAIT 2.
STAGE.
WAIT 5.5.
RCS on.
LOCK STEERING to HEADING(270, 15).
SET STEERINGMANAGER:MAXSTOPPINGTIME TO 7.

UNTIL ship:bearing > 88 and ship:bearing < 92
{
  PRINT "WAITING FOR BEARING." + ship:bearing.
}

UNLOCK STEERING.
UNLOCK THROTTLE.
