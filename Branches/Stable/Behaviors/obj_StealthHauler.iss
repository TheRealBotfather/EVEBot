/*
	The stealth hauler object
	
	The obj_StealthHauler object is a bot mode designed to be used with 
	obj_Freighter bot module in EVEBOT.  It will move cargo from point A
	to point B in a covert ops or force recon ship.  It will stay cloaked
	the entire time and it will attempt to avoid bubbles and 'dictors.
	
	-- GliderPro	
*/

/* obj_StealthHauler is a "bot-mode" which is similar to a bot-module.
 * obj_StealthHauler runs within the obj_Freighter bot-module.  It would 
 * be very straightforward to turn obj_StealthHauler into a independent 
 * bot-module in the future if it outgrows its place in obj_Freighter.
 */
 
objectdef obj_StealthHauler
{
	variable index:int apRoute
	variable index:int apWaypoints
	variable iterator  apIterator
	
	method Initialize()
	{
		UI:UpdateConsole["obj_StealthHauler: Initialized", LOG_MINOR]
	}

	method Shutdown()
	{
	}
	
	method SetState()
	{
		
	}

	function ProcessState()
	{
		if ${Station.Docked}
		{
			call Station.Undock
		}
		elseif ${Ship.HasCovOpsCloak}
		{
			if ${apRoute.Used} == 0
			{
				EVE:GetToDestinationPath[apRoute]	
				EVE:GetWaypoints[apWaypoints]
				apRoute:GetIterator[apIterator]
				apIterator:First
				
				if ${apRoute.Used} == 0
				{	/* must be at the destination */
					Me:SetVelocity[${Math.Calc[90 + ${Math.Rand[9]} + ${Math.Calc[0.10 * ${Math.Rand[9]}]}]}]
					wait 5
					Ship:Activate_AfterBurner
					wait 5
					Ship:Activate_Cloak
				}
			}
			else
			{
				if ${apIterator.Value(exists)}
				{
					variable index:entity sgIndex
					variable iterator     sgIterator
					EVE:QueryEntities[sgIndex, "GroupID = GROUP_STARGATE && Name = ${Universe[${apIterator.Value}].Name}"]
					sgIndex:GetIterator[sgIterator]
					if ${sgIterator:First(exists)}
					{
				
						if ${sgIterator.Value(exists)}
						{
							UI:UpdateConsole["Setting speed to full throttle"]
							Me:SetVelocity[${Math.Calc[90 + ${Math.Rand[9]} + ${Math.Calc[0.10 * ${Math.Rand[9]}]}]}]
							do
							{
							   	wait 5
							}
							while ${Me.ToEntity.IsCloaked}
							Ship:Activate_AfterBurner
							wait 5
							do
							{
								Ship:Activate_Cloak
							   	wait 10
							}
							while !${Me.ToEntity.IsCloaked}
							do
							{
							   wait 5
							}
							while ${Me.ToEntity.IsWarpScrambled}
							wait 5
							call Ship.WarpToID ${sgIterator.Value.ID}
							call Ship.Approach ${sgIterator.Value.ID} JUMP_RANGE
							Ship:Deactivate_Cloak
							do
							{
							   	wait 5
							}
							while ${Me.ToEntity.IsCloaked}
							wait 5
							sgIterator.Value:Jump
							wait 50
							apIterator:Next
						}
						else
						{
							UI:UpdateConsole["obj_StealthHauler: Could not find stargate to ${Universe[${apIterator.Value}].Name}!!", LOG_CRITICAL]
						}
					}	
				}
				else
				{	/* must be at the destination */
					Me:SetVelocity[${Math.Calc[90 + ${Math.Rand[9]} + ${Math.Calc[0.10 * ${Math.Rand[9]}]}]}]
					wait 5
					Ship:Activate_AfterBurner
					wait 5
					Ship:Activate_Cloak
				}
				
			}
		}
		else
		{
			UI:UpdateConsole["obj_StealthHauler: ERROR: You need a CovOps cloak to use this script!!", LOG_CRITICAL]
		}
	}
}
