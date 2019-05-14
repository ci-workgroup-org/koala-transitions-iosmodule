env.SLACK_CHANNEL="koala-builds"
prettyNode("uber_ios") {
	dir ("Example") {
		fastlane.setup()
		awsCreds('ios-secrets-s3-creds') {
	  	fastlane.pull_secrets()
		}
		mobileBuildStage("KoalaCreditCardInput") {
			fastlane.build 'Debug'
			}
			fastlane.run_reports()
		}
}
