/* See LICENSE file for copyright and license details. */
/* Default settings; can be overriden by command line. */

static int topbar = 1;                 /* -b  option; if 0, dmenu appears at bottom     */
static int centered = 1;               /* -c option; centers dmenu on screen */
static int min_width = 480;            /* minimum width when centered */
static const char *fonts[] = {         /* -fn option overrides fonts[0]; default X11 font or font set */
	"xos4 Terminus:pixelsize=14"
};
static const char *prompt      = NULL; /* -p  option; prompt to the left of input field */
static const char *colors[SchemeLast][2] = {
		           /* fg         bg */
	[SchemeNorm]  = { "#E0E0E0", "#2D2D2D" },
	[SchemeSel]   = { "#000000", "#E4DF52" },
	[SchemeOut]   = { "#000000", "#00FFFF" },
	[SchemeInput] = { "#E0E0E0", "#4D4D2D" },
};
/* -l option; if nonzero, dmenu uses vertical list with given number of lines */
static unsigned int lines      = 8;
static unsigned int lineheight = 30;   /* -h option; minimum height of a menu line     */

/*
 * Characters not considered part ofa word while deleting words
 * for example: " /?\"&[]"
 */
static const char worddelimiters[] = " ";

/* Size of the window border */
static const unsigned int border_width = 1;
