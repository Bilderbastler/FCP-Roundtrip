package de.franziskaneumeister.fcpxmlconverter 
{
	import flash.desktop.NotificationType;
	
	import mx.messaging.management.Attribute;

	/**
	 * This Class holds the logic for the conversion of the FCP X xml to the FCP 7 xml
	 */
	public class XMLDownConverter implements IConverter
	{
		/** stores all ID Names for clips in <clip> nodes that were used in the project */
		private var clipIDs:Array;
		private var _isProject:Boolean;
		private var compoundClipIndex:int = 1;
		private var fcpX:XML;
		private var fcp7BaseNodeTemplate:XML = 	<xmeml version="5">
								</xmeml>;
		/** the final converted fcp 7 xml/ */
		private var convertedXml:XML;
		
		
		/** the current FCP7 Sequence that the converter is adding elements to*/
		private var currentSequence:XML;
		
		private var currentTrackIndex:uint = 0;
		
		private var sequenceTemplate:XML = 	<sequence id="">
										<uuid></uuid>
										<updatebehavior>add</updatebehavior>
										<name></name>
										<duration>0</duration>
										<rate>
											<ntsc>FALSE</ntsc>
											<timebase>25</timebase>
										</rate>
										<timecode>
											<rate>
												<ntsc>FALSE</ntsc>
												<timebase>25</timebase>
											</rate>
											<string>01:00:00:00</string>
											<frame>90000</frame>
											<source>source</source>
											<displayformat>NDF</displayformat>
										</timecode>
										<in>-1</in>
										<out>-1</out>
										<media>
										</media>
										<ismasterclip>FALSE</ismasterclip>
									</sequence>;
		
		private var videoTemplate:XML = 	<video>
										<format>
											<samplecharacteristics>
												<width>1280</width>
												<height>720</height>
												<anamorphic>FALSE</anamorphic>
												<pixelaspectratio>Square</pixelaspectratio>
												<fielddominance>none</fielddominance>
											</samplecharacteristics>
											<appspecificdata>
												<appname>Final Cut Pro</appname>
												<appmanufacturer>Apple Inc.</appmanufacturer>
												<appversion>7.0</appversion>
												<data>
													<fcpimageprocessing>
														<useyuv>TRUE</useyuv>
														<usesuperwhite>FALSE</usesuperwhite>
														<rendermode>YUV8BPP</rendermode>
													</fcpimageprocessing>
												</data>
											</appspecificdata>
										</format>
										<track>
										</track>
									</video>;
		
		private var audioTemplate:XML = 	<audio>
										<format>
											<samplecharacteristics>
												<depth>16</depth>
												<samplerate>48000</samplerate>
											</samplecharacteristics>
										</format>
										<outputs>
											<group>
												<index>1</index>
												<numchannels>2</numchannels>
												<downmix>0</downmix>
												<channel>
													<index>1</index>
												</channel>
												<channel>
													<index>2</index>
												</channel>
											</group>
										</outputs>
										<in>-1</in>
										<out>-1</out>
										<track>
										</track>			
									</audio>
		
			/**
			 * empty constructor
			 */
		public function XMLDownConverter()
		{
		}
		
		/**
		 * set the source XML from FCP X before the start of the conversion to FCP 7
		 */ 
		public function setFCPXML(xmeml:XML):void{
			this.clipIDs = new Array();
			this.fcpX = xmeml;
		}
		
		public function set isProject(param:Boolean):void{
			this._isProject = param;
		}
		
		/**
		 * starts the conversion of the xml from FCP X to FCP 7. 
		 * A source XML must have been set prior via the setFCPXML() method
		 */
		public function startConverstion():void{
			if (this.fcpX != null){
				var base:XML = this.fcp7BaseNodeTemplate.copy();
				if(_isProject){
					base.appendChild(createProject());
					base = base.project[0];
				}
				
				// create the base sequence 
				var mainSequence:XML = createSequence();
				this.currentSequence = mainSequence;
				
				// goes through the complete node tree of the fcp x sequence and translates it into a fcp 7 timeline
				// with possible sub-timelines.
				// asumes that there can be only one sequence node in a fcp x xml (??)
				parseClipitemChildNodes(fcpX.project.sequence[0]);
				
				base.appendChild(this.currentSequence);
				
				if(_isProject){
					// TODO append all Clips in the resource-nodes as Clips in the <proeject> node;
				}
				
				this.convertedXml = base;
				
			}
		}
		
		private function createProject():XML{
			var project:XML =
			<project>
				<name>some Name</name>
			</project>;
			project.name = fcpX.project.@name;
			return project;
		}
		
		
		/**
		 * creates a new empty sequence
		 */
		private function createSequence():XML{
			
			
			var sequence:XML = this.sequenceTemplate.copy();
			sequence.@id = fcpX.project.@name;
			sequence.uuid = fcpX.project.@uid;
			sequence.name = fcpX.project.@name;
			
			var formatRef:String = fcpX.project.sequence.@format;
			var noNTSCPattern:RegExp = /60|50|30|25|24/;
			var sequenceFormatInX:XMLList = fcpX.project.resources.format.(@id==formatRef);
			var frameDuration:String = sequenceFormatInX.@frameDuration;
			var frameRate:int = Math.round(1 / parseTime(frameDuration));
			var isNTSC:Boolean = ! noNTSCPattern.test(frameRate.toString());
			sequence.rate.ntsc = isNTSC.toString();
			sequence.rate.timebase = 1 / frameRate;
			sequence.duration = parseTime(fcpX.project.sequence.@duration) * frameRate;
			
			sequence.timecode.displayformat = fcpX.project.sequence.@tcFormat;
			sequence.rate.timebase = frameRate; 
			sequence.rate.string;//start timecode
			
			sequence.media.appendChild(this.videoTemplate.copy());
			var format:XMLList = sequence.media.video.format;
			format.samplecharacteristics.width = sequenceFormatInX.width;
			format.samplecharacteristics.height = sequenceFormatInX.height;
			format.samplecharacteristics.rate.ntsc = isNTSC.toString();
			format.samplecharacteristics.rate.timebase = 1 / frameRate;
			
			sequence.media.appendChild(this.audioTemplate.copy());
			
			var audioRate:String = fcpX.project.sequence.@audioRate.toString();
			// convert Strings like "48k" to "480000"
			audioRate = audioRate.replace(/k/, "000");  
			sequence.media.audio.format.formatsamplecharacteristics.samplerate = audioRate;
			
			return sequence;
		}
		
		/**
		 * Parses through all children of a fcp x timeline element and attaches the translated timeline elements to 
		 * the currentSequence:XML instance of the converter. 
		 * 
		 * Supposed to be called recursivly to traverse through the xml tree of a fcp 7 project timeline
		 * 
		 * @param node a node from the timeline. can potentialy contain more nested elements from the timeline
		 */
		private function parseClipitemChildNodes(node:XML):void{
			for each (var childNodeFromX:XML in node.children()){
				// the fcp7 node in which the element:XML is translated
				var nodeName:String = childNodeFromX.localName().toString();
				switch (nodeName){
					// independent storylines, similar to tracks
					case "spine" :
						// go through all clips in that spine
						var lane:int = parseInt(childNodeFromX.@lane);
						var oldLane:int = this.currentTrackIndex;
						this.currentTrackIndex = lane;
						parseClipitemChildNodes(childNodeFromX);
						this.currentTrackIndex = oldLane;
						break;
					// clips are containers for "real" audio and video clips 
					case "clip" :
						// if this is a compound clip…
						if (childNodeFromX.children().length() > 1){
							//…create a new sub-sequence
							var seq:XML = this.createSequence();
							var node:XML = <clipitem id=" "></clipitem>;
							node.@id = "Compound Clip " + this.compoundClipIndex.toString();
							this.compoundClipIndex++;
							var oldSequence:XML = this.currentSequence;
							var oldTrackIndex:uint = this.currentTrackIndex;
							this.currentSequence = seq;
							// let the recursion beginn!
							parseClipitemChildNodes(childNodeFromX);
							node.appendChild(seq.children());
							// TODO add the node object to a video track
							// TODO add a node to the nessesary audio tracks
							var numberOfAudioTracks:int = this.currentSequence.media.audio.track.length();
							if(_isProject){
								// TODO add refernce to this new sequence in the project node
							}							
							this.currentSequence = oldSequence;
							this.currentTrackIndex = oldTrackIndex;
						}else{
							parseClipitemChildNodes(childNodeFromX);
						}
						break;
					case "video" :
						// TODO: implement this node
						createVideoClipItem(childNodeFromX);
						for each (var audioNode:XML in childNodeFromX.children()){
							createAudioClipItem(audioNode);
						}
						break;
					case "audio" :
						// TODO: implement this node
						break;
					case "gap" :
						// TODO: implement this node
						break;
					case "transition" :
						// TODO: implement this node
						break;
					case "title" :
						// TODO: implement this node
						break;
					case "audition" :
						// TODO: implement this node
						break;
					default:
						// well, skip this node, whatever it is …
						break;
				}//end switch 
			}// end for each
		}
		
		/**
		 * Creates the setup of a FCP7 Sequence from the FCP X Project Settings
		 * 
		 * @param sequence A raw FCP 7 <sequence> Node
		 */
		private function setUpVideo(sequence:XML):void{
			var formatRef:String = fcpX.project.sequence.@format;
			var format:XML = fcpX.project.resources.format.(@id==formatRef)[0];
			videoTemplate.format.samplecharacteristics.width = format.@width;
			videoTemplate.format.samplecharacteristics.height = format.@height;
			videoTemplate.format.samplecharacteristics.appendChild(this.currentSequence.rate[0]);
		}
		
		private function setUpAudio():void{
			// nothing yet. will there ever be something?
		}
		
		/**
		 * returns the XMEML conversion as a String ready for the output to a file
		 */
		public function getXMLAsString():String{
			return '<?xml version="1.0" encoding="utf-8"?>\n<!DOCTYPE fcpxml>\n'+this.convertedXml.toXMLString();
		}
		
		/**
		 * Mainly used for testing purposes with the flexunit framework
		 */
		public function getXMLResult():XML{
			return this.convertedXml.copy();
		}
		
		/**
		 * Takes a <clip> Node from the fcpxml and returns it as a <clipitem> node
		 * for xmeml 
		 */
		private function createVideoClipItem(videoNode:XML):void{
			var video:XML =	<clipitem id="foo ">
								<name>foo</name>
								<duration>0</duration>
								<in>-1</in>
								<out>-1</out>
								<start>0</start>
								<end>0</end>
								<masterclipid>foo 1</masterclipid>
								<file id="foo">
									<name>foo.mov</name>
									<pathurl>file://localhost/Users/user/someMovie.mov</pathurl>
									<rate>
										<timebase>25</timebase>
									</rate>
									<duration>0</duration>
									<media>
										<video>
											<duration>0</duration>
											<samplecharacteristics>
												<width>0</width>
												<height>0</height>
											</samplecharacteristics>
										</video>
										<audio>
											<samplecharacteristics>
												<samplerate>0</samplerate>
												<depth>0</depth>
											</samplecharacteristics>
											<channelcount>0</channelcount>
										</audio>
									</media>
								</file>
								<sourcetrack>
									<mediatype>video</mediatype>
								</sourcetrack>
								<link>
									<linkclipref>foo </linkclipref>
									<mediatype>video</mediatype>
									<trackindex>1</trackindex>
									<clipindex>1</clipindex>
								</link>
								<link>
									<linkclipref>foo 3</linkclipref>
									<mediatype>audio</mediatype>
									<trackindex>1</trackindex>
									<clipindex>1</clipindex>
									<groupindex>1</groupindex>
								</link>
								<link>
									<linkclipref>foo 4</linkclipref>
									<mediatype>audio</mediatype>
									<trackindex>2</trackindex>
									<clipindex>1</clipindex>
									<groupindex>1</groupindex>
								</link>
								<fielddominance>none</fielddominance>
								<itemhistory>
									<uuid>0000000000000</uuid>
								</itemhistory>
							</clipitem>;
			
			var clip:XML = videoNode.parent();
			
			// create ID
			var id:String = clip.@name + " ";
			var idIndex:int = this.clipIDs[id];
			if(idIndex == 0){
				this.clipIDs[id] = 1;
			}else{
				id = id +idIndex;
				
				this.clipIDs[id] = idIndex +1;
			}
			video.@id = id;
			
			// Clip Name in Timeline
			video.name = clip.@name;
			
			var inPoint:int = parseFrames(clip.@start);
			// Setting in Point. No E4X because "IN" is a restircted term in Actionscript (?)
			video.child("in")[0] = inPoint.toString();
			var duration:int = parseFrames(clip.@duration);
			video.out = (inPoint + duration).toString();
				
			var offset:String = clip.@offset;
			var start:int = parseFrames(offset);
			video.start = start.toString();//startframe in timeline
			video.end = (start + duration).toString(); //endframe in timlinw
			
			//master clip id is always "clipname 1"
			video.masterclipid = clip.name + " 1";
			
			// "clipname 2" is allways the id of the assosicated file. if it doesn exist, create a new file tree
			if(this.clipIDs[clip.name] > 1){
				
			}else{
				video.file.@id = clip.name + " 2"
			}
			
			// create a many empty tracks until we have reached the amount needed for the track index of this video clip
			var lane:String = clip.@lane.toString();
			if(lane == ""){
				lane = "0";
			}
			// calculate Track-No. Make sure it's posivtive and that relative lane indices are 
			// converted to absolute track indices. 
			var trackIndex:int = Math.abs(this.currentTrackIndex + parseInt(lane));
			
			while (this.currentSequence.media.video.track[trackIndex] == null){
				this.currentSequence.media.video.appendChild(<track>
																<enabled>TRUE</enabled>
																<locked>FALSE</locked>
															</track>);
			}
			
			this.currentSequence.media.video.track[trackIndex].appendChild(video);
			
			
		}
		
		private function createAudioClipItem(node:XML):XML{
			return null;
		}
		
		/**
		 * parses Strings like "12600/2500s" or "500s" to seconds
		 */
		private function parseTime(time:String):Number{
			var pattern:RegExp = /\d+/g;
			var result:Array = pattern.exec(time);
			var seconds:Number = result[0];
			var denominator:Array = pattern.exec(time);
			if(denominator != null){
				seconds = seconds / denominator[0];
			}
			return seconds;
		}
		
		/**
		 * returns the first integer value in Strings like "12600/2500s" and converts that value to frames
		 * returns 0 if time is NULL
		 */
		private function parseFrames(time:String):Number{
			if(time == null || time == ""){
				return 0;
			}
			var pattern:RegExp = /\d+/g;
			var result:Array = pattern.exec(time);
			var frames:Number = result[0];
			return Math.floor(frames / 100);
		}
	}
}