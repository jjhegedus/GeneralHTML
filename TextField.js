function TextField()
{
	try
	{
		this.set_name = TextField_set_name;
		this.get_name = TextField_get_name;
		
		this.set_length = TextField_set_length;
		this.get_length = TextField_get_length;
		
		this.set_offset = TextField_set_offset;
		this.get_offset = TextField_get_offset;
		
		this.set_value = TextField_set_value;
		this.get_value = TextField_get_value;
		
		this.set_displayWidth = TextField_set_displayWidth;
		this.get_displayWidth = TextField_get_displayWidth;
	}
	catch(e)
	{
		throw logError(e);
	}
}
	function TextField_set_name(new_name)
	{
		try
		{
			this.mvarName = new_name;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function TextField_get_name()
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
	function TextField_set_length(new_length)
	{
		try
		{
			this.mvarLength = new_length;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function TextField_get_length()
	{
		try
		{
			return this.mvarLength;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function TextField_set_offset(new_offset)
	{
		try
		{
			this.mvarOffset = new_offset;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function TextField_get_offset()
	{
		try
		{
			return this.mvarOffset;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function TextField_set_value(new_value)
	{
		try
		{
			this.mvarValue = new String(new_value);
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function TextField_get_value()
	{
		try
		{
			return this.mvarValue;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function TextField_set_displayWidth(new_displayWidth)
	{
		try
		{
			this.mvarDisplayWidth = new_displayWidth;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function TextField_get_displayWidth()
	{
		try
		{
			return this.mvarDisplayWidth;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
