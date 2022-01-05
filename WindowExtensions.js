initializeWindowExtensions();

function initializeWindowExtensions()
{
	try
	{
		window.windowsControl = new ActiveXObject('windowsControl.clsWindowsControl');
		window.writeHTMLDocFromViewPort = window.window_writeHTMLDocFromViewPort;
		window.writeHTMLTableToExcel = window_writeHTMLTableToExcel;
	}
	catch(e)
	{
		throw logError(e);
	}
}
	function window_writeHTMLDocFromViewPort(fileName, viewPort)
	{
		try
		{
			var htmlString = "";
			htmlString += "<html><body>";
			
			htmlString += viewPort.innerHTML;
			
			htmlString += '</body></html>';
			
			window.windowsControl.writeTextFile(fileName, htmlString);
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function window_writeHTMLTableToExcel(fileName, htmlTable)
	{
		try
		{
			var csvString = "";
			
			
			var rows = htmlTable.rows;
			
			for(var i = 0;i < rows.length;i++)
			{
				var row = rows[i];
				var cells = row.cells;
				for(var j = 0;j < cells.length;j++)
				{
					var cell = cells[j];
					
					csvString += cell.innerText + ", ";
				}
				csvString = new String(csvString);
				csvString = csvString.slice(0, csvString.length - 2);
				csvString += "\r";
			}
			
			window.windowsControl.writeTextFile(fileName, csvString);
		}
		catch(e)
		{
			throw logError(e);
		}
	}
