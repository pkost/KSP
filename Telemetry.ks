CLEARSCREEN.

PRINT "BEFORE COMMENCING, MAKE SURE THAT LSAs ARE ON SECOND STAGE AND ONLY MAIN BOOSTERS HAVE FUEL LEFT.".
PRINT " ".
PRINT "NO PAYLOAD ALLOWED.".
PRINT "GRAVITY SENSOR REQUIRED.".
PRINT "REVERT FLIGHT OR RETRIEVE CRAFT TO CANCEL.".
PRINT " ".
PRINT "PRESS ANY KEY TO CONTINUE...".
UNTIL terminal:input:getchar()
{
  Wait 1.
}

CLEARSCREEN.
FOR item IN ship:resources
{
  IF item:name = "LiquidFuel"
  {
    SET ship_liquidfuel to item.
  }.
}.
SET booster_liquidfuel_capacity to ship_liquidfuel:capacity.

WAIT 0.5.
PRINT "BOOSTER LIQUID FUEL CAPACITY: " + booster_liquidfuel_capacity.
PRINT " ".
PRINT "PRESS ANY KEY TO CONTINUE...".
UNTIL terminal:input:getchar()
{
  Wait 1.
}

LOCK STEERING to HEADING (90, 90).
STAGE.
WAIT 1.

list engines in elist.
for engine in elist
{
  if engine:ignition
  {
    PRINT "AVAILABLE THRUST (kN): " + ROUND ((engine:availablethrust), 2).
  }
}
PRINT " ".
PRINT "EQUALING " + ROUND ((availablethrust), 2) + " kN IN TOTAL AT SEA LEVEL.".
PRINT " ".
PRINT "READY FOR STATIC FIRE TEST. PRESS ANY KEY TO CONTINUE...".
UNTIL terminal:input:getchar()
{
  Wait 1.
}

PRINT "DELTA V (m/s^2) = " + ROUND (((availablethrust / ship:mass)) - ship:sensors:grav:mag, 2).
LOCK THROTTLE to 1.

UNTIL availablethrust < 1
{
  WAIT 7.5.
  PRINT "DELTA V (m/s^2) = " + ROUND (((availablethrust / ship:mass)) - ship:sensors:grav:mag, 2).
}

PRINT "STATIC FIRE TEST COMPLETE. STANDBY...".
WAIT 2.
GEAR on.
WAIT 5.
STAGE.
PRINT "WAITING FOR BOOSTER TO SETTLE. STANDBY 20.".
WAIT 20.
SET shipHeight to ((ship:altitude) - (geoposition:terrainheight + 7.5)).
PRINT "BOOSTER HEIGHT [m]: " + ROUND ((shipHeight), 2).
PRINT " ".
PRINT "BOOSTER READY FOR RETRIEVAL...".
