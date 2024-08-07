/* See LICENSE file for copyright and license details. */

#include <X11/XF86keysym.h>

/* appearance */
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int default_border = 0;   /* to switch back to default border after dynamic border resizing via keybinds */
static const unsigned int snap      = 32;       /* snap pixel */
static const unsigned int gappih    = 0;        /* horiz inner gap between windows */
static const unsigned int gappiv    = 0;        /* vert inner gap between windows */
static const unsigned int gappoh    = 0;        /* horiz outer gap between windows and screen edge */
static const unsigned int gappov    = 0;        /* vert outer gap between windows and screen edge */
static const int smartgaps          = 0;        /* 1 means no outer gap when there is only one window */
static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails,display systray on the 1st monitor,False: display systray on last monitor*/
static const int showsystray        = 1;        /* 0 means no systray */
static const int showbar            = 1;        /* 0 means no bar */
static const int showtab            = showtab_auto;
static const int toptab             = 0;        /* 0 means bottom tab for monocal layout .. makes one window full screen without loosing status bar */ 
static const int floatbar           = 1;        /* 1 means the bar will float(don't have padding),0 means the bar have padding */
static const int topbar             = 1;        /* 0 means bottom bar */
static const int horizpadbar        = 5;        /* padding inside the bar */
static const int vertpadbar         = 0;        /* padding inside the bar */
static const int vertpadtab         = 25;       /* tab size for monocal layout*/
static const int horizpadtabi       = 15;
static const int horizpadtabo       = 15;
static const int scalepreview       = 4;
static const int tag_preview        = 1;        /* 1 means enable, 0 is off */
static const int colorfultag        = 1;        /* 0 means use SchemeSel for selected non vacant tag */

// ### adding volume and brightness keys in sxhkd to be independent form any window manager ### || keybinding defined billow//
//static const char *upvol[]   = { "/usr/bin/pactl", "set-sink-volume", "0", "+5%",     NULL };
//static const char *downvol[] = { "/usr/bin/pactl", "set-sink-volume", "0", "-5%",     NULL };
//static const char *mutevol[] = { "/usr/bin/pactl", "set-sink-mute",   "0", "toggle",  NULL };
//static const char *light_up[] = {"/usr/bin/light", "-A", "5", NULL};
//static const char *light_down[] = {"/usr/bin/light", "-U", "5", NULL};

static const int new_window_attach_on_end = 0; /*  1 means the new window will attach on the end; 0 means the new window will attach on the front,default is front */
#define ICONSIZE 19   /* icon size */
#define ICONSPACING 8 /* space between icon and title */

static const char *fonts[]          = { "Iosevka Nerd Font:pixelsize=16:antialias=true:autohint=true:hinting=full:rgba=rgb" };
// static const char *fonts[]       = { "Iosevka Nerd Font:size=12" };

// theme
#include "themes/onedark.h"
//#include "themes/catppuccin.h"
//#include "themes/nord.h"
//#include "themes/gruvchad.h"
//#include "themes/dracula.h"

static const char *colors[][3]      = {
    /*                     fg       bg      border */
    [SchemeNorm]       = { gray3,   black,  gray2 },
    [SchemeSel]        = { gray4,   blue,   blue  },
    [SchemeTitle]      = { white,   black,  black  }, // active window title
    [TabSel]           = { blue,    gray2,  black },
    [TabNorm]          = { gray3,   black,  black },
    [SchemeTag]        = { gray3,   black,  black },
    [SchemeTag1]       = { blue,    black,  black },
    [SchemeTag2]       = { red,     black,  black },
    [SchemeTag3]       = { orange,  black,  black },
    [SchemeTag4]       = { green,   black,  black },
    [SchemeTag5]       = { blue,    black,  black },
    [SchemeTag6]       = { pinky,   black,  black },
    [SchemeTag7]       = { pink,    black,  black },
    [SchemeTag8]       = { orange,  black,  black },
    [SchemeTag9]       = { red,     black,  black },
    [SchemeLayout]     = { green,   black,  black },
    [SchemeBtnPrev]    = { green,   black,  black },
    [SchemeBtnNext]    = { yellow,  black,  black },
    [SchemeBtnClose]   = { red,     black,  black },
};

/* tagging */
//static char *tags[] = {"🯱", "🯲", "🯳", "🯴", "🯵", "🯶", "🯷", "🯸", "🯹"};
static char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };
//static char *tags[] = { "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX" };
//static char *tags[] = { "", "", "", "", "", "", "", "", "" };
//static char *tags[] = { "Web", "Chat", "Edit", "Meld", "Vb", "Mail", "Video", "Image", "Files" };
//static char *tags[] = {"一", "二", "三", "四", "五", "六", "七", "八", "九"};

static const char* suspend[] = { "systemctl", "suspend", NULL };  //{ "eww", "open" , "eww", NULL }; ## space as comma seprator
static const char* discord[] = { "discord", "open" , "discord", NULL };
static const char* telegram[] = { "telegram-desktop", "open" , "telegram-desktop", NULL };
static const char* mintstick[] = { "mintstick", "-m", "iso", NULL};
static const char* pavucontrol[] = { "pavucontrol", NULL };

static const Launcher launchers[] = {
    /* command     name to display */
    { suspend,       "" },
    { discord,       "" },
    { telegram,      "" },
    { mintstick,     "" },
    { pavucontrol,   "" },
};

static const int tagschemes[] = {
    SchemeTag1, SchemeTag2, SchemeTag3, SchemeTag4, SchemeTag5, SchemeTag6, SchemeTag7, SchemeTag8, SchemeTag9
};

/*tags under line settings*/
static const unsigned int ulinepad      = 3; /* horizontal padding between the underline and tag */
static const unsigned int ulinestroke   = 2; /* thickness / height of the underline */
static const unsigned int ulinevoffset  = 0; /* how far above the bottom of the bar the line should appear */
static const int ulineall               = 0; /* 1 to show underline on all tags, 0 for just the active ones */

static const Rule rules[] = {
    /* xprop(1):
     *	WM_CLASS(STRING) = instance, class
     *	WM_NAME(STRING) = title
     */
    /* class            instance    title       tags mask   switchtag  iscentered   isfloating   monitor */
    { "firefox",        NULL,       NULL,       1 << 1,          1,              0,           0,           -1 },
    { "Subl",           NULL,       NULL,       1 << 2,          1,              0,           0,           -1 },
    { "Thunar",         NULL,       NULL,       1 << 3,          1,              0,           0,           -1 },
    { "Xfce4-terminal", NULL,       NULL,       0,               0,              1,           1,           -1 },
    
};

/* layout(s) */
static const float mfact     = 0.50; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

#define FORCE_VSPLIT 1  /* nrowgrid layout: force two clients to always split vertically */
#include "functions.h"


static const Layout layouts[] = {
    /* symbol     arrange function */
    { "[]=",      tile },    /* first entry is default */
    { "[M]",      monocle },
    { "[@]",      spiral }, // Fibonacci layout
    { "[\\]",     dwindle }, // same as Fibonacci layout
    { "H[]",      deck }, // only two recent window on workspace/tag
    { "TTT",      bstack },
    { "===",      bstackhoriz },
    { "HHH",      grid },
    { "###",      nrowgrid },
    { "---",      horizgrid },
    { ":::",      gaplessgrid },
    { "|M|",      centeredmaster },
    { ">M>",      centeredfloatingmaster },
    { "><>",      NULL },    /* no layout function means floating behavior */
    { NULL,       NULL },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
    { MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
    { MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
    { MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
    { MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

#define STATUSBAR "dwmblocks"

/* commands */

static const Key keys[] = {
    /* modifier                         key                 function        argument */

    // ### adding volume and brightness keys in sxhkd to be independent form any window manager || function defined above ### //
    //{0,                    XF86XK_AudioLowerVolume,        spawn,        {.v = downvol}},
	//{0,                    XF86XK_AudioMute,               spawn,        {.v = mutevol }},
	//{0,                    XF86XK_AudioRaiseVolume,        spawn,        {.v = upvol}},
	//{0,                    XF86XK_MonBrightnessUp,         spawn,	     {.v = light_up}},
	//{0,                    XF86XK_MonBrightnessDown,       spawn,	     {.v = light_down}},

    // screenshot fullscreen and cropped
    //{ MODKEY|ControlMask,              XK_s,             spawn,         SHCMD("maim | xclip -selection clipboard -t image/png")},
    //{ MODKEY,                          XK_s,             spawn,         SHCMD("maim --select | xclip -selection clipboard -t image/png")},
    //{ MODKEY,                          XK_c,             spawn,         SHCMD("rofi -show drun") },
    //{ MODKEY,                          XK_Return,        spawn,         SHCMD("st")},




//#########################################################################################################
//#########################################################################################################
// its better to not change default keybinding because all are well configured to avoide any confilicts

    // toggle stuff
    { MODKEY,                           XK_b,       togglebar,      {0} },      // toggle bar 
  //{ MODKEY|ControlMask,               XK_t,       togglegaps,     {0} },      // there is no any gaps already to toggle anything
    { MODKEY|ShiftMask,                 XK_space,   togglefloating, {0} },      // toggle floating tilling
    { MODKEY,                           XK_f,       togglefullscr,  {0} },      // full screen window


//#########################################################################################################
//#########################################################################################################

  //{ MODKEY|ControlMask,               XK_w,       tabmode,        { -1 } },         // monocal layout have already tab mode enabled
    { MODKEY,                           XK_j,       focusstack,     {.i = +1 } },     // switch window focus down
    { MODKEY,                           XK_k,       focusstack,     {.i = -1 } },     // switch window foucs up
    { MODKEY,                           XK_i,       incnmaster,     {.i = +1 } },     // add master 
    { MODKEY,                           XK_u,       incnmaster,     {.i = -1 } },     // remove master

//#########################################################################################################
//#########################################################################################################

    // change m,cfact sizes 
    { MODKEY,                           XK_h,       setmfact,       {.f = -0.05} },      // resize window horizontal
    { MODKEY,                           XK_l,       setmfact,       {.f = +0.05} },      // resize window horizontal
    { MODKEY|ShiftMask,                 XK_h,       setcfact,       {.f = +0.25} },      // resize window vertical
    { MODKEY|ShiftMask,                 XK_l,       setcfact,       {.f = -0.25} },      // resize window vertical
  //{ MODKEY|ShiftMask,                 XK_o,       setcfact,       {.f =  0.00} },      // reset to default vertical window size if resized {not needed much}
    { MODKEY|ShiftMask,                 XK_j,       movestack,      {.i = +1 } },        //  move window in stack down
    { MODKEY|ShiftMask,                 XK_k,       movestack,      {.i = -1 } },        //  move window in stack up
  //{ MODKEY|ShiftMask,                 XK_Return,  zoom,           {0} },               //  not tried <<===================================
    { MODKEY,                           XK_Tab,     view,           {0} },               //  switch b/w two recent workspace

//#########################################################################################################
//#########################################################################################################

    // overall gaps
    //{ MODKEY|ControlMask,               XK_i,       incrgaps,       {.i = +1 } },      //  not tried <<===================================
    //{ MODKEY|ControlMask,               XK_d,       incrgaps,       {.i = -1 } },      //  not tried <<===================================

    // inner gaps
    //{ MODKEY|ShiftMask,                 XK_i,       incrigaps,      {.i = +1 } },      //  not tried <<===================================
    //{ MODKEY|ControlMask|ShiftMask,     XK_i,       incrigaps,      {.i = -1 } },      //  not tried <<===================================

    // outer gaps
    //{ MODKEY|ControlMask,               XK_o,       incrogaps,      {.i = +1 } },      //  not tried <<===================================
    //{ MODKEY|ControlMask|ShiftMask,     XK_o,       incrogaps,      {.i = -1 } },      //  not tried <<===================================


// inner+outer hori, vert gaps { keybinding are in conflicts with connecting tags}
//    { MODKEY|ControlMask,               XK_6,       incrihgaps,     {.i = +1 } },        // increase Vertical gaps b/w window
//    { MODKEY|ControlMask|ShiftMask,     XK_6,       incrihgaps,     {.i = -1 } },        // decrease Vertical gaps b/w window
//    { MODKEY|ControlMask,               XK_7,       incrivgaps,     {.i = +1 } },        // increase Horizental gaps b/w widnow
//    { MODKEY|ControlMask|ShiftMask,     XK_7,       incrivgaps,     {.i = -1 } },        // decrease Horizental gaps b/w widnow
//    { MODKEY|ControlMask,               XK_8,       incrohgaps,     {.i = +1 } },        // increase Vertical gaps b/w screen edge and window manager
//    { MODKEY|ControlMask|ShiftMask,     XK_8,       incrohgaps,     {.i = -1 } },        // decrease Vertical gaps b/w screen edge and window manager
//    { MODKEY|ControlMask,               XK_9,       incrovgaps,     {.i = +1 } },        // increase Horizental gaps b/w screen edge and window manager
//    { MODKEY|ControlMask|ShiftMask,     XK_9,       incrovgaps,     {.i = -1 } },        // decrease Horizental gaps b/w screen edge and window manager
//    { MODKEY|ControlMask|ShiftMask,     XK_d,       defaultgaps,    {0} },               // reset screen gaps to default


//#########################################################################################################
//#########################################################################################################

    // layout
    { MODKEY,                           XK_t,       setlayout,      {.v = &layouts[0]} },       // tilling layout
    { MODKEY,                           XK_m,       setlayout,      {.v = &layouts[1]} },       // monocal layout
  //{ MODKEY|ShiftMask,                 XK_f,       setlayout,      {.v = &layouts[2]} },       // configure layout <<<<==================
  //{ MODKEY|ControlMask,               XK_g,       setlayout,      {.v = &layouts[10]} },      // configure layout <<<<==================
  //{ MODKEY|ControlMask|ShiftMask,     XK_t,       setlayout,      {.v = &layouts[13]} },      // configure layout <<<<==================
    { MODKEY,                           XK_space,   setlayout,      {0} },                      // switch to last recent layout
    { MODKEY|ControlMask,               XK_comma,   cyclelayout,    {.i = -1 } },               // forward change layout in bus      ->
    { MODKEY|ControlMask,               XK_period,  cyclelayout,    {.i = +1 } },               // backward change layout in bus <-
    { MODKEY,                           XK_0,       view,           {.ui = ~0 } },              // active all tags togather
    { MODKEY|ShiftMask,                 XK_0,       tag,            {.ui = ~0 } },              // place focused window in all tags
  //{ MODKEY,                           XK_comma,   focusmon,       {.i = -1 } },               //   move focus to different monitor(if available)
  //{ MODKEY,                           XK_period,  focusmon,       {.i = +1 } },               //   move focus to different monitor(if available)
  //{ MODKEY|ShiftMask,                 XK_Left,    tagmon,         {.i = -1 } },               //   move focused window to different monitor (if available) 
  //{ MODKEY|ShiftMask,                 XK_Right,   tagmon,         {.i = +1 } },               //   move focused window to different monitor (if available)

//#########################################################################################################
//#########################################################################################################

    // change border size
    //{ MODKEY|ShiftMask,                 XK_minus,   setborderpx,    {.i = -1 } },             // decrease window boarder size
    //{ MODKEY|ShiftMask,                 XK_p,       setborderpx,    {.i = +1 } },             // increase window boarder size
    //{ MODKEY|ShiftMask,                 XK_w,       setborderpx,    {.i = default_border } }, // default window boarder size

//#########################################################################################################
//#########################################################################################################

    // kill dwm
    //{ MODKEY|ControlMask,               XK_q,       spawn,        SHCMD("killall bar.sh dwm") },

    // kill window
    { MODKEY,                           XK_q,       killclient,     {0} },      // kill window
    //{ MODKEY|ShiftMask,                 XK_q,       killclient,     {0} },      // kill window {not needed}

//#########################################################################################################
//#########################################################################################################

    // restart
    { MODKEY|ShiftMask,                 XK_r,       restart,           {0} },       // restart DWM

    // hide & restore windows
    { MODKEY,                           XK_e,       hidewin,        {0} },       // hide the focused window
    { MODKEY|ShiftMask,                 XK_e,       restorewin,     {0} },       // unhide the hidden window 

//#########################################################################################################
//#########################################################################################################

    // qwerty keyboard

    TAGKEYS(                            XK_1,                       0)
    TAGKEYS(                            XK_2,                       1)
    TAGKEYS(                            XK_3,                       2)
    TAGKEYS(                            XK_4,                       3)
    TAGKEYS(                            XK_5,                       4)
    TAGKEYS(                            XK_6,                       5)
    TAGKEYS(                            XK_7,                       6)
    TAGKEYS(                            XK_8,                       7)
    TAGKEYS(                            XK_9,                       8)


};

//#########################################################################################################
//#########################################################################################################


/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
    /* click                event mask      button          function        argument */
    { ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
    { ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
    { ClkWinTitle,          0,              Button2,        zoom,           {0} },
    
    { ClkStatusText,        0,              Button1,        sigstatusbar,   {.i = 1} },
    { ClkStatusText,        0,              Button2,        sigstatusbar,   {.i = 2} },
    { ClkStatusText,        0,              Button3,        sigstatusbar,   {.i = 3} },
    { ClkStatusText,        0,              Button4,        sigstatusbar,   {.i = 4} },
    { ClkStatusText,        0,              Button5,        sigstatusbar,   {.i = 5} },


    /* Keep movemouse? */
    /* { ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} }, */

    /* placemouse options, choose which feels more natural:
    *    0 - tiled position is relative to mouse cursor
    *    1 - tiled position is relative to window center
    *    2 - mouse pointer warps to window center
    *
    * The moveorplace uses movemouse or placemouse depending on the floating state
    * of the selected client. Set up individual keybindings for the two if you want
    * to control these separately (i.e. to retain the feature to move a tiled window
    * into a floating position).
    */
    { ClkClientWin,         MODKEY,         Button1,        moveorplace,    {.i = 0} },
    { ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
    { ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
    //{ ClkClientWin,         ControlMask,    Button1,        dragmfact,      {0} },
    //{ ClkClientWin,         ControlMask,    Button3,        dragcfact,      {0} },
    { ClkTagBar,            0,              Button1,        view,           {0} },
    { ClkTagBar,            0,              Button3,        toggleview,     {0} },
    { ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
    { ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
    { ClkTabBar,            0,              Button1,        focuswin,       {0} },
    { ClkTabBar,            0,              Button1,        focuswin,       {0} },
    { ClkTabPrev,           0,              Button1,        movestack,      { .i = -1 } },
    { ClkTabNext,           0,              Button1,        movestack,      { .i = +1 } },
    { ClkTabClose,          0,              Button1,        killclient,     {0} },
};



