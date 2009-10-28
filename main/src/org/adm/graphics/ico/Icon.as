package org.adm.graphics.ico
{
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.display.BitmapData;
	
	import mx.controls.Image;

	[IconFile("image.png")]
	[DefaultTriggerEvent("complete")]
	public class Icon extends Image
	{
		private var urlLoader : URLLoader = new URLLoader();
 		private var imageData : ByteArray = new ByteArray;
 		private var ico : Array = [];
 		
 		private var formats : Array = [];
 		private var fileName : String = '';
 		
 		private var _iconSize : int = 16;
 		private var _availableSizes : Array = [];
 		private var _sizeIndex : Array = [];
 		private var _iconIndex : Number = -1;
 		private var _colorDepth : Number = 16;
 		public var autoSize : Boolean = true;
 		
 		private var icons : IconDictionary;
 		
 		public function Icon()
 		{
 			super();
 		}
 		
 		[Bindable("sourceChanged")]
		[Inspectable(category="General", format="File")]
 		public override function set source(file : Object) : void
 		{
 			if (this.fileName == String(file)) return;
 			
 			if (this.formats)
 				this.formats.splice(0, this.formats.length);
 				
 			this._availableSizes = [];
 			this._sizeIndex = [];
 			this._iconIndex = -1;
 			this._iconSize = 16;
 			
 			this.fileName = String(file);
 			if (file is String && this.autoLoad) 
 			{
 				this.loadFile();
 			}
 		}
 		
 		private function onMove() : void
 		{
 			this.draw();
 			
 			this.invalidateDisplayList();
 			this.invalidateProperties();
 			this.invalidateSize();
 		}
 		
 		private function sortSizes() : void
 		{
 			var tmp : Array = [];
			for (var i : int = 0; i < this.formats.length; i ++)
			{	 	
				tmp.push({size : this.formats[i]['width'], index : i});
			}
			
			tmp.sortOn('size', Array.NUMERIC);
			
			this._availableSizes = [];
 			this._sizeIndex = [];
			
			for each(var obj : Object in tmp)
			{
				this._availableSizes.push(obj.size);
				this._sizeIndex.push(obj.index);
			}
			
 		}
 		
 		private function init() : void
 		{
 			if (this.fileName)
 				this.loadFile()
 				
 			this.addEventListener("autoLoadChanged", onAutoLoadChanged);
 		}
 		
 		private function onAutoLoadChanged(evt : Event) : void
 		{
 			if (this.autoLoad == true)
 				if (this.fileName) this.loadFile();
 		}
 		
 		private function loadFile() : void
 		{
 			this.urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			this.urlLoader.addEventListener(Event.COMPLETE, onComplete);
			this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			this.urlLoader.load(new URLRequest(this.fileName));
 		}
 		
 		private function onIOError(ev : IOErrorEvent):void
 		{
 			trace ("Error loading url "); 
 		}
 		
 		[Bindable]
 		[Inspectable(type="Number", enumeration="16,24,32,48,64,72,96,128,256", defaultValue="32")]
 		public function set iconSize(val : int) : void
 		{
 			 this._iconSize = val;
 			 var ico : IconEntity = findIcon(val, this._colorDepth);
 			 if (ico)
 			 {
 			 	this.drawIcon(ico.bitmapData, ico.width, ico.height);
 			 }
 		}
 		
 		public function get iconSize(): int
 		{
 			return this._iconSize;
 		}
 		
 		[Bindable]
 		[Inspectable(type="Number", enumeration="2,4,8,16,32", defaultValue="32")]
 		public function set colorDepth(val : int) : void
 		{
 			 this._colorDepth = val;
 			 
 			 var ico : IconEntity = findIcon(this._iconSize, val);
 			 if (ico)
 			 {
 			 	this.drawIcon(ico.bitmapData, ico.width, ico.height);
 			 }
 		}
 		
 		public function get colorDepth() : int
 		{
 			return this._colorDepth;
 		}
 		
 		[Bindable]
 		public function set iconIndex(val : Number) : void
 		{
 			this._iconIndex = val;
 			draw();
 		} 
 		
 		public function get iconIndex() : Number
 		{
 			return this._iconIndex;
 		}
 		
 		private function get sizeIndex() : int
 		{
 			// try to get the requested size
 			var tmp : int = this._availableSizes.indexOf(this._iconSize);
 			// if not, try to get default (32)
 			if (tmp == -1)
 				tmp = this._availableSizes.indexOf(16);
 			// if not, just get the first one	
 			if (tmp == -1)
 				tmp = 0;
 				
 			return this._sizeIndex[tmp];
 		}
 		
 		private function onComplete(evt : Event) : void
 		{
 			this.imageData = evt.target.data;
 			this.icons = new IconDictionary(this.imageData);
 			this.formats = this.icons.icons;
 			this.sortSizes();

 			this.draw();
 			
 			this.invalidateDisplayList();
 			this.invalidateProperties();
 			this.invalidateSize();
 			
 			this.dispatchEvent(new Event('complete'));
 		}
 		
 		private function draw() : void
 		{
 			if (this.icons == null) return;
 			
 			var icon : BitmapData = this.icons.getIcon(this.iconIndex == -1 ? this.sizeIndex : this.iconIndex).bitmapData;
 			
 			if (icon == null) return;
 		
 			this.graphics.clear();
 			this.graphics.beginBitmapFill(icon, null, false, false);
 			if (this.autoSize)
 			{
	 			this.width = icon.width;
	 			this.height = icon.height;
	 		}
	 		this.graphics.drawRect(0, 0, icon.width, icon.height); 
	 		this.graphics.endFill();
	 		this.width = 16;
	 		this.height = 16;
 		}
 		
 		private function drawIcon(icon : BitmapData, width : int, height : int) : void
 		{
 			if (icon == null) return;
 			
 			this.graphics.clear();
 			this.graphics.beginBitmapFill(icon, null, false, false);
 			
 			if (this.autoSize)
 			{
	 			this.width = width;
	 			this.height = height;
	 		}
	 		this.graphics.drawRect(0, 0, width, height); 
	 		this.graphics.endFill();
 		}
	 		
 		public function get totalIcons() : int
 		{
 			return this.icons.total;
 		}
 		
 		private function getIconInfo(index : int) : ICOHeader
 		{
 			var icon : IconEntity = this.icons.getIcon(index);
 			if (icon)
 				return icon.header;
 			else
 				return null
 		}
 		
 		public function getIconsInfo() : Array
 		{
 			if (this.icons == null) return [];
 			
 			var tmp : Array = [];
 			
 			for (var i : int = 0; i < this.icons.total; i ++)
 			{
 				tmp.push(this.icons.getIcon(i).header)
 			}
 			return tmp;
 		}
 		
 		private function findIcon(size : int, depth : int) : IconEntity
 		{
 			var ico : IconEntity;
 			if (this.icons == null) return null;
 			for (var i : int = 0; i < this.icons.total; i ++)
 			{
 				var obj : IconEntity = this.icons.getIcon(i);
 				if ((obj.width == size || obj.height == size) && obj.bitCount == depth)
 				{
 					ico = obj;
 					break;
 				}
 			}
 			return ico;
 		}
 		
 		private function rgb2hex32(r : int, g : int, b : int, alpha : int) : Number
		{
			return alpha << 24 | r << 16 | g << 8 | b;
		}
 		
 		private function padString(input : String, length : int, padString : String) : String
 		{
 			var len : int = input.length;
 			if (len < length)
 			{
 				for (var i : int = 0; i < length - len; i++)
					input = padString + input;	 					
 			}
 			return input;
 		} 
 		
 		public function clone():Icon
 		{
 			var ret : Icon = new Icon();
 			ret.maxWidth = this.maxWidth;
			ret.maxHeight = this.maxHeight;
			ret.iconSize = this.iconSize;
			ret.scaleContent = this.scaleContent;
			ret.source = this.fileName;
			return ret;
 		}
	}
}