package valueObjects
{
	import flash.text.TextFieldAutoSize;
	import mx.controls.Button;
	
	public class WrapButton extends Button
	{
		
		
		public function WrapButton()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			textField.multiline = true;
			textField.wordWrap = true;
			textField.autoSize = TextFieldAutoSize.CENTER;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			//Causes text to wrap around in these buttons
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			textField.y = (this.height - textField.height) >> 1;
			
		}
	}
}