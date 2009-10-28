package org.adm.graphics.ico
{
	import flash.utils.ByteArray;
	
	public class ICOHeader
	{
		// size of bitmapinfoheader = 40
		public var size : int = 0;
		// bitmap width
		public var width : int = 0;
		// height of bitmap
		public var height : int = 0;
		// always 1
		public var planes : uint = 1;
		// number color bits 4 = 16 colors, 8 = 256 pixel is a byte
		public var bitCount : uint = 0;
		// compression used, 0
		public var compression : int = 0;
		// size of the pixel data
		public var imageSize : int = 0;
		// not used, 0
		public var xPixelsPerMap : int = 0;
		// not used, 0
		public var yPixelsPerMap : int = 0;
		// number of colors used, set to 0
		public var colorsUsed : int = 0;
		// important colors, set to 0
		public var colorsImportant : int = 0;
		
 		
 		public function ICOHeader(bytes : ByteArray, offset : int = 0)
 		{
 			bytes.position = offset;
 			
 			this.size = bytes.readUnsignedInt();
 			this.width = bytes.readUnsignedInt();
 			this.height = bytes.readUnsignedInt();
 			this.planes = bytes.readUnsignedShort();
 			this.bitCount = bytes.readUnsignedShort();
 			this.compression = bytes.readUnsignedInt();
 			this.imageSize = bytes.readUnsignedInt();
 			this.xPixelsPerMap = bytes.readUnsignedInt();
 			this.yPixelsPerMap = bytes.readUnsignedInt();
 			this.colorsUsed = bytes.readUnsignedInt();
 			this.colorsImportant = bytes.readUnsignedInt();
 		} 
		
	}
}