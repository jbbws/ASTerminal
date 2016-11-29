package GitPackage 
{
	/**
	 * ...
	 * @author Matskan
	 */
	internal class GitPatterns 
	{
		public static var PatternNames:Object = 
		{
			GitCommand:/^git(\s)*/i,
			GitConfigGlobal:/[\d\s]+(\-\-global)\s+/i,
			GitConfigSystem:/[\d\s]+(\-\-system)\s+/i,
			GitConfigLocal:/[\d\s]+(\-\-local\)s+/i,
			GitConfigList:/[--list$|-l$]/i,
			GitConfig:/config/i,
			GitAnyConfigCommand:/(git\s+?config)(\s+?(--local|--system|--global))?(\s+?(--list$|-l$)|\s+?(([\w\d]+?)\.([\w\d]+))(\s+"([\d\w\s]+)")?)?/i  //   /(git\s+?config)(\s+?((--local)|(--system)|(--global)))?((\s+?((--list$)|(-l$)))|(\s+?([\w\d]+?\.[\w\d]+?)))/i     //\s+(--list)/i //  (--list$|-l$)|([\w\d]+?)/i   //([\w\d]+?\.[\w\d]+?\s("[\w\d\s]*?")?)?
		}
	}

}