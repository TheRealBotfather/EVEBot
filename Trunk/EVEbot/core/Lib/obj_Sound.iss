/*
	Sound class

	Object to handle playing sounds.

	-- GliderPro

*/

objectdef obj_Sound inherits obj_BaseClass
{
	variable string SVN_REVISION = "$Rev$"

	variable int m_LastSoundTime
	variable int m_SoundDelay

	method Initialize()
	{
		LogPrefix:Set["${This.ObjectName}"]

		m_LastSoundTime:Set[${LavishScript.RunningTime}]
		m_SoundDelay:Set[15000]	/* milliseconds */
		;PulseTimer:SetIntervals[0.5,1.0]
		;Event[EVENT_ONFRAME]:AttachAtom[This:Pulse]

		Logger:Log["${LogPrefix}: Initialized", LOG_MINOR]
	}

	method TryPlaySound(string Filename)
	{
		if !${Config.Common.UseSound}
			return

		if ${Math.Calc64[${m_LastSoundTime} + ${m_SoundDelay}]} < ${LavishScript.RunningTime}
		{
			PlaySound "${Filename}"
			m_LastSoundTime:Set[${LavishScript.RunningTime}]
		}
	}

	method PlayAlarmSound()
	{
		This:TryPlaySound[ALARMSOUND]
	}

	method PlayDetectSound()
	{
		This:TryPlaySound[DETECTSOUND]
	}

	method PlayTellSound()
	{
		This:TryPlaySound[TELLSOUND]
	}

	method PlayLevelSound()
	{
		This:TryPlaySound[LEVELSOUND]
	}

	method PlayWarningSound()
	{
		This:TryPlaySound[WARNSOUND]
	}
}
