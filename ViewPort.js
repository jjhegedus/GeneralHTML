function createViewPort(object)
{
	try
	{
		var viewPort = document.createElement('div');
		viewPort.object = object;
		
		/* create viewPorts collection if it doesn't already exist */
		if(!window.viewPorts)
		{
			window.viewPorts = new ObjectCollection();
		}
		window.viewPorts.add(viewPort);
		viewPort.viewPortNumber = window.viewPorts.getChildIndex(viewPort);
		
		viewPort.ondragstart = ViewPort_ondragstart;
		viewPort.ondragenter = ViewPort_ondragenter;
		viewPort.ondragover = ViewPort_ondragover;
		viewPort.ondrop = ViewPort_ondrop;
		viewPort.oncontextmenu = ViewPort_oncontextmenu;
		viewPort.onclick = ViewPort_onclick;
		
		return viewPort;
	}
	catch(e)
	{
		throw logError(e);
	}
}
	function ViewPort_ondragstart()
	{
		try
		{
			var x = new String(this.viewPortNumber);
			var y = x.toString();
			
			event.dataTransfer.effectAllowed = 'copy';
			event.dataTransfer.setData('text', y);
		}
		catch(e)
		{
			throw logError(e);
		}
		
		event.cancelBubble = true;
	}
	function ViewPort_ondragenter()
	{
		try
		{
			event.cancelBubble = true;
			event.returnValue = false;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	
	function ViewPort_ondragover()
	{
		try
		{
			event.cancelBubble = true;
				
			if((this.viewPortNumber) || (event.srcElement.viewPortNumber == 0))
			{
				event.dataTransfer.dropEffect = 'copy';
				event.returnValue = false;
			}
			else
			{
				event.dataTransfer.dropEffect = 'none';
				
			}
	
			event.cancelBubble = true;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	
	function ViewPort_ondrop()
	{
		try
		{
			event.cancelBubble = true;
			event.returnValue = false;
	
			if(event.dataTransfer.effectAllowed == 'copy')
			{
				try
				{
					var draggedViewPortNumber = event.dataTransfer.getData('text');
					var droppedOnViewPortNumber = this.viewPortNumber;
					
					var viewPort1 = window.viewPorts.item(draggedViewPortNumber);
					var viewPort2 = window.viewPorts.item(droppedOnViewPortNumber);
					
					var object1 = viewPort1.object;
					var object2 = viewPort2.object;
					
					this.contextMenuViewPort = get_contextMenuViewPort(object1, object2);
					this.contextMenuViewPort.setParentViewPort(this);
					this.contextMenuViewPort.show(true);
				}
				catch(innerE)
				{
					alert('error copying \r' + innerE.description);
				}
			}
			else if(event.dataTransfer.effectAllowed == 'move')
			{
				alert('moving viewPort ' + event.dataTransfer.getData('text'));
			}
			else
			{
				alert('Error:  Unknown drop effect');
			}
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function ViewPort_oncontextmenu()
	{
		try
		{
			var object = this.object;
			
			this.contextMenuViewPort = get_contextMenuViewPort(object);
			this.contextMenuViewPort.setParentViewPort(this);
			this.contextMenuViewPort.show(true);
			event.cancelBubble = true;
			event.returnValue = false;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function ViewPort_onclick()
	{
		try
		{
			if(this.object)
			{
				if(this.object.onclick)
				{
					this.object.onclick(this.object);
				}
			}
		}
		catch(e)
		{
			throw logError(e);
		}
	}
