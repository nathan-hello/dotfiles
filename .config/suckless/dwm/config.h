#include <string.h>
#include <stdlib.h>
/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  	= 3;  /* border pixel of windows            */
static const unsigned int mongap    	= 10; /* gap from monitor sides             */
static const unsigned int bargap	= 0;  /* gap between bar sections           */
static const unsigned int gappx     	= 10; /* gaps between windows               */
static const int vertpad   	    	= 0;  /* vertical padding of bar            */
static const int sidepad	 	= 0;  /* horizontal padding of bar          */
static const int horizpadbar		= 3;  /* horizontal internal padding of bar */
static const int vertpadbar		= 10; /* vertical internal padding of bar   */

static const unsigned int snap      	= 8;  /* snap pixel                         */
static const int showbar            	= 1;  /* 0 means no bar                     */
static const int topbar             	= 1;  /* 0 means bottom bar                 */
static const char *fonts[]          = { "monospace:style=Regular:size=12" };
static const char dmenufont[]       = "monospace:style=Regular:size=12";

static const char col_white[]			= "#bbbbbb";
static const char col_black[]			= "#222222";
static const char col_urgent[]			= "#E85031";
static const char col_urgent2[]			= "#510000";
static const char col_select[]			= "#005577";
static const char col_unselect[]		= "#bbbbbb";
static const char col_unselect2[]		= "#D0D0D0";
static const char col_unselect3[]		= "#444444";
static const char col_infobg[]			= "#2D2D2D";
static const char col_winbg[]			= "#1D1D1D";

static const char *colors[][4] = {
	/*                   fg	           bg             border         float border  */
	[SchemeGap]      = { COL_UNUSED,   COL_UNUSED,    COL_UNUSED,    COL_UNUSED    },
	[SchemeNorm]     = { col_white,    COL_UNUSED,    COL_UNUSED,    COL_UNUSED    },
	[SchemeSel]      = { col_white,    COL_UNUSED,    col_select,    col_select    },
	[SchemeUrg]      = { col_white,    COL_UNUSED,    col_urgent,    col_urgent    },
	[SchemeStatus]   = { col_white,    col_black,	  col_unselect3, COL_UNUSED    },
	[SchemeTagsSel]  = { col_white,    col_select,    COL_UNUSED,    COL_UNUSED    },
	[SchemeTagsNorm] = { col_white,    col_black,	  COL_UNUSED,    COL_UNUSED    },
	[SchemeLayout]   = { col_white,    col_black,     COL_UNUSED,    COL_UNUSED    },
	[SchemeInfoSel]  = { col_white,    col_select,    COL_UNUSED,    COL_UNUSED    },
	[SchemeInfoNorm] = { col_white,    col_black,	  COL_UNUSED,    COL_UNUSED    },
	[SchemeMisc1]    = { col_select,   col_infobg,    COL_UNUSED,    COL_UNUSED    },
	[SchemeMisc2]    = { col_white,    col_unselect,  COL_UNUSED,    COL_UNUSED    },
	[SchemeMisc3]    = { col_select,   col_urgent2,   COL_UNUSED,    COL_UNUSED    },
	[SchemeMisc4]    = { col_white,    col_urgent2,   COL_UNUSED,    COL_UNUSED    },
};

static const unsigned int alphas[][3] = {
	/*                   fg       bg       border */
	[SchemeGap]      = { CLEAR,   CLEAR,   CLEAR  },
	[SchemeNorm]     = { OPAQUE,  OPAQUE,  OPAQUE },
	[SchemeSel]      = { OPAQUE,  OPAQUE,  OPAQUE },
	[SchemeUrg]      = { OPAQUE,  OPAQUE,  OPAQUE },
	[SchemeStatus]   = { OPAQUE,  OPAQUE,  OPAQUE },
	[SchemeTagsSel]  = { OPAQUE,  OPAQUE,  OPAQUE },
	[SchemeTagsNorm] = { OPAQUE,  OPAQUE,  OPAQUE },
    [SchemeLayout]   = { OPAQUE,  OPAQUE,  OPAQUE },
    [SchemeInfoSel]  = { OPAQUE,  OPAQUE,  OPAQUE },
	[SchemeInfoNorm] = { OPAQUE,  OPAQUE,  OPAQUE },
	[SchemeMisc1]    = { OPAQUE,  OPAQUE,  OPAQUE },
	[SchemeMisc2]    = { OPAQUE,  OPAQUE,  OPAQUE },
};

/* tagging */
static const char *tags[] = { " 1 ", " 2 ", " 3 ", " 4 ", " 5 " };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class                     instance   title   tags mask   isfloating   monitor */
        // gotta put something here or it complains
	{ "devnull",  NULL,       NULL,       1 << 8,       0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.60; /* factor of master area size [0.05..0.95]      */
static const int nmaster     = 1;    /* number of clients in master area             */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol   arrange function */
	{ "[]=",    tile           },    /* first entry is default */
	// { "><>",    NULL           },    /* no layout function means floating behavior */
	// { "[M]",    monocle        },
	// { "TTT",    bstack         },
	// { "===",    bstackhoriz    },
	// { "|M|",    centeredmaster },
	// { "__|",    threadmill     },
	// { "|||",    columns        },
};

/* key definitions */
#define MOD1    Mod4Mask
#define MOD2    Mod1Mask
#define TAGKEYS(KEY,TAG) \
	{ MOD1,           KEY, view,       {.ui = 1 << TAG} }, \
	{ MOD1|ShiftMask, KEY, tag,        {.ui = 1 << TAG} }, \
	/* { MOD2|ShiftMask, KEY, toggletag,  {.ui = 1 << TAG} },
	{ MOD1|ShiftMask, KEY, toggleview, {.ui = 1 << TAG} }, \ */



static char terminal_cmd[PATH_MAX];
static char webbrowser_cmd[PATH_MAX];
// static char dmenu_cmd[PATH_MAX];
// static char screenshot_cmd[PATH_MAX];
// static char boomer_cmd[PATH_MAX];

static char scrlive_cmd[PATH_MAX];
static char startmenu_cmd[PATH_MAX];
static char lock_cmd[PATH_MAX];
static char upvol_cmd[PATH_MAX];
static char downvol_cmd[PATH_MAX];
static char mutevol_cmd[PATH_MAX];
static char brighter_cmd[PATH_MAX];
static char dimmer_cmd[PATH_MAX];
static char windowmenu_script[PATH_MAX];
static char layoutmenu_script[PATH_MAX];

static const char *terminal[]       = { terminal_cmd,                NULL };
static const char *webbrowser[]     = { webbrowser_cmd,              NULL };
static const char *dmenu[]          = { "dmenu_run",                 NULL };
static const char *screenshot[]     = { "flameshot", "gui",          NULL };
static const char *boomer[]         = { "boomer",                    NULL };

static const char *screenrec[]      = { scrlive_cmd,                 NULL };
static const char *startmenu[]      = { startmenu_cmd,               NULL };
static const char *lock[]           = { lock_cmd,                    NULL };
static const char *upvol[]          = { upvol_cmd,                   NULL };
static const char *downvol[]        = { downvol_cmd,                 NULL };
static const char *mutevol[]        = { mutevol_cmd,                 NULL };
static const char *brighter[]       = { brighter_cmd, "set", "10%+", NULL };
static const char *dimmer[]         = { dimmer_cmd,  "set", "10%-",  NULL };
static const char *windowmenu_cmd = windowmenu_script;
static const char *layoutmenu_cmd = layoutmenu_script;

__attribute__((constructor)) 
void setup_commands() {
    const char* home    = getenv("HOME");
    const char* term    = getenv("TERM");
    const char* browser = getenv("BROWSER");
    if (!home) return;

    snprintf(terminal_cmd,       sizeof(terminal_cmd),        "%s",                                      term);
    snprintf(webbrowser_cmd,     sizeof(webbrowser_cmd),      "%s",                                   browser);

    snprintf(scrlive_cmd,        sizeof(scrlive_cmd),        "%s/.config/scripts/scrlive.sh",            home);
    snprintf(startmenu_cmd,      sizeof(startmenu_cmd),      "%s/.config/scripts/startmenu.sh",          home);
    snprintf(lock_cmd,           sizeof(lock_cmd),           "%s/.config/scripts/lockscreen.sh",         home);
    snprintf(upvol_cmd,          sizeof(upvol_cmd),          "%s/.config/scripts/volup.sh",              home);
    snprintf(downvol_cmd,        sizeof(downvol_cmd),        "%s/.config/scripts/voldown.sh",            home);
    snprintf(mutevol_cmd,        sizeof(mutevol_cmd),        "%s/.config/scripts/mutevol.sh",            home);
    snprintf(brighter_cmd,       sizeof(brighter_cmd),       "%s/.config/scripts/brightnessctl",         home);
    snprintf(dimmer_cmd,         sizeof(dimmer_cmd),         "%s/.config/scripts/brightnessctl",         home);
    snprintf(windowmenu_script,  sizeof(windowmenu_script),  "%s/.config/scripts/dwm-menu-window.sh",    home);
    snprintf(layoutmenu_script,  sizeof(layoutmenu_script),  "%s/.config/scripts/dwm-menu-layout.sh",    home);
}

#include "shiftview.c"
#include <X11/XF86keysym.h>

static Key keys[] = {
	/* modkey               key                             function        argument                */
        /* processes */
	{ MOD1,                 XK_Return,                      spawn,                          {.v = terminal}         },
	{ MOD1,                 XK_d,                           spawn,                          {.v = dmenu}            },
	{ MOD1,                 XK_w,                           spawn,                          {.v = webbrowser}       },
	{ 0,                    XK_Print,                       spawn,                          {.v = screenshot}       },
	{ MOD1|ShiftMask,       XK_l,		                spawn,	    	                {.v = lock}	        },
        { 0,		        XK_F9,  	                spawn,                          {.v = screenrec}        },
        { 0,                    XF86XK_MonBrightnessUp,         spawn,                          {.v = brighter}         },
        { 0,                    XF86XK_MonBrightnessDown,       spawn,                          {.v = dimmer}           },
	{ 0,	                XF86XK_AudioMute, 	        spawn,                          {.v = mutevol}          },
	{ 0,                    XF86XK_AudioLowerVolume,        spawn,                          {.v = downvol}          },
	{ 0,                    XF86XK_AudioRaiseVolume,        spawn,                          {.v = upvol}            },	
	{ MOD1,                 XK_q,                           killclient,                     {0}                     },
	{ MOD1|ShiftMask,       XK_q,                           quit,                           {0}                     },
	{ MOD1,                 XK_l,                           setmfact,                       {.f = +0.05}            },
	{ MOD1,                 XK_h,	                        setmfact,                       {.f = -0.05}            },
	{ MOD1,                 XK_j,                           focusstack,                     {.i = +1}               },
	{ MOD1,                 XK_k,                           focusstack,                     {.i = -1}               },
	{ MOD1,                 XK_z,                           focusmaster,                    {0}                     },
        { MOD1|ShiftMask,       XK_Return,                      zoom,                           {0}                     }, { MOD1,                 XK_BackSpace,                   incnmaster,                     {.i =  0}               }, { MOD1,                 XK_Tab,                         view,                           {0}                     },
	{ MOD2,                 XK_l,                           setcfact,                       {.f = +0.15}            },
	{ MOD2,                 XK_h,                           setcfact,                       {.f = -0.15}            },
	{ MOD2,                 XK_equal,                       setcfact,                       {.f =  0.00}            },
	{ MOD2,                 XK_j,                           swapdown,                       {0}                     },
	{ MOD2,                 XK_k,                           swapup,                         {0}                     },
	{ MOD1,                 XK_f,                           togglefullscr,                  {0}                     },
	// { MOD1,                 XK_space,                       togglefloating,                 {0}                     },
	// { MOD1,                 XK_n,                           shiftview,                      {.i = +1}               },
	// { MOD1,                 XK_b,                           shiftview,                      {.i = -1}	           },
	// { MOD1,                 XK_t,                           togglebar,                      {0}                     },

	/* monitors */
	// { MOD1,	           XK_period,                      focusmon,                       {.i = -1}               },
        // { MOD1,	           XK_comma,                       focusmon,                       {.i = +1}               },
 	// { MOD1|ShiftMask,       XK_comma,                       tagmon,                         {.i = -1 }              },
 	// { MOD1|ShiftMask,       XK_period,                      tagmon,                         {.i = +1 }              },
        // { MOD1|ShiftMask,       XK_g,                           togglegaps,                     {0}                     },

	/* layouts */
	// { MOD1,                 XK_F1,                          setlayout,                      {.v = &layouts[0]}      },
	// { MOD1,                 XK_F2,                          setlayout,                      {.v = &layouts[1]}      },
	// { MOD1,                 XK_F3,                          setlayout,                      {.v = &layouts[2]}      },
	// { MOD1,                 XK_F4,                          setlayout,                      {.v = &layouts[3]}      },
	// { MOD1,                 XK_F5,                          setlayout,                      {.v = &layouts[4]}      },
	// { MOD1,                 XK_F6,                          setlayout,                      {.v = &layouts[5]}      },
	// { MOD1,                 XK_F7,                          setlayout,                      {.v = &layouts[6]}      },
	// { MOD1,                 XK_F8,                          setlayout,                      {.v = &layouts[7]}      },
	// { MOD1,                 XK_equal,                       incnmaster,                     {.i = +1}               },
	// { MOD1,                 XK_minus,                       incnmaster,                     {.i = -1}               },
	// { MOD2,                 XK_t,                           layoutmenu,                     {0}                     },
	/* tagging */
	{ MOD2,                 XK_0,                           tag,                            {.ui = ~0}              },

	TAGKEYS(                XK_1,         0)
	TAGKEYS(                XK_2,         1)
	TAGKEYS(                XK_3,         2)
	TAGKEYS(                XK_4,         3)
	TAGKEYS(                XK_5,         4)
	TAGKEYS(                XK_6,         5)
	TAGKEYS(                XK_7,         6)
	TAGKEYS(                XK_8,         7)
	TAGKEYS(                XK_9,         8)
};

/* button definitions */
static Button buttons[] = {
	/* click         modkey   button   function        argument         */
	/* tag bar section                                                  */
	{ ClkTagBar,     0,       Button1, view,           {0}              },
	{ ClkTagBar,     0,       Button3, toggleview,     {0}              },
	{ ClkTagBar,     MOD1,    Button1, tag,            {0}              },
	{ ClkTagBar,     MOD1,    Button3, toggletag,      {0}              },
	/* layout indicator section                                         */
	{ ClkLtSymbol,   0,       Button1, layoutmenu,     {0}              },
	{ ClkLtSymbol,   0,       Button3, setlayout,      {0}              },
	/* selected window title section                                    */
	{ ClkWinTitle,   0,       Button1, windowmenu,     {0}              },
	{ ClkWinTitle,   0,       Button3, zoom,           {0}              },
	/* status section, subsections gaps are included in the hitbox      */
	// { ClkStatusText, 0,       Button3, spawn,          {.v = startmenu} },
	// { ClkStatusText, 0,       Button3, spawn,          SHCMD(TERMINAL)  },
	/* client windows                                                   */
	{ ClkClientWin,  MOD1,    Button1, movemouse,      {0}              },
	{ ClkClientWin,  MOD1,    Button3, windowmenu,     {0}              },
	{ ClkClientWin,  MOD2,    Button1, resizemouse,    {0}              },
	{ ClkClientWin,  MOD2,    Button3, togglefloating, {0}              },
	{ ClkClientWin,  MOD1,       Button2, spawn,          {.v = boomer}    },
	/* root window                                                      */
	{ ClkRootWin,    0,       Button3, spawn,          {.v = startmenu} },
	{ ClkRootWin,    0,       Button3, focusmaster,    {0}              },
};
