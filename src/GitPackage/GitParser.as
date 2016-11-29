package GitPackage 
{
	import GitPackage.GitPatterns;
	/**
	 * ...
	 * @author Matskan
	 */
	public class GitParser 
	{	
		
		static var RefTerm:Terminal;
		static var ParsedCommand:Array;
		static const GLOBAL:String = "glb", SYSTEM:String = "sys", LOCAL:String = "loc";
		static var defaultTarger:String = LOCAL;
		
		public static const Error:Object = 
			{
				ComNotFound:"Command not found",
				UnknowGitCommand:"Unknow Git command"
			};			
		public static function SetRefernces(obj:Terminal)
		{
				RefTerm = obj;
		}
		static function ParseCommand(command:String)
		{
			//trace("RESULT " + GitPatterns.PatternNames["GitCommand"].test(command));
			if (GitPatterns.PatternNames["GitCommand"].test(command))
			{
				if (GitPatterns.PatternNames["GitConfig"].test(command))
				{
					if (GitPatterns.PatternNames["GitAnyConfigCommand"].test(command))
						{
							trace("WELL GIT COMMAND");
							ParsedCommand = command.match(GitPatterns.PatternNames["GitAnyConfigCommand"]);							
							trace(ParsedCommand.length);
							ExecuteConfigCommand(ParsedCommand);
						}
					else trace ("WRONG GIT CONFIG COMMAND");
						
				}
					
				
			}
			else
			{
				 trace("EROR");
				RefTerm.PushTextInfo("Terminal error: " + command + ": " +Error["ComNotFound"]);
			}
		}
		
		static function ExecuteConfigCommand(MatchedCommand:Array)
		{
			var i: int;
			for (i = 0; i < MatchedCommand.length; i++)
			{
				trace("i = " + i + ", " + MatchedCommand[i]);	
			}
			
			switch(MatchedCommand[3])
			{
				case "--system":
					defaultTarger = SYSTEM;
					break;
				case "--global":
					defaultTarger = GLOBAL;
					break;
				case undefined:
				case "--local":
					defaultTarger = LOCAL;
					break;
			}
			
			if (MatchedCommand[5] != undefined)
			{
				switch(defaultTarger)
				{
					case LOCAL:
						RefTerm.PropertyToList(Terminal.LocalConfig);
						break;
					case GLOBAL:
						RefTerm.PropertyToList(Terminal.GlobalConfig);
						break;	
					case SYSTEM:
						RefTerm.PropertyToList(Terminal.SystemConfig);
						break;	
				}			
			}
			else
			{
				if (MatchedCommand[6] == undefined)
				{
					trace("VIEW HELP");
				}
				else
				{
					if (MatchedCommand[10] == undefined)
					{
						//читаем поле
						switch(defaultTarger)
						{
							case LOCAL:
								RefTerm.PushTextInfo(MatchedCommand[7] + "." + MatchedCommand[8]+ " = "+ Terminal.GetProperty(MatchedCommand[7], MatchedCommand[8], Terminal.LocalConfig));
								break;
							case GLOBAL:
								RefTerm.PushTextInfo(MatchedCommand[7] + "."+ MatchedCommand[8] + " = " +Terminal.GetProperty(MatchedCommand[7], MatchedCommand[8], Terminal.GlobalConfig));
								break;	
							case SYSTEM:
								RefTerm.PushTextInfo(MatchedCommand[7] + "."+ MatchedCommand[8] + " = " + Terminal.GetProperty(MatchedCommand[7], MatchedCommand[8], Terminal.SystemConfig));
								break;	
						}
					}
					else
					{
						//пишем поле
						switch(defaultTarger)
						{
							case LOCAL:
								RefTerm.SetProperty(MatchedCommand[7], MatchedCommand[8], MatchedCommand[10], Terminal.LocalConfig);
								break;
							case GLOBAL:
								RefTerm.SetProperty(MatchedCommand[7], MatchedCommand[8], MatchedCommand[10], Terminal.GlobalConfig);
								break;	
							case SYSTEM:
								RefTerm.SetProperty(MatchedCommand[7], MatchedCommand[8], MatchedCommand[10], Terminal.SystemConfig);
								break;	
						}
						
					}
				}
			}
				
		}
	}

}