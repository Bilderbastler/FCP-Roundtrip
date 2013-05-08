package UnitTesting.Tests
{
	import UnitTesting.TestData;
	
	import de.franziskaneumeister.fcpxmlconverter.XMLDownConverter;
	
	import flashx.textLayout.debug.assert;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	
	public class XMLDownConverterTestCase
	{
		
		/** instance of the tested XMLDownConverter */
		private var _downconverter:XMLDownConverter;
		
		[Before]
		public function beforeTest():void{
			this._downconverter = new XMLDownConverter();
		}
		
		[After]
		public function afterTest():void{
			this._downconverter = null;
		}
		
		[Test( description="Testing if the converter produces a result that is not empty or NULL" )]
		public function testGetXMLAsString():void{
			_downconverter.setFCPXML(TestData.threeClipsFromX);
			var result:String = _downconverter.getXMLAsString();
			assertNotNull(result);
			assertFalse(result == "");
		}
		
		[Test( description="Tests if the raw XML output from the converter works fine" )]
		public function testGetXMLResult():void{
			_downconverter.setFCPXML(TestData.threeClipsFromX);
			assertNotNull(_downconverter.getXMLResult());
			assertTrue(_downconverter.getXMLResult() is XML);
		}
		
		[Ignore]
		[Test( description="Dummy test that is used as a copy and paste template in this file" )]
		public function testDummy():void{
			_downconverter.setFCPXML(TestData.threeClipsFromX);
			//_downconverter.isProject = true;
			_downconverter.startConverstion();
			var result:XML = _downconverter.getXMLResult();
			assertNull(null);
		}
		
		[Test( description="Test if a project is created" )]
		public function testProjectCreation():void{
			_downconverter.setFCPXML(TestData.threeClipsFromX);
			_downconverter.isProject = true;
			_downconverter.startConverstion();
			var result:XML = _downconverter.getXMLResult();
			assertNotNull(result.project);
			assertNull(result.sequence);
		}
		
		[Test( description="Test if there is a sequence created" )]
		public function testSequenceCreation():void{
			_downconverter.setFCPXML(TestData.threeClipsFromX);
			//_downconverter.isProject = true;
			_downconverter.startConverstion();
			var result:XML = _downconverter.getXMLResult();
			assertTrue(result.sequence.@id == "Alice 1");
			assertTrue(result.sequence.duration == "753");
			assertTrue(result.sequence.rate.timebase[0] == "753");

		}
	}
}