function TextFile()
{
	try
	{
		this.get_name = TextFile_get_name;
		this.set_name = TextFile_set_name;
		
		this.get_text = TextFile_get_text;
		this.set_text = TextFile_set_text;

		this.write = TextFile_write;
		this.read = TextFile_read;
	}
	catch(e)
	{
		throw logError(e);
	}
}
	function TextFile_get_name()
	{
		try
		{
			return this.mvarName;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function TextFile_set_name(newName)
	{
		try
		{
			this.mvarName = newName;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function TextFile_get_text()
	{
		try
		{
			return this.mvarText;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function TextFile_set_text(newText)
	{
		try
		{
			this.mvarText = new String(newText);
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function TextFile_write()
	{
		try
		{
			alert(this.get_name());
			alert(this.get_text());
			window.windowsControl.writeTextFile(this.get_name(), this.get_text());
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function TextFile_read()
	{
		try
		{
			this.set_text(window.windowsControl.readTextFile(this.get_name()));
		}
		catch(e)
		{
			alert(e.description);
			throw logError(e);
		}
	}
