package org.adm.graphics.ico
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class IconDictionary
	{
		[ArrayElementType("IconEntity")]
		public var icons : Array = [];
		
		private var count : int = 0;
		private var reserved : int = 0;
		private var type : int = 0;
		
		private var _bytes : ByteArray;
		
		public function IconDictionary(bytes : ByteArray)		
		{
			this._bytes = bytes;
			
			this.reserved = bytes.readByte();
			this.type = bytes.readShort();
			this.count = bytes.readShort()
			
			bytes.position = 6;
			
			this.readIcons();
		}
		
		private function readIcons() : void
		{
			this._bytes.endian = Endian.LITTLE_ENDIAN
			
			for (var i : int = 0; i < this.count; i ++)
	 		{
	 			this.addIcon(new IconEntity(this._bytes));
	 		}
	 		
	 		for (var j : int = 0; j < this.count; j ++)
	 		{
	 			this.getIcon(j).readData();
	 			if (this.getIcon(j).bitmapData == null)
	 				this.icons[j] = null;
	 		}
	 		
	 		for (var l : int = 0; l < this.count; l ++)
	 		{
	 			if (this.icons[l] == null)
	 				this.icons.splice(l,1);
	 		}
	 		this.count = this.icons.length;
		}
		
		public function addIcon(icon : IconEntity) : void
		{
			this.icons.push(icon);
		}

 		public function getIcon(index : int) : IconEntity
		{
			if (this.icons[index])
				return this.icons[index]
			else
				return null;
		}
		
		public function get total() : int
		{
			return this.count;
		}
		
	}
}