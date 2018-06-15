FUNCTION getFuelPercentage
{
  local result is (ship:liquidfuel / LiquidFuelCap:text:toScalar() * 100).
  return result.
}

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

LOCAL startupGUI IS gui(600, 600).
LOCAL label IS startupGUI:addlabel("FALCON PRE-LAUNCH SETTINGS").
SET label:style:align to "center".
SET label:style:hstretch TO true.

startupGUI:addlabel("LIQUID FUEL CAPACITY [UNITS]").
LOCAL LiquidFuelCap to startupGUI:addtextfield("").
startupGUI:addlabel("AVAILABLE THRUST [kN]").
LOCAL AvailableThrust to startupGUI:addtextfield("").
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

PRINT "READY FOR STATIC FIRE TEST. PRESS ANY KEY TO CONTINUE...".
UNTIL terminal:input:getchar()
{
  Wait 1.
}

PRINT "DELTA V (m/s^2) = " + ROUND (((availablethrust:text:toScalar() / ship:mass)) - 9.806, 2).
LOCK THROTTLE to 1.

WAIT UNTIL getFuelPercentage < 5.
LOCK THROTTLE to 0.
PRINT "TWR at 5% fuel left: " + ROUND ((ship:MAXTHRUST / ship:mass), 2).

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
