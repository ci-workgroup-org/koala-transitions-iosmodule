env.SLACK_CHANNEL="koala-builds"
prettyNode("uber_ios") {
	dir ("Example") {
		fastlane.setup()
		mobileBuildStage("KoalaTranistions") {
			fastlane.build 'Debug'
			}
			fastlane.run_reports()
		}
}
