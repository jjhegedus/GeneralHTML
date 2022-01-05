function WindowsOS()
{
	try
	{
		this.windowsControl = WindowsOS_get_windowsControl;
	}
	catch(e)
	{
		throw logError(e);
	}
}
	function WindowsOS_get_windowsControl()
	{
		try
		{
			if(!this.mvarWindowsControl)
			{
				this.mvarWindowsControl = new ActiveXObject('windowsControl.clsWindowsControl');
			}
			
			return this.mvarWindowsControl;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
