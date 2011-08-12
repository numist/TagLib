//
//  debugger.h
//  TagLib
//
//  Created by Scott Perry on 8/11/11.
//  Copyright 2011 Scott Perry. All rights reserved.
//

#ifndef _TagLib_debugger_h_
#define _TagLib_debugger_h_

#ifdef DEBUG
    #include <stdbool.h>

    bool AmIBeingDebugged(void);
    /*
     * Breaking into the debugger (if possible) provided by:
     * http://cocoawithlove.com/2008/03/break-into-debugger.html
     */
    #if __ppc64__ || __ppc__
        #define DebugBreak() \
            if(AmIBeingDebugged()) \
            { \
                __asm__("li r0, 20\nsc\nnop\nli r0, 37\nli r4, 2\nsc\nnop\n" \
                    : : : "memory","r0","r3","r4" ); \
            }
    #else
        #define DebugBreak() if(AmIBeingDebugged()) {__asm__("int $3\n" : : );}
    #endif

    /*
     * The Check and NotTested functions emit a log message and
     * will break a watching debugger if possible.
     */
    #define TLCheck(exp) do { \
                if (exp); \
                else { \
                    TLLog(@"Failed check `%s`", #exp); \
                    DebugBreak(); \
                } \
            } while(0)
    #define TLNotTested() do { \
                TLLog(@"%@", @"NOT TESTED"); \
                DebugBreak(); \
            } while(0)

    /*
     * The Log and Assert macros are much more mundane, serving to
     * prevent the incidence of NSLog calls in Release builds,
     * improve logging in Debug builds, and
     * kill the program.
     */
    #define TLLog(fmt, ...) NSLog(@"%s:%d <%s> %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, [NSString stringWithFormat:(fmt), __VA_ARGS__]);
    #define TLAssert(exp) do { \
                if (exp); \
                else { \
                    TLLog(@"Failed assertion `%s`", #exp); \
                    abort(); \
                } \
            } while(0)

    /*
     * The TODO macro allows TODO items to appear as compiler warnings.
     */
    #define DO_PRAGMA(x) _Pragma (#x)
    #define TODO(x) DO_PRAGMA(message ("TODO - " x))



#else
    #define DebugBreak()
    #define TLLog(...)
    #define TLCheck(exp)
    #define TLAssert(exp)
    #define TLNotTested()
    #define TODO(x)
#endif


#endif // _TagLib_debugger_h_
