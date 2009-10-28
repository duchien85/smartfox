package org.adm.graphics.ico
{
	public class RGBQuad
	{
		public var red : int = 0;
		public var green : int = 0;
		public var blue : int = 0;
		public var reserved : int = 0;
		
		public function RGBQuad(r : int, g : int, b: int, reserved : int, reversed : Boolean = false)
		{
			if (reversed)
			{
				this.red = b;
				this.green = g;
				this.blue = r;
			} else {
				this.red = r;
				this.green = g;
				this.blue = b;
			}
			this.reserved = reserved;
		}
		
		public function get toHEX() : int
		{
			return RGBQuad.toHEX(this.red, this.green, this.blue);
		}
		
		public static function toHEX(r : int, g : int, b : int, reversed : Boolean = false) : int
		{
			if (reversed)
				return b << 16 | g << 8 | r
			else
				return r << 16 | g << 8 | b
		}
		
		public function get toHEX32() : int
		{
			return RGBQuad.toHEX32(this.red, this.green, this.blue, this.reserved);
		}
		
		public static function toHEX32(r : int , g : int , b : int , a : int, reversed : Boolean = false) : int
		{
			if (reversed)
				return a << 24 | b << 16 | g << 8 | r
			else
				return a << 24 | r << 16 | g << 8 | b
		}

	}
}