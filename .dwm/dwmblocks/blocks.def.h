//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/
//	{"Mem:", "free -h | awk '/^Mem/ { print $3\"/\"$2 }' | sed s/i//g",	30,		0},
	{" [", "acpi | awk  '{print $3 , $4}' | sed 's/,//g'",	5,		0},

	{"Volume ", "awk -F\"[][]\" '/Left:/ { print $2 }' <(amixer sget Master)", 	0,		10},
	{"Brightness ", "brightnessctl -m -d nvidia_0 | awk -F, '{print substr($4, 0,length($4)-1)\"%\"}' & brightnessctl -m -d intel_backlight| awk -F, '{print substr($4, 0,length($4)-1)\"%\"}'", 	0,		20},
	{"", "date '+%I:%M%p (%a) %D] '",					30,		0},
};

//sets delimeter between status commands. NULL character ('\0') means no delimeter.
static char delim[] = "] [";
static unsigned int delimLen = 5;
