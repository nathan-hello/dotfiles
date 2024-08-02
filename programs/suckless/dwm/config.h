/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  	= 1;  /* border pixel of windows            */
static const unsigned int mongap	= 0;  /* gap from monitor sides             */
static const unsigned int bargap	= 0; /* gap between bar sections           */
static const unsigned int gappx     	= 0; /* gaps between windows               */
static const int vertpad   	    	= 0; /* vertical padding of bar            */
static const int sidepad	 	= 0; /* horizontal padding of bar          */
static const int horizpadbar		= 2;  /* horizontal internal padding of bar */
static const int vertpadbar		= 4;  /* vertical internal padding of bar   */

static const unsigned int snap      	= 8;  /* snap pixel                         */
static const int showbar            	= 1;  /* 0 means no bar                     */
static const int topbar             	= 0;  /* 0 means bottom bar                 */
static const char *fonts[]          = { "SFMono Nerd Font:style=Regular:size=12" };
static const char dmenufont[]       = "SFMono Nerd Font:style=Regular:size=12";

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
	[SchemeTagsSel]  = { col_black,    col_select,    COL_UNUSED,    COL_UNUSED    },
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
	[SchemeInfoSel]  = { OPAQUE,  OPAQUE,  OPAQUE },
	[SchemeInfoNorm] = { OPAQUE,  OPAQUE,  OPAQUE },
	[SchemeMisc1]    = { OPAQUE,  OPAQUE,  OPAQUE },
	[SchemeMisc2]    = { OPAQUE,  OPAQUE,  OPAQUE },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class                     instance   title   tags mask   isfloating   monitor */
	{ "Qutebrowser",  NULL,       NULL,       1 << 8,       0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.60; /* factor of master area size [0.05..0.95]      */
static const int nmaster     = 1;    /* number of clients in master area             */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol   arrange function */
	{ "[]=",    tile           },    /* first entry is default */
	{ "><>",    NULL           },    /* no layout function means floating behavior */
	{ "[M]",    monocle        },
	{ "TTT",    bstack         },
	{ "===",    bstackhoriz    },
	{ "|M|",    centeredmaster },
	{ "__|",    threadmill     },
	{ "|||",    columns        },
};

/* key definitions */
#define MOD1    Mod4Mask
#define MOD2    Mod1Mask
#define TAGKEYS(KEY,TAG) \
	{ MOD1,           KEY, view,       {.ui = 1 << TAG} }, \
	{ MOD1|ShiftMask, KEY, toggleview, {.ui = 1 << TAG} }, \
	{ MOD2,           KEY, tag,        {.ui = 1 << TAG} }, \
	{ MOD2|ShiftMask, KEY, toggletag,  {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
#define TERMINAL    "alacritty"
#define DMENU	    "dmenu_run"
#define WEBBROWSER  "qutebrowser"
#define STARTMENU   "startmenu.sh"
#define LOCK	    "lockscreen.sh"
#define SCREENSHOT  "flameshot gui"
#define SCREENREC   "scrlive.sh"
#define UPVOL	    "volup.sh"
#define DOWNVOL	    "voldown.sh"
#define MUTEVOL	    "mutevol.sh"
#define BRIGHTER    "brightnessctl set 10%+"
#define DIMMER	    "brightnessctl set 10%-"
static const char *layoutmenu_cmd = "dwm-menu-layout";
static const char *windowmenu_cmd = "dwm-menu-window";

#include "shiftview.c"
#include <X11/XF86keysym.h>

static Key keys[] = {
	/* modkey         key           function        argument             */
        /* processes                                                         */
	{ MOD1,           XK_Return,    spawn,          SHCMD(TERMINAL)       },
	{ MOD1,           XK_p,         spawn,          SHCMD(DMENU)          },
	{ 0,              XK_Print,     spawn,          SHCMD(SCREENSHOT)     },
	{ MOD1,           XK_q,         killclient,     {0}                   },
	{ MOD1|ShiftMask, XK_q,         quit,           {0}                   },
	{ MOD1,           XK_l,         setmfact,       {.f = +0.05}          },
	{ MOD1,           XK_h,	        setmfact,       {.f = -0.05}          },
	{ MOD1,           XK_j,         focusstack,     {.i = +1}             },
	{ MOD1,           XK_k,         focusstack,     {.i = -1}             },
	{ MOD1,           XK_z,         focusmaster,    {0}                   },
        { MOD1|ShiftMask, XK_Return,    zoom,           {0}                   },
	{ MOD1,           XK_space,     togglefloating, {0}                   },
	/* monitors                                                           */
	{ MOD1,           XK_b,         togglebar,      {0}                   },
	/* layouts                                                            */
	{ MOD1,           XK_BackSpace, incnmaster,     {.i =  0}             },
	/* tagging                                                            */
	{ MOD1,           XK_Tab,       view,           {0}            },
	{ MOD2,           XK_0,         tag,            {.ui = ~0}            },
	TAGKEYS(          XK_1,         0)
	TAGKEYS(          XK_2,         1)
	TAGKEYS(          XK_3,         2)
	TAGKEYS(          XK_4,         3)
	TAGKEYS(          XK_5,         4)
	TAGKEYS(          XK_6,         5)
	TAGKEYS(          XK_7,         6)
	TAGKEYS(          XK_8,         7)
	TAGKEYS(          XK_9,         8)
	// { MOD1|ShiftMask, XK_l,		        spawn,		SHCMD(LOCK)	      },
	// { 0,		     XK_F9,	                spawn,		SHCMD(SCREENREC)      },
	// { 0,	             XF86XK_AudioMute,		spawn,          SHCMD(MUTEVOL)        },
	// { 0,              XF86XK_AudioLowerVolume,   spawn,          SHCMD(DOWNVOL)        },
	// { 0,              XF86XK_AudioRaiseVolume,   spawn,          SHCMD(UPVOL)          },	
	// { MOD2,           XK_l,                      setcfact,       {.f = +0.15}          },
	// { MOD2,           XK_h,                      setcfact,       {.f = -0.15}          },
	// { MOD2,           XK_equal,                  setcfact,       {.f =  0.00}          },
	// { MOD2,           XK_j,                      swapdown,       {0}                   },
	// { MOD2,           XK_k,                      swapup,         {0}                   },
	// { MOD1,           XK_f,                      togglefullscr,  {0}                   },
	// { MOD1,           XK_n,                      shiftview,      {.i = +1}	      },
	// { MOD1,           XK_b,                      shiftview,      {.i = -1}	      },
	// { MOD1,	     XK_period,                 focusmon,       {.i = -1}             },
        // { MOD1,	     XK_comma,                  focusmon,       {.i = +1}             },
	// { MOD1|ShiftMask, XK_g,         togglegaps,     {0}                   },
	// { MOD1,           XK_F1,        setlayout,      {.v = &layouts[0]}    },
	// { MOD1,           XK_F2,        setlayout,      {.v = &layouts[1]}    },
	// { MOD1,           XK_F3,        setlayout,      {.v = &layouts[2]}    },
	// { MOD1,           XK_F4,        setlayout,      {.v = &layouts[3]}    },
	// { MOD1,           XK_F5,        setlayout,      {.v = &layouts[4]}    },
	// { MOD1,           XK_F6,        setlayout,      {.v = &layouts[5]}    },
	// { MOD1,           XK_F7,        setlayout,      {.v = &layouts[6]}    },
	// { MOD1,           XK_F8,        setlayout,      {.v = &layouts[7]}    },
	// { MOD1,           XK_equal,     incnmaster,     {.i = +1}             },
	// { MOD1,           XK_minus,     incnmaster,     {.i = -1}             },
	// { MOD2,           XK_t,         layoutmenu,     {0}                   },
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
	{ ClkStatusText, 0,       Button3, spawn,          SHCMD(STARTMENU) },
	{ ClkStatusText, 0,       Button3, spawn,          SHCMD(TERMINAL)  },
	/* client windows                                                   */
	{ ClkClientWin,  MOD1,    Button1, movemouse,      {0}              },
	{ ClkClientWin,  MOD1,    Button3, windowmenu,     {0}              },
	{ ClkClientWin,  MOD2,    Button1, resizemouse,    {0}              },
	{ ClkClientWin,  MOD2,    Button3, togglefloating, {0}              },
	/* root window                                                      */
	{ ClkRootWin,    0,       Button3, spawn,          SHCMD(STARTMENU) },
	{ ClkRootWin,    0,       Button3, focusmaster,    {0}              },
};
