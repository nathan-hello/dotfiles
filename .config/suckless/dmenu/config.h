/*
 * See LICENSE file for copyright and license details. */
/* Default settings; can be overriden by command line. */

static int topbar = 1;                 /* -b  option; if 0, dmenu appears at bottom     */
static int centered = 1;               /* -c option; centers dmenu on screen */
static int min_width = 480;            /* minimum width when centered */
static const char *fonts[] = { "monospace:size=16" };
static const char *prompt      = NULL; /* -p  option; prompt to the left of input field */
static const char *colors[SchemeLast][2] = {
		           /* fg         bg */
	[SchemeNorm] = { "#bbbbbb", "#222222" },
	[SchemeSel] = { "#eeeeee", "#005577" },
	[SchemeOut] = { "#000000", "#00ffff" },
	[SchemeInput] = { "#bbbbbb", "#222222" },
};
/* -l option; if nonzero, dmenu uses vertical list with given number of lines */
static unsigned int lines      = 8;
static unsigned int lineheight = 48;   /* -h option; minimum height of a menu line     */

/*
 * Characters not considered part ofa word while deleting words
 * for example: " /?\"&[]"
 */
static const char worddelimiters[] = " ";

/* Size of the window border */
static const unsigned int border_width = 1;
