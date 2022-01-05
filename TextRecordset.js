function TextRecordset()
{
	try
	{
		this.mvarRecordSeparator = String.fromCharCode(10) + String.fromCharCode(13);
		this.set_recordSeparator = TextRecordset_set_recordSeparator;
		this.get_recordSeparator = TextRecordset_get_recordSeparator;
		
		this.set_templateRecord = TextRecordset_set_templateRecord;
		this.get_templateRecord = TextRecordset_get_templateRecord;
		
		this.set_text = TextRecordset_set_text;
		
		this.get_record = TextRecordset_get_record;
		
		this.get_htmlTable = TextRecordset_get_htmlTable;
	}
	catch(e)
	{
		throw logError(e);
	}
}
	function TextRecordset_set_recordSeparator(new_recordSeparator)
	{
		try
		{
			this.mvarRecordSeparator = new_recordSeparator;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function TextRecordset_get_recordSeparator()
	{
		try
		{
			return this.mvarRecordSeparator;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function TextRecordset_set_templateRecord(new_templateRecord)
	{
		try
		{
			this.mvarTemplateRecord = new_templateRecord;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function TextRecordset_get_templateRecord()
	{
		try
		{
			return this.mvarTemplateRecord;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function TextRecordset_set_text(new_text)
	{
		try
		{
			this.mvarText = new String(new_text);
			
			this.mvarRecordsArray = this.mvarText.split(this.get_recordSeparator());
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function TextRecordset_get_record(index)
	{
		try
		{
			var record = copyObject(this.mvarTemplateRecord, true, 20);
			record.set_text(this.mvarRecordsArray[index]);
			
			return record;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
	function TextRecordset_get_htmlTable()
	{
		try
		{
			var tbl = document.createElement('table');
			tbl.height = '100%';
			tbl.width = '100%';
			tbl.cols = 2;
			
			tbl.tableHeader = document.createElement('tHead');
			tbl.appendChild(tbl.tableHeader);
			
			tbl.headerRow = document.createElement('tr');
			tbl.tableHeader.appendChild(tbl.headerRow);
			
			for(var lpCtr = 0; lpCtr < this.mvarTemplateRecord.mvarFields.count;lpCtr++)
			{
				var lpField = this.mvarTemplateRecord.mvarFields.item(lpCtr);
				var lpTh = document.createElement('th');
				lpTh.innerText = lpField.get_name();
				lpTh.width = lpField.get_displayWidth();
				
				tbl.headerRow.appendChild(lpTh);
			}
			
			tbl.tableBody = document.createElement('tbody');
			tbl.appendChild(tbl.tableBody);
			
			for(var lpCtr = 0;lpCtr < this.mvarRecordsArray.length;lpCtr++)
			{
				var lpRecord = this.get_record(lpCtr);
				var lpTr = this.get_record(lpCtr).get_htmlRow();
				tbl.tableBody.appendChild(lpTr);
				/*
				var lpTr = document.createElement('tr');
				tbl.tableBody.appendChild(lpTr);
				
				var lpRecordText = new String(this.mvarRecordsArray[lpCtr]);
				if(this.mvarTemplateRecord.get_delimited())
				{
					var lpFieldsArray = lpRecordText.split(this.mvarTemplateRecord.get_fieldSeparator());
					//alert(lpRecordText + '\r' + lpFieldsArray.length);
					for(var lpFieldCtr = 0;lpFieldCtr < this.mvarTemplateRecord.mvarFields.count;lpFieldCtr++)
					{
						var lpField = this.mvarTemplateRecord.mvarFields.item(lpFieldCtr);
						var lpTd = document.createElement('td');
						lpTr.width = lpField.get_displayWidth();
						
						lpTd.innerText = lpFieldsArray[lpFieldCtr];
						
						lpTr.appendChild(lpTd);
					}
				}
				else
				{
					alert('Fixed length records not yet implemented');
				}
				*/
			}
			
			return tbl;
		}
		catch(e)
		{
			throw logError(e);
		}
	}
