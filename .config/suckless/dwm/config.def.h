/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  	= 1;  /* border pixel of windows            */
static const unsigned int mongap		= 1;  /* gap from monitor sides             */
static const unsigned int bargap		= 10; /* gap between bar sections           */
static const unsigned int gappx     	= 10; /* gaps between windows               */
static const int vertpad   	    		= 10; /* vertical padding of bar            */
static const int sidepad	 			= 10; /* horizontal padding of bar          */
static const int horizpadbar			= 4;  /* horizontal internal padding of bar */
static const int vertpadbar				= 8;  /* vertical internal padding of bar   */

static const unsigned int snap      	= 8;  /* snap pixel                         */
static const int showbar            	= 1;  /* 0 means no bar                     */
static const int topbar             	= 1;  /* 0 means bottom bar                 */
static const char *fonts[]          	= { "xos4 Terminus:size=12" };
static const char dmenufont[]       	= "xos4 Terminus:size=12";

static const char col_white[]			= "#E0E0E0";
static const char col_black[]			= "#000000";
static const char col_urgent[]			= "#E85031";
static const char col_urgent2[]			= "#510000";
static const char col_select[]			= "#E4DF52";
static const char col_unselect[]		= "#858585";
static const char col_unselect2[]		= "#D0D0D0";
static const char col_unselect3[]		= "#4D4D2D";
static const char col_infobg[]			= "#2D2D2D";
static const char col_winbg[]			= "#1D1D1D";

static const char *colors[][4] = {
	/*                   fg	           bg             border        float border  */
	[SchemeGap]      = { COL_UNUSED,   COL_UNUSED,    COL_UNUSED,   COL_UNUSED    },
	[SchemeNorm]     = { col_white,    COL_UNUSED,    col_unselect, col_unselect2 },
	[SchemeSel]      = { col_white,    COL_UNUSED,    col_select,   col_select    },
	[SchemeUrg]      = { col_white,    COL_UNUSED,    col_urgent,   col_urgent    },
	[SchemeStatus]   = { col_white,    col_infobg,    COL_UNUSED,   COL_UNUSED    },
	[SchemeTagsSel]  = { col_black,    col_select,    COL_UNUSED,   COL_UNUSED    },
	[SchemeTagsNorm] = { col_white,    col_unselect3, COL_UNUSED,   COL_UNUSED    },
	[SchemeLayout]   = { col_black,    col_select,    COL_UNUSED,   COL_UNUSED    },
	[SchemeInfoSel]  = { col_white,    col_infobg,    COL_UNUSED,   COL_UNUSED    },
	[SchemeInfoNorm] = { col_white,    col_infobg,    COL_UNUSED,   COL_UNUSED    },
	[SchemeMisc1]    = { col_select,   col_infobg,    COL_UNUSED,   COL_UNUSED    },
	[SchemeMisc2]    = { col_white,    col_urgent,    COL_UNUSED,   COL_UNUSED    },
	[SchemeMisc3]    = { col_select,   col_urgent2,   COL_UNUSED,   COL_UNUSED    },
	[SchemeMisc4]    = { col_white,    col_urgent2,   COL_UNUSED,   COL_UNUSED    },
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
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class                     instance   title   tags mask   isfloating   monitor */
	{ "Galculator",              NULL,      NULL,   0 << 8,     1,           -1      },
	{ "Keepass",                 NULL,      NULL,   0 << 8,     1,           -1      },
	{ "Gcolor2",                 NULL,      NULL,   0 << 8,     1,           -1      },
	{ "Gcolor3",                 NULL,      NULL,   0 << 8,     1,           -1      },
	{ "Keepassxc",               NULL,      NULL,   0 << 8,     1,           -1      },
	{ "Simplescreenrecorder",    NULL,      NULL,   0 << 8,     1,           -1      },
	{ "Veracrypt",               NULL,      NULL,   0 << 8,     0,           -1      },
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
#define TERMINAL	"${TERM}"
#define DMENU	    "dmenu_run"
#define STARTMENU	"${SCRIPTSDIR}startmenu.sh"
#define WEBBROWSER	"${BROWSER}"
#define FILEMANAGER	"${FILEMANAGER}"
#define LOCK	    "${LOCKER}"
#define SCREENSHOT  "scrot 'temp/scrot-%Y-%m-%d-%H%M%S.png'"
static const char *layoutmenu_cmd = "dwm-menu-layout";
static const char *windowmenu_cmd = "dwm-menu-window";

static Key keys[] = {
	/* modkey         key           function        argument            */
	/* processes                                                        */
	{ MOD1,           XK_t,         spawn,          SHCMD(TERMINAL)     },
	{ MOD1,           XK_d,         spawn,          SHCMD(DMENU)        },
	{ MOD1,           XK_s,         spawn,          SHCMD(STARTMENU)    },
	{ MOD1,           XK_w,         spawn,          SHCMD(WEBBROWSER)   },
	{ MOD1,           XK_f,         spawn,          SHCMD(FILEMANAGER)  },
	{ MOD1,           XK_l,         spawn,          SHCMD(LOCK)         },
	{ 0,              XK_Print,     spawn,          SHCMD(SCREENSHOT)   },
	{ MOD1,           XK_q,         killclient,     {0}                 },
	{ MOD1|MOD2,      XK_q,         quit,           {0}                 },
	/* windows                                                          */
	{ MOD1,           XK_Up,        setmfact,       {.f = +0.05}        },
	{ MOD1,           XK_Down,      setmfact,       {.f = -0.05}        },
	{ MOD2,           XK_Up,        setcfact,       {.f = +0.15}        },
	{ MOD2,           XK_Down,      setcfact,       {.f = -0.15}        },
	{ MOD2,           XK_equal,     setcfact,       {.f =  0.00}        },
	{ MOD1,           XK_Right,     focusstack,     {.i = +1}           },
	{ MOD1,           XK_Left,      focusstack,     {.i = -1}           },
	{ MOD1,           XK_Return,    focusmaster,    {0}                 },
	{ MOD2,           XK_Right,     swapdown,       {0}                 },
	{ MOD2,           XK_Left,      swapup,         {0}                 },
	{ MOD2,           XK_Return,    zoom,           {0}                 },
	{ MOD2,           XK_f,         togglefullscr,  {0}                 },
	{ MOD2,           XK_space,     togglefloating, {0}                 },
	{ MOD1,           XK_End,       tagmon,         {.i = +1}           },
	{ MOD1,           XK_Home,      tagmon,         {.i = -1}           },
	{ MOD2,           XK_w,         windowmenu,     {0}                 },
	/* monitors                                                         */
	{ MOD1|ShiftMask, XK_Right,     focusmon,       {.i = +1}           },
	{ MOD1|ShiftMask, XK_Left,      focusmon,       {.i = -1}           },
	{ MOD1|ShiftMask, XK_b,         togglebar,      {0}                 },
	{ MOD1|ShiftMask, XK_g,         togglegaps,     {0}                 },
	/* layouts                                                          */
	{ MOD1,           XK_F1,        setlayout,      {.v = &layouts[0]}  },
	{ MOD1,           XK_F2,        setlayout,      {.v = &layouts[1]}  },
	{ MOD1,           XK_F3,        setlayout,      {.v = &layouts[2]}  },
	{ MOD1,           XK_F4,        setlayout,      {.v = &layouts[3]}  },
	{ MOD1,           XK_F5,        setlayout,      {.v = &layouts[4]}  },
	{ MOD1,           XK_F6,        setlayout,      {.v = &layouts[5]}  },
	{ MOD1,           XK_F7,        setlayout,      {.v = &layouts[6]}  },
    { MOD1,           XK_F8,        setlayout,      {.v = &layouts[7]}  },
	{ MOD1,           XK_equal,     incnmaster,     {.i = +1}           },
	{ MOD1,           XK_minus,     incnmaster,     {.i = -1}           },
	{ MOD1,           XK_BackSpace, incnmaster,     {.i =  0}           },
	/* tagging                                                          */
	{ MOD1,           XK_0,         view,           {.ui = ~0}          },
	{ MOD2,           XK_0,         tag,            {.ui = ~0}          },
	{ MOD2,           XK_t,         layoutmenu,     {0}                 },
	TAGKEYS(          XK_1,         0)
	TAGKEYS(          XK_2,         1)
	TAGKEYS(          XK_3,         2)
	TAGKEYS(          XK_4,         3)
	TAGKEYS(          XK_5,         4)
	TAGKEYS(          XK_6,         5)
	TAGKEYS(          XK_7,         6)
	TAGKEYS(          XK_8,         7)
	TAGKEYS(          XK_9,         8)
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
	{ ClkStatusText, 0,       Button1, spawn,          SHCMD(STARTMENU) },
	{ ClkStatusText, 0,       Button3, spawn,          SHCMD(TERMINAL)  },
	/* client windows                                                   */
	{ ClkClientWin,  MOD1,    Button1, movemouse,      {0}              },
	{ ClkClientWin,  MOD1,    Button3, windowmenu,     {0}              },
	{ ClkClientWin,  MOD2,    Button1, resizemouse,    {0}              },
	{ ClkClientWin,  MOD2,    Button3, togglefloating, {0}              },
	/* root window                                                      */
	{ ClkRootWin,    0,       Button1, spawn,          SHCMD(STARTMENU) },
	{ ClkRootWin,    0,       Button3, focusmaster,    {0}              },
};
