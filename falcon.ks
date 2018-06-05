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

PRINT ship:heading.

FROM {local countdown is 5.} UNTIL countdown = 0 step {SET countdown to countdown - 1.}
DO
{
  PRINT "  t-" + countdown.
  WAIT 1.
}
// Init steering, thrust
SET STEERING  TO HEADING(90,90).
PRINT "FALCON 9 STAGE 1 IGNITION.".
SET THROTTLE to 1.0.
WAIT 0.2.
STAGE.
WAIT 0.5.
PRINT "LIFTOFF.".

UNTIL SHIP:APOAPSIS > 150000
{
  SET STEERING to HEADING(90, getInclinationForStage1(SHIP:ALTITUDE)).
}

SET THROTTLE to 0.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
SET SHIP:CONTROL:NEUTRALIZE TO TRUE.