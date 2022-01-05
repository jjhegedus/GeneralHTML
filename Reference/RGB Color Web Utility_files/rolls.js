NS4 = (document.layers);
var curRoll=-1;
var rolls=new Array();
function roll(theNum,hrefname,href,theClass)
{if (!NS4) return;
 if (curRoll >= 0)
  rolls[curRoll].visibility = "hide";
 curRoll = theNum;
 if (!rolls[theNum]) // need to this layer, first time over this link
  {rolls[theNum] = new Layer(300);
   rolls[theNum].left = document.links[theNum].x;
   rolls[theNum].top = document.links[theNum].y;
   rolls[theNum].visibility = "show";
   str = '<A href="'+href+'" class="'+theClass+'" onMouseOut="rolls['+theNum+'].visibility=\'hide\'">'+hrefname+'</A>';
   rolls[theNum].document.write(str);
   rolls[theNum].document.close();
  }
 else
  rolls[theNum].visibility = "show";
}

// text link rollovers code
function checkmove(e)
{
 if (!e.target.text && curRoll>=0)
  {rolls[curRoll].visibility = "hide";
   curRoll = -1;
  }
}

if (NS4)
 {document.captureEvents(Event.MOUSEMOVE);
  document.onmousemove = checkmove;
 }
