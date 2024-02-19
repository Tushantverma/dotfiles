#include "config.h"
#include "block.h"
#include "util.h"

#define SCRIPTS_PATH "~/.config/tv-dwm/dwmblocks/scripts/"

Block blocks[] = {
    {SCRIPTS_PATH "sb-traffic"       ,1     ,7 },
    {SCRIPTS_PATH "sb-disk"          ,1     ,9 },
    {SCRIPTS_PATH "sb-battery"       ,5     ,6 },
    {SCRIPTS_PATH "sb-brightness"    ,0     ,5 },
    {SCRIPTS_PATH "sb-mic"           ,0     ,8 },
    {SCRIPTS_PATH "sb-volume"        ,0     ,4 },
    {SCRIPTS_PATH "sb-cpu"           ,5     ,3 },
    {SCRIPTS_PATH "sb-memory"        ,5     ,2 },
    {SCRIPTS_PATH "sb-time"          ,1     ,1 },
};

const unsigned short blockCount = LEN(blocks);
