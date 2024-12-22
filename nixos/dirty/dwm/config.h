
/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "monospace:size=10" };
static const char dmenufont[]       = "monospace:size=10";
static const char col_gray1[]       = "#222222";
static const char col_gray2[]       = "#444444";
static const char col_gray3[]       = "#bbbbbb";
static const char col_gray4[]       = "#eeeeee";
static const char col_cyan[]        = "#005577";
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray4, col_cyan,  col_cyan  },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "poop",     NULL,       NULL,       0,            1,           -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = { { "", tile } };

#define MOD1    Mod4Mask // Meta key
#define MOD2    Mod1Mask // Alt key
#define TAGKEYS(KEY,TAG) \
	{ MOD1,           KEY, view,       {.ui = 1 << TAG} }, \
	{ MOD1|ShiftMask, KEY, toggleview, {.ui = 1 << TAG} }, \
	{ MOD2,           KEY, tag,        {.ui = 1 << TAG} }, \
	{ MOD2|ShiftMask, KEY, toggletag,  {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
#define TERMINAL    "$TERM"
#define DMENU	    "dmenu_run"
#define STARTMENU   "startmenu.sh"
#define SCREENSHOT  "flameshot gui"
#define BOOMER	    "boomer"
#define UPVOL	    "volup.sh"
#define DOWNVOL	    "voldown.sh"
#define MUTEVOL	    "mutevol.sh"

#include <X11/XF86keysym.h>

static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };

static const Key keys[] = {
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
	// { MOD1,           XK_z,         focusmaster,    {0}                   },
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
	{ MOD1,	     XK_period,                 focusmon,       {.i = -1}             },
        { MOD1,	     XK_comma,                  focusmon,       {.i = +1}             },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click         modkey   button   function        argument         */
	/* tag bar section                                                  */
	{ ClkTagBar,     0,       Button1, view,           {0}              },
	{ ClkTagBar,     0,       Button3, toggleview,     {0}              },
	{ ClkTagBar,     MOD1,    Button1, tag,            {0}              },
	{ ClkTagBar,     MOD1,    Button3, toggletag,      {0}              },
	/* layout indicator section                                         */
	// { ClkLtSymbol,   0,       Button1, layoutmenu,     {0}              },
	{ ClkLtSymbol,   0,       Button3, setlayout,      {0}              },
	/* selected window title section                                    */
	// { ClkWinTitle,   0,       Button1, windowmenu,     {0}              },
	{ ClkWinTitle,   0,       Button3, zoom,           {0}              },
	/* status section, subsections gaps are included in the hitbox      */
	{ ClkStatusText, 0,       Button3, spawn,          SHCMD(STARTMENU) },
	{ ClkStatusText, 0,       Button3, spawn,          SHCMD(TERMINAL)  },
	/* client windows                                                   */
	{ ClkClientWin,  MOD1,    Button1, movemouse,      {0}              },
	// { ClkClientWin,  MOD1,    Button3, windowmenu,     {0}              },
	{ ClkClientWin,  MOD2,    Button1, resizemouse,    {0}              },
	{ ClkClientWin,  MOD2,    Button3, togglefloating, {0}              },
	{ ClkClientWin,  MOD1,       Button2, spawn,        SHCMD(BOOMER)   },
	/* root window                                                      */
	{ ClkRootWin,    0,       Button3, spawn,          SHCMD(STARTMENU) },
	//{ ClkRootWin,    0,       Button3, focusmaster,    {0}              },
};

