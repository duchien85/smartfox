package hosts
{
    import flash.html.*;
    
    import mx.core.Application;

	/*
	*** | CustomHost extends HTMLHost in order to detect the new title
	*** | of each page
	*/
    public class CustomHost extends HTMLHost
    {
    	public var _tab : HTMLTab;
    	
    	public function CustomHost(tab : HTMLTab)
    	{
    		super(true);
    		this._tab = tab;
    	}
    	
        override public function updateTitle(winTitle:String):void
        {
        	this._tab.title = winTitle;
        }
    }
}