function Drive(drive)
{
	try
	{
		this.drive = drive;
		this.get_name = Drive_get_name;
		this.get_navViewPort = Drive_get_navViewPort;
		this.get_defaultViewPort = Drive_get_defaultViewPort;
		this.showDefaultViewPort = Drive_showDefaultViewPort;
		this.get_children = Drive_get_children;
		this.get_objectType = Drive_get_objectType;
		this.onclick = Drive_onclick;
		this.fileSystem = d2k.get_activeXControl().localFileSystem;
	}
	catch(e)
	{
		throw logError(e);
	}
}
	function Drive_get_name()
	{
		try
		{
			return new String(this.drive.DriveLetter) + '(' + new String(this.drive.ShareName) + ')';
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function Drive_get_navViewPort()
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
	function Drive_get_defaultViewPort()
	{
		try
		{
			if(!this.defaultViewPort)
			{
				this.defaultViewPort = createViewPort(this);
				this.defaultViewPort.style.textAlign = 'left';
				this.defaultViewPort.treeNode = get_treeNodeViewPort(this);
				this.defaultViewPort.appendChild(this.defaultViewPort.treeNode);
			}
			
			return this.defaultViewPort;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function Drive_showDefaultViewPort()
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
	function Drive_get_children()
	{
		try
		{
			if(!this.mvarChildren)
			{
				this.mvarChildren = new ObjectCollection();
				this.rootFolder = this.drive.RootFolder;
				
				var foldersEnum = new Enumerator(this.rootFolder.SubFolders);

   				for(;!foldersEnum.atEnd(); foldersEnum.moveNext())
				{
					var folder = foldersEnum.item();
					this.mvarChildren.add(new Folder(folder));
				}
				
				var filesEnum = new Enumerator(this.rootFolder.Files);
				
				for(;!filesEnum.atEnd(); filesEnum.moveNext())
				{
					var file = filesEnum.item();
					this.mvarChildren.add(new File(file));
				}
			}
			
			return this.mvarChildren;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function Drive_get_objectType()
	{
		try
		{
			return 'Drive';
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function Drive_onclick()
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
