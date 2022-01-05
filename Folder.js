function Folder(path)
{
	try
	{
		this.fileSystem = window.windowsControl.localFileSystem;
		this.folder = this.fileSystem.GetFolder(path);
		this.get_name = Folder_get_name;
		this.get_children = Folder_get_children;
	}
	catch(e)
	{
		throw logError(e);
	}
}
	function Folder_get_name()
	{
		try
		{
			return new String(this.folder.Path);
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function Folder_get_navViewPort()
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
	function Folder_get_defaultViewPort()
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
	function Folder_showDefaultViewPort()
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
	function Folder_get_children()
	{
		try
		{
			if(!this.mvarChildren)
			{
				this.mvarChildren = new ObjectCollection();
				
				var foldersEnum = new Enumerator(this.folder.SubFolders);

   				for(;!foldersEnum.atEnd(); foldersEnum.moveNext())
				{
					var folder = foldersEnum.item();
					this.mvarChildren.add(new Folder(folder));
				}
				
				var filesEnum = new Enumerator(this.folder.Files);
				
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
	function Folder_get_objectType()
	{
		try
		{
			return 'Folder';
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function Folder_onclick()
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
