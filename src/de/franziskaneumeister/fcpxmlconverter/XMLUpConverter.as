package de.franziskaneumeister.fcpxmlconverter
{
	/**
	 * This Class holds the logic for the conversion of the FCP 7 xml to the FCP X xml
	 */
	public class XMLUpConverter implements IConverter
	{
		private var fcpX:XML;
		private var fcp7:XML;
		public function XMLUpConverter()
		{
		}
		
		function startConverstion():void{
			
		}
		
		function getXMLAsString():String{
			return '<?xml version="1.0" encoding="utf-8"?>\n<!DOCTYPE xmeml>\n'+this.fcpX.toXMLString();
		}
	}
}