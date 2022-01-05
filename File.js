function File(file)
{
	try
	{
		this.file = file;
		this.openImageSource = '/images/60-60-60.GIF';
		this.closedImageSource = '/images/60-60-60.GIF';
		this.get_name = File_get_name;
		this.get_navViewPort = File_get_navViewPort;
		this.get_defaultViewPort = File_get_defaultViewPort;
		this.showDefaultViewPort = File_showDefaultViewPort;
		this.get_children = File_get_children;
		this.get_objectType = File_get_objectType;
		this.onclick = File_onclick;
		this.fileSystem = d2k.get_activeXControl().localFileSystem;
		this.get_ascii = File_get_ascii;
		this.set_ascii = File_set_ascii;
	}
	catch(e)
	{
		throw logError(e);
	}
}
	function File_get_name()
	{
		try
		{
			return new String(this.file.Name);
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function File_get_navViewPort()
	{
		try
		{
			if(!this.mvarNavViewPort)
			{
				this.mvarNavViewPort = get_navItemViewPort(this);
			}
			
			return this.mvarNavViewPort;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function File_get_defaultViewPort()
	{
		try
		{
			if(!this.defaultViewPort)
			{
				this.defaultViewPort = createViewPort(this);
				this.defaultViewPort.style.textAlign = 'left';
				this.defaultViewPort.style.width = '98%';
				this.defaultViewPort.style.height = '98%';
				
				this.defaultViewPort.textArea = document.createElement('textArea');
				this.defaultViewPort.textArea.style.width = '100%';
				this.defaultViewPort.textArea.style.height = '85%';
				this.defaultViewPort.textArea.innerText = this.get_ascii();
				this.defaultViewPort.appendChild(this.defaultViewPort.textArea);
				this.defaultViewPort.appendChild(document.createElement('br'));
				
				this.defaultViewPort.saveButton = document.createElement('input');
				this.defaultViewPort.saveButton.type = 'button';
				this.defaultViewPort.saveButton.value = 'Update';
				this.defaultViewPort.saveButton.viewPort = this.defaultViewPort;
				this.defaultViewPort.saveButton.onclick = File_defaultViewPort_saveButton_onclick;
				this.defaultViewPort.saveButton.style.width = '20%';
				this.defaultViewPort.appendChild(this.defaultViewPort.saveButton);
			}
			
			return this.defaultViewPort;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function File_defaultViewPort_saveButton_onclick()
	{
		try
		{
			this.viewPort.object.set_ascii(this.viewPort.textArea.innerText);
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function File_showDefaultViewPort()
	{
		try
		{
			d2k.swapBodyViewPort(this.get_defaultViewPort());
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function File_get_children()
	{
		try
		{	
			return null;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function File_get_objectType()
	{
		try
		{
			return 'File';
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function File_onclick()
	{
		try
		{
			this.showDefaultViewPort();
			event.cancelBubble = true;
			event.returnValue = false;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function File_get_ascii()
	{
		try
		{
			var textStream = this.file.OpenAsTextStream(1, -2);
			var data = '';
			
			if(!textStream.atEndOfStream)
			{
				data = textStream.ReadAll();
			}
			
			return data;
;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function File_set_ascii(newAscii)
	{
		try
		{
			var textStream = this.file.OpenAsTextStream(2, -2);
			textStream.Write(newAscii);
		}
		catch(e)
		{
			throw logError(e);
		}
	}
