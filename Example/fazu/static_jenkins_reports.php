<?php

  $CURR_DIR = getcwd();
  $SCRIPT_PATH = "Fazu CI";
  $SCRIPT_FULL_PATH = $CURR_DIR . "/" . $SCRIPT_PATH;

  #color formats
$FMT_FG_LTE_GREEN="\033[1;32m"; # Light Green
$FMT_FG_RED="\033[0;31m"; # Red
$FMT_FG_YELLOW="\033[1;33m"; # Yellow
$FMT_FG_CYAN="\033[0;36m"; # Cyan
$FMT_FG_GREEN="\033[0;32m";
$FMT_FG_BLUE="\033[0;34m";
$FMT_FG_NO_COLOR="\033[0m"; # No Color
$FMT_BG_BLACK_COLOR="\033[40m"; # Black
$FMT_FG_BLINK="\033[5m";
$FMT_FG_ORANGE_COLOR="\033[38;5;208m"; # orange

print_r("\n");
print_r("${FMT_FG_ORANGE_COLOR}[Fazu Jira]${FMT_FG_NO_COLOR}: ${FMT_FG_LTE_GREEN}---------------------------------------------------------------------------------${FMT_FG_NO_COLOR}\n");
print_r("${FMT_FG_ORANGE_COLOR}[Fazu Jira]${FMT_FG_NO_COLOR}: ${FMT_FG_LTE_GREEN}------------------------------ Jenkins Static Reports -----------------------------${FMT_FG_NO_COLOR}\n");
print_r("${FMT_FG_ORANGE_COLOR}[Fazu Jira]${FMT_FG_NO_COLOR}: ${FMT_FG_LTE_GREEN}---------------------------------------------------------------------------------${FMT_FG_NO_COLOR}\n");
print_r("${FMT_FG_ORANGE_COLOR}[Fazu Jira]${FMT_FG_NO_COLOR}:\n");

print_r("${CURR_DIR}");

  if (!file_exists(".swiftlint.yml")) {
    system("echo \"reporter: \"checkstyle\"\nline_length: 120\nexcluded:\n  - Pods\n  - *Tests\n\ndisabled_rules:\n  - trailing_newline\n  - trailing_whitespace\n  - line_length\n  - control_statement\" > .swiftlint.yml");
  } else {
    system("sed 's/: \"xcode\"/: \"checkstyle\"/' .swiftlint.yml >> .swiftlint2.yml");
    system("rm .swiftlint.yml");
    system("mv .swiftlint2.yml .swiftlint.yml");
  }
  system("lizard -x\"*.framework*\" -x\"*Tests*\" -x\"*Pods*\" -x\"*Libraries*\" -X > build/reports/lizard.xml");
  system("swiftlint lint >> build/reports/swift-lint.xml");
  system('cloc --by-file --xml --exclude-dir=vendor,Pods,build,Libraries,docs,External --not-match-d=".(Tests|framework)" --exclude-lang=PHP,JSON,YAML,"Bourne Shell"  -out=build/reports/cloc.xml .');
  system("export HEAPSIZE=2g");
  system("sh /Applications/pmd/bin/run.sh cpd --minimum-tokens 100 --files . --exclude ./External/ --exclude ./Pods/ --exclude ./build/ --exclude ./Libraries/ --exclude ./*Tests*/ --language swift --format xml > build/reports/swift-cpd.xml");
  system("sh /Applications/pmd/bin/run.sh cpd --minimum-tokens 100 --files . --exclude ./External/ --exclude ./Pods/ --exclude ./build/ --exclude ./Libraries/ --exclude ./*Tests*/ --language objectivec --format xml > build/reports/objc-cpd.xml");
?>
