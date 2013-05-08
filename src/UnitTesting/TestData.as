package UnitTesting
{
	public class TestData
	{
		private static var _threeClipsFromX:XML =
			<fcpxml version="1.0">
				<project name="Alice 1" uid="6C92FC4A-8A3C-48D8-88FD-0A96FC4D22A7" eventID="F2DA8348-457B-41B3-B00F-3D46D69B64AC" location="file://localhost/Users/florianneumeister/Movies/Final%20Cut%20Projects/Alice%201/">
					<resources>
						<format id="r1" name="FFVideoFormat720p25" frameDuration="100/2500s" width="1280" height="720"/>
						<format id="r2" frameDuration="100/2500s" width="1280" height="720"/>
						<projectRef id="r3" name="Alice" uid="F2DA8348-457B-41B3-B00F-3D46D69B64AC"/>
						<asset id="r4" name="MVI_8247" uid="16AC078CD9A98EC35F323C7C4BCF38B5" projectRef="r3" src="file://localhost/Users/florianneumeister/Movies/Final%20Cut%20Events/Alice/Original%20Media/MVI_8247.mov" start="0s" duration="264900/2500s" hasVideo="1" hasAudio="1" audioSources="1" audioChannels="2" audioRate="20020"/>
						<asset id="r5" name="MVI_8248" uid="FD951A398438F2F307FF06D9F3EC317B" projectRef="r3" src="file://localhost/Users/florianneumeister/Movies/Final%20Cut%20Events/Alice/Original%20Media/MVI_8248.mov" start="0s" duration="211000/2500s" hasVideo="1" hasAudio="1" audioSources="1" audioChannels="2" audioRate="20020"/>
						<asset id="r6" name="MVI_8249" uid="FD7A9BF8A6340E2F3ECACA4523D86DE1" projectRef="r3" src="file://localhost/Users/florianneumeister/Movies/Final%20Cut%20Events/Alice/Original%20Media/MVI_8249.mov" start="0s" duration="72600/2500s" hasVideo="1" hasAudio="1" audioSources="1" audioChannels="2" audioRate="20020"/>
					</resources>
					<sequence duration="75300/2500s" format="r1" tcFormat="NDF" audioLayout="surround" audioRate="48k">
						<spine>
							<clip name="MVI_8247" duration="25100/2500s" start="10s" format="r2" tcFormat="NDF">
								<video ref="r4" duration="264900/2500s">
									<audio lane="-1" ref="r4" duration="2121319/20020s" role="dialogue" outCh="L, R"/>
								</video>
							</clip>
							<clip offset="25100/2500s" name="MVI_8248" duration="25100/2500s" start="10s" format="r2" tcFormat="NDF">
								<video ref="r5" duration="211000/2500s">
									<audio lane="-1" ref="r5" duration="1689688/20020s" role="dialogue" outCh="L, R"/>
								</video>
							</clip>
							<clip offset="50200/2500s" name="MVI_8249" duration="25100/2500s" start="10s" format="r2" tcFormat="NDF">
								<video ref="r6" duration="72600/2500s">
									<audio lane="-1" ref="r6" duration="581380/20020s" role="dialogue" outCh="L, R"/>
								</video>
							</clip>
						</spine>
					</sequence>
				</project>
			</fcpxml>;
		
		private static var _secondaryClipsFromX = 
			<fcpxml version="1.0">
				<project name="Alice 1" uid="6C92FC4A-8A3C-48D8-88FD-0A96FC4D22A7" eventID="F2DA8348-457B-41B3-B00F-3D46D69B64AC" location="file://localhost/Users/florianneumeister/Movies/Final%20Cut%20Projects/Alice%201/">
					<resources>
						<format id="r1" name="FFVideoFormat720p25" frameDuration="100/2500s" width="1280" height="720"/>
						<format id="r2" frameDuration="100/2500s" width="1280" height="720"/>
						<projectRef id="r3" name="Alice" uid="F2DA8348-457B-41B3-B00F-3D46D69B64AC"/>
						<asset id="r4" name="MVI_8259" uid="F22196B1B2D76A4DBDA88ECE11F13359" projectRef="r3" src="file://localhost/Users/florianneumeister/Movies/Final%20Cut%20Events/Alice/Original%20Media/MVI_8259.mov" start="0s" duration="57s" hasVideo="1" hasAudio="1" audioSources="1" audioChannels="2" audioRate="20020"/>
						<asset id="r5" name="MVI_8255" uid="909B699176CAD53A074407DBD0D0C890" projectRef="r3" src="file://localhost/Users/florianneumeister/Movies/Final%20Cut%20Events/Alice/Original%20Media/MVI_8255.mov" start="0s" duration="420900/2500s" hasVideo="1" hasAudio="1" audioSources="1" audioChannels="2" audioRate="20020"/>
						<asset id="r6" name="MVI_8257" uid="6A1304EF03AED120F626C4EFDD73B48C" projectRef="r3" src="file://localhost/Users/florianneumeister/Movies/Final%20Cut%20Events/Alice/Original%20Media/MVI_8257.mov" start="0s" duration="101000/2500s" hasVideo="1" hasAudio="1" audioSources="1" audioChannels="2" audioRate="20020"/>
						<asset id="r7" name="MVI_8266" uid="7A28CAC9C570B9F1B8E518A90787A9E4" projectRef="r3" src="file://localhost/Users/florianneumeister/Movies/Final%20Cut%20Events/Alice/Original%20Media/MVI_8266.mov" start="0s" duration="158300/2500s" hasVideo="1" hasAudio="1" audioSources="1" audioChannels="2" audioRate="20020"/>
					</resources>
					<sequence duration="102400/2500s" format="r1" tcFormat="NDF" audioLayout="surround" audioRate="48k">
						<spine>
							<clip name="MVI_8259" duration="58300/2500s" start="24000/2500s" format="r2" tcFormat="NDF">
								<video ref="r4" duration="57s">
									<audio lane="-1" ref="r4" duration="57s" role="dialogue" outCh="L, R"/>
								</video>
								<clip lane="2" offset="59100/2500s" name="MVI_8255" duration="62000/2500s" start="268200/2500s" tcFormat="NDF">
									<video ref="r5" duration="420900/2500s">
										<audio lane="-1" ref="r5" duration="3370567/20020s" role="dialogue" outCh="L, R"/>
									</video>
								</clip>
							</clip>
							<clip offset="58300/2500s" name="MVI_8257" duration="21500/2500s" start="21700/2500s" format="r2" tcFormat="NDF">
								<video ref="r6" duration="101000/2500s">
									<audio lane="-1" ref="r6" duration="808808/20020s" role="dialogue" outCh="L, R"/>
								</video>
								<clip lane="1" offset="12s" name="MVI_8266" duration="35800/2500s" start="66800/2500s" tcFormat="NDF">
									<video ref="r7" duration="158300/2500s">
										<audio lane="-1" ref="r7" duration="1267666/20020s" role="dialogue" outCh="L, R"/>
									</video>
								</clip>
							</clip>
						</spine>
					</sequence>
				</project>
			</fcpxml>;
			
		/** Contains three PAL 720p25 Clips, all with an In-Point at 10:00 and a duration of 10:00	 */
		public static function get threeClipsFromX():XML{
			return _threeClipsFromX.copy();
		}
		
		/** A storyline with 2 clips in the main storyline, each with a secondary clip */
		public static function get secondaryClipsFromX():XML{
			return _secondaryClipsFromX.copy();
		}
		
	}
}