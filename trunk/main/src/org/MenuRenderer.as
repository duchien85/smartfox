package org
{
	import flash.events.MouseEvent;
	
	import mx.controls.Menu;
	import mx.controls.Text;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.controls.menuClasses.IMenuItemRenderer;
	import mx.core.UIComponent;
	
	import org.adm.graphics.ico.Icon;

	public class MenuRenderer extends UIComponent implements IListItemRenderer, IMenuItemRenderer
	{

		private var icon:Icon;
		private var _data : Object;
		private var tf : Text
		private var label : String;

		function MenuRenderer()
		{
			this.addEventListener(MouseEvent.MOUSE_OVER, onClick);
			this.addEventListener(MouseEvent.ROLL_OVER, onClick);
		}
		
		private function onClick(ev : MouseEvent):void
		{
			trace (this.toString());
		}
		
		override protected function createChildren():void
		{
			if (tf == null)
			{
				tf = new Text();
				if (this.label)
				{
					tf.text = this.label;
				}
				tf.x = 20;
				tf.y = 0;
				this.addChild(tf);
			}
			super.createChildren();
		}
		
		public function set data(val : Object):void
		{
			if (this.icon != null && this.contains(this.icon)) this.removeChild(icon);
			this.icon = val.icon;
			this.addChild(icon);
			this.label = val.label;
			if (tf && this.label) tf.text = "Iamhere";
			this._data = val;
		}
		
		public function get data():Object
		{
			return this._data;
		}

		public function get menu():Menu
		{
			return null;
		}

		public function set menu(value:Menu):void
		{

		}

		public function get measuredIconWidth():Number
		{
			return icon.measuredWidth;
		}

		/**
		 *  The width of the type icon (radio/check).
		 */
		public function get measuredTypeIconWidth():Number
		{
			return icon.measuredWidth;
		}

		/**
		 *  The width of the branch icon.
		 */
		public function get measuredBranchIconWidth():Number
		{
			return icon.measuredWidth;
		}
	}
}

