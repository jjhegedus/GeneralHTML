function TextRecord()
{
	try
	{
		this.mvarDelimited = true;
		this.set_delimited = TextRecord_set_delimited;
		this.get_delimited = TextRecord_get_delimited;
		
		this.mvarFieldSeparator = ":";  //String.fromCharCode(9);
		this.set_fieldSeparator = TextRecord_set_fieldSeparator;
		this.get_fieldSeparator = TextRecord_get_fieldSeparator;
		
		this.mvarFields = new ObjectCollection(new TextField());
		this.get_fields = TextRecord_get_fields;
		
		this.get_field = TextRecord_get_field;
		
		this.set_text = TextRecord_set_text;
		
		this.get_htmlRow = TextRecord_get_htmlRow;
	}
	catch(e)
	{
		throw logError(e);
	}
}
	function TextRecord_set_delimited(new_delimited)
	{
		try
		{
			if(typeof(new_delimited) == 'boolean')
			{
				this.mvarDelimited = new_delimited;
			}
			else
			{
				var err = new Error();
				err.number = 10002;
				err.source = "TextRecord_set_delimited(" + new_delimited + "):if(typeof(new_delimited) = 'boolean')";
				err.description = "The delimited property can only be set to a boolean value";
			}
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function TextRecord_get_delimited()
	{
		try
		{
			return this.mvarDelimited;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function TextRecord_set_fieldSeparator(new_fieldSeparator)
	{
		try
		{
			this.mvarFieldSeparator = new_fieldSeparator;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function TextRecord_get_fieldSeparator()
	{
		try
		{
			return this.mvarFieldSeparator;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function TextRecord_get_fields()
	{
		try
		{
			return this.mvarFields;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function TextRecord_get_field(index)
	{
		try
		{
			return this.mvarFields.item(index);
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function TextRecord_set_text(new_text)
	{
		try
		{
			this.mvarText = new String(new_text);
			
			if(this.mvarDelimited)
			{
				this.mvarFieldsArray = this.mvarText.split(this.get_fieldSeparator());
				
				for(var lpCtr = 0;lpCtr < this.mvarFieldsArray.length;lpCtr++)
				{
					this.mvarFields.item(lpCtr).set_value(this.mvarFieldsArray[lpCtr]);
				}
			}
			else
			{
			}
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function TextRecord_get_htmlRow()
	{
		try
		{
			var lpTr = document.createElement('tr');
			
			var lpRecordText = new String(this.mvarText);
			if(this.get_delimited())
			{
				for(var lpFieldCtr = 0;lpFieldCtr < this.mvarFields.count;lpFieldCtr++)
				{
					var lpField = this.get_field(lpFieldCtr);
					var lpTd = document.createElement('td');
					lpTr.width = lpField.get_displayWidth();
					
					lpTd.innerText = lpField.get_value().replace(/^\s+/, '');
					
					lpTr.appendChild(lpTd);
				}
			}
			else
			{
				alert('Fixed length records not yet implemented');
			}
			
			return lpTr;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
