package GitPackage 
{
	import flash.text.*;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import GitPackage.GitParser;
		
	/**
	 * ...
	 * @author Matskan
	 */
	internal class Terminal 
	{
		
		
		public var Screen:TextField;
		public var Console:TextField;
		
		var StartPath:String = "C:/Projects/LearnGit/";
		
		//CONST
		public const CPNAME:String = "User@Com", TERM = "WinPrototype", NL = "\n", SP = " ",CMD = "$";
		
		//ENVIROMENT
		public static var GlobalConfig:Object = new Object();
		public static var SystemConfig:Object = new Object();
		public static var LocalConfig:Object = new Object();
		public static var ConFormat:TextFormat = new TextFormat();
		public static var TermFormat:TextFormat = new TextFormat();
		public static var PathFormat:TextFormat = new TextFormat();
		public static var DataFormat:TextFormat = new TextFormat();
		
		
		
		//
		var HistoryCommand:Array;
		var HistoryIndex:int;
		
		public function Terminal(x:int,y:int,w:int,h:int)
		{
			Screen = new TextField();
			Console = new TextField();
			InitInteractiveObjects(x, y, w, h);
			GitParser.SetRefernces(this);
			HistoryCommand = new Array();
			HistoryIndex = HistoryCommand.length;

		}
		function FillFormats()
		{
			ConFormat.size = 14;
			ConFormat.bold = false;
			ConFormat.font = "Courier New";
			ConFormat.color = 0xFAFCF2;
			ConFormat.align = TextFormatAlign.LEFT;
			
			TermFormat.size = 14;
			TermFormat.bold = false;
			TermFormat.font = "Courier New";
			TermFormat.color = 0x9F43E6;
			TermFormat.align = TextFormatAlign.LEFT;
			
			PathFormat.size = 14;
			PathFormat.bold = false;
			PathFormat.font = "Courier New";
			PathFormat.color = 0x12FE32;
			PathFormat.align = TextFormatAlign.LEFT;
			
			DataFormat.size = 14;
			DataFormat.bold = false;
			DataFormat.font = "Courier New";
			DataFormat.color = 0xAAAAAA;
			DataFormat.align = TextFormatAlign.LEFT;
			
			
			
		}
		function InitInteractiveObjects(x:int, y:int, width:int, height:int)
		{
			Screen.x = x;
			Screen.y = y;
			Screen.width = width;
			Screen.background = true;
			Screen.backgroundColor = 0x000000;
			Screen.height = height - 25;
			
			FillFormats(); 
			
			Console.x = x;
			Console.y = Screen.y + Screen.height;
			Console.height = 25-1;
			Console.width = width-1;
			Console.background = true;
			Console.border = true;
			Console.borderColor = 0xffffff;
			Console.backgroundColor = 0x111111;
			Console.type = TextFieldType.INPUT;
			Console.textColor = 0xffffff;
			
			
			Console.defaultTextFormat = ConFormat;
			Screen.defaultTextFormat = ConFormat
			
			PushHead(CPNAME + SP, ConFormat);
			PushHead(TERM + NL, ConFormat);
			PushHead(SP +  CMD + SP, ConFormat);
			
			Console.addEventListener(FocusEvent.FOCUS_IN, SetConsoleFocus);
			Console.addEventListener(FocusEvent.FOCUS_OUT, SetConsoleFocus);
		}
		
		function SetConsoleFocus(event:FocusEvent):void
		{
			trace(event.type);
			switch(event.type)
			{
				case "focusIn":
					trace("GET FOCUS");
					Console.addEventListener(KeyboardEvent.KEY_UP, ConsoleKeyHanlder)
					break;
				case "focusOut":
					trace("LOST FOCUS");
					Console.removeEventListener(KeyboardEvent.KEY_UP, ConsoleKeyHanlder)
					break;
			}
			
		}
		
		function ConsoleKeyHanlder(event:KeyboardEvent)
		{
			switch (event.keyCode)
			{
				case 13:
					trace("ENTER PRESSED");
					trace(Console.text);
					HistoryCommand.push(Console.text);
					HistoryIndex = HistoryCommand.length;
					PushCommand(Console.text + "\n",ConFormat);
					GitParser.ParseCommand(Console.text);
					PushHead(CPNAME + SP, ConFormat);
					PushHead(TERM + NL, ConFormat);
					PushHead(SP +  CMD + SP, ConFormat);
					Console.text = "";
					break;
				case 38:
					if (HistoryCommand.length)
					{
						trace("YET");
						Console.text = HistoryIndex == 0 ? "" : HistoryCommand[HistoryIndex - 1];
						HistoryIndex = HistoryIndex == 0 ? 0 : --HistoryIndex;
						Console.setSelection(Console.text.length,Console.text.length);
					}
					break;
			}
		}
		function PushCommand(text:String,Format:TextFormat):void
		{
			trace(text.length);
			trace(Screen.text.length);
			var begin:int = Screen.text.length,
				end:int = Screen.text.length + text.length;
			Screen.text = Screen.text + " " + text + "\n";
			Screen.setTextFormat(Format, begin, end);
		}
		function PushHead(text:String, Format:TextFormat)
		{
			var beging:int = Screen.text.length, end = Screen.text.length + text.length;
			//trace(beging, end);
			Screen.text += text;
			//trace(Screen.text.length);
			Screen.setTextFormat(Format, beging, end);
		}
		function PushTextInfo(text:String):void
		{
			Screen.text += text + "\n\n";

		}
		public  function SetProperty(field:String,key:String,value:String, ConfigObject: Object)
		{
			try
			{
				if (ConfigObject[field] == undefined)
				{
					ConfigObject[field] = new Object();
					ConfigObject[field][key] = value;
				}
				else
				{
					ConfigObject[field][key] = value;
				}
				//trace("Value: " + value + " with key: " + key + " has been added");
				PushTextInfo("Add field " + field + "." + key + " = " + value);
			}
			catch (err:Error)
			{
				trace("Some wrong");
			}
		}
		public static function GetProperty(field:String, key:String, ConfigObject:Object):String
		{
			var Result:String;
			trace(field, key);
			try
			{
				
				Result = ConfigObject[field][key];
				trace("RES" + Result);//ConfigObject[field] + "." + ConfigObject[field][key];
			}
			catch (err:Error)
			{
				trace("ERRRORO");
				return "undefined";
				
			}
			return Result;
		}
		
		public  function PropertyToList(ConfigObject:Object)
		{
			for (var prop:String in ConfigObject)
				{
					trace("NAME " + prop);
					for(var field:String in ConfigObject[prop])
						{
							trace("LOL");
							PushTextInfo(prop + "." + field + " = " + ConfigObject[prop][field]);
							
						}
				}
		}
	}

}