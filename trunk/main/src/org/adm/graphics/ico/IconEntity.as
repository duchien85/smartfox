package org.adm.graphics.ico
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class IconEntity
	{
		// ie: 16 or 32
		public var width : int = 0;
		// ie: 16 or 32
		public var height : int = 0;
		// number of entires in pallette table below
	 	public var colorCount : int = 256;
	 	// not used = 0
 		public var reserved : int = 0;
 		// not used = 0
 		public var planes : int = 0; 
 		// not used = 0
 		public var bitCount : int = 0; 
 		// total number bytes in images including pallette data XOR, AND and bitmap info header
 		public var sizeInBytes : int = 0; 
 		// pos of image as offset from the beginning of file
 		public var fileOffset : int = 0;
		// icon header
		public var header : ICOHeader;
		// color pallete
		[ArrayElementType("RGBQuad")]
		public var colors : Array = [];
		// entire icon reference 
		private var bytes : ByteArray;
		// byte info from file
		private var data : ByteArray = new ByteArray();
		// bitmap data
		public var bitmapData : BitmapData;
		
		public function IconEntity(bytes : ByteArray)
		{
			this.width = bytes.readUnsignedByte(); 
 			this.height = bytes.readUnsignedByte(); 
 			this.colorCount = bytes.readByte(); 
 			
 			if (this.colorCount == 0) this.colorCount = 255;
 			
 			this.reserved = bytes.readByte(); 
 			this.planes = bytes.readUnsignedShort(); 
 			this.bitCount = bytes.readUnsignedShort(); 
 			this.sizeInBytes = bytes.readUnsignedInt(); 
 			this.fileOffset = bytes.readUnsignedInt();
 			
 			this.bytes = bytes;
		}
		
		public function readData() : void
		{
			this.header = new ICOHeader(this.bytes, this.fileOffset);
			
			this.bitCount = this.header.bitCount;
			
			this.readBitmapInfo();
			
			this.header.height = this.height;
			
		}
		
		private function readBitmapInfo() : void
		{
			this.data.endian = Endian.LITTLE_ENDIAN;
			
			var offset : int = this.fileOffset + this.header.size;
			var length : int = 0;
			var loop : int = 0;
			
			switch (this.bitCount)
			{
				case 32:
	 			case 24:
	 				length = this.header.width * this.header.height * (this.bitCount / 8);
	 				this.data.writeBytes(this.bytes, offset, this.bytes.bytesAvailable > length ? length : 0);
	 				break;
	 				
	 			case 8:
	 			case 4:
	 				this.bytes.position = offset; 			
	 				for (loop = 0; loop < this.colorCount; loop++)
	 				{
	 					this.colors.push(new RGBQuad(this.bytes.readUnsignedByte(), // B
	 												 this.bytes.readUnsignedByte(), // G
	 												 this.bytes.readUnsignedByte(), // R
	 												 this.bytes.readUnsignedByte(), true)); // RES
	 				}
	 				
	 				length = this.header.width * this.header.height * (1 + this.bitCount) / this.bitCount
	 				this.data.writeBytes(this.bytes, this.bitCount == 8 ? offset + (this.colorCount * 4) + 4 : this.bytes.position, this.bytes.bytesAvailable > length ? length : 0); 
	 				break;
	 				
			}
			
			this.data.position = 0;
			this.getBitmap();
		}
		
		public function getBitmap() : BitmapData
		{
			if (bitmapData) return this.bitmapData;
			
			if (this.width == 0 || this.height == 0) return null;
						
			this.bitmapData = new BitmapData(this.width, this.height);
			this.bitmapData.lock();
			
			var x : int = 0;
			var y : int = 0;
			
			var loop : int = 0;
			var offset : int = 0;
			var byte : int = 0;
			
			// allocate pallete and xor image
			if (this.bitCount < 32)
			{
				var bitMask : String = '';
				
				// PALLETE OBSOLETE CODE
				
				var width : int = this.width;
				if ((width % 32) > 0) 
				{
					width += (32 - (this.width % 32));
				}
				
				offset = this.width * this.height * this.bitCount / 8;
				var totalByes : int = (width * this.height) / 8;
				var bytes : int = 0;
				var bytesPerLine : int = this.width / 8;
				var bytesToRemove : int = (width - this.width) / 8;
				
				for (loop = 0; loop < totalByes; loop++)
				{
					this.data.position = offset + loop; 
					var bytex : int = this.data.readUnsignedByte();
					bitMask = bitMask + padString(bytex.toString(2), 8, '0');
					
					if (++bytes == bytesPerLine)
					{
						loop += bytesToRemove;
						bytes = 0;
					}
				}
				
			}
						
			switch (this.bitCount)
			{
				// 4 bytes per pixel [B | G | R | A]
				case 32: 
					for (y = this.height - 1; y >= 0; y--)
					{
						for (x = 0; x < this.width; x++)
						{
							this.bitmapData.setPixel32(x, y, RGBQuad.toHEX32(this.data.readUnsignedByte(), // B
																			 this.data.readUnsignedByte(), // G
																			 this.data.readUnsignedByte(), // R
																			 this.data.readUnsignedByte(), // A
																			 true)); // reverse it
						}
					}
					
					break;
					
				// 3 bytes per pixel [B | G | R] 	
				case 24 :
					offset = 0;
					for (y = this.height - 1; y >= 0; y--)
					{
						for (x = 0; x < this.width; x++)
						{
							if (bitMask.charAt(offset) == '0')
							{
								if (this.data.bytesAvailable < 4) break;
								
								this.bitmapData.setPixel(x, y, RGBQuad.toHEX(this.data.readUnsignedByte(), // B
																			 this.data.readUnsignedByte(), // G
																			 this.data.readUnsignedByte(), // R
																			 true)); // reverse it
							}
							offset++;
						}
					}
					
					break;
						
				// 1 byte per pixel [COLOR INDEX] 
				case 8:
					offset = 0;
					this.data.position = 0;
					
					for (y = this.height - 1; y >= 0; y--)
					{
						for (x = 0; x < this.width; x++)
						{
							byte = this.data.readUnsignedByte();
							
							if (bitMask.charAt(offset) == '0')
								if (this.colors[byte])
									this.bitmapData.setPixel(x, y, this.colors[byte].toHEX);
								
							offset++;
						}
					}
					
					break;
					
				// half byte/nibble per pixel [COLOR INDEX]	
				case 4:
					offset = 0;
					var leftbits : Boolean = true;
					var maskOffset : int = 0;
					var low : int = 0;
					var high : int = 0;
					for (y = this.height - 1; y >= 0; y--)
					{
						for (x = 0; x < this.width; x++)
						{
							if (leftbits)
							{
								this.data.position = offset;
								byte = this.data.readUnsignedByte();
								
								high = parseInt(byte.toString(2).substr(0, 4), 2);
								low = parseInt(byte.toString(2).substr(4), 2);
								
								if (bitMask.charAt(maskOffset++) == '0')
								{
									this.bitmapData.setPixel(x, y, this.colors[high].toHEX);
								}
								
								leftbits = false;
							}
							else
							{
								if (bitMask.charAt(maskOffset++) == '0')
								{
									this.bitmapData.setPixel(x, y, this.colors[low].toHEX);
								}
								
								offset++;
								leftbits = true;
							}							
						}
					}
					
					break;
					
				// 1 bit per pixel (2 colors, usualy black and white [color index]	
				case 1:
				
					break;
			}
			
			this.bitmapData.unlock();
			return this.bitmapData;
		}
		
		private function padString(input : String, length : int, padString : String, left : Boolean = true) : String
 		{
 			var len : int = input.length;
 			if (len < length)
 			{
 				for (var i : int = 0; i < length - len; i++)
					if (left) 
						input = padString + input;
					else
						input = input + padString;
 			}
 			return input;
 		} 
	 		
	}
}